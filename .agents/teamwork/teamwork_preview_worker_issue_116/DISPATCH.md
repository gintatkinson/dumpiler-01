# Dispatch: Defect Repair Specialist for Issue #116

## 2026-10-11T14:48:00Z

Task: Surgically repair and verify Issue #116:
Title: [AUDIT] [activities.sysml]: Monolithic Level 0 Operational Activities Restricting Backlog Decomposition and Subsystem Semantic Traceability

Target File:
`schema/conops/activities.sysml`

Requirements:
1. Ingest .pipeline/constitution.md and .pipeline/ACTIVE_RULES_BUNDLE.md.
2. Review Issue #116 root cause and requirements:
   - Check `schema/conops/activities.sysml`, `crates/verify-baseline/src/spec_audit/conops_audit.rs`, and any other references to `OA_` in `crates/` and `docs/`.
   - Ensure `schema/conops/activities.sysml` defines normative SysML v2 operational activities with typed item pins (`in item`, `out item`) and nested child actions/activities allocated to subsystems.
   - Preserve backward-compatibility with Gate 24 (conops audit) and forward sync compiler (`compile-sysml`).
3. Verification:
   - Run `./target/release/compile-sysml --compile` to compile SysML v2 schema and update `.pipeline/schema.sysml` and `.pipeline/schema-digest.json`.
   - Run `cargo check --workspace` and `cargo build --release --workspace`.
   - Run `./target/release/verify-baseline . --no-domain` and `./target/release/verify-baseline . --spec-only`. All 32 quality gates must pass cleanly with exit code 0.
4. Commit & Closeout:
   - Commit with neutral citation:
     `git commit -m "fix(schema): enrich ConOps operational activities with typed pins and subsystem decomposition (refs #116)"`
   - Post verification evidence comment via `gh issue comment 116 --body "..."` documenting empirical root cause, diff, and passing verification output.
   - Apply label: `gh issue edit 116 --add-label "status:fixed-resolved"`. Do NOT close the issue.
   - Clean up temporary files, confirm `git status --short` is clean, and write `handoff.md` in your working directory.
