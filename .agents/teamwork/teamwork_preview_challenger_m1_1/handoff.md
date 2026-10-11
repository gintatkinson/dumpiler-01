# Adversarial Challenge Report: Milestone 1 Unified Metadata Contract

## 1. Observation

1. **Rejection of Raw YAML Frontmatter (`--- ... ---`)**:
   - Injected raw YAML frontmatter into `docs/epics/EPIC-01-SysML_Model.md`:
     ```markdown
     ---
     title: "Epic 01: System Architecture and Compiler Primacy"
     issue_id: 101
     type: epic
     ---
     ```
     Execution of `./target/release/verify-baseline . --spec-only --only docs/epics/EPIC-01-SysML_Model.md` failed with exit code 1 and findings:
     `docs/epics/EPIC-01-SysML_Model.md: [specification-metadata-integrity] docs/epics/EPIC-01-SysML_Model.md: Raw YAML frontmatter ('--- ... ---') is strictly forbidden. Specifications must use a native CommonMark metadata table at lines 1-10 per rules/specification-metadata-integrity.md.`
     `docs/epics/EPIC-01-SysML_Model.md: [specification-metadata-integrity] docs/epics/EPIC-01-SysML_Model.md: Specification metadata table must begin within lines 1-10 (line 1 contains unexpected text before metadata table).`
   - Rejection was also empirically reproduced and verified across all other specification types:
     - Features: `docs/features/FEAT-01-HumanEngineer.md` (exit code 1, 2 findings).
     - User Stories: `docs/user-stories/US-01-BootstrapSystemVisionAction.md` (exit code 1, 2 findings).
     - Use Cases: `docs/use-cases/UC-01-UC_01_System_Vision_and_Foundational_Invariants.md` (exit code 1, 2 findings).
   - Injected pure YAML frontmatter without CommonMark table: verified exit code 1 and 3 findings (`Raw YAML frontmatter forbidden`, `Missing native CommonMark metadata table`, and missing mandatory fields).

2. **CommonMark Table Lines 1-10 Constraints**:
   - Boundary shift past line 10: shifted table header to line 12 in `docs/epics/EPIC-01-SysML_Model.md`. Verification with `./target/release/verify-baseline . --spec-only --only docs/epics/EPIC-01-SysML_Model.md` failed with exit code 1:
     `Missing native CommonMark metadata table at lines 1-10 with exact header '| Attribute | Specification Detail |'.`
   - Non-comment preamble within lines 1-10: placed `# Preceding Header` at line 1, table header at line 3. Fails with exit code 1:
     `Specification metadata table must begin within lines 1-10 (line 1 contains unexpected text before metadata table).`
   - Allowed comments before table: placed `<!-- Copyright Gint Atkinson -->` at line 1, table header at line 3. Verification passed with exit code 0 (`passed: true`).
   - Corrupted table separator: mutated separator to `| :--- | --- |`. Fails with exit code 1:
     `Invalid metadata table separator row at line 4. Expected '| :--- | :--- |'.`
   - 1-column header: mutated header to `| Attribute |`. Fails with exit code 1:
     `Missing native CommonMark metadata table at lines 1-10 with exact header '| Attribute | Specification Detail |'.`
   - Truncated data row: truncated `| **Issue ID** | #101 |` to `| **Issue ID** |`. Fails with exit code 1:
     `Missing mandatory metadata field 'issue_id'.`

3. **Mandatory Spec-Type Attributes Enforcement**:
   - Epics (`docs/epics/EPIC-01-SysML_Model.md`):
     - Removed `Package`: flagged with exit code 1 (`Epic is missing mandatory 'package' metadata.`).
     - Removed `Subsystem`: flagged with exit code 1 (`Epic is missing mandatory 'subsystem' metadata.`).
     - Removed `Specification Source`: flagged with exit code 1 (`Missing mandatory metadata field 'specification_source'.`).
   - Features (`docs/features/FEAT-01-HumanEngineer.md`):
     - Removed `Parent Epic`, `Interface Type`, `Schema Containers`: flagged with exit code 1 with 3 distinct findings for each respective attribute.
   - User Stories (`docs/user-stories/US-01-BootstrapSystemVisionAction.md`):
     - Removed `Parent Epic`, `SysML Interaction`, `SysML Test Case`: flagged with exit code 1 with 3 distinct findings for each respective attribute.
   - Use Cases (`docs/use-cases/UC-01-UC_01_System_Vision_and_Foundational_Invariants.md`):
     - Removed `Primary Actor`, `Scope`, `Level`: flagged with exit code 1 with 3 distinct findings for each respective attribute.

4. **Generation & Full Baseline Conformance**:
   - Executed `./target/release/compile-sysml --forward-sync --force`:
     `[SysML v2 Forward-Sync] Successfully synchronized 94 specifications to 'docs/'` (exit code 0).
   - Executed `./target/release/verify-baseline . --spec-only`:
     `Spec audit completed in 267 ms (93 files audited, 0 findings, passed: true)` (exit code 0).
   - Executed `./target/release/verify-baseline . --no-domain`:
     All 31 baseline checks verified with exit code 0 and 0 findings.
   - Executed `cargo check --workspace` and `cargo build --release --workspace`:
     Exit code 0 (clean compilation with zero warnings or errors).

5. **Clean Workspace & Mutation Reversion**:
   - All intentional mutations during adversarial stress testing were completely reverted.
   - Transient defect dossiers in `.pipeline/defects/` generated during failed runs were removed.
   - Working tree state restored cleanly.

6. **Zero Em Dash Invariant Verification**:
   - Scanned all modified codebase and specification files (113 files audited) for Unicode em dashes (`\u2014`, `b'\xe2\x80\x94'`) and en dashes (`\u2013`, `b'\xe2\x80\x93'`).
   - Result: Exactly 0 Unicode em dashes or en dashes present across all 94 specification files in `docs/` and all implementation files in `crates/` and `rules/`.

## 2. Logic Chain

1. Based on Observation 1, `validate_metadata` in `crates/verify-baseline/src/spec_audit/metadata.rs:326-331` actively inspects both raw file prefix (`content.trim_start().starts_with("---")`) and AST frontmatter (`doc.frontmatter.is_some()`), ensuring that any spec containing raw YAML frontmatter is reliably detected and rejected with exit code 1 across all 4 specification categories.
2. Based on Observation 2, the lines 1-10 boundary check (`lines.take(10)`) enforces exact table header (`| Attribute | Specification Detail |`), exact separator (`| :--- | :--- |`), and prohibits unexpected content before the header while allowing valid HTML comments.
3. Based on Observation 3, spec-type branch logic in `metadata.rs:415-515` accurately validates all mandatory attributes (`package`/`subsystem` for Epics; `parent_epic`/`interface_type`/`schema_containers` for Features; `parent_epic`/`sysml_interaction`/`sysml_test_case` for User Stories; `primary_actor`/`scope`/`level` for Use Cases).
4. Based on Observation 4, `compile-sysml --forward-sync --force` produces 100% compliant CommonMark tables matching this contract across all 94 specification files, satisfying both `--spec-only` and the complete 31-check `--no-domain` baseline audit.
5. Based on Observation 6, the zero em dash invariant is strictly observed without any Unicode dash characters.

## 3. Caveats

- In permissive mode (without `--strict` or `--only`), `verify-baseline . --spec-only` logs audit findings to standard output but returns exit code 0. When `--strict` or `--only <file>` is supplied, it strictly returns exit code 1 and generates a defect dossier. This is the intended architecture of `runner.rs:186-206`.

## 4. Conclusion

**Verdict: APPROVE**

Milestone 1 (Unified Metadata Contract) is fully validated, highly resilient, and strictly conforms to all specifications in `rules/specification-metadata-integrity.md` and `.pipeline/constitution.md`. All failure modes and edge cases were tested empirically and behaved as expected.

## 5. Verification Method

1. Verify raw YAML frontmatter rejection:
   `./target/release/verify-baseline . --spec-only --only docs/epics/EPIC-01-SysML_Model.md`
2. Run forward-sync spec regeneration:
   `./target/release/compile-sysml --forward-sync --force`
3. Verify specification audit passes:
   `./target/release/verify-baseline . --spec-only` (assert exit code 0, 0 findings)
4. Verify complete baseline passes:
   `./target/release/verify-baseline . --no-domain` (assert exit code 0, 31 checks passed)
5. Verify compiler build:
   `cargo check --workspace && cargo build --release --workspace` (assert exit code 0)
6. Verify zero Unicode em dashes:
   `python3 -c "import glob; [print(f) for f in glob.glob('docs/**/*.md', recursive=True) if any(ord(c) in (0x2014, 0x2013) for c in open(f).read())]"` (assert 0 findings)
