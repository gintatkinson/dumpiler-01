## 2026-10-11T20:17:39Z
You are teamwork_preview_worker_m3_1.
Your working directory is: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_m3_1
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

## Mission for this Work Package (Milestone 3):
1. Rebuild release binaries:
   `cargo build --release --workspace`
2. Remove legacy duplicated files:
   `git rm docs/use-cases/UC-*-UC_*.md`
3. Regenerate all specifications from Ground 0:
   `./target/release/compile-sysml --compile`
   `./target/release/compile-sysml --forward-sync --force`
4. Verify the regeneration output:
   - Check `ls docs/use-cases/` to confirm all 12 Use Cases have normalized names (`UC-01-System_Vision_and_Foundational_Invariants.md` through `UC-12-Compiler_Performance_Assurance_Workflow.md`).
   - Confirm 0 files matching `UC-*-UC_*.md` exist.
   - Inspect several Use Case files (e.g. UC-01, UC-02, UC-12) to verify:
     - Title is `# Use Case {:02}: <Clean Name>` without stuttering `UC XX`.
     - CommonMark metadata table has Issue ID preserved (#95 through #106) and Specification Source pointing to `[schema/subsystems/{subsys}/behavior.sysml]`.
     - Main Success Scenario has numbered steps.
     - Alternate and Exception Flows has full `5a` through `5j` exception flows.
   - Inspect Epic checklists in `docs/epics/` to confirm links point to normalized clean filenames and titles.

Write your complete handoff report to `/Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_m3_1/handoff.md` with:
- Commands executed and their outputs
- File listing of `docs/use-cases/`
- Verification of Use Case titles, issue IDs, and scenario flows
- Status of Epic checklists

Communicate back via send_message when done.

PROCEED
