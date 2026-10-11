# DISPATCH

## 2026-10-11T08:39:52Z

You are a teamwork_preview_worker for Milestone 2: Taxonomy Standardization (Purge "Worker" & Fractional Phases).
Your working directory is /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_m2_1/

Autonomous On-Disk Governance Initialization:
You must autonomously execute view_file on .pipeline/constitution.md and .pipeline/ACTIVE_RULES_BUNDLE.md as your first step.

The original user request is recorded at:
/Users/perkunas/jail/dumpiler-01/.agents/teamwork/ORIGINAL_REQUEST.md
Please review the detailed Explorer findings and implementation guide at:
- /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_explorer_m2_1/analysis.md
- /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_explorer_m2_1/handoff.md

Here is the verbatim user request for Milestone 2:
### 2. Taxonomy Standardization (Purge "Worker" & Fractional Phases)
- In `skills/spec-orchestrator/SKILL.md`: Purge all occurrences of "Worker" and fractional phases (Phase 0.5, Phase 0.75). Standardize on Phase (Macro Milestone), Step (Procedural Step), and Subagent Role.
- In `skills/feature-driven-implementation/SKILL.md`: Standardize all agent references to context-isolated Subagents with explicit Roles.
- In `.pipeline/constitution.md`: Purge legacy references to "workers".
- Recompile `.pipeline/ACTIVE_RULES_BUNDLE.md`.

Write Ownership for this task:
- `skills/spec-orchestrator/SKILL.md`
- `skills/feature-driven-implementation/SKILL.md`
- `.pipeline/constitution.md`
- `rules/role-boundary-lock.md`, `rules/constitution-first.md`, `rules/uml-model-integrity.md`, `rules/subagent-dispatch-standards.md`
- `.pipeline/ACTIVE_RULES_BUNDLE.md`

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_preview_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Invariants:
- Zero Em Dash Invariant: Unicode em dashes (\u2014) are strictly forbidden. Use ASCII -- exclusively.
- Strict Prohibition of Unit Tests across this repository: Do NOT create any unit test files or test runner scripts.
- Verify that `skills/spec-orchestrator/SKILL.md` contains 0 occurrences of "worker" / "Worker" and 0 occurrences of fractional phases (`Phase 0.5`, `Phase 0.75`, `Phase 1.5`).
- Verify that `.pipeline/constitution.md` contains 0 occurrences of "worker" / "workers".
- Recompile `.pipeline/ACTIVE_RULES_BUNDLE.md` ensuring all 20 rules are included in canonical quad-anchor format.
- Run `./target/release/verify-baseline . --no-domain` and verify all 31 checks pass with exit code 0.
- Verify 0 unicode em dashes (\u2014) across all touched files.
- Deliver your handoff report to `/Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_m2_1/handoff.md`.
- Report back to parent upon completion via send_message.

PROCEED

## 2026-10-11T08:45:11Z

From parent (644aaf2a-8330-4388-a7e5-98f97497e001):
**Context**: Milestone 2 Implementation
**Content**: Checking in on taxonomy standardization and ACTIVE_RULES_BUNDLE.md recompilation.
**Action**: Please share current status of edits and ETA for completion.

## 2026-10-11T20:10:17Z

You are teamwork_preview_worker_m2_1.
Your working directory is: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_m2_1
Original request file: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/ORIGINAL_REQUEST.md

As your FIRST action, execute `view_file` on `.pipeline/constitution.md` and `.pipeline/ACTIVE_RULES_BUNDLE.md` to ingest repository governance rules.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_preview_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

User Request:
Eliminate the redundant repeating string prefix in Use Case titles and filenames (e.g. `Use Case 01: UC 01 ...` -> `Use Case 01: System Vision and Foundational Invariants`), fix the compiler parser bug in `crates/compile-sysml/src/parser/grammar.rs` that discards inner `doc /* ... */` blocks inside `use case def` bodies, regenerate all 12 Use Cases with their full schema-defined scenarios and exception flows, verify all 32 quality gates, and project clean updates to GitHub.

Working directory: /Users/perkunas/jail/dumpiler-01
Integrity mode: development

## Requirements

### R1. Compiler Parser Fix (`crates/compile-sysml/src/parser/grammar.rs`)
In `parse_use_case_decl`, handle `TokenKind::Doc` and `TokenKind::DocComment` inside `use case def` braces so that structured specification sections (`Actors:`, `Preconditions:`, `Trigger:`, `Main Success Scenario:`, `Alternate and Exception Flows:`, `Postconditions:`) are retained on the `UseCaseDef` rather than discarded.

### R2. Use Case Name Normalization & Path Resolution (`crates/compile-sysml/src/sync/forward.rs`)
Strip redundant leading prefixes (`UC_XX_`, `UC-XX-`, `UCXX_`) from Use Case identifiers when generating display titles (`Use Case 01: <Clean Name>`), slugified file paths (`use-cases/UC-01-<Clean_Slug>.md`), and Epic checklist links. Preserve issue IDs across file renames, and dynamically link the subsystem behavior file as the `Specification Source`.

### R3. Toolchain Rebuild, Legacy File Purge & Ground 0 Regeneration
Rebuild the compiler release binaries with `cargo build --release --workspace`, remove legacy duplicated files (`git rm docs/use-cases/UC-*-UC_*.md`), and regenerate all specifications via `./target/release/compile-sysml --compile` and `./target/release/compile-sysml --forward-sync --force`.

### R4. Quality Gate Auditing & Repository Synchronization
Verify that `./target/release/verify-baseline . --spec-only` passes with 0 findings, verify all 32 quality gates via `./target/release/verify-baseline . --no-domain`, synchronize issue bodies and titles to GitHub with `./target/release/reconcile-backlog --sync-bodies`, and commit all changes using neutral citations `(refs #115)`.

## Mission for this Work Package (Milestone 2):
Read the exploration report blueprint at `/Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_explorer_m1_1/handoff.md`.
Exclusively own and modify:
1. `crates/compile-sysml/src/parser/grammar.rs`:
   Verify that `parse_use_case_decl` captures inner `TokenKind::Doc` and `TokenKind::DocComment` inside `use case def { ... }` braces and concatenates them with outer doc into `UseCaseDef.doc`.
2. `crates/compile-sysml/src/sync/forward.rs`:
   - Implement `strip_use_case_prefix(name: &str) -> &str` to strip leading `UC_XX_`, `UC-XX-`, or `UCXX_` prefixes.
   - Update `UseCaseMeta` to include `subsys_dir: String`.
   - Update `uc_metas` population to set `subsys_dir` from the package name (`to_snake_case(&p.name)` or subsystem mapping).
   - In Epic checklist formatting (`assoc_uc`), use `strip_use_case_prefix` so the display title is `Use Case {:02}: {}` without stutter and the link targets `../use-cases/UC-{:02}-{}.md` with clean slug.
   - In Use Case generation, use `strip_use_case_prefix` for `title`, `uc_slug`, and `rel_path`.
   - Update CommonMark metadata table and Source References in Use Cases to link to `schema/subsystems/{subsys_dir}/behavior.sysml` as Specification Source.
   - Update `resolve_issue_id` to include prefix lookup for `UC-{:02}-*.md` so existing issue IDs (#95-#106) are preserved across renames.
3. Verify with `cargo check --workspace` that the entire workspace compiles cleanly without errors or warnings.

Write your handoff report to `/Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_m2_1/handoff.md` with:
- Files modified
- Exact diff or changes made
- Output of `cargo check --workspace`
- Verification results

Communicate back via send_message when done.

PROCEED
