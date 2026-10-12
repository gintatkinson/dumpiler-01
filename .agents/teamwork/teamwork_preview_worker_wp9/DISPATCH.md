# Work Package 9 Working Directory
Created for teamwork_preview_worker_wp9.

## 2026-10-12T14:47:26Z
You are teamwork_preview_worker_wp9.
Your working directory is: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_wp9
Original request path: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/ORIGINAL_REQUEST.md
Implementation plan path: /Users/perkunas/jail/dumpiler-01/implementation_plan.md

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_preview_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Autonomous On-Disk Governance Initialization:
Autonomously execute view_file on .pipeline/constitution.md and .pipeline/ACTIVE_RULES_BUNDLE.md as your first step.

Assigned Micro-Task: Work Package 9 (Arm Baseline Toolchain with Checks 33 & 34)
Verbatim User Instructions:
Execute the autonomous Ralph burndown loop on dumpiler-01 to eradicate all 43 regular expression sites across the 4 Rust compiler crates, evict the regex crate completely from the workspace, purge all Python debris, and arm ./target/release/verify-baseline with Check 33 (Zero Python Scripts Invariant) and Check 34 (Zero Regex Invariant).

### WP9: Arm Baseline Toolchain (Checks 33 & 34)
- Target: `crates/verify-baseline/src/checks/structural.rs` (and `checks/mod.rs`):
  1. Implement Check 33: `check_zero_python_scripts(repo_root: &Path) -> Result<(), Vec<String>>`
     - Recursively walk repository filesystem from root using WalkDir.
     - Skip `target` and `.git` directories.
     - Detect any file with extension `py` (case-insensitive or `.py`).
     - If any `.py` file is detected, report its relative path and fail closed (`Err(violations)`).
  2. Implement Check 34: `check_zero_regex(repo_root: &Path) -> Result<(), Vec<String>>`
     - Scan all `.rs` files and `Cargo.toml` files in `crates/` and root `Cargo.toml`.
     - Check if any line contains forbidden patterns: `Regex::`, `use regex::`, or in Cargo.toml dependency on `regex`.
     - Ensure the check scanner itself does not false-positive trigger on its own string constants (e.g. by avoiding literal patterns or inspecting non-comment/non-string code or token matching).
     - If any regex usage is found, report file, line number, and content, and fail closed (`Err(violations)`).
- Target: `crates/verify-baseline/src/runner.rs`:
  - Wire Check 33 immediately after Check 32:
    - Print error and write defect dossier on failure: `"Check 33 (Zero Python Scripts Invariant)"`.
    - Print success: `"Success: Check 33 verified (Zero Python Scripts Invariant passed -- zero .py files exist on disk)."`
  - Wire Check 34 immediately after Check 33:
    - Print error and write defect dossier on failure: `"Check 34 (Zero Regex Invariant)"`.
    - Print success: `"Success: Check 34 verified (Zero Regex Invariant passed -- zero regex occurrences exist across crates)."`
- Build and verify:
  - Run `cargo check -p verify-baseline` and `cargo test -p verify-baseline`.
  - Compile release binary: `cargo build --release -p verify-baseline`.
  - Execute `./target/release/verify-baseline . --no-domain`.
  - Verify all 34 checks pass with exit code 0.

Strict Prohibition of Unit Tests and Scripts:
- Creating, maintaining, or executing Python scripts (.py), shell scripts (.sh), or unit test scripts (test_*.py, pytest) is STRICTLY FORBIDDEN anywhere in this repository.
- Writing a .py file into .agents/teamwork/ or anywhere else will result in immediate disqualification and failure of the teamwork session.
- All tools, checks, tests, and parsers MUST be written exclusively in native Rust.

Zero Em Dash Invariant: Unicode em dashes (\u2014) are strictly forbidden. Use ASCII -- exclusively.
Commit Message Non-Closure Invariant: Auto-closing keywords are forbidden. Use neutral citations: (refs #115).

Deliverables:
1. Implement Check 33 and Check 34 in `crates/verify-baseline/src/checks/structural.rs` (and export in `checks/mod.rs`).
2. Wire Check 33 and Check 34 into `crates/verify-baseline/src/runner.rs`.
3. Compile release binary with `cargo build --release -p verify-baseline`.
4. Run `./target/release/verify-baseline . --no-domain` and verify all 34 checks pass cleanly with exit code 0.
5. Verify zero em dashes (\u2014) in modified files.
6. Document diff, commands, and raw verbatim output in /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_wp9/handoff.md.
7. Notify orchestrator via send_message when complete.

PROCEED
