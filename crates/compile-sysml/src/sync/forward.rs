//! SysML v2 to Markdown Forward Synchronization Engine.
//!
//! Generates canonical Agile markdown specifications from the SysML v2 SSOT AST:
//! - Epics (docs/epics/EPIC-*.md) from CapabilityDef
//! - Features (docs/features/FEAT-*.md) from PartDef & ActionDef
//! - User Stories (docs/user-stories/US-*.md) from InteractionDef / TestCaseDef
//! - Use Cases (docs/use-cases/UC-*.md) from UseCaseDef
//! - Safety Matrix (docs/safety/STPA_MATRIX.md) from ConstraintDef & STPA Generator

use std::collections::HashMap;
use std::fs;
use std::path::PathBuf;

use chrono::Utc;
use deap_core::sysml_ast::PackageDef;
use crate::semantic::digest::write_atomic;
use crate::stpa::uca::expand_cartesian_stpa;

/// Forward sync options.
#[derive(Debug, Clone)]
pub struct ForwardSyncOptions {
    pub schema_path: PathBuf,
    pub docs_dir: PathBuf,
    pub out_dir: Option<PathBuf>,
    pub dry_run: bool,
    pub force: bool,
}

/// Sanitizes an identifier for use in file names and symbol names.
fn sanitize_id(id: &str) -> String {
    let clean: String = id
        .chars()
        .filter(|c| c.is_alphanumeric() || *c == '_' || *c == '-')
        .collect();
    if clean.is_empty() {
        "Default".to_string()
    } else {
        clean
    }
}

/// Executes forward synchronization from the SysML model to markdown specifications.
pub fn forward_sync_sysml_to_specs(
    pkg: &PackageDef,
    opts: &ForwardSyncOptions,
) -> Result<HashMap<String, String>, String> {
    let target_out_dir = opts
        .out_dir
        .as_ref()
        .cloned()
        .unwrap_or_else(|| opts.docs_dir.clone());

    let mut generated_files = HashMap::new();
    let today_iso = Utc::now().format("%Y-%m-%d").to_string();

    // 1. Epics (EPIC-*.md) from CapabilityDef or Subsystem Packages
    let capabilities = pkg.get_all_capabilities();
    let epics_data: Vec<(String, String, String)> = if !capabilities.is_empty() {
        capabilities
            .into_iter()
            .map(|cap| {
                let cap_name = sanitize_id(&cap.name);
                let subsys = cap
                    .subsystem
                    .as_deref()
                    .filter(|s| !s.is_empty())
                    .map(sanitize_id)
                    .unwrap_or_else(|| sanitize_id(&pkg.name));
                let doc = cap
                    .doc
                    .clone()
                    .or(cap.description)
                    .unwrap_or_else(|| format!("System capability specification for {}", cap_name));
                (cap_name, subsys, doc)
            })
            .collect()
    } else {
        pkg.get_all_packages()
            .into_iter()
            .filter(|p| p.name != "DEAP_Compiler_System")
            .map(|subpkg| {
                let cap_name = sanitize_id(&subpkg.name);
                let subsys = sanitize_id(&subpkg.name);
                let doc = subpkg
                    .doc
                    .as_deref()
                    .map(|d| d.trim())
                    .filter(|d| !d.is_empty())
                    .map(|d| d.to_string())
                    .unwrap_or_else(|| format!("Subsystem specification for {}", cap_name));
                (cap_name, subsys, doc)
            })
            .collect()
    };

    for (idx, (cap_name, subsys, doc)) in epics_data.iter().enumerate() {
        let i = idx + 1;
        let content = format!(
            r#"---
title: "Epic {i:02}: {cap_name}"
version: "1.0.0"
date: "{today_iso}"
type: epic
subsystem: "{subsys}"
generation_mode: subagent
---

# Epic {i:02}: {cap_name}

## Metadata
| Attribute | Specification Detail |
| :--- | :--- |
| **Title** | Epic {i:02}: {cap_name} |
| **Version** | 1.0.0 |
| **Date** | {today_iso} |
| **Type** | epic |
| **Subsystem** | {subsys} |
| **Generation Mode** | subagent |

## Subsystem Capability Allocations

| Capability | Subsystem | Description |
| :--- | :--- | :--- |
| **{cap_name}** | {subsys} | {doc} |

## Architectural Context

```mermaid
classDiagram
    class {subsys} {{
        +void perform{cap_name}()
    }}
```
"#
        );

        let rel_path = format!("epics/EPIC-{:02}-{}.md", i, cap_name);
        generated_files.insert(rel_path, content);
    }

    // 2. Features (FEAT-*.md) from PartDef & ActionDef
    let all_parts = pkg.get_all_parts();
    for (idx, part) in all_parts.iter().enumerate() {
        let i = idx + 1;
        let part_name = sanitize_id(&part.name);

        let mut member_lines = Vec::new();
        for attr in &part.attributes {
            let a_type = if attr.type_name.is_empty() {
                "String"
            } else {
                &attr.type_name
            };
            member_lines.push(format!("        +{} {}", a_type, attr.name));
        }

        let mut logical_ops_bullets = Vec::new();
        if part.actions.is_empty() && part.operations.is_empty() {
            let default_act = format!("execute_{}", part_name.to_lowercase());
            member_lines.push(format!("        +void {}()", default_act));
            logical_ops_bullets.push(format!(
                "- `+{}() : void` - Executes operations for {}",
                default_act, part_name
            ));
        } else {
            for act in &part.actions {
                let act_name = sanitize_id(&act.name);
                member_lines.push(format!("        +void {}()", act_name));
                logical_ops_bullets.push(format!(
                    "- `+{}() : void` - Dispatches action {}",
                    act_name, act_name
                ));
            }
            for op in &part.operations {
                let op_name = sanitize_id(&op.name);
                let ret_type = op.return_type.as_deref().unwrap_or("void");
                member_lines.push(format!("        +{} {}()", ret_type, op_name));
                logical_ops_bullets.push(format!(
                    "- `+{}() : {}` - Operation for {}",
                    op_name, ret_type, part_name
                ));
            }
        }

        if member_lines.is_empty() {
            member_lines.push("        +String status".to_string());
        }

        let members_block = member_lines.join("\n");
        let logical_ops_block = logical_ops_bullets.join("\n");

        let content = format!(
            r#"---
title: "Feature {i:02}: {part_name} Architecture & Control"
version: "1.0.0"
date: "{today_iso}"
type: feature
part: "{part_name}"
part_def: "{part_name}"
generation_mode: subagent
---

# Feature {i:02}: {part_name} Architecture & Control

## Metadata
| Attribute | Specification Detail |
| :--- | :--- |
| **Title** | Feature {i:02}: {part_name} |
| **Version** | 1.0.0 |
| **Date** | {today_iso} |
| **Type** | feature |
| **Part** | {part_name} |
| **Generation Mode** | subagent |

## Architectural Structure

```mermaid
classDiagram
    class {part_name} {{
{members_block}
    }}
```

## Logical Operations & Interface Messages
{logical_ops_block}

## Interface Requirements
### 1. Payload Schema
Formal schema and interface definition for {part_name}.

### 2. Validation & Constraints
Formal constraints and invariants enforced by {part_name}.
"#
        );

        let rel_path = format!("features/FEAT-{:02}-{}.md", i, part_name);
        generated_files.insert(rel_path, content);
    }

    // 3. User Stories (US-*.md) from Interactions
    let interactions = pkg.get_all_interactions();
    for (idx, inter) in interactions.iter().enumerate() {
        let i = idx + 1;
        let inter_name = sanitize_id(&inter.name);
        let lifelines = if inter.lifelines.is_empty() {
            vec![format!("{}Source", inter_name), format!("{}Target", inter_name)]
        } else {
            inter.lifelines.iter().map(|l| sanitize_id(l)).collect()
        };
        let messages = if inter.messages.is_empty() {
            vec![format!("process_{}", inter_name.to_lowercase())]
        } else {
            inter.messages.clone()
        };
        let trigger = inter
            .triggers
            .first()
            .cloned()
            .unwrap_or_else(|| format!("{}_Trigger", inter_name));
        let tc_name = format!("TC_{}", inter_name);
        let subject_part = lifelines.get(1).unwrap_or(&lifelines[0]).clone();

        let mut seq_lines = vec![
            "sequenceDiagram".to_string(),
            "    autonumber".to_string(),
        ];
        for ll in &lifelines {
            seq_lines.push(format!("    participant {}", ll));
        }
        for j in 0..lifelines.len().saturating_sub(1) {
            let msg = messages.get(j).unwrap_or(&messages[0]);
            seq_lines.push(format!("    {}->>{}: {}()", lifelines[j], lifelines[j + 1], msg));
        }
        let seq_diagram = seq_lines.join("\n");

        let content = format!(
            r#"---
title: "User Story {i:02}: {inter_name}"
version: "1.0.0"
date: "{today_iso}"
type: user-story
interaction: "{inter_name}"
interaction_def: "{inter_name}"
test_case: "{tc_name}"
test_case_def: "{tc_name}"
subject: "{subject_part}"
generation_mode: subagent
---

# User Story {i:02}: {inter_name}

## Metadata
| Attribute | Specification Detail |
| :--- | :--- |
| **Title** | User Story {i:02}: {inter_name} |
| **Version** | 1.0.0 |
| **Date** | {today_iso} |
| **Type** | user-story |
| **Interaction** | {inter_name} |
| **Test Case** | {tc_name} |
| **Subject** | {subject_part} |
| **Generation Mode** | subagent |

## Sequence Diagram

```mermaid
{seq_diagram}
```

## Acceptance Criteria (BDD)

Scenario: Verify {inter_name} Nominal Flow
  Given the system is initialized in nominal operational state
  When the {trigger} occurs
  Then the interaction completes successfully within real-time latency bounds.

## Test Steps
- step InitializeTestHarness
- step DispatchCommand
- step VerifyResponse
"#
        );

        let rel_path = format!("user-stories/US-{:02}-{}.md", i, inter_name);
        generated_files.insert(rel_path, content);
    }

    // 4. Use Cases (UC-*.md) from UseCaseDef
    let use_cases = pkg.get_all_use_cases();
    for (idx, uc) in use_cases.iter().enumerate() {
        let i = idx + 1;
        let uc_name = sanitize_id(&uc.name);
        let subject = uc
            .subject
            .as_deref()
            .filter(|s| !s.is_empty())
            .map(sanitize_id)
            .unwrap_or_else(|| format!("{}_Subject", uc_name));
        let actors: Vec<String> = if uc.actors.is_empty() {
            if let Some(ref a) = uc.actor {
                vec![sanitize_id(a)]
            } else {
                vec![format!("{}_Actor", uc_name)]
            }
        } else {
            uc.actors.iter().map(|a| sanitize_id(a)).collect()
        };
        let primary_actor = &actors[0];
        let actors_yaml = actors
            .iter()
            .map(|a| format!("  - {}", a))
            .collect::<Vec<_>>()
            .join("\n");
        let actors_csv = actors.join(", ");
        let objective = uc
            .objective
            .clone()
            .or_else(|| uc.doc.clone())
            .unwrap_or_else(|| format!("Execute formal operational objective for {}", uc_name));

        let content = format!(
            r#"---
title: "Use Case {i:02}: {uc_name}"
version: "1.0.0"
date: "{today_iso}"
type: use-case
use_case_def: "{uc_name}"
use_case: "{uc_name}"
subject: "{subject}"
subject_part: "{subject}"
actors:
{actors_yaml}
objective: "{objective}"
generation_mode: subagent
---

# Use Case {i:02}: {uc_name}

## Metadata
| Attribute | Specification Detail |
| :--- | :--- |
| **Title** | Use Case {i:02}: {uc_name} |
| **Version** | 1.0.0 |
| **Date** | {today_iso} |
| **Type** | use-case |
| **Subject Part** | `{subject}` |
| **Actors** | {actors_csv} |
| **Objective** | {objective} |
| **Generation Mode** | subagent |

## Operational Flow

```mermaid
flowchart TD
    Actor["{primary_actor}"] --> Action["{uc_name}"]
    Action --> Target["{subject}"]
```

## Primary Scenario Steps
1. Actor `{primary_actor}` initiates `{uc_name}`.
2. Subject `{subject}` verifies precondition status.
3. System completes operation within specified performance envelope.
"#
        );

        let rel_path = format!("use-cases/UC-{:02}-{}.md", i, uc_name);
        generated_files.insert(rel_path, content);
    }

    // 5. STPA Matrix (safety/STPA_MATRIX.md)
    let ucas = expand_cartesian_stpa(pkg);
    let all_constraints = pkg.get_all_constraints();

    let mut sc_table = String::new();
    sc_table.push_str("| SC ID | Constraint Statement / Description | Controller / Subsystem | Traceability / UCA |\n");
    sc_table.push_str("| :--- | :--- | :--- | :--- |\n");

    for (idx, c) in all_constraints.iter().enumerate() {
        let sc_id = format!("SC-{:02}", idx + 1);
        let desc = c.doc.as_deref().filter(|d| !d.is_empty()).unwrap_or(&c.expression);
        let desc_clean = if desc.is_empty() { &c.name } else { desc }.replace('|', "\\|");
        let uca_trace = ucas
            .iter()
            .find(|u| u.constraint == sc_id || u.constraint == c.name)
            .map(|u| u.id.as_str())
            .unwrap_or("-");
        let controller = ucas
            .iter()
            .find(|u| u.constraint == sc_id || u.constraint == c.name)
            .map(|u| u.controller.as_str())
            .unwrap_or("-");
        sc_table.push_str(&format!(
            "| **{}** | {} | {} | {} |\n",
            sc_id, desc_clean, controller, uca_trace
        ));
    }

    for u in &ucas {
        if !all_constraints.iter().any(|c| c.name == u.constraint) {
            sc_table.push_str(&format!(
                "| **{}** | System shall prevent {} during {} | {} | {} |\n",
                u.constraint, u.guide_word, u.control_action, u.controller, u.id
            ));
        }
    }

    let mut uca_table = String::new();
    uca_table.push_str("| UCA ID | Controller | Control Action | Guide Word | Hazard | Safety Constraint |\n");
    uca_table.push_str("| :--- | :--- | :--- | :--- | :--- | :--- |\n");
    for u in &ucas {
        uca_table.push_str(&format!(
            "| {} | {} | {} | {} | {} | {} |\n",
            u.id, u.controller, u.control_action, u.guide_word, u.hazard, u.constraint
        ));
    }

    let stpa_content = format!(
        r#"# STPA Safety & Failure Mode Tracking Matrix

## 1. Formal Safety Constraints
{sc_table}
## 2. STPA Unsafe Control Actions (UCA) Matrix
{uca_table}
"#
    );
    generated_files.insert("safety/STPA_MATRIX.md".to_string(), stpa_content);

    // If not dry-run, write to disk
    if !opts.dry_run {
        for (rel_path, text) in &generated_files {
            let full_dest = target_out_dir.join(rel_path);
            if let Some(parent) = full_dest.parent() {
                fs::create_dir_all(parent).map_err(|e| {
                    format!("Failed to create directory '{}': {}", parent.display(), e)
                })?;
            }
            write_atomic(&full_dest, text).map_err(|e| e.to_string())?;
        }
        println!(
            "[SysML v2 Forward-Sync] Successfully synchronized {} specifications to '{}'",
            generated_files.len(),
            target_out_dir.display()
        );
    } else {
        println!(
            "[SysML v2 Forward-Sync] [DRY RUN] Would generate {} specifications in '{}'",
            generated_files.len(),
            target_out_dir.display()
        );
    }

    Ok(generated_files)
}

#[cfg(test)]
mod tests {
    use super::*;
    use deap_core::sysml_ast::PartDef;

    #[test]
    fn test_forward_sync_generates_expected_files() {
        let mut pkg = PackageDef::default();
        pkg.name = "TestSystem".to_string();

        let mut p1 = PartDef::default();
        p1.name = "Airframe".to_string();
        pkg.part_defs.push(p1);

        let opts = ForwardSyncOptions {
            schema_path: PathBuf::from("schema/test.sysml"),
            docs_dir: PathBuf::from("docs"),
            out_dir: None,
            dry_run: true,
            force: true,
        };

        let generated = forward_sync_sysml_to_specs(&pkg, &opts).unwrap();
        assert!(generated.keys().any(|k| k.starts_with("epics/")));
        assert!(generated.keys().any(|k| k.starts_with("features/")));
        assert!(generated.contains_key("safety/STPA_MATRIX.md"));
    }

    #[test]
    fn test_recursive_package_traversal_picks_up_subpackage_elements() {
        let mut root = PackageDef {
            name: "DEAP_Compiler_System".to_string(),
            ..Default::default()
        };
        let mut sub = PackageDef {
            name: "Subsystem_Alpha".to_string(),
            ..Default::default()
        };
        sub.capability_defs.push(deap_core::sysml_ast::CapabilityDef {
            name: "AlphaCapability".to_string(),
            subsystem: Some("Subsystem_Alpha".to_string()),
            ..Default::default()
        });
        sub.part_defs.push(PartDef {
            name: "AlphaPart".to_string(),
            ..Default::default()
        });
        sub.use_case_defs.push(deap_core::sysml_ast::UseCaseDef {
            name: "AlphaUseCase".to_string(),
            subject: Some("AlphaPart".to_string()),
            ..Default::default()
        });
        sub.interaction_defs.push(deap_core::sysml_ast::InteractionDef {
            name: "AlphaInteraction".to_string(),
            lifelines: vec!["Source".to_string(), "Target".to_string()],
            ..Default::default()
        });
        root.packages.push(sub);

        let opts = ForwardSyncOptions {
            schema_path: PathBuf::from("schema/test.sysml"),
            docs_dir: PathBuf::from("docs"),
            out_dir: None,
            dry_run: true,
            force: true,
        };

        let generated = forward_sync_sysml_to_specs(&root, &opts).unwrap();
        assert!(generated.keys().any(|k| k.contains("AlphaCapability")), "Subpackage capability must generate Epic");
        assert!(generated.keys().any(|k| k.contains("AlphaPart")), "Subpackage part must generate Feature");
        assert!(generated.keys().any(|k| k.contains("AlphaUseCase")), "Subpackage use case must generate Use Case");
        assert!(generated.keys().any(|k| k.contains("AlphaInteraction")), "Subpackage interaction must generate User Story");
    }

    #[test]
    fn test_zero_hardcoded_domain_strings_exist_in_output_specifications() {
        let mut pkg = PackageDef {
            name: "GenericCompiler".to_string(),
            ..Default::default()
        };
        let mut sub = PackageDef {
            name: "ParserSubsystem".to_string(),
            ..Default::default()
        };
        sub.part_defs.push(PartDef {
            name: "LexerEngine".to_string(),
            ..Default::default()
        });
        pkg.packages.push(sub);

        let opts = ForwardSyncOptions {
            schema_path: PathBuf::from("schema/test.sysml"),
            docs_dir: PathBuf::from("docs"),
            out_dir: None,
            dry_run: true,
            force: true,
        };

        let generated = forward_sync_sysml_to_specs(&pkg, &opts).unwrap();
        let forbidden = [
            "CoreController",
            "TelemetrySync",
            "ExecuteAutonomousMission",
            "HandleSafetyFailsafe",
            "SensorSuite",
            "OperatorConsole",
            "SafetyWatchdog",
            "flight parameters",
        ];

        for (path, content) in &generated {
            for bad in &forbidden {
                assert!(
                    !content.contains(bad),
                    "File '{}' contains forbidden domain string '{}'",
                    path,
                    bad
                );
            }
        }
    }

    #[test]
    fn test_empty_collections_do_not_emit_phantom_specifications() {
        let mut pkg = PackageDef {
            name: "CleanSystem".to_string(),
            ..Default::default()
        };
        pkg.part_defs.push(PartDef {
            name: "CleanPart".to_string(),
            ..Default::default()
        });

        let opts = ForwardSyncOptions {
            schema_path: PathBuf::from("schema/test.sysml"),
            docs_dir: PathBuf::from("docs"),
            out_dir: None,
            dry_run: true,
            force: true,
        };

        let generated = forward_sync_sysml_to_specs(&pkg, &opts).unwrap();
        assert!(
            !generated.keys().any(|k| k.starts_with("use-cases/")),
            "Empty use cases must not emit phantom use-case files"
        );
        assert!(
            !generated.keys().any(|k| k.starts_with("user-stories/")),
            "Empty interactions must not emit phantom user-story files"
        );
    }
}
