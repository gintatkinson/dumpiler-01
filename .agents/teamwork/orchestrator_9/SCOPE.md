# Scope: Use Case Normalization, Parser Fix & Ground 0 Regeneration

## Architecture
- `crates/compile-sysml`: SysML parser (`grammar.rs`) and specification generator (`sync/forward.rs`).
- `crates/verify-baseline`: Mechanical baseline checker and quality gate enforcement.
- `crates/reconcile-backlog`: Backlog synchronization and GitHub projection engine.

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | Parser Doc Block Retention | Parse `TokenKind::Doc` and `DocComment` inside `use case def` braces into `UseCaseDef.doc` | M2 | R1 |
| 2 | Use Case Title & Filename Normalization | Strip redundant `UC_XX_`, `UC-XX-`, `UCXX_` prefixes; produce clean titles and filenames | M2 | R2 |
| 3 | Use Case Epic Checklist & Specification Source Linking | Link to clean names and dynamic `behavior.sysml` paths | M2 | R2 |
| 4 | Issue ID Retention Across Renames | Ensure issue ID resolution preserves #95--#106 across normalized filenames | M2 | R2 |
| 5 | Toolchain Rebuild & Legacy Purge | `cargo build --release --workspace` and `git rm docs/use-cases/UC-*-UC_*.md` | M3 | R3 |
| 6 | Ground 0 Regeneration | `./target/release/compile-sysml --compile` and `--forward-sync --force` | M3 | R3 |
| 7 | Quality Gates & Spec Audit | Verify `--spec-only` (0 findings) and `--no-domain` (all 32 gates pass) | M4 | R4 |
| 8 | GitHub Issue Projection & Remote Sync | `reconcile-backlog --sync-bodies`, commit `(refs #115)`, push to `origin/main` | M5 | R4 |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Exploration & Survey | Explore `grammar.rs`, `forward.rs`, `schema/`, and `docs/use-cases/` | none | DONE |
| M2 | Parser & Sync Implementation | Implement R1 parser fix and R2 normalization in `crates/compile-sysml` | M1 | DONE |
| M3 | Rebuild, Purge & Regenerate | Rebuild release binary, purge legacy files, run Ground 0 forward-sync | M2 | DONE |
| M4 | Quality Gates & Verification | Verify all 32 quality gates, `--spec-only`, anti-stutter, and scenario counts | M3 | DONE |
| M5 | GitHub Projection & Remote Sync | Reconcile backlog with GitHub, commit `(refs #115)`, push to remote, verify 0 diff | M4 | DONE |

## Interface Contracts
### `crates/compile-sysml/src/parser/grammar.rs`
- `parse_use_case_decl(&mut self) -> Result<UseCaseDef, ParseError>`:
  Captures `TokenKind::Doc` and `TokenKind::DocComment` inside `{ ... }` into `use_case.doc`.
### `crates/compile-sysml/src/sync/forward.rs`
- `strip_use_case_prefix`: strips `UC_XX_`, `UC-XX-`, `UCXX_` prefixes.
- Filename format: `use-cases/UC-{num:02}-{clean_slug}.md`.
- Display title format: `Use Case {num:02}: {clean_name}`.
- Epic checklist markdown links matching clean filename and title.
- Specification Source linking to `schema/subsystems/{subsystem}/behavior.sysml`.
- `resolve_issue_id`: matches prefix `UC-{:02}-*.md` to preserve existing issue IDs.
### `crates/verify-baseline/src/spec_audit/provenance.rs`
- `is_section_or_label`: recognizes alphanumeric outline sub-step labels (`5a.`, `5e.`, `5i.`).
