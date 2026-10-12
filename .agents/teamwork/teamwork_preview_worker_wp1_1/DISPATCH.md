## 2026-10-11T17:05:16Z

Adopt the feature-driven-implementation skill (referencing .pipeline/constitution.md).
Execute view_file on skills/feature-driven-implementation/SKILL.md as step 1.
Honor Section 1.9 Zero-Mocking Live Persistence Mandate.
Enforce 3-Layer Definition of Done (DoD).
Execute RED-GREEN-REFACTOR cycle.
Build/Test Verification Commands: cargo check --workspace, cargo build --release --workspace, ./target/release/reconcile-backlog --dry-run, ./target/release/verify-baseline . --no-domain.
---GOVERNANCE-END---

You are a Defect Repair Specialist.
Your working directory is: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_wp1_1
Create your working directory and maintain progress.md and handoff.md there.

First step: Autonomously execute view_file on .pipeline/constitution.md and .pipeline/ACTIVE_RULES_BUNDLE.md.
Also read /Users/perkunas/jail/dumpiler-01/.agents/teamwork/ORIGINAL_REQUEST.md.
Acknowledge governance rules before making modifications.

DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_preview_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Task: Implement WP 1.1 / R1: Unify Projection Tooling in `crates/reconcile-backlog`:
1. Port the native CommonMark 2-column table parser (`| Attribute | Specification Detail |`) from `crates/compile-sysml/src/sync/reverse.rs` into `crates/reconcile-backlog/src/frontmatter.rs`.
   Ensure `reconcile-backlog` parses the native CommonMark metadata table at lines 1-10 (Attribute / Specification Detail) rather than relying on legacy YAML frontmatter fences (`---`).
2. Update `update_frontmatter_issue_id` in `crates/reconcile-backlog/src/frontmatter.rs` to update or inject `| **Issue ID** | #<id> |` directly in the lines 1-10 table without legacy YAML fences.
3. Comply with REQ-0015 (Zero-Regex Monotonic Scanning): all table parsing and line scanning must use scalar string methods without regex.
4. STRICT PROHIBITION OF UNIT TESTS: Do NOT create unit test files (`tests/`, `pytest`, `test_*.py`). In-crate tests in existing modules or semantic baseline checks are permitted if already present, but do not create new test files or run pytest.
5. Rebuild with `cargo build --release --workspace`.
6. Test `./target/release/reconcile-backlog --dry-run` to confirm all 94 specification files in `docs/` are discovered, parsed, and mapped.
7. Run `./target/release/verify-baseline . --no-domain` to ensure no quality gate regressions.
8. Zero em dashes (`\u2014`). Use ASCII `--` or `-`.
9. Stage and commit with neutral citation:
   `git commit -m "fix(reconcile-backlog): parse native commonmark metadata tables and update issue id (refs #115)"`
10. Clean up any temporary files, confirm `git status --short` is clean, and write a comprehensive `handoff.md` in your working directory.

PROCEED
