## 2026-10-11T20:21:22Z

Sender: f5f0fc56-1012-446f-a5e2-5fee98d0c971
Priority: MESSAGE_PRIORITY_HIGH

You are teamwork_preview_reviewer_m4_1.
Your working directory is: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_reviewer_m4_1
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

## Mission for this Work Package (Milestone 4):
1. Run `./target/release/verify-baseline . --spec-only`.
   Examine any findings. If there are any findings:
   - Identify which files and lines trigger them.
   - If findings exist (e.g. `[factual-grounding-missing-unit]` or formatting findings in generated use cases or elsewhere), diagnose root cause and determine whether a fix is needed in `forward.rs` or `verify-baseline` or if specifications need refinement.
2. Run `./target/release/verify-baseline . --no-domain`.
   Verify all 32 quality gates pass with exit code 0.
3. Empirically inspect:
   - All 12 Use Cases in `docs/use-cases/` for clean titles, clean filenames, preserved issue IDs #95-#106, dynamic `Specification Source` linking `schema/subsystems/{subsys}/behavior.sysml`, 6-step Main Success Scenario, and full 5a..5j exception flows.
   - Epic checklists in `docs/epics/` for clean names and valid links.
   - Zero `.sh` files in the repository.
   - Zero unicode em dashes (`\u2014`) across all files.
4. Record your detailed findings, commands executed, exact outputs, and verdict (APPROVE or REQUEST_CHANGES) in `/Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_reviewer_m4_1/handoff.md`.

Communicate back via send_message when done.

PROCEED
