# Implementation Plan -- Native Forward Generator Parity & Closed-Loop Pipeline Execution

## 1. Ground Truth & Objectives

### Current State
- `docs/` specifications (14 Epics, 65 Features, 6 User Stories, 6 Use Cases) are 100% compliant with DO-178C Level A and pass spec audit in 168 ms with 0 findings.
- Live GitHub issues ([#10](https://github.com/gintatkinson/dumpiler-01/issues/10)--[#114](https://github.com/gintatkinson/dumpiler-01/issues/114)) are synchronized and completely free of placeholders.
- The repository has 0 Python files and relies exclusively on native Rust binaries and POSIX shell wrappers.
- **The Gap**: [`crates/compile-sysml/src/sync/forward.rs`](crates/compile-sysml/src/sync/forward.rs) still uses earlier template strings that lack the newly repaired `Associated Use Cases & User Stories` checklists in Epics, `epic:` frontmatter in Stories/Use Cases, and relative Markdown links. Running `compile-sysml --forward-sync --force` from scratch would regenerate older, unlinked files.

### Objectives
1. **Update `forward.rs`**:
   - Embed canonical `epic:` frontmatter metadata in User Stories and Use Cases.
   - Embed relative Markdown links (`../features/FEAT-*.md` and `../user-stories/US-*.md`) in User Stories and Use Cases.
   - Embed fully-resolved `### Associated Use Cases & User Stories` checklists in all 14 Epics (`EPIC-01` through `EPIC-14`).
2. **Execute Full Closed-Loop Pipeline**:
   - `cargo build --release --workspace`
   - `./target/release/compile-sysml --compile` (recompiles `schema/` into `.pipeline/schema.sysml`)
   - `./target/release/compile-sysml --forward-sync --force` (generates specifications directly from native Rust AST)
   - `./target/release/compile-sysml --reverse-sync` (merges all specs back into SysML AST model and updates digest)
   - `./target/release/reconcile-backlog --workspace .` (reconciles issue IDs and tasklists against GitHub tracker)
3. **Verify Zero Regressions & Parity**:
   - `./target/release/verify-baseline . --no-domain` (31/31 baseline checks pass)
   - `./target/release/verify-baseline . --spec-only` (91/91 specifications pass in <0.2s with 0 findings)
   - Assert `git diff docs/` is 0 (forward generation produces bitwise-identical compliant specifications).
   - Assert `git diff .pipeline/` is clean.
4. **Git Sync**:
   - Commit any updated model/pipeline assets with neutral citation `feat(compiler): close forward-sync AST projection loop and verify roundtrip parity (refs #9)` and push to `origin/main`.

---

## 2. Detailed Work Breakdown

### Work Package 1: Native Rust Forward-Sync Generator Parity [COMPLETED]
- **File**: `crates/compile-sysml/src/sync/forward.rs`
- **Changes**:
  1. `generate_epics()`:
     - Updated `EPIC-02` (ConOps) to include all 6 Use Cases and all 6 User Stories under `### Associated Use Cases & User Stories`.
     - Updated `EPIC-04` (Subsystem 2) to include UC-01 and US-01.
     - Updated `EPIC-05` (Subsystem 3) to include US-02 and `- None directly allocated...`.
     - Updated `EPIC-06` (Subsystem 4) to include UC-02 and US-03.
     - Updated `EPIC-09` (Subsystem 7) to include UC-03 and US-04.
     - Updated `EPIC-11` (Subsystem 9) to include UC-04 and US-05.
     - Updated `EPIC-12` (Subsystem 10) to include UC-05 and `- None directly allocated...`.
     - Updated `EPIC-14` (Subsystem 12) to include UC-06 and US-06.
     - Updated Epics 01, 03, 07, 08, 10, 13 to explicitly include `- None directly allocated (operational behavior allocated at system ConOps level in Epic 02)`.
  2. `generate_user_stories()`:
     - Added `epic: "{epic_name}"` to YAML frontmatter.
     - Injected relative Markdown links `../features/FEAT-XX-...md` under `## Required Features`.
  3. `generate_use_cases()`:
     - Added `epic: "{epic_name}"` to YAML frontmatter.
     - Injected relative Markdown links `../user-stories/US-XX-...md` and `../features/FEAT-XX-...md` under `## 8. Realization Matrix`.
  4. Added `resolve_date()` helper to preserve historical specification dates and eliminate timestamp churn.

### Work Package 2: Full End-to-End Pipeline Execution & Roundtrip Parity [COMPLETED]
- **Execution Sequence & Verification Evidence**:
  1. `cargo build --release --workspace`: Clean compilation in 7.13s.
  2. `./target/release/compile-sysml --compile`: Compiled SysML schema to `.pipeline/schema.sysml` (275 elements).
  3. `./target/release/compile-sysml --forward-sync --force`: Successfully synchronized 92 specifications to `docs/` with zero unexpected diff (`git diff docs/` empty).
  4. `./target/release/compile-sysml --reverse-sync`: Successfully merged specifications back to `.pipeline/schema.sysml`.
  5. `./target/release/reconcile-backlog --workspace .`: 91 specs scanned, 0 drift, 0 placeholders.
  6. `./target/release/verify-baseline . --no-domain`: All 31/31 baseline checks passed.
  7. `./target/release/verify-baseline . --spec-only`: 91 specifications audited with 0 findings in 165 ms.
  8. `cargo test --workspace`: 195/195 tests passed.
  9. Zero em dash invariant verified (`\u2014` = 0).
  10. Zero deprecated placeholder occurrences in specifications.

### Work Package 3: Remote Synchronization & Walkthrough [PENDING]
- Commit with neutral citation `feat(compiler): close forward-sync AST projection loop and verify roundtrip parity (refs #9)`.
- Push to `origin/main`.
- Verify `git diff origin/main` is empty.
- Post verification evidence comment on Issue #9.

---

## 3. Governance & Safety Invariants
- **Zero Em Dash Invariant**: Unicode `\u2014` strictly forbidden. ASCII `--` exclusively.
- **Commit Message Non-Closure Invariant**: Neutral citations `(refs #9)` exclusively.
- **Strict Planning Gate**: Plan written and presented; awaiting user review.
