//! Semantic validation engine for SysML v2 / KerML models.

use super::symbols::{Symbol, SymbolKind, SymbolTable};
use deap_core::sysml_ast::*;
use regex::Regex;
use std::collections::HashSet;

/// Severity level of semantic diagnostics.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum DiagnosticSeverity {
    Error,
    Warning,
}

/// Structured diagnostic emitted during semantic validation.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct SemanticDiagnostic {
    pub severity: DiagnosticSeverity,
    pub message: String,
    pub element: String,
}

impl SemanticDiagnostic {
    pub fn error(element: impl Into<String>, message: impl Into<String>) -> Self {
        Self {
            severity: DiagnosticSeverity::Error,
            message: message.into(),
            element: element.into(),
        }
    }

    pub fn warning(element: impl Into<String>, message: impl Into<String>) -> Self {
        Self {
            severity: DiagnosticSeverity::Warning,
            message: message.into(),
            element: element.into(),
        }
    }
}

/// Semantic validator verifying topology, types, and referential integrity.
pub struct SemanticValidator<'a> {
    pkg: &'a PackageDef,
    symbols: SymbolTable,
    diagnostics: Vec<SemanticDiagnostic>,
}

impl<'a> SemanticValidator<'a> {
    pub fn new(pkg: &'a PackageDef) -> Self {
        let symbols = SymbolTable::build_from_package(pkg);
        Self {
            pkg,
            symbols,
            diagnostics: Vec::new(),
        }
    }

    /// Execute complete semantic validation suite.
    pub fn validate(&mut self) -> &[SemanticDiagnostic] {
        self.diagnostics.clear();
        self.validate_part_hierarchy();
        self.validate_connections();
        self.validate_referential_integrity();
        &self.diagnostics
    }

    /// Check if any error-level diagnostics were recorded.
    pub fn has_errors(&self) -> bool {
        self.diagnostics
            .iter()
            .any(|d| d.severity == DiagnosticSeverity::Error)
    }

    /// Filter error diagnostics.
    pub fn errors(&self) -> Vec<&SemanticDiagnostic> {
        self.diagnostics
            .iter()
            .filter(|d| d.severity == DiagnosticSeverity::Error)
            .collect()
    }

    // --- Validation Rules ---

    fn validate_part_hierarchy(&mut self) {
        let mut seen_parts = HashSet::new();
        self.check_parts_recursive(&self.pkg.part_defs, "", &mut seen_parts);
    }

    fn check_parts_recursive(
        &mut self,
        parts: &[PartDef],
        scope: &str,
        seen: &mut HashSet<String>,
    ) {
        for part in parts {
            let part_key = if scope.is_empty() {
                part.name.clone()
            } else {
                format!("{}::{}", scope, part.name)
            };

            if !seen.insert(part_key.clone()) {
                self.diagnostics.push(SemanticDiagnostic::error(
                    &part.name,
                    format!("Duplicate part declaration '{}' in scope '{}'", part.name, scope),
                ));
            }

            // Check duplicate ports on this part
            let mut seen_ports = HashSet::new();
            for port in &part.ports {
                if !seen_ports.insert(port.name.clone()) {
                    self.diagnostics.push(SemanticDiagnostic::error(
                        format!("{}.{}", part.name, port.name),
                        format!(
                            "Duplicate port declaration '{}' on part '{}'",
                            port.name, part.name
                        ),
                    ));
                }
            }

            self.check_parts_recursive(&part.parts, &part_key, seen);
        }
    }

    fn validate_connections(&mut self) {
        self.validate_connection_list(&self.pkg.connection_defs, None);

        for part in &self.pkg.part_defs {
            self.validate_part_connections(part);
        }
    }

    fn validate_part_connections(&mut self, part: &PartDef) {
        self.validate_connection_list(&part.connections, Some(&part.name));
        for subpart in &part.parts {
            self.validate_part_connections(subpart);
        }
    }

    fn validate_connection_list(&mut self, conns: &[ConnectionDef], part_scope: Option<&str>) {
        for conn in conns {
            let src_sym = self.symbols.lookup_port(&conn.source_port, part_scope);
            let tgt_sym = self.symbols.lookup_port(&conn.target_port, part_scope);

            if src_sym.is_none() {
                self.diagnostics.push(SemanticDiagnostic::error(
                    &conn.name,
                    format!(
                        "Connection '{}' references undefined source port '{}'",
                        conn.name, conn.source_port
                    ),
                ));
            }

            if tgt_sym.is_none() {
                self.diagnostics.push(SemanticDiagnostic::error(
                    &conn.name,
                    format!(
                        "Connection '{}' references undefined target port '{}'",
                        conn.name, conn.target_port
                    ),
                ));
            }

            if let (Some(src), Some(tgt)) = (src_sym, tgt_sym) {
                let src_eff_dir = get_effective_direction(src);
                let tgt_eff_dir = get_effective_direction(tgt);

                match (src_eff_dir.as_str(), tgt_eff_dir.as_str()) {
                    ("out", "in") | ("inout", "in") | ("out", "inout") | ("inout", "inout") => {
                        // Compatible flow direction
                    }
                    ("in", "out") => {
                        self.diagnostics.push(SemanticDiagnostic::error(
                            &conn.name,
                            format!(
                                "Inverted flow direction in connection '{}': source port '{}' ({}) cannot feed target port '{}' ({})",
                                conn.name, conn.source_port, src_eff_dir, conn.target_port, tgt_eff_dir
                            ),
                        ));
                    }
                    ("in", "in") => {
                        self.diagnostics.push(SemanticDiagnostic::error(
                            &conn.name,
                            format!(
                                "Invalid connection '{}': cannot connect input port '{}' to input port '{}'",
                                conn.name, conn.source_port, conn.target_port
                            ),
                        ));
                    }
                    ("out", "out") => {
                        self.diagnostics.push(SemanticDiagnostic::error(
                            &conn.name,
                            format!(
                                "Invalid connection '{}': cannot connect output port '{}' to output port '{}'",
                                conn.name, conn.source_port, conn.target_port
                            ),
                        ));
                    }
                    _ => {}
                }
            }
        }
    }

    fn validate_referential_integrity(&mut self) {
        let known_constraints: HashSet<String> = self
            .symbols
            .all_of_kind(SymbolKind::Constraint)
            .into_iter()
            .map(|s| normalize_id(&s.name))
            .collect();

        let known_hazards: HashSet<String> = self
            .symbols
            .all_of_kind(SymbolKind::Hazard)
            .into_iter()
            .map(|s| normalize_id(&s.name))
            .collect();

        let safety_realises_re = Regex::new(
            r#"(?i)@SafetyRealises\s*(?:\(([^)]+)\)|:\s*([A-Za-z0-9_\-]+))"#,
        )
        .unwrap();

        let triggers_hazard_re = Regex::new(
            r#"(?i)@TriggersHazard\s*(?:\(([^)]+)\)|:\s*([A-Za-z0-9_\-]+))"#,
        )
        .unwrap();

        let mut req_texts = Vec::new();
        self.collect_requirement_texts(&self.pkg.requirement_defs, &mut req_texts);
        for part in &self.pkg.part_defs {
            self.collect_part_requirement_texts(part, &mut req_texts);
        }

        for (req_name, text_corpus) in req_texts {
            // Check @SafetyRealises
            for cap in safety_realises_re.captures_iter(&text_corpus) {
                let targets = if let Some(grp) = cap.get(1) {
                    grp.as_str()
                        .split(',')
                        .map(|s| s.trim())
                        .filter(|s| !s.is_empty())
                        .collect()
                } else if let Some(grp) = cap.get(2) {
                    vec![grp.as_str().trim()]
                } else {
                    vec![]
                };

                for target in targets {
                    let clean_target = normalize_id(target);
                    if !known_constraints.is_empty()
                        && !known_constraints.iter().any(|c| c == &clean_target || c.contains(&clean_target))
                    {
                        self.diagnostics.push(SemanticDiagnostic::error(
                            &req_name,
                            format!(
                                "Requirement '{}' references undefined constraint/UCA '{}' in @SafetyRealises",
                                req_name, target
                            ),
                        ));
                    }
                }
            }

            // Check @TriggersHazard
            for cap in triggers_hazard_re.captures_iter(&text_corpus) {
                let targets = if let Some(grp) = cap.get(1) {
                    grp.as_str()
                        .split(',')
                        .map(|s| s.trim())
                        .filter(|s| !s.is_empty())
                        .collect()
                } else if let Some(grp) = cap.get(2) {
                    vec![grp.as_str().trim()]
                } else {
                    vec![]
                };

                for target in targets {
                    let clean_target = normalize_id(target);
                    if !known_hazards.is_empty()
                        && !known_hazards.iter().any(|h| h == &clean_target || h.contains(&clean_target))
                    {
                        self.diagnostics.push(SemanticDiagnostic::error(
                            &req_name,
                            format!(
                                "Requirement '{}' references undefined hazard '{}' in @TriggersHazard",
                                req_name, target
                            ),
                        ));
                    }
                }
            }
        }
    }

    fn collect_requirement_texts(&self, reqs: &[RequirementDef], out: &mut Vec<(String, String)>) {
        for req in reqs {
            let corpus = format!(
                "{} {} {}",
                req.doc.as_deref().unwrap_or(""),
                req.text,
                req.assumes.join(" ")
            );
            out.push((req.name.clone(), corpus));
        }
    }

    fn collect_part_requirement_texts(&self, part: &PartDef, out: &mut Vec<(String, String)>) {
        self.collect_requirement_texts(&part.requirements, out);
        for subpart in &part.parts {
            self.collect_part_requirement_texts(subpart, out);
        }
    }
}

fn get_effective_direction(port_sym: &Symbol) -> String {
    let dir = port_sym.direction.as_deref().unwrap_or("inout");
    if port_sym.is_conjugated {
        match dir {
            "in" => "out".to_string(),
            "out" => "in".to_string(),
            other => other.to_string(),
        }
    } else {
        dir.to_string()
    }
}

fn normalize_id(id: &str) -> String {
    id.trim().replace('-', "_").to_lowercase()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_valid_connection_passes() {
        let pkg = PackageDef {
            name: "TestSys".to_string(),
            part_defs: vec![
                PartDef {
                    name: "Sensor".to_string(),
                    ports: vec![
                        PortDef {
                            name: "out_data".to_string(),
                            direction: "out".to_string(),
                            type_name: "RawData".to_string(),
                            ..Default::default()
                        },
                    ],
                    ..Default::default()
                },
                PartDef {
                    name: "Computer".to_string(),
                    ports: vec![
                        PortDef {
                            name: "in_data".to_string(),
                            direction: "in".to_string(),
                            type_name: "RawData".to_string(),
                            ..Default::default()
                        },
                    ],
                    ..Default::default()
                },
            ],
            connection_defs: vec![
                ConnectionDef {
                    name: "SensorToComputer".to_string(),
                    source_port: "Sensor.out_data".to_string(),
                    target_port: "Computer.in_data".to_string(),
                    ..Default::default()
                },
            ],
            ..Default::default()
        };

        let mut validator = SemanticValidator::new(&pkg);
        validator.validate();
        assert!(!validator.has_errors(), "Expected no errors, got: {:?}", validator.errors());
    }

    #[test]
    fn test_mismatched_connection_direction_fails() {
        let pkg = PackageDef {
            name: "TestSys".to_string(),
            part_defs: vec![
                PartDef {
                    name: "Sensor".to_string(),
                    ports: vec![
                        PortDef {
                            name: "in_data".to_string(),
                            direction: "in".to_string(),
                            type_name: "RawData".to_string(),
                            ..Default::default()
                        },
                    ],
                    ..Default::default()
                },
                PartDef {
                    name: "Computer".to_string(),
                    ports: vec![
                        PortDef {
                            name: "out_data".to_string(),
                            direction: "out".to_string(),
                            type_name: "RawData".to_string(),
                            ..Default::default()
                        },
                    ],
                    ..Default::default()
                },
            ],
            connection_defs: vec![
                ConnectionDef {
                    name: "InvertedFlow".to_string(),
                    source_port: "Sensor.in_data".to_string(),
                    target_port: "Computer.out_data".to_string(),
                    ..Default::default()
                },
            ],
            ..Default::default()
        };

        let mut validator = SemanticValidator::new(&pkg);
        validator.validate();
        assert!(validator.has_errors());
        let errors = validator.errors();
        assert_eq!(errors.len(), 1);
        assert!(errors[0].message.contains("Inverted flow direction"));
    }

    #[test]
    fn test_dangling_safety_realises_fails() {
        let pkg = PackageDef {
            name: "SafetySys".to_string(),
            requirement_defs: vec![
                RequirementDef {
                    name: "Req_Safety_1".to_string(),
                    text: "Shall maintain velocity limit. @SafetyRealises(UCA-99)".to_string(),
                    ..Default::default()
                },
            ],
            constraint_defs: vec![
                ConstraintDef {
                    name: "UCA_01_Overspeed".to_string(),
                    expression: "v <= 60.0".to_string(),
                    ..Default::default()
                },
            ],
            ..Default::default()
        };

        let mut validator = SemanticValidator::new(&pkg);
        validator.validate();
        assert!(validator.has_errors());
        let errors = validator.errors();
        assert!(errors[0].message.contains("references undefined constraint/UCA 'UCA-99'"));
    }
}
