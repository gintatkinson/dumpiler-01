# Implementation Plan -- Total Shell Script Eradication, Native Rust Rewiring & Check 32 Zero-Shell Invariant

**Objective**: Permanently eradicate 100% of `.sh` shell scripts across the repository, port all remaining peripheral scripts (hook installer, secret leak scanner) to native Rust subcommands in `crates/verify-baseline`, rewire all call-sites and documentation to compiled binaries, and establish Check 32 (Zero-Shell Invariant) in `verify-baseline` to guarantee zero shell scripts on disk.

---

## 1. Problem Statement & Audit Targets

A previous migration ported core verification and issue management logic to Rust (`crates/verify-baseline` and `crates/reconcile-backlog`), but left 9 shell scripts as forwarding wrappers. Shell scripts introduce line ending (`CRLF`), execution flag (`chmod +x`), and environment fragmentation across macOS, Linux, and native Windows.

### Deletion Audit Targets (`git rm`):
- [x] `skills/spec-orchestrator/scripts/create_issue.sh`
- [x] `scripts/file_defect.sh`
- [x] `scripts/verify_commit_messages.sh`
- [x] `scripts/verify_subagent_output.sh`
- [x] `scripts/reconcile_backlog.sh`
- [x] `scripts/setup_git_hooks.sh`
- [x] `.pipeline/scripts/verify_secret_leak.sh`
- [x] `scripts/generate_wbs_suite.sh`
- [x] `scripts/install_pipeline.sh`

---

## 2. Requirements & Architecture

### R1. Complete Shell Script Eradication (`git rm`)
- [x] Permanently remove all 9 `.sh` files from the repository via `git rm`.
- [x] Invariant: `find . -name "*.sh" -not -path "*/target/*" -not -path "*/.git/*"` returns exactly 0 files.

### R2. Port Remaining Peripheral Functions to Native Rust
- [x] **Native Hook Installer (`crates/verify-baseline setup-hooks`)**:
  - Added `setup-hooks` subcommand to `crates/verify-baseline` to configure Git hooks natively in pure Rust.
  - Installed `.git/hooks/commit-msg` executes `./target/release/verify-baseline check-commit-msg` directly with fallback to `target/debug/` or `cargo run`.
- [x] **Native Secret Leak Scanner (`crates/verify-baseline check-secrets`)**:
  - Implemented native token and credential pattern scanning in `crates/verify-baseline` as a standalone subcommand and integrated check with zero regex crates.

### R3. Rewire All Call-Sites, Skills, and Documentation
- [x] Grepped entire repository for `.sh` references (`git grep "\.sh"`).
- [x] Rewired all references in `skills/`, `rules/`, `.pipeline/`, `README.md`, and `AGENTS.md` directly to compiled release binaries:
  - `skills/spec-orchestrator/scripts/create_issue.sh` -> `./target/release/reconcile-backlog create-issue`
  - `scripts/file_defect.sh` -> `./target/release/reconcile-backlog create-issue --label bug`
  - `scripts/verify_commit_messages.sh` -> `./target/release/verify-baseline check-commit-msg`
  - `scripts/verify_subagent_output.sh` -> `./target/release/verify-baseline check-output`
  - `scripts/reconcile_backlog.sh` -> `./target/release/reconcile-backlog`
- [x] Verified zero dangling references to `.sh` files remain in active documentation or skills.

### R4. Mechanical Gate Enforcement (Check 32: Zero-Shell Invariant)
- [x] Added **Check 32: Zero Shell Scripts Invariant** to `crates/verify-baseline`.
- [x] Scans working tree (excluding `target/` and `.git/`) and fails closed with exit code 1 if ANY `.sh` file exists on disk.

### R5. Verification, Issue Closure & Remote Synchronization
- [x] Clean compilation: `cargo check --workspace` and `cargo build --release --workspace` pass (exit code 0).
- [x] Baseline conformance: `./target/release/verify-baseline . --no-domain` passes all 32 checks (exit code 0).
- [x] GitHub Issue #122 updated with empirical evidence and marked `status:fixed-resolved`.
- [x] Committed with neutral citation: `refactor(toolchain): total elimination of shell scripts in favor of pure cross-platform rust (refs #122)` (`e6c6db1`).
- [x] Synchronized with remote tracking branch (`git diff origin/main` returns 0 bytes).

---

## 3. Teamwork Multi-Agent Verification Status

- **Reviewer**: `teamwork_preview_reviewer_m1_3` -> **APPROVE**
- **Challenger**: `teamwork_preview_challenger_m1_3` -> **APPROVE** (stress-tested Check 32 fail-closed behavior)
- **Forensic Auditor**: `teamwork_preview_auditor_m1_3` -> **CLEAN**
- **Victory Auditor**: `victory_auditor_2` -> **VICTORY CONFIRMED**
