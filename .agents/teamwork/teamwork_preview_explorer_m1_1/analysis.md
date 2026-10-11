# Milestone 1: Unified Metadata Contract -- Codebase Exploration & Analysis

## Executive Summary
This analysis investigates the implementation scope for Milestone 1 (Unified Metadata Contract) in `gintatkinson/dumpiler-01`. The milestone replaces raw YAML frontmatter (`--- ... ---`) across all generated specification files in `docs/` (`docs/epics/`, `docs/features/`, `docs/user-stories/`, `docs/use-cases/`) with a native CommonMark two-column table located directly at lines 1-10. It also updates the governance constitution line 94 and equips `crates/verify-baseline/src/spec_audit/` to enforce this contract while rejecting raw YAML frontmatter.

---

## 1. Specification Generation Engine (`crates/compile-sysml/src/sync/forward.rs`)

### 1.1 Existing Code Analysis & Line Numbers
In `crates/compile-sysml/src/sync/forward.rs`, specifications are currently generated with both raw YAML frontmatter at lines 1-10/13 AND a redundant `## Metadata` section further down:

1. **Epics Template (`lines 615-640`)**:
   ```rust
   let content = format!(
       r#"---
   title: "{title}"
   version: "1.0.0"
   date: "{epic_date}"
   type: epic
   package: "{pkg_name}"
   subsystem: "{subsys_display}"
   issue_id: {epic_issue_id}
   generation_mode: subagent
   ---

   # {title}

   ## Metadata
   | Attribute | Specification Detail |
   | :--- | :--- |
   | **Title** | {title} |
   | **Version** | 1.0.0 |
   | **Date** | {epic_date} |
   | **Type** | epic |
   | **Package** | {pkg_name} |
   | **Subsystem** | {subsys_display} |
   | **Issue ID** | #{epic_issue_id} |
   | **Generation Mode** | subagent |
   ...
   ```

2. **Features Template (`lines 762-788`)**:
   ```rust
   let content = format!(
       r#"---
   title: "{title}"
   version: "1.0.0"
   date: "{feat_date}"
   type: feature
   part: "{part_name}"
   part_def: "{part_name}"
   subsystem: "{subsys_display}"
   issue_id: {feat_issue_id}
   generation_mode: subagent
   ---

   # {title}

   ## Metadata
   | Attribute | Specification Detail |
   | :--- | :--- |
   | **Title** | {title} |
   | **Version** | 1.0.0 |
   | **Date** | {feat_date} |
   | **Type** | feature |
   | **Part** | {part_name} |
   | **Subsystem** | {subsys_display} |
   | **Issue ID** | #{feat_issue_id} |
   | **Generation Mode** | subagent |
   ...
   ```

3. **User Stories Template (`lines 873-899`)**:
   ```rust
   let content = format!(
       r#"---
   title: "{title}"
   version: "1.0.0"
   date: "{us_date}"
   type: user-story
   epic: "EPIC-02-ConOps"
   interaction: "{action_name}"
   subject: "{engine_name}"
   issue_id: {us_issue_id}
   generation_mode: subagent
   ---

   # {title}

   ## Metadata
   | Attribute | Specification Detail |
   | :--- | :--- |
   | **Title** | {title} |
   | **Version** | 1.0.0 |
   | **Date** | {us_date} |
   | **Type** | user-story |
   | **Interaction** | {action_name} |
   | **Subject** | {engine_name} |
   | **Issue ID** | #{us_issue_id} |
   | **Generation Mode** | subagent |
   ...
   ```

4. **Use Cases Template (`lines 1039-1068`)**:
   ```rust
   let content = format!(
       r#"---
   title: "{title}"
   version: "1.0.0"
   date: "{uc_date}"
   type: use-case
   epic: "EPIC-02-ConOps"
   use_case_def: "{uc_name}"
   subject: "{subject}"
   actors:
   {actors_yaml}
   issue_id: {uc_issue_id}
   generation_mode: subagent
   ---

   # {title}

   ## Metadata
   | Attribute | Specification Detail |
   | :--- | :--- |
   | **Title** | {title} |
   | **Version** | 1.0.0 |
   | **Date** | {uc_date} |
   | **Type** | use-case |
   | **Use Case Def** | {uc_name} |
   | **Subject** | {subject} |
   | **Actors** | {primary_actor} |
   | **Issue ID** | #{uc_issue_id} |
   | **Generation Mode** | subagent |
   ...
   ```

5. **Issue ID Extraction in `resolve_issue_id` (`lines 98-119`)**:
   ```rust
   fn resolve_issue_id(target_out_dir: &Path, rel_path: &str, fallback_id: usize) -> usize {
       let full = target_out_dir.join(rel_path);
       if let Ok(content) = fs::read_to_string(&full) {
           for line in content.lines() {
               let trimmed = line.trim();
               if trimmed.starts_with("issue_id:") {
                   let d = trimmed
                       .trim_start_matches("issue_id:")
                       .trim()
                       .trim_matches('"')
                       .trim_matches('\'')
                       .trim_start_matches('#');
                   if let Ok(parsed) = d.parse::<usize>() {
                       if parsed > 0 {
                           return parsed;
                       }
                   }
               }
           }
       }
       fallback_id
   }
   ```
   *Critical Finding*: `resolve_issue_id` currently only inspects lines starting with `"issue_id:"`. Once YAML frontmatter is removed and replaced by CommonMark table rows (e.g. `| **Issue ID** | 101 |`), re-running forward-sync will fail to preserve historical issue IDs unless `resolve_issue_id` also parses the CommonMark metadata table row!

### 1.2 Proposed Changes to `forward.rs`
1. **Eliminate YAML frontmatter and redundant `## Metadata` blocks.**
2. **Emit the CommonMark table directly at lines 1-10 with exact header:**
   ```markdown
   | Attribute | Specification Detail |
   | :--- | :--- |
   ```
3. **Mandatory attribute mapping per spec type:**
   - **Epics (`docs/epics/EPIC-*.md`)**:
     ```markdown
     | Attribute | Specification Detail |
     | :--- | :--- |
     | **Issue ID** | {epic_issue_id} |
     | **Title** | {title} |
     | **Type** | epic |
     | **Package** | {pkg_name} |
     | **Subsystem** | {subsys_display} |
     | **Generation Mode** | subagent |
     | **Specification Source** | [schema/model.sysml](../../schema/model.sysml) |

     # {title}

     ## 1. Context
     ...
     ```
     *(7 attributes + 2 header rows = 9 lines, lines 1-9; line 10 empty)*.

   - **Features (`docs/features/FEAT-*.md`)**:
     Compute `parent_epic_link` (e.g. `[EPIC-02-ConOps](../epics/EPIC-02-ConOps.md)` or `[EPIC-01-SysML_Model](../epics/EPIC-01-SysML_Model.md)` or corresponding subsystem epic), `interface_type` (e.g. `"UI / LUMI / Component"` or `"Component / Internal"`), `schema_containers` (e.g. `` `{pkg_name}::{part_name}` ``), and `specification_source` (`[schema/model.sysml](../../schema/model.sysml)`):
     ```markdown
     | Attribute | Specification Detail |
     | :--- | :--- |
     | **Issue ID** | {feat_issue_id} |
     | **Title** | {title} |
     | **Type** | feature |
     | **Parent Epic** | {parent_epic_link} |
     | **Interface Type** | {interface_type} |
     | **Schema Containers** | `{schema_container}` |
     | **Generation Mode** | subagent |
     | **Specification Source** | [schema/model.sysml](../../schema/model.sysml) |

     # {title}

     ## UML Class Diagram
     ...
     ```
     *(8 attributes + 2 header rows = exactly 10 lines, lines 1-10)*.

   - **User Stories (`docs/user-stories/US-*.md`)**:
     ```markdown
     | Attribute | Specification Detail |
     | :--- | :--- |
     | **Issue ID** | {us_issue_id} |
     | **Title** | {title} |
     | **Type** | user-story |
     | **Parent Epic** | [EPIC-02-ConOps](../epics/EPIC-02-ConOps.md) |
     | **SysML Interaction** | `{action_name}` |
     | **SysML Test Case** | `Test_{action_name}` |
     | **Generation Mode** | subagent |
     | **Specification Source** | [schema/conops/activities.sysml](../../schema/conops/activities.sysml) |

     # {title}

     ## UML Sequence Diagram
     ...
     ```
     *(8 attributes + 2 header rows = exactly 10 lines, lines 1-10)*.

   - **Use Cases (`docs/use-cases/UC-*.md`)**:
     ```markdown
     | Attribute | Specification Detail |
     | :--- | :--- |
     | **Issue ID** | {uc_issue_id} |
     | **Title** | {title} |
     | **Type** | use-case |
     | **Primary Actor** | {primary_actor} |
     | **Scope** | {subject} |
     | **Level** | User Goal |
     | **Generation Mode** | subagent |
     | **Specification Source** | [schema/model.sysml](../../schema/model.sysml) |

     # {title}

     ## UML Diagrams
     ...
     ```
     *(8 attributes + 2 header rows = exactly 10 lines, lines 1-10)*.

4. **Update `resolve_issue_id` (`lines 98-119`)**:
   Add parsing for CommonMark table row:
   ```rust
   if trimmed.starts_with("issue_id:") {
       let d = trimmed
           .trim_start_matches("issue_id:")
           .trim()
           .trim_matches('"')
           .trim_matches('\'')
           .trim_start_matches('#');
       if let Ok(parsed) = d.parse::<usize>() {
           if parsed > 0 {
               return parsed;
           }
       }
   } else if trimmed.starts_with('|') && trimmed.to_lowercase().contains("issue") && trimmed.to_lowercase().contains("id") {
       let parts: Vec<&str> = trimmed.split('|').map(|s| s.trim()).collect();
       if parts.len() >= 3 {
           let d = parts[2]
               .trim_matches('*')
               .trim_matches('`')
               .trim_start_matches('#')
               .trim();
           if let Ok(parsed) = d.parse::<usize>() {
               if parsed > 0 {
                   return parsed;
               }
           }
       }
   }
   ```

5. **Associated reverse-sync consideration (`crates/compile-sysml/src/sync/reverse.rs:59`)**:
   `reverse.rs:parse_frontmatter` should also support extracting metadata from the CommonMark table when `!trimmed.starts_with("---")` so that `--reverse-sync` functionality remains intact.

---

## 2. Specification Metadata Integrity Rule (`rules/specification-metadata-integrity.md`)

### 2.1 Existing Rule Overview
- Normative home for native CommonMark metadata table contract.
- Line 5 mandates: "All engineering specification files across the repository (`docs/epics/`, `docs/features/`, `docs/user-stories/`, and `docs/use-cases/`) MUST start at lines 1-10 with a native CommonMark two-column Markdown Metadata Table. Raw `--- ... ---` YAML frontmatter blocks are strictly forbidden in specification markdown documents."
- Line 25 mandates exact header:
  ```markdown
  | Attribute | Specification Detail |
  | :--- | :--- |
  ```
- Attributes per type:
  - Epics (`lines 46-54`): `Issue ID`, `Title`, `Type`, `Package`, `Subsystem`, `Generation Mode`, `Specification Source`. (Matches user request).
  - Features (`lines 74-83`): `Issue ID`, `Title`, `Type`, `Parent Epic`, `Interface Type`, `Schema Containers`, `Generation Mode`, `Specification Source`. (Matches user request).
  - User Stories (`lines 104-113`): `Issue ID`, `Title`, `Type`, `Parent Epic`, `SysML Interaction`, `SysML Test Case`, `Generation Mode`, `Specification Source`. (Matches user request).
  - Use Cases (`lines 134-142`): Currently specifies `Issue ID, Title, Type, Parent Epic, Schema Containers, Generation Mode, Specification Source`.
    *Difference*: The user request specifically defines Use Cases as:
    `Issue ID, Title, Type, Primary Actor, Scope, Level, Generation Mode, Specification Source`.
    To ensure 100% coherence between the rules, `compile-sysml`, and `verify-baseline`, lines 134-154 of `rules/specification-metadata-integrity.md` must be updated to align with the user request.
  - Unicode character audit: Found `\u2013` (en-dash) on lines 5 and 25 (`1–10`). This should be converted to ASCII hyphen `1-10` to maintain compliance with ASCII-only conventions.

---

## 3. Governance Constitution (`.pipeline/constitution.md`)

### 3.1 Existing Lines & Proposed Edits
- **Line 94**:
  *Existing*:
  ```markdown
  - All local specification files MUST include a permanent unique identifier (`issue_id: <int>`) in their YAML frontmatter, mapped directly to their remote issue number.
  ```
  *Proposed*:
  ```markdown
  - All local specification files MUST include a permanent unique identifier (`issue_id: <int>`) in their CommonMark metadata table at lines 1-10 instead of YAML frontmatter, mapped directly to their remote issue number.
  ```
- **Line 152**:
  *Existing*:
  ```markdown
  - All generated markdown files include YAML frontmatter.
  ```
  *Proposed*:
  ```markdown
  - All generated markdown files include native CommonMark two-column metadata tables at lines 1-10.
  ```

---

## 4. Metadata Validator in Baseline Verifier (`crates/verify-baseline/src/spec_audit/`)

### 4.1 Existing Implementation
1. **`crates/verify-baseline/src/spec_audit/metadata.rs:316-406` (`validate_metadata`)**:
   Currently:
   - Uses `get_field` which reads from `doc.table_metadata` and falls back to `doc.frontmatter`.
   - Checks `issue_id`, `type`, `title`, and if epic, `package` and `subsystem`.
   - **Does NOT check** whether raw YAML frontmatter is present.
   - **Does NOT verify** that the CommonMark table is at lines 1-10.
   - **Does NOT verify** exact header `| Attribute | Specification Detail |`.
   - **Does NOT verify** all mandatory attributes for Features, User Stories, and Use Cases.

2. **`crates/verify-baseline/src/spec_audit/markdown_ast.rs`**:
   - `extract_yaml_frontmatter` (`lines 383-421`) parses `--- ... ---`.
   - `extract_table_metadata` (`lines 428-478`) extracts key-value pairs from lines beginning and ending with `|` in the first 50 lines.
   - `METADATA_KEYS` (`lines 143-182`) contains allowed metadata row keys for placeholder tolerance.
     *Finding*: Does not contain `"primary_actor"`, `"scope"`, `"level"`. These must be added to `METADATA_KEYS`.

3. **`crates/verify-baseline/src/spec_audit/mod.rs:542-560`**:
   - Calls `validate_metadata(&spec_type, &doc, &rel_path)`.
   - Has `content: &str` already loaded in scope (`line 509`).

### 4.2 Proposed Implementation for `spec_audit`
Update `validate_metadata` (or add content inspection) to enforce the contract:
1. **Reject raw YAML frontmatter**:
   If `content.trim_start().starts_with("---")` or `doc.frontmatter.is_some()`, report:
   `[specification-metadata-integrity] <rel_path>: Raw YAML frontmatter ('--- ... ---') is strictly forbidden. Specifications must use a native CommonMark metadata table at lines 1-10.`
2. **Verify CommonMark table at lines 1-10**:
   Inspect line 1 and line 2 of the specification:
   - Line 1 must trim to `| Attribute | Specification Detail |`.
   - Line 2 must trim to `| :--- | :--- |`.
   - The table must reside within lines 1-10.
   If not satisfied, report:
   `[specification-metadata-integrity] <rel_path>: Missing native CommonMark metadata table at lines 1-10 with exact header '| Attribute | Specification Detail |'.`
3. **Verify all mandatory attributes per specification type from `doc.table_metadata`**:
   - **Epics**: `issue_id`, `title`, `type`, `package`, `subsystem`, `generation_mode`, `specification_source`
   - **Features**: `issue_id`, `title`, `type`, `parent_epic`, `interface_type`, `schema_containers`, `generation_mode`, `specification_source`
   - **User Stories**: `issue_id`, `title`, `type`, `parent_epic`, `sysml_interaction`, `sysml_test_case`, `generation_mode`, `specification_source`
   - **Use Cases**: `issue_id`, `title`, `type`, `primary_actor`, `scope`, `level`, `generation_mode`, `specification_source`
4. **Update `METADATA_KEYS` in `markdown_ast.rs`**:
   Include `"primary_actor"`, `"scope"`, `"level"` in the allowed token list.

---

## 5. Potential Pitfalls and Mitigation Strategies

| Pitfall | Risk / Symptom | Mitigation Strategy |
|---|---|---|
| **Line count disparity across spec types** | Epics has 7 attributes (9 lines total) while Features/US/UC have 8 attributes (10 lines total). Strict check for exactly 10 table rows would fail on Epics. | Validator verifies that table begins on line 1 with exact header and separator, and all rows reside within lines 1-10 (lines 1..=9 or 1..=10). |
| **Leading blank lines / whitespace** | If any newline or whitespace precedes line 1, the table is pushed down to line 2+, failing the line 1-10 check. | Ensure forward sync templates emit `| Attribute | ...` at byte 0 of the file without preceding `\n`. |
| **Historical Issue ID loss on re-sync** | When `forward-sync --force` runs, `resolve_issue_id` reads existing spec files. If it only checks `issue_id:`, it fails to extract the ID from the CommonMark table and resets all issue numbers to fallback defaults! | Update `resolve_issue_id` in `forward.rs` to parse both `issue_id:` and `\| **Issue ID** \| <id> \|`. |
| **Unresolved placeholder false positives** | Markdown links in metadata cells (e.g. `[schema/model.sysml](../../schema/model.sysml)` or `[EPIC-01-SysML_Model](../epics/EPIC-01-SysML_Model.md)`) contain brackets `[...]`. If `is_metadata_header_table_row` returns false, placeholder scanner flags them as unresolved tokens. | Keep keys in `METADATA_KEYS` in `markdown_ast.rs` synchronized with all table attributes (`primary_actor`, `scope`, `level`). |
| **Unicode em dash / en dash violations** | Unicode `\u2014` or `\u2013` triggers gate failures under the Zero Em Dash Invariant. | Use ASCII `--` or `-` exclusively across all code, templates, and markdown files. |
| **Backlog reconciler & reverse sync drift** | `reconcile-backlog` and `compile-sysml --reverse-sync` also parse specification metadata. | Ensure `parse_frontmatter` functions in `reverse.rs` and `reconcile-backlog` gracefully extract metadata from CommonMark tables. |
