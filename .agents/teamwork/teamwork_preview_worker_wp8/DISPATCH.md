## 2026-10-12T14:44:04Z

You are teamwork_preview_worker_wp8.
Your working directory is: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_wp8
Original request path: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/ORIGINAL_REQUEST.md
Implementation plan path: /Users/perkunas/jail/dumpiler-01/implementation_plan.md

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_preview_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Autonomous On-Disk Governance Initialization:
Autonomously execute view_file on .pipeline/constitution.md and .pipeline/ACTIVE_RULES_BUNDLE.md as your first step.

Assigned Micro-Task: Work Package 8 (Workspace Manifest Eviction & Lockfile Regeneration)
Verbatim User Instructions:
Execute the autonomous Ralph burndown loop on dumpiler-01 to eradicate all 43 regular expression sites across the 4 Rust compiler crates, evict the regex crate completely from the workspace, purge all Python debris, and arm ./target/release/verify-baseline with Check 33 (Zero Python Scripts Invariant) and Check 34 (Zero Regex Invariant).

### WP8: Workspace Manifest Eviction & Lockfile Regeneration
- Inspect root Cargo.toml and ensure no regex dependency exists in [workspace.dependencies] or any crate.
- Run `cargo check --workspace` to update Cargo.lock and regenerate the lockfile cleanly without regex.
- Verify negative proof: `cargo tree -i regex` must exit non-zero (proving total eviction from dependency graph).
- Execute negative proof commands:
  * `test $(git grep "Regex::" crates/ | wc -l) -eq 0`
  * `test $(git grep "use regex::" crates/ | wc -l) -eq 0`
  * `test $(git grep "regex = " crates/ | wc -l) -eq 0`
- Run `./target/release/verify-baseline . --no-domain` and verify all quality gates pass.

Strict Prohibition of Unit Tests and Scripts:
- Creating, maintaining, or executing Python scripts (.py), shell scripts (.sh), or unit test scripts (test_*.py, pytest) is STRICTLY FORBIDDEN anywhere in this repository.
- Writing a .py file into .agents/teamwork/ or anywhere else will result in immediate disqualification and failure of the teamwork session.
- All tools, checks, tests, and parsers MUST be written exclusively in native Rust.

Zero Em Dash Invariant: Unicode em dashes (\u2014) are strictly forbidden. Use ASCII -- exclusively.
Commit Message Non-Closure Invariant: Auto-closing keywords are forbidden. Use neutral citations: (refs #115).

Deliverables:
1. Inspect root Cargo.toml.
2. Run `cargo check --workspace` and check if Cargo.lock is updated.
3. Run `cargo tree -i regex` and verify it exits non-zero (package `regex` not found in tree).
4. Run negative grep commands across all crates/ to verify zero regex occurrences in code and manifests.
5. Run `./target/release/verify-baseline . --no-domain` to ensure baseline passes.
6. Verify zero em dashes (\u2014) in modified files.
7. Document diffs, commands, and verbatim raw output in /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_wp8/handoff.md.
8. Notify orchestrator via send_message when complete.

PROCEED
