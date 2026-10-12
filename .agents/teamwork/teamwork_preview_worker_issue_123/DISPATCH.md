## 2026-10-11T13:22:22Z

Adopt the feature-driven-implementation skill (referencing .pipeline/constitution.md).
Execute view_file on skills/feature-driven-implementation/SKILL.md as step 1.
Honor Section 1.9 Zero-Mocking Live Persistence Mandate.
Enforce 3-Layer Definition of Done (DoD).
Execute RED-GREEN-REFACTOR cycle.
Build/Test Verification Commands: cargo check --workspace, cargo build --release --workspace, ./target/release/verify-baseline . --no-domain.
---GOVERNANCE-END---

You are a Defect Repair Specialist.
Your working directory is: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_issue_123
Create your working directory and maintain progress.md and handoff.md there.

First step: Autonomously execute view_file on .pipeline/constitution.md and .pipeline/ACTIVE_RULES_BUNDLE.md.
Acknowledge governance rules before making modifications.

Task: Surgically repair Issue #123:
Title: [AUDIT] [forward.rs]: Synthetic Class Diagram Stub Gaming and Linter Bypass Vulnerability

Root Cause & Requirements:
1. `crates/compile-sysml/src/sync/forward.rs:751-765`:
   - Replace hardcoded synthetic class diagram stubs (`DEAPCompilerSystem --> {part_name} : contains`) with a genuine `generate_class_diagram(part: &PartDef) -> String` helper function.
   - The generator must inspect `part` and lower its declared ports, attributes, operations, and subparts into valid Mermaid `classDiagram` syntax:
     - `class <part.name> {`
     - Ports: for port in &part.ports:
       `+<port.type_name> <port.name> (<dir>)` (or clean valid type and name, ensuring no secondary colons or inner curly braces)
     - Attributes: for attr in &part.attributes:
       `+<attr.type_name> <attr.name>`
     - Operations: for op in &part.operations:
       `+<op.name>() <return_type>`
     - `}`
     - Subparts / Relations: for subpart in &part.parts:
       `<part.name> --> <target_type> : <subpart.name>`
     - If the part has no ports, attributes, or operations and no subparts, emit valid clean class block or definition without synthetic placeholder stubs.
2. `crates/verify-baseline/src/spec_audit/uml_validator.rs:372-438`:
   - In `validate_class_diagram`:
     - Allow ports in member matching: `classifier.ports.contains(attr_clean) || index.port_names.contains(attr_clean)`.
     - Verify that classifiers with declared AST members do not omit them (reject vacuous empty stubs when AST defines members).
3. Forward Synchronization:
   - Re-run forward synchronization or `./target/release/compile-sysml --forward-sync` so `docs/features/FEAT-*.md` are generated with genuine AST-derived class diagrams.
4. Constraints & Verification:
   - STRICT PROHIBITION OF UNIT TESTS: Do NOT create any unit test files (`tests/`, `pytest`, `test_*.py`).
   - Run `cargo check --workspace` and `cargo build --release --workspace`.
   - Run `./target/release/verify-baseline . --no-domain` and `./target/release/verify-baseline . --spec-only`. All 32 quality gates must pass with exit code 0.
   - Stage and commit with neutral citation:
     `git commit -m "fix(compiler): eliminate synthetic class diagram stubs and lower ast members (refs #123)"`
   - Post verification evidence comment via `gh issue comment 123 --body "..."` documenting empirical root cause, diff, and passing verification output.
   - Apply label: `gh issue edit 123 --add-label "status:fixed-resolved"`. Do NOT close the issue.
   - Clean up any temporary files, confirm `git status --short` is clean, and write `handoff.md` in your working directory.

PROCEED
