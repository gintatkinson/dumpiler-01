## 2026-10-11T09:31:28Z
You are orchestrator_3 (teamwork_preview_orchestrator).
Your working directory is /Users/perkunas/jail/dumpiler-01/.agents/teamwork/orchestrator_3
Your original user request is recorded in /Users/perkunas/jail/dumpiler-01/.agents/teamwork/ORIGINAL_REQUEST.md

Execute total elimination of all shell scripts, rewire all callers to native Rust binaries, and establish Check 32 Zero-Shell Invariant.

Eliminate 100% of `.sh` shell scripts across the entire repository to ensure true cross-platform portability on Linux, macOS, and native Windows (PowerShell / Command Prompt) without POSIX shell dependencies. Replace all operational scripts with direct invocations of compiled release binaries (`verify-baseline`, `reconcile-backlog`, `compile-sysml`), port remaining peripheral tasks into native Rust, and add an automated baseline gate enforcing zero shell scripts on disk.

Working directory: /Users/perkunas/jail/dumpiler-01
Integrity mode: development

## Problem & Context

A previous migration pass successfully ported core verification logic and issue creation into native Rust crates (`crates/verify-baseline` and `crates/reconcile-backlog`), but erroneously retained 9 shell scripts as 16-47 line forwarding wrappers.

Shell scripts are fundamentally hostile to native Windows environments (PowerShell / CMD), suffer from line ending (`CRLF`) and executable bit (`chmod +x`) corruption in cross-platform Git workflows, and violate the project's **Rust-Only / Zero-Shell Architectural Mandate**.

All transitional wrappers must be completely eradicated. Not a single `.sh` file may remain in the repository.

Audit targets for total deletion (`git rm`):
- `skills/spec-orchestrator/scripts/create_issue.sh`
- `scripts/file_defect.sh`
- `scripts/verify_commit_messages.sh`
- `scripts/verify_subagent_output.sh`
- `scripts/reconcile_backlog.sh`
- `scripts/setup_git_hooks.sh`
- `.pipeline/scripts/verify_secret_leak.sh`
- `scripts/generate_wbs_suite.sh`
- `scripts/install_pipeline.sh`

## Requirements

### R1. Complete Shell Script Eradication (`git rm`)
- Permanently delete all 9 `.sh` files from the repository using `git rm`.
- Non-negotiable constraint: `find . -name "*.sh" -not -path "*/target/*" -not -path "*/.git/*"` MUST return exactly 0 files. Zero shell scripts are permitted to remain on disk.

### R2. Port Remaining Peripheral Functions to Native Rust
- **Native Hook Installer (`crates/verify-baseline setup-hooks`)**:
  - Add a subcommand to `crates/verify-baseline` that configures Git hooks natively in pure Rust.
  - The installed `.git/hooks/commit-msg` must invoke `./target/release/verify-baseline check-commit-msg` directly with fallback to `target/debug/` or `cargo run`, functioning across Linux, macOS, and Windows.
- **Native Secret Leak Scanner (`crates/verify-baseline check-secrets`)**:
  - Port pattern scanning from `.pipeline/scripts/verify_secret_leak.sh` into a native Rust subcommand in `crates/verify-baseline` (or integrate directly into baseline checks).

### R3. Rewire All Call-Sites, Skills, and Documentation
- Grep the entire repository for references to `.sh` scripts (`git grep "\.sh"`).
- Update all call-sites in `skills/` (including `skills/spec-orchestrator/SKILL.md`, `skills/feature-driven-implementation/SKILL.md`), `rules/`, `.pipeline/constitution.md`, `README.md`, and `AGENTS.md` to reference compiled release binaries directly:
  - `skills/spec-orchestrator/scripts/create_issue.sh` -> `./target/release/reconcile-backlog create-issue`
  - `scripts/file_defect.sh` -> `./target/release/reconcile-backlog create-issue --label bug`
  - `scripts/verify_commit_messages.sh` -> `./target/release/verify-baseline check-commit-msg`
  - `scripts/verify_subagent_output.sh` -> `./target/release/verify-baseline check-output`
  - `scripts/reconcile_backlog.sh` -> `./target/release/reconcile-backlog`
- Ensure zero dangling references to `.sh` files remain in active documentation or skill instructions.

### R4. Mechanical Gate Enforcement (Check 32: Zero-Shell Invariant)
- Add **Check 32: Zero Shell Scripts Invariant** to `crates/verify-baseline` in `./target/release/verify-baseline . --no-domain`.
- Check 32 must scan the repository tree (excluding `target/` and `.git/`) and fail closed with exit code 1 if ANY `.sh` file exists on disk.
- This mechanically prevents future regressions from ever re-introducing a shell script into the workspace.

### R5. Verification, Issue Closure & Remote Synchronization
- Verify clean compilation: `cargo check --workspace` and `cargo build --release --workspace`.
- Verify full baseline conformance: `./target/release/verify-baseline . --no-domain` passes all checks (including Check 32) with exit code 0.
- Update GitHub Issue #122 with empirical evidence of total script elimination and mark `status:fixed-resolved`.
- Commit with neutral citation:
  `refactor(toolchain): total elimination of shell scripts in favor of pure cross-platform rust (refs #122)`
- Synchronize with remote tracking branch (`git diff origin/main` must return exactly 0 bytes).

## Non-Negotiable Invariants

1. **Zero Shell Scripts**: Absolute count of `.sh` files on disk must be 0.
2. **Anti-Regex Invariant**: `check-commit-msg` and all linters must continue using pure lexical token scanning with strictly zero regex crates.
3. **Cross-Platform Compatibility**: All commands and hooks must execute natively on Linux, macOS, and Windows.
4. **Zero Em Dash**: Unicode em dashes (\u2014) are strictly forbidden. Use ASCII -- exclusively.
5. **Commit Non-Closure Invariant**: Use neutral citations (`(refs #122)`); auto-closing verbs are forbidden.

## Acceptance Criteria

### Script Eradication Gate
- [ ] `find . -name "*.sh" -not -path "*/target/*" -not -path "*/.git/*"` returns exactly 0 lines (0 files).
- [ ] `git grep -l "\.sh" -- 'skills/' 'rules/' '.pipeline/' 'README.md'` returns 0 active invocations.

### Rust Toolchain & Gates
- [ ] `crates/verify-baseline` exposes `setup-hooks` and `check-secrets`.
- [ ] Check 32 is active in `crates/verify-baseline` and verifies zero `.sh` scripts.
- [ ] `cargo check --workspace` and `cargo build --release --workspace` pass with exit code 0.
- [ ] `./target/release/verify-baseline . --no-domain` passes all 32 checks with exit code 0.

### Issue Resolution & Remote Sync
- [ ] GitHub Issue #122 updated with verification evidence and marked `status:fixed-resolved`.
- [ ] Remote tracking branch synchronized (`git diff origin/main` is 0 bytes).
- [ ] Independent Victory Audit independently verifies 0 shell scripts on disk before declaring completion.

PROCEED
