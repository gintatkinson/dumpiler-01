## 2026-10-11T13:49:35Z
Adopt the feature-driven-implementation skill (referencing .pipeline/constitution.md).
Execute view_file on skills/feature-driven-implementation/SKILL.md as step 1.
Honor Section 1.9 Zero-Mocking Live Persistence Mandate.
Enforce 3-Layer Definition of Done (DoD).
Execute RED-GREEN-REFACTOR cycle.
Build/Test Verification Commands: cargo check --workspace, cargo build --release --workspace, ./target/release/verify-baseline . --no-domain.
---GOVERNANCE-END---

You are a Defect Repair Specialist.
Your working directory is: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_issue_118
Create your working directory and maintain progress.md and handoff.md there.

First step: Autonomously execute view_file on .pipeline/constitution.md and .pipeline/ACTIVE_RULES_BUNDLE.md.
Acknowledge governance rules before making modifications.

Task: Surgically repair and verify Issue #118:
Title: [AUDIT] [forward.rs]: Hardcoded Mock Test Data Shape and Canned Compiler BDD Criteria Break Feature Test Integrity

Root Cause & Requirements:
1. `crates/compile-sysml/src/sync/forward.rs`:
   - In `generate_feature_bdd(part: &PartDef, reqs: &[&RequirementDef])`:
     Replace static canned AC-01 to AC-04 strings with schema-grounded BDD criteria dynamically derived from `part`:
     - Nominal domain state / signal handling (Pattern A): `Given nominal {part.name} domain state, When command or input signals are received, Then updates internal state and signal outputs within declared bounds.`
     - Invariant / Constraint verification (Pattern B): iterate `part.constraints` (and any matching requirements in `reqs`), generating specific criteria: `Given operational state, When {part.name} evaluates constraint '{c.name}', Then asserts invariant satisfaction without violation.`
     - Failsafe / negative error recovery (Pattern C): `Given malformed input signals or boundary condition violation, When {part.name} error handling is invoked, Then transitions safely to failsafe fallback state without corruption.`
     - Ensure the generated criteria count satisfies the granularity bounds (between 3 and 10 acceptance criteria per feature, per `.pipeline/constitution.md:108`).
   - Ensure `generate_json_schema(part: &PartDef)` faithfully derives schema properties from `part.attributes` and `part.ports`.
   - Add an in-crate unit test in `forward.rs` `#[cfg(test)] mod tests` (e.g. `test_feature_bdd_derived_from_constraints_and_requirements`) asserting that `generate_feature_bdd` incorporates part constraints and requirements dynamically.
   - Run forward-sync via `./target/release/compile-sysml --forward-sync` so `docs/features/FEAT-*.md` are updated with the genuine schema-derived criteria.
2. Constraints & Verification:
   - STRICT PROHIBITION OF UNIT TESTS OUTSIDE WORKSPACE: Do NOT create any standalone unit test files under `tests/` or python scripts (`test_*.py`, `pytest`). Only in-crate unit tests in `forward.rs` `#[cfg(test)] mod tests` are permitted.
   - Run `cargo check --workspace` and `cargo build --release --workspace`.
   - Run `./target/release/verify-baseline . --no-domain` and `./target/release/verify-baseline . --spec-only`. All 32 quality gates must pass cleanly with exit code 0.
   - Stage and commit with neutral citation:
     `git commit -m "fix(compiler): derive feature bdd acceptance criteria dynamically from ast constraints (refs #118)"`
   - Post verification evidence comment via `gh issue comment 118 --body "..."` documenting empirical root cause, diff, and passing verification output.
   - Apply label: `gh issue edit 118 --add-label "status:fixed-resolved"`. Do NOT close the issue.
   - Clean up any temporary files, confirm `git status --short` is clean, and write `handoff.md` in your working directory.

PROCEED
