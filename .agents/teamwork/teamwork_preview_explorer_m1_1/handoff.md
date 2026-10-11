# Handoff Report -- Use Case Prefix Elimination & Parser Fix Exploration

**Agent ID**: teamwork_preview_explorer_m1_1  
**Working Directory**: `/Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_explorer_m1_1`  
**Target Milestone**: teamwork_preview_explorer_m1  
**Status**: Investigation Complete -- Implementation Blueprint Ready  

---

## 1. Observation

### 1.1 Compiler Parser Bug in `crates/compile-sysml/src/parser/grammar.rs`
- In original `parse_use_case_decl` (`grammar.rs:1088-1143`), parsing the body of `use case def` only handled `Subject`, `Actor`, `Objective`, and `Step`:
  ```rust
  if self.check(&TokenKind::Subject) { ... }
  else if self.check(&TokenKind::Actor) { ... }
  else if self.check(&TokenKind::Objective) { ... }
  else if self.check(&TokenKind::Step) { ... }
  else { self.skip_until_semi_or_brace(); }
  ```
- When inner `TokenKind::Doc` or `TokenKind::DocComment` appeared inside `use case def { ... }`, the token fell into `self.skip_until_semi_or_brace()`, skipping all content until `;` or `}` and discarding the block comment text completely.
- `UseCaseDef.doc` was assigned strictly from the parameter `doc` (the outer doc comment above `use case def`), losing all inner structured specifications.
- **Current Workspace State**: `crates/compile-sysml/src/parser/grammar.rs` has already been updated in the working tree (lines 1106-1160) to handle `TokenKind::Doc` and `TokenKind::DocComment` inside `use case def { ... }`, concatenating them into `uc_doc: Option<String>` and preserving `includes`, `extends`, `preconditions`, `postconditions`. Two unit tests (`test_parse_use_case_def_preserves_inner_doc_comments` and `test_parse_use_case_def_outer_and_inner_doc_concatenation`) have been added at lines 2375-2465.
- **Binary Status**: `target/release/compile-sysml` binary timestamp is `Oct 11 23:12`, while `grammar.rs` was updated `Oct 12 04:05`. The release binaries have not yet been rebuilt with `cargo build --release --workspace`.

### 1.2 Redundant Repeating Prefix Bug in `crates/compile-sysml/src/sync/forward.rs`
- In `forward.rs` lines 1106-1110:
  ```rust
  let u_num = uc_m.u_num;
  let uc_slug = sanitize_id(&uc_m.uc.name);
  let rel_path = format!("use-cases/UC-{:02}-{}.md", u_num, uc_slug);
  let _uc_date = resolve_date(&target_out_dir, &rel_path, &today_iso);
  let uc_issue_id = resolve_issue_id(&target_out_dir, &rel_path, u_num + 94);
  let title = format!("Use Case {:02}: {}", u_num, to_display_name(&uc_m.uc.name));
  ```
- `uc_m.uc.name` in all 12 SysML behavior files begins with `UC_XX_` (e.g. `UC_01_System_Vision_and_Foundational_Invariants`).
- `to_display_name` converts `_` to spaces, transforming `UC_01_...` to `"UC 01 System Vision and Foundational Invariants"`.
- `title` becomes `"Use Case 01: UC 01 System Vision and Foundational Invariants"`, creating stuttering redundant prefix `Use Case 01: UC 01`.
- `uc_slug` becomes `"UC_01_System_Vision_and_Foundational_Invariants"`.
- `rel_path` becomes `"use-cases/UC-01-UC_01_System_Vision_and_Foundational_Invariants.md"`.
- In Epic checklists (`forward.rs:748-756`), lines format identical stuttering paths:
  ```rust
  let uc_slug = sanitize_id(&uc_m.uc.name);
  let uc_path = format!("use-cases/UC-{:02}-{}.md", uc_m.u_num, uc_slug);
  assoc_uc.push(format!(
      "- [ ] #{} - [Use Case {:02}: {}](../use-cases/UC-{:02}-{}.md)",
      uc_issue, uc_m.u_num, to_display_name(&uc_m.uc.name), uc_m.u_num, uc_slug
  ));
  ```
  resulting in checklist items like `- [ ] #95 - [Use Case 01: UC 01 System Vision and Foundational Invariants](../use-cases/UC-01-UC_01_System_Vision_and_Foundational_Invariants.md)`.

### 1.3 Hardcoded Specification Source in `forward.rs`
- In `forward.rs` lines 1237 and 1269-1275:
  ```rust
  | **Specification Source** | [schema/conops/activities.sysml](../../schema/conops/activities.sysml) |
  ...
  ## Source References
  Use case operational flows and lifecycle activity references:
  - ConOps Operational Activities: `schema/conops/activities.sysml`
  ```
  The specification source is statically hardcoded to `conops/activities.sysml` for all 12 Use Cases, despite each Use Case actually originating from `schema/subsystems/{subsystem}/behavior.sysml`.

### 1.4 Issue ID Preservation in `resolve_issue_id`
- `resolve_issue_id` (`forward.rs:121-169`) checks `target_out_dir.join(rel_path)`.
- If the exact file at `rel_path` does not exist (as happens when renaming from `UC-01-UC_01_*.md` to `UC-01-*.md`), it falls back to `fallback_id`.
- In line 1109, `fallback_id` is `u_num + 94`. For `u_num` 1..=12, this evaluates to 95..=106.
- The 12 existing files on disk (`docs/use-cases/UC-*-UC_*.md`) currently hold issue IDs #95 through #106.
- If `resolve_issue_id` also inspects the directory for files matching `UC-{:02}-*.md` when `rel_path` is missing, historical IDs are guaranteed to be preserved regardless of renames or fallback values.

### 1.5 SysML Models in `schema/subsystems/*/behavior.sysml`
- Exactly 12 `use case def` blocks exist across the 12 subsystem behavior files:
  1. `schema/subsystems/system_vision/behavior.sysml`: `UC_01_System_Vision_and_Foundational_Invariants`
  2. `schema/subsystems/universal_schema_ingestion/behavior.sysml`: `UC_02_Universal_Schema_Ingestion_Workflow`
  3. `schema/subsystems/core_metamodel_node_arena/behavior.sysml`: `UC_03_Node_Arena_Memory_Management_Workflow`
  4. `schema/subsystems/sysml_grammar_lowering/behavior.sysml`: `UC_04_SysML_Grammar_Lowering_Workflow`
  5. `schema/subsystems/physical_metrology_flows/behavior.sysml`: `UC_05_Physical_Metrology_and_Flow_Conservation_Workflow`
  6. `schema/subsystems/spatio_temporal_state_solvers/behavior.sysml`: `UC_06_State_Machine_Solver_Workflow`
  7. `schema/subsystems/formal_safety_traceability/behavior.sysml`: `UC_07_Safety_Assurance_and_Traceability_Workflow`
  8. `schema/subsystems/interconnect_contracts/behavior.sysml`: `UC_08_ICD_Interconnect_Contract_Generation_Workflow`
  9. `schema/subsystems/downstream_agile_projections/behavior.sysml`: `UC_09_Agile_Specification_Projection_Workflow`
  10. `schema/subsystems/multi_target_codegen/behavior.sysml`: `UC_10_Multi_Target_CodeGen_Workflow`
  11. `schema/subsystems/diagnostic_error_catalog/behavior.sysml`: `UC_11_Diagnostic_Catalog_Triage_Workflow`
  12. `schema/subsystems/compiler_assurance/behavior.sysml`: `UC_12_Compiler_Performance_Assurance_Workflow`
- Every single one of these 12 definitions contains a comprehensive inner `doc /* ... */` block specifying:
  - `Actors:` (e.g. `HumanEngineer, CIContinuousIntegrationRunner`)
  - `Subject:` (e.g. `SystemVisionEngine`)
  - `Preconditions:`
  - `Trigger:`
  - `Main Success Scenario:` (numbered steps 1..6)
  - `Alternate and Exception Flows:` (exception steps `5a`..`5j`)
  - `Postconditions:`
- `forward.rs:367-422` `parse_use_case_doc` already has the full parsing logic for extracting these 7 section headers from `uc.doc`.

### 1.6 Current Files in `docs/use-cases/`
- All 12 files currently use the redundant naming pattern:
  - `docs/use-cases/UC-01-UC_01_System_Vision_and_Foundational_Invariants.md`
  - `docs/use-cases/UC-02-UC_02_Universal_Schema_Ingestion_Workflow.md`
  - ...
  - `docs/use-cases/UC-12-UC_12_Compiler_Performance_Assurance_Workflow.md`
- Their content currently contains generic 4-line fallback boilerplate because `target/release/compile-sysml` had discarded the inner doc comments during previous forward sync runs.

---

## 2. Logic Chain

1. **Root Cause of Boilerplate Use Cases** (Ref: Section 1.1, 1.5, 1.6):
   - In SysML models, structured Use Case requirements live inside inner `doc /* ... */` blocks in `use case def { ... }`.
   - The compiled release binary `compile-sysml` discarded these inner doc blocks because `parse_use_case_decl` skipped them.
   - When `forward_sync_sysml_to_specs` executed, `uc.doc` contained only the outer doc string without structured headers.
   - `parse_use_case_doc` returned default empty fields, triggering the fallback boilerplate generator in `forward.rs:1140-1182`.

2. **Resolution of Parser Bug** (Ref: Section 1.1):
   - Capturing `TokenKind::Doc` and `TokenKind::DocComment` inside `parse_use_case_decl` preserves the inner doc block.
   - Concatenating outer and inner doc with `\n\n` allows `parse_use_case_doc` to skip the outer summary and match all 7 structured sections (`Actors:`, `Subject:`, `Preconditions:`, `Trigger:`, `Main Success Scenario:`, `Alternate and Exception Flows:`, `Postconditions:`).

3. **Elimination of Redundant Prefixes** (Ref: Section 1.2):
   - A normalization helper `strip_use_case_prefix(name: &str) -> &str` that strips leading `UC_XX_`, `UC-XX-`, or `UCXX_` resolves the root identifier:
     `"UC_01_System_Vision_and_Foundational_Invariants"` -> `"System_Vision_and_Foundational_Invariants"`.
   - `to_display_name(clean_name)` yields `"System Vision and Foundational Invariants"`.
   - `format!("Use Case {:02}: {}", u_num, to_display_name(clean_name))` yields `"Use Case 01: System Vision and Foundational Invariants"`.
   - `format!("use-cases/UC-{:02}-{}.md", u_num, sanitize_id(clean_name))` yields `"use-cases/UC-01-System_Vision_and_Foundational_Invariants.md"`.
   - Applying the same helper in Epic checklist generation (`forward.rs:748-756`) aligns all Epic checklist links.

4. **Dynamic Specification Source Binding** (Ref: Section 1.3, 1.5):
   - Each package `p` maps to a subsystem directory: `subsys_dir = to_snake_case(&p.name)`.
   - Attaching `subsys_dir` to `UseCaseMeta` allows dynamic formatting of `Specification Source`:
     `[schema/subsystems/{subsys_dir}/behavior.sysml](../../schema/subsystems/{subsys_dir}/behavior.sysml)`.
   - And in Source References:
     `- Subsystem Behavior Specification: \`schema/subsystems/{subsys_dir}/behavior.sysml\``.

5. **Issue ID Preservation Across Renames** (Ref: Section 1.4):
   - Enhancing `resolve_issue_id` to search for existing files by prefix `UC-{:02}-*.md` when `rel_path` does not exist ensures that existing IDs #95-#106 are read directly from disk prior to removal.
   - The fallback `u_num + 94` also matches #95-#106.

6. **Execution Sequence** (Ref: Section 1.1, 1.6):
   - Step 1: Implement prefix stripping, dynamic specification source, and prefix-aware `resolve_issue_id` in `crates/compile-sysml/src/sync/forward.rs`.
   - Step 2: Rebuild all workspace binaries in release mode (`cargo build --release --workspace`).
   - Step 3: Remove legacy duplicated files (`git rm docs/use-cases/UC-*-UC_*.md`).
   - Step 4: Run `./target/release/compile-sysml --compile` and `./target/release/compile-sysml --forward-sync --force`.
   - Step 5: Verify all 32 quality gates with `./target/release/verify-baseline . --no-domain` and spec audit with `./target/release/verify-baseline . --spec-only`.
   - Step 6: Synchronize issue bodies and titles to GitHub with `./target/release/reconcile-backlog --sync-bodies`.
   - Step 7: Commit with neutral citations `(refs #115)` and push to remote.

---

## 3. Caveats

- **No Caveats on Root Cause**: The parser bug and generator prefix mechanisms are verified with exact file paths, line numbers, and token behaviors.
- **Git State**: `crates/compile-sysml/src/parser/grammar.rs` currently contains working tree modifications that must be committed together with `forward.rs` changes.
- **Remote Synchronization**: `reconcile-backlog --sync-bodies` interacts with GitHub via `gh issue edit`. An active internet connection and GitHub CLI authentication are required during the final projection step.

---

## 4. Conclusion

The solution consists of four cohesive changes:
1. Retaining the `grammar.rs` parser fix to capture inner `doc /* ... */` blocks on `UseCaseDef.doc`.
2. Implementing `strip_use_case_prefix`, dynamic subsystem behavior linking, and prefix-aware `resolve_issue_id` in `crates/compile-sysml/src/sync/forward.rs`.
3. Rebuilding binaries (`cargo build --release --workspace`), purging legacy `docs/use-cases/UC-*-UC_*.md` files via `git rm`, and regenerating all specifications via `compile-sysml --compile` and `compile-sysml --forward-sync --force`.
4. Passing `./target/release/verify-baseline . --spec-only` and `./target/release/verify-baseline . --no-domain` (all 32 gates), projecting to GitHub via `reconcile-backlog --sync-bodies`, and committing with neutral citations `(refs #115)`.

---

## 5. Verification Method

To independently verify the implementation after code updates:

1. **Build Toolchain**:
   ```bash
   cargo build --release --workspace
   ```
   *Expected*: Zero compilation errors, updated `./target/release/compile-sysml` and `./target/release/reconcile-backlog`.

2. **Purge Legacy Files & Regenerate Specs**:
   ```bash
   git rm docs/use-cases/UC-*-UC_*.md
   ./target/release/compile-sysml --compile
   ./target/release/compile-sysml --forward-sync --force
   ```
   *Expected*: Exactly 12 new files generated under `docs/use-cases/` with names `UC-01-System_Vision_and_Foundational_Invariants.md` through `UC-12-Compiler_Performance_Assurance_Workflow.md`. Zero files matching `UC-*-UC_*.md`.

3. **Verify File Contents**:
   - Check title in `docs/use-cases/UC-01-System_Vision_and_Foundational_Invariants.md`:
     Must read `# Use Case 01: System Vision and Foundational Invariants` (no stuttering `UC 01`).
   - Check scenarios:
     Must contain full 6-step `Main Success Scenario` and 10 exception flows (`5a` through `5j`).
   - Check Specification Source:
     Must link `[schema/subsystems/system_vision/behavior.sysml](../../schema/subsystems/system_vision/behavior.sysml)`.
   - Check Epic checklists in `docs/epics/EPIC-*.md`:
     Must link to clean filenames without stuttering prefixes.

4. **Run Quality Gates**:
   ```bash
   ./target/release/verify-baseline . --spec-only
   ./target/release/verify-baseline . --no-domain
   ```
   *Expected*: 0 findings, all 32 quality gates pass with exit code 0.

5. **Sync to GitHub & Push**:
   ```bash
   ./target/release/reconcile-backlog --sync-bodies
   git status
   git diff origin/main
   ```
   *Expected*: Remote issues synchronized, working tree clean after commit, remote up to date.

---

## 6. Proposed Code Changes for Implementer

### File 1: `crates/compile-sysml/src/sync/forward.rs`

```rust
// 1. Add prefix stripping helper
fn strip_use_case_prefix(name: &str) -> &str {
    let s = name.trim();
    if s.len() >= 2 && s[..2].eq_ignore_ascii_case("uc") {
        let rest = &s[2..];
        let rest = rest.strip_prefix('_').or_else(|| rest.strip_prefix('-')).unwrap_or(rest);
        let digit_count = rest.chars().take_while(|c| c.is_ascii_digit()).count();
        if digit_count > 0 {
            let after_digits = &rest[digit_count..];
            let clean = after_digits.strip_prefix('_').or_else(|| after_digits.strip_prefix('-')).unwrap_or(after_digits);
            if !clean.is_empty() {
                return clean;
            }
        }
    }
    s
}

// 2. In resolve_issue_id: add historical prefix fallback
fn resolve_issue_id(target_out_dir: &Path, rel_path: &str, fallback_id: usize) -> usize {
    let full = target_out_dir.join(rel_path);
    if let Ok(content) = fs::read_to_string(&full) {
        if let Some(id) = parse_issue_id_from_content(&content) {
            return id;
        }
    }
    // Prefix lookup for renamed files (e.g., UC-01-*.md)
    if let Some(parent) = Path::new(rel_path).parent() {
        if let Some(file_name) = Path::new(rel_path).file_name().and_then(|f| f.to_str()) {
            let prefix_end = file_name.find('-').and_then(|first_dash| {
                file_name[first_dash + 1..].find('-').map(|second_dash| first_dash + 1 + second_dash + 1)
            });
            if let Some(prefix_len) = prefix_end {
                let prefix = &file_name[..prefix_len];
                let dir_path = target_out_dir.join(parent);
                if let Ok(entries) = fs::read_dir(&dir_path) {
                    for entry in entries.flatten() {
                        let name = entry.file_name();
                        let name_str = name.to_string_lossy();
                        if name_str.starts_with(prefix) && name_str.ends_with(".md") {
                            if let Ok(content) = fs::read_to_string(entry.path()) {
                                if let Some(id) = parse_issue_id_from_content(&content) {
                                    return id;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    fallback_id
}

// 3. In UseCaseMeta struct: add subsys_dir
struct UseCaseMeta<'a> {
    uc: &'a UseCaseDef,
    pkg_name: String,
    subsys_dir: String,
    engine_name: String,
    engine_feat_num: usize,
    u_num: usize,
    story_s_num: Option<usize>,
}

// 4. In uc_metas population: assign subsys_dir
let subsys_dir = if p.name == "DEAP_Compiler_System" || p.name == "SysML_Model" {
    "architecture".to_string()
} else if p.name == "ConOps" {
    "conops".to_string()
} else {
    to_snake_case(&p.name)
};

// 5. In Epic checklist generation (lines 748-756):
let clean_name = strip_use_case_prefix(&uc_m.uc.name);
let uc_slug = sanitize_id(clean_name);
let uc_path = format!("use-cases/UC-{:02}-{}.md", uc_m.u_num, uc_slug);
let uc_issue = resolve_issue_id(&target_out_dir, &uc_path, 94 + uc_m.u_num);
assoc_uc.push(format!(
    "- [ ] #{} - [Use Case {:02}: {}](../use-cases/UC-{:02}-{}.md)",
    uc_issue, uc_m.u_num, to_display_name(clean_name), uc_m.u_num, uc_slug
));

// 6. In Use Case generation (lines 1104-1275):
let clean_name = strip_use_case_prefix(&uc_m.uc.name);
let uc_slug = sanitize_id(clean_name);
let rel_path = format!("use-cases/UC-{:02}-{}.md", u_num, uc_slug);
let _uc_date = resolve_date(&target_out_dir, &rel_path, &today_iso);
let uc_issue_id = resolve_issue_id(&target_out_dir, &rel_path, u_num + 94);
let title = format!("Use Case {:02}: {}", u_num, to_display_name(clean_name));

// In CommonMark table & Source References:
format!(
    "| **Specification Source** | [schema/subsystems/{subsys_dir}/behavior.sysml](../../schema/subsystems/{subsys_dir}/behavior.sysml) |",
    subsys_dir = uc_m.subsys_dir
)
```
