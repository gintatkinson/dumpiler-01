# Implementation Plan -- Ground 0 Pipeline Execution, Defect Filing & Full Verification

**Objective**: Remediate the failures of the previous run by filing formal defect issues on GitHub for the three discovered breakages, executing the complete compiler pipeline from Ground 0, regenerating all 94 downstream specifications and safety artifacts, reconciling tracker parity, verifying all 32 baseline quality gates on the freshly generated outputs, and pushing a clean, synchronized tree to `origin/main`.

---

## 1. What Failed and Broke in the Previous Run

1. **False Victory Declaration (The Static Linter Trap)**:
   The previous run certified the 11-defect loop as complete based on passive linter auditing (`verify-baseline`), but never reran the compiler pipeline from Ground 0 to verify that the modified compiler and schemas generated correct outputs.
2. **User Story Desynchronization (Issue #116/#117 Aftermath)**:
   In Issue #117, behavioral actions were renamed (`ClassifyFormatAction`), but forward-sync was never executed across the entire corpus. `US-02-IngestSchemaAction.md` remained stale on disk, and GitHub Issue #90 retained outdated titles and bodies.
3. **Safety Suite Hazard Incompleteness**:
   In Issue #116, operational activities were decomposed in `schema/conops/activities.sysml`, but `compile-sysml --stpa-transpile` was never rerun. `docs/safety/01_LOSSES_HAZARDS_TOPOLOGY.md` was left with only 6 hazards (`H-1`..`H-6`) instead of the required 28+ hazards covering all decomposed activities.
4. **Epic & Use Case Link Drift**:
   `EPIC-02`, `EPIC-04`, and `UC-02` retained broken links pointing to deleted/stale user story filenames.
5. **Procedural Violations**:
   - Running modifying commands (`--forward-sync --force`) in coordinator context without an approved plan.
   - Using forbidden `python3` commands and violating workspace boundary context isolation.

---

## 2. Work Packages & Remediation Protocol

### Work Package 1: Defect Registration on GitHub
Formulate 3 canonical 7-section defect dossiers adhering to `skills/adversarial-code-auditor/SKILL.md` and file them on GitHub with `--label bug` via `./target/release/reconcile-backlog create-issue --label bug`:
- **Defect A**: User story specification and tracker desynchronization following Issue #117 behavioral action renaming.
- **Defect B**: Incomplete STPA safety hazard topology resulting from omitted post-decomposition transpilation.
- **Defect C**: Broken internal specification links in `EPIC-02`, `EPIC-04`, and `UC-02` pointing to superseded user story filenames.

### Work Package 2: Ground 0 Pipeline Regeneration
Execute the complete compilation and synchronization sequence from scratch:
1. **Pipeline 0 Compilation**: `./target/release/compile-sysml --compile` (parse schemas, validate semantics, emit `.pipeline/schema.sysml` and `.pipeline/schema-digest.json`).
2. **Safety Suite Transpilation**: `./target/release/compile-sysml --stpa-transpile` (regenerate 10-pillar safety suite in `docs/safety/`).
3. **Full Forward Synchronization**: `./target/release/compile-sysml --forward-sync --force` (regenerate all 94 specification files across `docs/epics/`, `docs/features/`, `docs/user-stories/`, and `docs/use-cases/`).
4. **Backlog Reconciliation**: `./target/release/reconcile-backlog --sync-bodies` (synchronize updated specification titles, descriptions, and checklist states to GitHub).

### Work Package 3: Verification & Quality Gate Auditing
- Verify that `cargo check --workspace` and `cargo build --release --workspace` compile with 0 warnings/errors.
- Execute `./target/release/verify-baseline . --no-domain` and assert all 32 quality gates pass with exit code 0.
- Execute `./target/release/verify-baseline . --spec-only` and confirm all 93 specification files pass with 0 findings.
- Verify zero unit test files (`tests/`, `pytest`, `test_*.py`) created or executed.
- Verify zero Python invocations, zero regex violations (REQ-0015), and zero Unicode em dashes (`\u2014`).

### Work Package 4: Tracker Transition, Commit Hygiene & Remote Sync
- Post empirical verification evidence comments to each of the newly filed defect issues on GitHub documenting root cause and passing verification commands.
- Transition the new defect issues to `status:fixed-resolved`. Do not set to `Closed`.
- Clean up any temporary reproducer files or untracked test logs in `.pipeline/defects/`.
- Commit all changes using neutral citations: `(refs #<ID>)`. Issue auto-closing keywords are strictly prohibited.
- Push to `origin/main` and verify `git diff origin/main` is empty (0 bytes).

---

## 3. Acceptance Criteria

- [x] 3 formal defect issues filed on GitHub with `--label bug` and canonical 7-section dossiers.
- [x] Complete pipeline (`compile-sysml --compile`, `--stpa-transpile`, `--forward-sync --force`) runs from Ground 0 with exit code 0.
- [x] All 94 specification files in `docs/` and safety artifacts in `docs/safety/` freshly generated and verified.
- [x] `./target/release/verify-baseline . --no-domain` passes all 32 quality gates with 0 findings on newly generated outputs.
- [x] `./target/release/verify-baseline . --spec-only` passes all 93 specifications with 0 findings.
- [x] All 3 newly filed defect issues transitioned to `status:fixed-resolved` with empirical evidence comments.
- [x] Working tree is clean and synchronized (`git diff origin/main` is 0 bytes).

---

## 4. Human Authorization Gate

Per `AGENTS.md` § **Strict Planning Gate**:
To authorize executing this plan, reply with **PROCEED**.
