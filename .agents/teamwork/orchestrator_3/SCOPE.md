# Scope: Shell Script Total Elimination & Native Rust Toolchain Consolidation

## Architecture
- Repository: DOWNSTREAM_CUSTOMER_PROJECT
- Eliminate 100% of `.sh` shell scripts across the entire repository.
- Native Rust subcommands in `crates/verify-baseline`:
  - `setup-hooks`: installs Git commit-msg hook natively.
  - `check-secrets`: scans workspace for secret leaks natively.
- Mechanical gate: Check 32 Zero Shell Invariant in `crates/verify-baseline` (`./target/release/verify-baseline . --no-domain`).
- Rewire all documentation, skills, and configuration from `.sh` to compiled release binaries.

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | R1 Shell Eradication | Delete all 9 `.sh` files with `git rm` | M1 | Dispatch |
| 2 | R2 Native Rust Subcommands | `setup-hooks` and `check-secrets` in `crates/verify-baseline` | M1 | Dispatch |
| 3 | R3 Call-Site Rewiring | Grep and replace all `.sh` invocations across docs, skills, configs | M1 | Dispatch |
| 4 | R4 Check 32 Zero Shell | Add Check 32 in `crates/verify-baseline` failing closed if any `.sh` exists | M1 | Dispatch |
| 5 | R5 Verification & Sync | Clean release build, 32 checks passing, Issue #122 update, git push | M1 | Dispatch |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| 1 | M1: Shell Script Eradication & Rust Toolchain Consolidation | R1, R2, R3, R4, R5 | none | IN_PROGRESS |
