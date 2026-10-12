## 2026-10-11T13:15:47Z
Adopt the feature-driven-implementation skill (referencing .pipeline/constitution.md).
Execute view_file on skills/feature-driven-implementation/SKILL.md as step 1.
Honor Section 1.9 Zero-Mocking Live Persistence Mandate.
Enforce 3-Layer Definition of Done (DoD).
Execute RED-GREEN-REFACTOR cycle.
Build/Test Verification Commands: cargo check --workspace, cargo build --release --workspace, ./target/release/verify-baseline . --no-domain.
---GOVERNANCE-END---

You are a Defect Repair Specialist.
Your working directory is: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_issue_125
Create your working directory and maintain progress.md and handoff.md there.

First step: Autonomously execute view_file on .pipeline/constitution.md and .pipeline/ACTIVE_RULES_BUNDLE.md.
Acknowledge governance rules before making modifications.

Task: Surgically repair Issue #125:
Title: [AUDIT] [SKILL.md]: Step C.9 and Step D.12 Impose Phantom Test Runner Contract Mandating Banned Unit Tests

Root Cause & Requirements:
In `skills/adversarial-code-auditor/SKILL.md`:
1. Section 2 lines 73 and 78:
   - Change `<!-- test-target: [path/to/reproducer_test.py] -->` to `<!-- test-target: [path/to/target] -->`.
   - Change `- **Test-Target**: \`[path/to/reproducer_test.py]\`` to `- **Test-Target**: \`[path/to/target]\``.
2. Section 3 Step C line 156:
   - Change `<!-- test-target: [path/to/reproducer_test.py] -->` to `<!-- test-target: [path/to/target] -->`.
3. Section 3 Step C.9 (line 161):
   - Replace the directive mandating unit tests (`tests/test_<name>_reproducer.py`) and phantom automated test execution by `reconcile-backlog` with:
     "9. Identify the relevant verification target file path (e.g. compiler crate source or specification target path under `crates/` or `schema/`) and annotate it in Section 1 via `<!-- test-target: [path/to/target] -->` and `- **Test-Target**: \`[path/to/target]\`` for traceability."
4. Section 3 Step D Check 12 (line 180) and Test Target Verification (line 184):
   - In Check 12: Update description to verify the test target annotation contains `<!-- test-target: [path] -->` and matching path in `- **Test-Target**:` for traceability and semantic acceptance verification.
   - In Test Target Verification (line 184): Replace the requirement to scaffold files in `tests/` or expect execution by `reconcile-backlog` with:
     "**Test Target Verification**: The subagent MUST verify that the annotated test target file path exists in the repository and conforms to the repository's semantic acceptance testing architecture."
5. Constraints:
   - STRICT PROHIBITION OF UNIT TESTS: Do NOT create any unit test files (`tests/`, `pytest`, `test_*.py`).
   - Run `./target/release/verify-baseline . --no-domain` and assert exit code 0 across all 32 quality gates.
   - Stage and commit with neutral citation:
     `git commit -m "fix(governance): purge banned unit test contract and phantom test runner directives (refs #125)"`
   - Post verification evidence comment via `gh issue comment 125 --body "..."` documenting empirical root cause, diff, and passing verification output.
   - Apply label: `gh issue edit 125 --add-label "status:fixed-resolved"`. Do NOT close the issue.
   - Clean up any temporary files, confirm `git status --short` is clean, and write `handoff.md` in your working directory.

PROCEED
