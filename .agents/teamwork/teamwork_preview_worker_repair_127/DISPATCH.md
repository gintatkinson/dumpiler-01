## 2026-10-11T17:47:34Z
Adopt the feature-driven-implementation skill (referencing .pipeline/constitution.md).
Execute view_file on skills/feature-driven-implementation/SKILL.md as step 1.
Honor Section 1.9 Zero-Mocking Live Persistence Mandate.
Enforce 3-Layer Definition of Done (DoD).
Execute RED-GREEN-REFACTOR cycle.
Build/Test Verification Commands: cargo check --workspace, cargo build --release --workspace, ./target/release/verify-baseline . --no-domain.
---GOVERNANCE-END---

You are a Defect Repair Specialist.
Your working directory is: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_repair_127
Create your working directory and maintain progress.md and handoff.md there.

First step: Autonomously execute view_file on .pipeline/constitution.md and .pipeline/ACTIVE_RULES_BUNDLE.md.
Also read /Users/perkunas/jail/dumpiler-01/.agents/teamwork/ORIGINAL_REQUEST.md.
Acknowledge governance rules before making modifications.

DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A victory auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Task: Surgically repair Issue #127: Native YANG Schema Ingestion in `crates/ingest-sysml`:
1. `crates/ingest-sysml/src/detectors.rs`:
   - In `discover_input_schemas`: add `("yang", "yang")` to `format_exts` so that `.yang` files are discovered in schema directories.
   - In `detect_format`: check file extension (`path.extension() == Some("yang")`) or content inspection (presence of `yang-version`, `namespace `, `prefix `, `typedef `, `grouping `) to return `Ok("yang".to_string())` before the generic `module ` IDL check.
2. `crates/ingest-sysml/src/translators/yang.rs`:
   - Implement `YangTranslator` converting RFC 6020/7950 YANG models into canonical SysML v2 `PackageDef`:
     - Parse `module <name> { ... }`.
     - Translate `typedef` into SysML `PartDef` or `AttributeDef` with base type and constraints (ranges, lengths, patterns).
     - Translate `grouping` and `container` into structural `PartDef`s containing `AttributeDef`s, child `PartDef`s (for nested containers or lists), and `ConstraintDef`s.
     - Translate `leaf` and `leaf-list` into `AttributeDef`s.
     - Translate `choice` / `case` into `PartDef`s or attributes with mutual exclusion constraints.
     - Implement both `translate(&str, &str) -> Result<PackageDef, String>` for single files and `translate_files(&[String], &str) -> Result<PackageDef, String>` for multi-file batch directory ingestion.
3. `crates/ingest-sysml/src/translators/mod.rs`:
   - Export `pub mod yang;`.
4. `crates/ingest-sysml/src/main.rs`:
   - Wire `"yang"` into `run_ingestion` for both multi-file directory and single-file pathways using `YangTranslator`.
5. Constraints:
   - Pure lexical/scalar scanning or stateful tokenizer conforming to REQ-0015 (Zero-Regex Monotonic Scanning).
   - STRICT PROHIBITION OF UNIT TESTS: Do NOT create unit test files (`tests/`, `pytest`, `test_*.py`). In-crate tests in existing modules are permitted.
   - Zero em dashes (`\u2014`). Use ASCII `--` or `-`.
6. Verification:
   - `cargo check --workspace`
   - `cargo build --release --workspace`
   - Test `./target/release/ingest-sysml --schema target/reference/3dgs-039/schema --out target/reference/3dgs-039_generated/model.sysml` (assert exit code 0 and non-empty structural elements).
   - Test `./target/release/compile-sysml --compile target/reference/3dgs-039_generated/model.sysml` (assert exit code 0).
   - Test `./target/release/compile-sysml --forward-sync --force target/reference/3dgs-039_generated/model.sysml --docs target/reference/3dgs-039_generated/docs` (assert exit code 0 and generation of specifications in `target/reference/3dgs-039_generated/docs/`).
   - Run `./target/release/verify-baseline . --no-domain` on `dumpiler-01` (assert all 32 checks pass).
7. GitHub Issue Transition:
   - Post empirical verification evidence comment: `gh issue comment 127 --body "..."`.
   - Apply label: `gh issue edit 127 --add-label "status:fixed-resolved"`. Do NOT close the issue.
8. Stage and commit:
   `git commit -m "fix(ingest-sysml): implement native yang schema ingestion and compilation (refs #127)"`
9. Clean up temporary files, confirm `git status --short` is clean, and write a comprehensive `handoff.md`.

PROCEED
