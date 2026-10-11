## 2026-10-11T08:41:43Z

Your working directory is /Users/perkunas/jail/dumpiler-01/.agents/teamwork/worker_m6_1.
You must read /Users/perkunas/jail/dumpiler-01/.agents/teamwork/ORIGINAL_REQUEST.md, .pipeline/constitution.md, and .pipeline/ACTIVE_RULES_BUNDLE.md.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_preview_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Here is the verbatim user instruction for your task:
"Reduce or eliminate the audited shell scripts:
  - Replace or reduce `create_issue.sh`, `file_defect.sh`, `verify_commit_messages.sh`, and `verify_subagent_output.sh` to lightweight wrappers <= 15-50 lines delegating directly to compiled release binaries (`./target/release/verify-baseline`, `./target/release/reconcile-backlog`)."

Your specific assignment for this milestone (Milestone M6):
1. Replace or reduce the following target shell scripts to lightweight POSIX delegation wrappers (<= 15-50 lines):
   - `skills/spec-orchestrator/scripts/create_issue.sh` (delegate directly to `./target/release/reconcile-backlog create-issue "$@"`)
   - `scripts/verify_commit_messages.sh` (delegate directly to `./target/release/verify-baseline check-commit-msg "$@"`)
   - `scripts/verify_subagent_output.sh` (delegate directly to `./target/release/verify-baseline check-output "$@"`)
   - `scripts/file_defect.sh` (validate defect dossier schema via `./target/release/verify-baseline check-defect` and create issue via `./target/release/reconcile-backlog create-issue` or `gh issue create`, keeping the script under 50 lines)
   - `.pipeline/scripts/verify_secret_leak.sh` (tighten/streamline to ensure <= 50 lines)
2. Ensure that ALL operational shell scripts in the repository are strictly <= 50 lines:
   Run `find . -name "*.sh" -not -path "*/target/*" -not -path "*/.git/*" | xargs wc -l` and ensure no script exceeds 50 lines.
3. Ensure executable permissions (`chmod +x`) on the wrapper scripts.
4. Empirically verify that invoking each of the wrapped scripts works as expected.
5. Verify `cargo check --workspace` and `./target/release/verify-baseline . --no-domain` still pass cleanly.
6. Write your handoff report in your working directory (/Users/perkunas/jail/dumpiler-01/.agents/teamwork/worker_m6_1/handoff.md) and report back via send_message.

PROCEED
