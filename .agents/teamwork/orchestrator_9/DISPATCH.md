## 2026-10-11T19:58:35Z
You are orchestrator_9.
Your working directory is: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/orchestrator_9
Original request file: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/ORIGINAL_REQUEST.md

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

## Acceptance Criteria

### Compiler & Parser Fidelity
- [ ] Parser preserves inner `doc /* ... */` blocks inside `use case def` in `crates/compile-sysml/src/parser/grammar.rs`.
- [ ] Redundant `UC 01` string eliminated from all 12 Use Case titles and filenames.
- [ ] Epic checklists in `docs/epics/` link to normalized Use Case paths and titles.
- [ ] All 12 Use Cases in `docs/use-cases/` contain full schema-defined scenarios and exception flows (`5a` through `5j`).

### Baseline Verification & Quality Gates
- [ ] `cargo check --workspace` and `cargo build --release --workspace` compile cleanly with exit code 0.
- [ ] `./target/release/verify-baseline . --spec-only` passes with 0 findings across all specifications.
- [ ] `./target/release/verify-baseline . --no-domain` passes all 32 quality gates with exit code 0.
- [ ] `./target/release/reconcile-backlog --sync-bodies` successfully synchronizes updated titles and bodies to GitHub issues.
- [ ] All commits use neutral citations `(refs #115)` with zero auto-closing keywords, and working tree diff against tracking branch is clean (`git diff origin/main` is empty).

PROCEED
