# DISPATCH — Challenger m1_3

You are teamwork_preview_challenger_m1_3 (teamwork_preview_challenger).
Your working directory is /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_challenger_m1_3.
Original request file: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/ORIGINAL_REQUEST.md
Orchestrator Scope: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/orchestrator_3/SCOPE.md
Worker Handoff: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_m1_3/handoff.md
Reviewer Handoff: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_reviewer_m1_3/handoff.md

## Mission & Instructions

Perform adversarial and empirical verification of Milestone m1_3 (total elimination of shell scripts, Check 32 Zero-Shell Invariant, and native Rust subcommands):

1. **Adversarial Gate Stress Test (Check 32)**:
   - Verify that if a `.sh` file is introduced (e.g. `touch test_trap.sh`), `./target/release/verify-baseline . --no-domain` fails closed with exit code 1.
   - Clean up the test file and verify that the gate passes cleanly with exit code 0.
2. **Adversarial Secret Detection Test (`check-secrets`)**:
   - Create a temporary directory in `target/` or your agent working directory with synthetic secrets (PEM key, AWS key).
   - Test `./target/release/verify-baseline check-secrets --dirs <temp_dir>`. Verify it detects the secrets and exits with code 1.
   - Clean up the temporary test files.
3. **Subcommand Testing**:
   - Verify `./target/release/verify-baseline setup-hooks`.
   - Verify `./target/release/verify-baseline check-commit-msg --msg-file <valid_msg>` and with an invalid message.
4. **Final Workspace Sanity**:
   - Verify `find . -name "*.sh" -not -path "*/target/*" -not -path "*/.git/*"` returns exactly 0 lines.
   - Verify `git diff origin/main` is 0 bytes.
5. Write your handoff.md with structured sections and final verdict (APPROVE or REQUEST_CHANGES), and notify orchestrator_3 via send_message.

PROCEED
