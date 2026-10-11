# Handoff Report -- Milestone M5: Rust Native `create-issue` Subcommand

## 1. Observation

1. **Initial Codebase State**:
   - `crates/reconcile-backlog/src/tracker.rs` defined `TrackerClient` trait with only `fetch_all_issues`, `update_issue_body`, and `add_label`. It lacked `create_issue`, `ensure_label_exists`, and `reopen_issue`.
   - `crates/reconcile-backlog/src/main.rs` supported only flags for default reconciliation (`--workspace`, `--offline`, `--provider`, `--dry-run`, `--sync-bodies`) and had no subcommand routing.
   - `skills/spec-orchestrator/scripts/create_issue.sh` (258 lines) performed fragile TSV string slicing with `awk`, shell subprocesses, and text-based title matching.

2. **Empirical Build and Verification Results**:
   - `cargo check -p reconcile-backlog`:
     ```text
     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.78s
     ```
   - `cargo build -p reconcile-backlog`:
     ```text
     Finished `dev` profile [unoptimized + debuginfo] target(s) in 1.70s
     ```
   - `cargo test -p reconcile-backlog`:
     ```text
     test result: ok. 13 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.01s
     ```
   - `cargo build --release -p reconcile-backlog`:
     ```text
     Finished `release` profile [optimized] target(s) in 2.09s
     ```
   - `cargo check --workspace`:
     ```text
     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.05s
     ```
   - `./target/release/verify-baseline . --no-domain`:
     ```text
     Success: Specification Quality & Coverage Audit passed (93 files audited in 272 ms).
     ```
     All 31 checks passed with exit code 0.

3. **Subcommand Verification Evidence**:
   - Running `./target/release/reconcile-backlog --help` confirmed default options preserved alongside `create-issue` subcommand:
     ```text
     Commands:
       create-issue  Create or reopen an issue idempotently with precondition checks
       help          Print this message or the help of the given subcommand(s)
     ```
   - Running `./target/release/reconcile-backlog create-issue --help` confirmed options:
     ```text
     Usage: reconcile-backlog create-issue [OPTIONS] [ARGS]...
     ```
   - Testing nonexistent body file:
     ```text
     ERROR: FATAL: Body file not found: /nonexistent/file.md
     (exit code 1)
     ```
   - Testing empty body file:
     ```text
     ERROR: FATAL: Body file is empty: /tmp/test_empty_body.md
     (exit code 1)
     ```
   - Testing unreplaced `{{REQUIRED_*}}` token:
     ```text
     ERROR: FATAL: Unreplaced {{REQUIRED_*}} escape token detected in: /tmp/test_token.md
     (exit code 1)
     ```
   - Testing unbalanced code fences:
     ```text
     ERROR: FATAL: Unbalanced code fences in: /tmp/test_fence.md (found 1 fences)
     (exit code 1)
     ```
   - Testing new issue creation with offline provider:
     ```text
     [CREATED] Issue #1 created: https://github.com/local/offline/issues/1
     https://github.com/local/offline/issues/1
     (exit code 0)
     ```
   - Testing positional argument syntax `<body-file> <label> <title> [repo]`:
     ```text
     [CREATED] Issue #1 created: https://github.com/my-org/my-repo/issues/1
     https://github.com/my-org/my-repo/issues/1
     (exit code 0)
     ```
   - Testing live GitHub duplicate detection against existing open issue #122:
     ```text
     [IDEMPOTENT] Issue #122 already open: https://github.com/gintatkinson/dumpiler-01/issues/122
     https://github.com/gintatkinson/dumpiler-01/issues/122
     (exit code 0)
     ```

## 2. Logic Chain

1. Per dispatch requirement 1, `TrackerClient` was extended with `create_issue(&self, title: &str, body: &str, label: &str, repo: Option<&str>) -> Result<(u64, String), String>`, `ensure_label_exists(&self, label: &str, repo: Option<&str>) -> Result<(), String>`, and `reopen_issue(&self, issue_number: u64, comment: Option<&str>, repo: Option<&str>) -> Result<(), String>` in `crates/reconcile-backlog/src/tracker.rs`.
2. Both `GitHubTracker` and `OfflineTracker` implementations were updated to implement these methods. `GitHubTracker` was given optional `repo` configuration and uses `gh issue create`, `gh label list`/`create`, and `gh issue reopen`/`comment`. `OfflineTracker` was updated with internal thread-safe state via `Mutex<OfflineState>` to maintain issue records and simulate full offline lifecycle operations without relying on external APIs.
3. Precondition validation (`validate_body_file` in `crates/reconcile-backlog/src/create_issue.rs`) enforces non-empty file size, file existence, balanced markdown code blocks (`fence_count % 2 == 0`), and zero unreplaced `{{REQUIRED_*}}` tokens.
4. Argument resolution (`CreateIssueArgs::resolve()`) handles both explicit `--flag` arguments and positional arguments (`<body-file> <label> <title> [repo]`) in a unified, deterministic order, ensuring 100% backwards compatibility with `create_issue.sh`.
5. Idempotency logic queries `TrackerClient::fetch_all_issues` and uses `normalize_title` to find existing issues. If an issue already exists and is closed, it is reopened (with optional analysis comment from `--reopen-with-analysis`), reporting the issue number and URL. If already open, it reports the existing issue number and URL and exits 0. If absent, it ensures the target label exists and creates the new issue.
6. In `crates/reconcile-backlog/src/main.rs`, clap's `subcommand_precedence_over_arg` attribute and `Option<Subcommands>` ensure that running `reconcile-backlog` without subcommands preserves default backlog reconciliation.

## 3. Caveats

- `GitLabTracker` was not requested in this milestone dispatch, so `--provider gitlab` returns a clear error recommending `github` or `offline`. If GitLab support is needed in the future, it can implement the identical `TrackerClient` trait using `glab`.
- Zero em dashes (`\u2014`) are used across all added files and comments, conforming to the Zero Em Dash Invariant.

## 4. Conclusion

Milestone M5 is complete. `crates/reconcile-backlog` now natively exposes the `create-issue` subcommand, implements all required precondition checks and idempotency logic via `TrackerClient`, supports both flag and positional arguments, preserves default backlog reconciliation, and passes all compiler, workspace, unit, and baseline verifier checks.

## 5. Verification Method

To independently verify the implementation, execute the following commands from the workspace root:

1. **Compiler & Workspace Checks**:
   ```bash
   cargo check -p reconcile-backlog
   cargo build -p reconcile-backlog
   cargo test -p reconcile-backlog
   cargo check --workspace
   ```
   *Expected outcome*: All compilation steps and 13 unit tests pass with exit code 0.

2. **CLI Help Output Verification**:
   ```bash
   ./target/release/reconcile-backlog --help
   ./target/release/reconcile-backlog create-issue --help
   ```
   *Expected outcome*: Help text displays default options and `create-issue` subcommand with both flags and positional arguments.

3. **Precondition Validation Checks**:
   ```bash
   # Test nonexistent file
   ./target/release/reconcile-backlog create-issue /nonexistent/file.md bug "Test Title" --provider offline
   # (Expected: exit code 1, ERROR: FATAL: Body file not found)

   # Test empty file
   touch /tmp/test_empty.md
   ./target/release/reconcile-backlog create-issue /tmp/test_empty.md bug "Test Title" --provider offline
   # (Expected: exit code 1, ERROR: FATAL: Body file is empty)

   # Test unreplaced token
   echo "Text {{REQUIRED_TOKEN}}" > /tmp/test_tok.md
   ./target/release/reconcile-backlog create-issue /tmp/test_tok.md bug "Test Title" --provider offline
   # (Expected: exit code 1, ERROR: FATAL: Unreplaced {{REQUIRED_*}} escape token detected)

   # Test unbalanced fences
   printf "Text\n\`\`\`rust\ncode\n" > /tmp/test_fence.md
   ./target/release/reconcile-backlog create-issue /tmp/test_fence.md bug "Test Title" --provider offline
   # (Expected: exit code 1, ERROR: FATAL: Unbalanced code fences)
   ```

4. **Creation and Idempotency Verification**:
   ```bash
   # Test valid offline creation
   printf "## Content\n\`\`\`rust\nlet a = 1;\n\`\`\`\n" > /tmp/test_valid.md
   ./target/release/reconcile-backlog create-issue /tmp/test_valid.md bug "Brand New Issue" --provider offline
   # (Expected: exit code 0, [CREATED] Issue #1 created: ...)

   # Test live GitHub idempotency on issue #122
   ./target/release/reconcile-backlog create-issue /tmp/test_valid.md bug "[AUDIT] Architecture: Eliminate brittle shell scripts (>50 lines) and consolidate into native Rust toolchain" --provider github
   # (Expected: exit code 0, [IDEMPOTENT] Issue #122 already open: https://github.com/gintatkinson/dumpiler-01/issues/122)
   ```

5. **Baseline Quality Conformance**:
   ```bash
   ./target/release/verify-baseline . --no-domain
   ```
   *Expected outcome*: All 31 checks pass with exit code 0.
