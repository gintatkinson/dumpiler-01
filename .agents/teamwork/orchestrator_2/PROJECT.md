# Project: Shell Script Sprawl Elimination & Rust Toolchain Consolidation

## Architecture
Consolidate brittle bash scripts (>50 lines) into native Rust subcommands across `crates/verify-baseline` and `crates/reconcile-backlog`, enforce zero regex in commit message checks via deterministic token iterators, validate defect dossiers via native schema checkers, and wrap legacy scripts with thin <= 50 line shims.

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | Adversarial 4-Pillar Code Audit & 5 Whys | Analyze target shell scripts (>50 lines), generate canonical 7-section defect dossier at docs/reports/defects/SHELL_SCRIPTS_SPRAWL_AUDIT.md | M1 | ORIGINAL_REQUEST R1 |
| 2 | Defect Issue Publication | Create GitHub issue with title `[AUDIT] Architecture: Eliminate brittle shell scripts (>50 lines) and consolidate into native Rust toolchain` | M2 | ORIGINAL_REQUEST R2 |
| 3 | Compile Fix in forward.rs | Fix format string mismatch in crates/compile-sysml/src/sync/forward.rs:808 | M3 | ORIGINAL_REQUEST R3 |
| 4 | verify-baseline Native Checkers | Implement `check-commit-msg` (zero-regex lexical scanner), output integrity checks, and defect dossier validation in `crates/verify-baseline` | M4 | ORIGINAL_REQUEST R3 |
| 5 | reconcile-backlog `create-issue` | Implement CLI subcommand `create-issue` in `crates/reconcile-backlog` using TrackerClient and serde_json | M5 | ORIGINAL_REQUEST R3 |
| 6 | Shell Script Wrappers | Reduce `create_issue.sh`, `file_defect.sh`, `verify_commit_messages.sh`, `verify_subagent_output.sh` to <= 50 lines delegating to Rust binaries | M6 | ORIGINAL_REQUEST R3 |
| 7 | Full Verification & Conformance | Run workspace check/build, verify all scripts <= 50 lines, verify-baseline all 31 checks pass, transition issue to `status:fixed-resolved` | M7 | ORIGINAL_REQUEST R4 |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Adversarial Code Audit | Audit targets, write SHELL_SCRIPTS_SPRAWL_AUDIT.md | none | DONE |
| M2 | Issue Publication | Publish issue on GitHub, record issue number/URL (#122) | M1 | DONE |
| M3 | Compile Fix | Fix compile error in forward.rs:808 | none | DONE |
| M4 | verify-baseline Rust Consolidation | Add check-commit-msg (lexical), output checks, defect validation | M3 | DONE |
| M5 | reconcile-backlog Rust Consolidation | Add create-issue subcommand | M3 | DONE |
| M6 | Shell Script Thinning | Replace/wrap shell scripts to <= 50 lines | M4, M5 | DONE |
| M7 | Baseline Verification & Issue Resolution | Workspace build, script line count check, verify-baseline . --no-domain, update issue | M6 | IN_PROGRESS |

## Code Layout
- `docs/reports/defects/SHELL_SCRIPTS_SPRAWL_AUDIT.md`: 7-section defect report
- `crates/compile-sysml/src/sync/forward.rs`: Forward sync generator
- `crates/verify-baseline/src/`: Native verification subcommands
- `crates/reconcile-backlog/src/`: Native issue tracking CLI subcommands
- `skills/spec-orchestrator/scripts/create_issue.sh`: Lightweight wrapper <= 50 lines
- `scripts/file_defect.sh`: Lightweight wrapper <= 50 lines
- `scripts/verify_commit_messages.sh`: Lightweight wrapper <= 50 lines
- `scripts/verify_subagent_output.sh`: Lightweight wrapper <= 50 lines
- `.pipeline/scripts/verify_secret_leak.sh`: Lightweight wrapper/linter <= 50 lines
