//! Markdown Specifications to SysML v2 Reverse Synchronization Engine.
//!
//! Parses markdown specifications across docs/ (epics, features, user-stories, use-cases, safety),
//! extracts canonical architectural entities and constraints, merges them non-destructively
//! into the SysML v2 AST Single Source of Truth, and updates the schema and digest.

use std::collections::HashMap;
use std::fs;
use std::path::PathBuf;

use deap_core::sysml_ast::{
    ActionDef, CapabilityDef, ConstraintDef, InteractionDef, PackageDef, PartDef, UseCaseDef,
};
use walkdir::WalkDir;

use crate::semantic::digest::{generate_digest, write_atomic, write_digest_atomic, SchemaDigest};
use crate::semantic::serializer::to_sysml;

/// Options for reverse synchronization.
#[derive(Debug, Clone)]
pub struct ReverseSyncOptions {
    pub docs_dir: PathBuf,
    pub schema_path: Option<PathBuf>,
    pub output_path: PathBuf,
    pub digest_path: PathBuf,
    pub allow_overwrite: bool,
}

/// Helper to parse basic YAML frontmatter from a markdown string.
fn parse_frontmatter(content: &str) -> (HashMap<String, String>, &str) {
    let mut fm = HashMap::new();
    let trimmed = content.trim_start();
    if !trimmed.starts_with("---") {
        return (fm, content);
    }

    let rest = &trimmed[3..];
    if let Some(end_idx) = rest.find("\n---") {
        let fm_block = &rest[..end_idx];
        let body = &rest[end_idx + 4..];

        for line in fm_block.lines() {
            let line = line.trim();
            if let Some(colon_pos) = line.find(':') {
                let key = line[..colon_pos].trim().to_string();
                let mut val = line[colon_pos + 1..].trim();
                if (val.starts_with('"') && val.ends_with('"'))
                    || (val.starts_with('\'') && val.ends_with('\''))
                {
                    val = &val[1..val.len() - 1];
                }
                fm.insert(key, val.to_string());
            }
        }
        (fm, body)
    } else {
        (fm, content)
    }
}

/// Helper to convert a string into clean PascalCase.
fn to_pascal_case(text: &str) -> String {
    let words: Vec<&str> = text
        .split(|c: char| !c.is_alphanumeric())
        .filter(|w| !w.is_empty())
        .collect();
    words
        .iter()
        .map(|w| {
            let mut c = w.chars();
            match c.next() {
                None => String::new(),
                Some(f) => f.to_uppercase().collect::<String>() + c.as_str(),
            }
        })
        .collect()
}

/// Reverse synchronizes markdown documents under `docs_dir` into the SysML AST SSOT.
pub fn reverse_sync_specs_to_sysml(
    base_pkg: Option<&PackageDef>,
    opts: &ReverseSyncOptions,
) -> Result<(PackageDef, SchemaDigest), String> {
    if !opts.docs_dir.exists() {
        return Err(format!("Docs directory does not exist: {}", opts.docs_dir.display()));
    }

    if !opts.allow_overwrite
        && opts.schema_path.as_ref() == Some(&opts.output_path)
    {
        return Err(format!(
            "In-place overwrite of base input schema '{}' is prohibited when allow_overwrite=false.",
            opts.output_path.display()
        ));
    }

    let mut pkg = base_pkg.cloned().unwrap_or_else(|| {
        let mut p = PackageDef::default();
        p.name = "System_SSOT".to_string();
        p.doc = Some("Single Source of Truth for System Architecture and Safety Model".to_string());
        p
    });

    let mut extracted_capabilities = Vec::new();
    let mut extracted_parts: HashMap<String, PartDef> = HashMap::new();
    let mut extracted_interactions = Vec::new();
    let mut extracted_use_cases = Vec::new();
    let mut extracted_constraints = Vec::new();

    // Populate existing parts into the map for merge
    for part in &pkg.part_defs {
        extracted_parts.insert(part.name.clone(), part.clone());
    }

    for entry in WalkDir::new(&opts.docs_dir)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.file_type().is_file())
    {
        let path = entry.path();
        if path.extension().map(|e| e == "md").unwrap_or(false) {
            let content = fs::read_to_string(path)
                .map_err(|e| format!("Failed to read {}: {}", path.display(), e))?;

            let (fm, body) = parse_frontmatter(&content);
            let doc_type = fm.get("type").map(|s| s.as_str()).unwrap_or("");

            match doc_type {
                "epic" => {
                    let title = fm.get("title").cloned().unwrap_or_else(|| {
                        path.file_stem().unwrap().to_string_lossy().to_string()
                    });
                    let subsys = fm.get("subsystem").cloned().unwrap_or_default();
                    let name = to_pascal_case(&title);
                    extracted_capabilities.push(CapabilityDef {
                        name: if name.is_empty() { "OperationalCapability".to_string() } else { name },
                        doc: Some(format!("Capability extracted from {}", path.display())),
                        subsystem: Some(subsys),
                        description: Some(title),
                        ..Default::default()
                    });
                }
                "feature" => {
                    let part_name = fm
                        .get("part")
                        .or_else(|| fm.get("part_def"))
                        .map(|s| to_pascal_case(s))
                        .unwrap_or_else(|| {
                            to_pascal_case(&path.file_stem().unwrap().to_string_lossy())
                        });

                    if !part_name.is_empty() {
                        let entry = extracted_parts.entry(part_name.clone()).or_insert_with(|| {
                            let mut p = PartDef::default();
                            p.name = part_name.clone();
                            p
                        });

                        // Extract operations/actions from markdown lists: - `+ActionName() : void`
                        let act_re = regex::Regex::new(r"-\s*`\+([A-Za-z0-9_]+)\s*\([^)]*\)\s*:\s*([A-Za-z0-9_]+)`").unwrap();
                        for cap in act_re.captures_iter(body) {
                            let act_name = cap[1].to_string();
                            if !entry.actions.iter().any(|a| a.name == act_name) {
                                let mut a = ActionDef::default();
                                a.name = act_name;
                                entry.actions.push(a);
                            }
                        }
                    }
                }
                "user-story" => {
                    let inter_name = fm
                        .get("interaction")
                        .or_else(|| fm.get("interaction_def"))
                        .map(|s| to_pascal_case(s))
                        .unwrap_or_else(|| {
                            to_pascal_case(&path.file_stem().unwrap().to_string_lossy())
                        });
                    let subject = fm.get("subject").cloned().unwrap_or_default();

                    extracted_interactions.push(InteractionDef {
                        name: inter_name,
                        doc: Some(format!("Interaction from {}", path.display())),
                        lifelines: if subject.is_empty() {
                            vec!["OperatorConsole".to_string(), "CoreController".to_string()]
                        } else {
                            vec!["OperatorConsole".to_string(), subject]
                        },
                        messages: vec!["ExecuteTask".to_string()],
                        triggers: vec!["OperationalTrigger".to_string()],
                    });
                }
                "use-case" => {
                    let uc_name = fm
                        .get("use_case")
                        .or_else(|| fm.get("use_case_def"))
                        .map(|s| to_pascal_case(s))
                        .unwrap_or_else(|| {
                            to_pascal_case(&path.file_stem().unwrap().to_string_lossy())
                        });
                    let subject = fm.get("subject").cloned().unwrap_or_default();
                    let objective = fm.get("objective").cloned().unwrap_or_default();

                    extracted_use_cases.push(UseCaseDef {
                        name: uc_name,
                        doc: Some(objective.clone()),
                        actors: vec!["OperatorConsole".to_string()],
                        subject: if subject.is_empty() { Some("CoreController".to_string()) } else { Some(subject) },
                        objective: Some(objective),
                        ..Default::default()
                    });
                }
                _ => {
                    // Check if file is STPA_MATRIX.md
                    if path.file_name().map(|f| f == "STPA_MATRIX.md").unwrap_or(false) {
                        let sc_re = regex::Regex::new(r"\|\s*\*\*?(SC-\d+)\*\*?\s*\|\s*([^|]+)\|\s*([^|]+)\|").unwrap();
                        for cap in sc_re.captures_iter(&content) {
                            let sc_id = cap[1].replace('-', "_");
                            let stmt = cap[2].trim().to_string();
                            extracted_constraints.push(ConstraintDef {
                                name: format!("{}_SafetyConstraint", sc_id),
                                doc: Some(stmt.clone()),
                                expression: format!("{} == true", sc_id),
                                is_assertion: true,
                                ..Default::default()
                            });
                        }
                    }
                }
            }
        }
    }

    // Merge into PackageDef
    for cap in extracted_capabilities {
        if !pkg.capability_defs.iter().any(|c| c.name == cap.name) {
            pkg.capability_defs.push(cap);
        }
    }

    // Update part defs
    for (_, part) in extracted_parts {
        if let Some(existing) = pkg.part_defs.iter_mut().find(|p| p.name == part.name) {
            for act in part.actions {
                if !existing.actions.iter().any(|a| a.name == act.name) {
                    existing.actions.push(act);
                }
            }
        } else {
            pkg.part_defs.push(part);
        }
    }

    for inter in extracted_interactions {
        if !pkg.interaction_defs.iter().any(|i| i.name == inter.name) {
            pkg.interaction_defs.push(inter);
        }
    }

    for uc in extracted_use_cases {
        if !pkg.use_case_defs.iter().any(|u| u.name == uc.name) {
            pkg.use_case_defs.push(uc);
        }
    }

    for con in extracted_constraints {
        if !pkg.constraint_defs.iter().any(|c| c.name == con.name) {
            pkg.constraint_defs.push(con);
        }
    }

    // Serialize to SysML
    let sysml_code = to_sysml(&pkg);

    // Write schema atomically
    if let Some(parent) = opts.output_path.parent() {
        fs::create_dir_all(parent).map_err(|e| {
            format!("Failed to create directory '{}': {}", parent.display(), e)
        })?;
    }
    write_atomic(&opts.output_path, &sysml_code).map_err(|e| e.to_string())?;

    // Compute and write digest
    let digest = generate_digest(&pkg, &sysml_code);
    write_digest_atomic(&opts.digest_path, &digest).map_err(|e| e.to_string())?;

    println!(
        "[SysML v2 Reverse-Sync] Merged specifications from '{}' -> '{}' (SHA-256: {})",
        opts.docs_dir.display(),
        opts.output_path.display(),
        digest.sha256
    );

    Ok((pkg, digest))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_frontmatter_extraction() {
        let md = r#"---
title: "Feature 01: Airframe"
type: feature
part: Airframe
---

# Content
"#;
        let (fm, body) = parse_frontmatter(md);
        assert_eq!(fm.get("title").map(|s| s.as_str()), Some("Feature 01: Airframe"));
        assert_eq!(fm.get("type").map(|s| s.as_str()), Some("feature"));
        assert_eq!(fm.get("part").map(|s| s.as_str()), Some("Airframe"));
        assert!(body.contains("# Content"));
    }
}
