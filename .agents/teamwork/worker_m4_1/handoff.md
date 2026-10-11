# Handoff Report -- Milestone M4: Native Rust Toolchain Consolidation in crates/verify-baseline

## 1. Observation

1. **Brittle Shell Verification Targets**:
   - `scripts/verify_commit_messages.sh` (133 lines) relied on POSIX `grep -E -i` with regex pattern `(^|[[:space:]]|[^[:alnum:]_])(fix|fixes|fixed|close|closes|closed|resolve|resolves|resolved)(:[[:space:]]*|[[:space:]]+)#[0-9]+` and non-POSIX `local` variables.
   - `scripts/verify_subagent_output.sh` (92 lines) performed word-splitting on target paths, invoked `grep -q '{{REQUIRED_'` and line-based `grep -c '\`\`\`'` fence counting.
   - `scripts/file_defect.sh` (148 lines) performed shell regex and grep matching for 7 sections, `## Audit Source`, `SEVERITY:`, `FILE_LOCATION:`, and code fence counts.

2. **Crate Baseline Architecture in `crates/verify-baseline`**:
   - `crates/verify-baseline/src/main.rs`: Originally only parsed `BaselineOptions` with `destination: String` (default `"."`) and baseline flags (`--no-domain`, `--strict`, `--spec-only`, etc.).
   - Root execution `./target/release/verify-baseline . --no-domain` passed all 31 baseline verification checks with exit code 0.

3. **Crate Implementation**:
   - Implemented `crates/verify-baseline/src/commit_msg.rs`: Deterministic lexical scanner in pure Rust with strictly zero regex (`scan_commit_message`, `CommitMsgArgs`, `run_check_commit_msg`). Supports `--msg-file <file>`, `--range <rev-range>`, `--head`, `--check-text <text>`, and positional arguments.
   - Implemented `crates/verify-baseline/src/output_integrity.rs`: Subagent output validation (`run_check_output`, `OutputIntegrityArgs`). Supports `--dir <DIR>`, `--files <FILES...>`, and positional arguments. Validates non-zero size, unreplaced `{{REQUIRED_*}}` escape tokens, and balanced code fence count. Exits with 42 on failure (matching shell script).
   - Implemented `crates/verify-baseline/src/defect_dossier.rs`: Schema validator for 7-section defect dossiers (`validate_defect_dossier`, `DefectDossierArgs`, `run_check_defect`). Verifies sections 1-7, `## Audit Source`, `SEVERITY:` (Critical|Important|Suggestion|Nitpick), `FILE_LOCATION:`, and balanced code fences. Supports `--body-file <FILE>` and positional arguments.
   - Exported modules in `crates/verify-baseline/src/lib.rs`.
   - Updated `crates/verify-baseline/src/main.rs` with `#[command(subcommand_precedence_over_arg = true)]` and `Subcommands` enum (`check-commit-msg` with alias `check-commit`, `check-output` with alias `verify-subagent-output`, `check-defect` with alias `verify-defect-dossier`). Preserved default baseline runner when no subcommand is specified.

4. **Empirical Command Outputs**:
   - `cargo check -p verify-baseline`: Exit code 0.
   - `cargo build --release -p verify-baseline`: Exit code 0.
   - `check-commit-msg --check-text "feat: (#115)"`: Exit code 0.
   - `check-commit-msg --check-text "fixes #115: broken test"`: Exit code 1 with compliant violation diagnostic:
     ```
     ERROR: Commit message violates the Commit Message Non-Closure Invariant (.pipeline/constitution.md:266).
     Context: raw text
     Forbidden auto-closing trigger detected.
       - Forbidden verb 'fixes' targeting #115 detected on line 1
     ```
   - `check-commit-msg --head`: Exit code 0 on current repository HEAD commit.
   - `check-output --files <valid>`: Exit code 0.
   - `check-output --files <empty> <token> <unbalanced>`: Exit code 42 with individual error diagnostics per file.
   - `check-defect docs/reports/defects/SHELL_SCRIPTS_SPRAWL_AUDIT.md`: Exit code 0, parsed Severity: Critical, File Location: skills/spec-orchestrator/scripts/create_issue.sh:1-259, Label: bug.
   - `./target/release/verify-baseline . --no-domain`: Exit code 0 across all 31 baseline checks.
   - `./target/debug/verify-baseline . --no-domain`: Exit code 0 across all 31 baseline checks.

## 2. Logic Chain

1. From Observation 1 and the critical Anti-Regex Invariant requirement, commit message linting was implemented in pure Rust without `regex` dependencies or regular expressions. Character-by-character scanning with boundary checks ensures that auto-closing keywords (`fix`, `fixes`, `fixed`, `close`, `closes`, `closed`, `resolve`, `resolves`, `resolved`) are only triggered when followed by `:` or whitespace and `#<digits>`, while preserving neutral citations like `(#<id>)` and `(refs #<id>)`.
2. From Observation 1 and Observation 3, the output integrity and defect dossier checks were ported directly into native Rust modules, removing reliance on external utilities (`awk`, `sed`, `grep`) and word-splitting vulnerabilities.
3. From Observation 2 and Observation 3, adding `#[command(subcommand_precedence_over_arg = true)]` to `main.rs` allows Clap to match subcommands first if present, while gracefully defaulting to the root baseline runner (`run(&options)`) when no subcommand is provided.
4. From Observation 4, all subcommands and the root CLI were tested empirically and verified to behave identically to their specifications and maintain full backwards compatibility with baseline checks.

## 3. Caveats

No caveats. All target subcommands have been implemented in pure Rust with zero regex, verified with positive and negative test cases, and confirmed to preserve all 31 baseline checks.

## 4. Conclusion

Milestone M4 is complete and fully verified. `crates/verify-baseline` exposes:
- `check-commit-msg` (alias `check-commit`)
- `check-output` (alias `verify-subagent-output`)
- `check-defect` (alias `verify-defect-dossier`)
while preserving root CLI baseline verification (`./target/release/verify-baseline . --no-domain`).

## 5. Verification Method

To independently verify this implementation, run:

```bash
# 1. Compilation verification
cargo check -p verify-baseline
cargo build --release -p verify-baseline

# 2. Commit message linter verification (zero regex)
./target/release/verify-baseline check-commit-msg --check-text "feat(core): update spec (refs #115)"
# Expected: exit 0

./target/release/verify-baseline check-commit-msg --check-text "fixes #115: broken test"
# Expected: exit 1

./target/release/verify-baseline check-commit-msg --head
# Expected: exit 0

# 3. Output integrity verification
./target/release/verify-baseline check-output --dir docs/
# Expected: exit 0

# 4. Defect dossier schema verification
./target/release/verify-baseline check-defect docs/reports/defects/SHELL_SCRIPTS_SPRAWL_AUDIT.md
# Expected: exit 0

# 5. Root CLI baseline verification
./target/release/verify-baseline . --no-domain
# Expected: all 31 checks pass, exit 0
```
