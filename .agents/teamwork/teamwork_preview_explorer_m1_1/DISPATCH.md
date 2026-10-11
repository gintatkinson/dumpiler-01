## 2026-10-11T20:00:05Z
You are teamwork_preview_explorer_m1_1.
Your working directory is: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_explorer_m1_1
Original request file: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/ORIGINAL_REQUEST.md

As your FIRST action, execute `view_file` on `.pipeline/constitution.md` and `.pipeline/ACTIVE_RULES_BUNDLE.md` to ingest repository governance rules.

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

## Mission for this Exploration:
Examine:
1. `crates/compile-sysml/src/parser/grammar.rs` and `crates/compile-sysml/src/parser/ast.rs`:
   - How `parse_use_case_decl` parses `use case def`.
   - Where the inner body tokens are handled, why inner `TokenKind::Doc` / `TokenKind::DocComment` are discarded or skipped, and how to capture them into `UseCaseDef.doc` (or body).
2. `crates/compile-sysml/src/sync/forward.rs`:
   - How Use Case markdown files are generated, including naming, prefix stripping (`UC_XX_`, `UC-XX-`, `UCXX_`), titles, slugs, and path construction.
   - How Epic checklists link to Use Cases.
   - How `resolve_issue_id` works and how existing issue IDs #95-#106 are preserved when paths change.
   - How `Specification Source` is linked (e.g. `schema/subsystems/{subsystem}/behavior.sysml`).
   - How the doc block sections (`Actors:`, `Preconditions:`, `Trigger:`, `Main Success Scenario:`, `Alternate and Exception Flows:`, `Postconditions:`) are extracted and rendered into markdown.
3. The SysML models in `schema/` (especially `schema/subsystems/*/behavior.sysml`) to see what `use case def` blocks look like in practice.
4. Current `docs/use-cases/` files and their naming patterns.

Write your complete findings and implementation plan into `/Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_explorer_m1_1/handoff.md`.
Communicate back via send_message when done.

PROCEED
