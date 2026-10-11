# Implementation Plan -- Adversarial Code Audit & Native Rust Consolidation for Shell Scripts Sprawl

**Objective**: Eliminate brittle, complex shell scripts (>50 lines) that were impulsively patched into Bash during the Zero-Python purge, enforce the project's strict "Rust Only" architecture, and consolidate all verification and tracker operations into the native Rust toolchain.

---

## 1. Problem Statement & Audit Scope

The project mandates a **Pure Native Rust Toolchain** (`Cargo.toml` workspace). However, during the Zero-Python migration (commit `f3fbfdd`), several peripheral Python linters and API scripts were impulsively rewritten in Bash rather than being properly engineered into Rust crates.

A shell script exceeding 50 lines ceases to be an operational shell launcher and becomes an un-compiled, un-typed software application with high risk of platform incompatibility (macOS vs GNU), fragile text parsing (`awk`/`sed`), and zero static verification:

| Script | Lines | Current Role & Architectural Violation | Target Rust Destination |
| :--- | :--- | :--- | :--- |
| `skills/spec-orchestrator/scripts/create_issue.sh` | 258 | TSV scraping with `awk`, tracker state management, duplicate check, dead code | `crates/reconcile-backlog` (`create-issue` subcommand) |
| `scripts/file_defect.sh` | 147 | Markdown AST header linter, code fence modulo counter, severity mapper, issue filer | `crates/verify-baseline` / `crates/deap-core` |
| `scripts/verify_commit_messages.sh` | 132 | Git log range parsing, regex commit linter, diagnostic formatter | `crates/verify-baseline` (`check-commit` subcommand) |
| `scripts/setup_git_hooks.sh` | 108 | Git hook generator and installer | Consolidated lightweight installer or binary runner |
| `scripts/verify_subagent_output.sh` | 91 | File size check, fence balance check, `{{REQUIRED_*}}` token scanner | `crates/verify-baseline` (integrated into baseline gates) |
| `.pipeline/scripts/verify_secret_leak.sh` | 51 | Secret / token pattern scanner | `crates/verify-baseline` |

---

## 2. Execution Phases & Micro-Task Decomposition

### Phase 1: Adversarial Code Audit Dispatch
- **Subagent Role**: `Adversarial Code Auditor`
- **Subagent TypeName**: `adversarial_auditor`
- **Skill**: `skills/adversarial-code-auditor/SKILL.md`
- **Payload / Task**:
  1. Inspect the target shell scripts: `skills/spec-orchestrator/scripts/create_issue.sh`, `scripts/file_defect.sh`, `scripts/verify_commit_messages.sh`, and `scripts/verify_subagent_output.sh`.
  2. Audit against the 4 correctness risk pillars (Resource Lifecycle, Test Integrity, Semantic Traceability, and Platform Independence / Fragility).
  3. Perform a 5 Whys Root Cause Analysis detailing how the "Zero-Python Purge" left un-typed Bash applications handling core pipeline gates and tracker API orchestration.
  4. Generate a Mermaid sequence diagram illustrating the fragile TSV scraping and lack of static type safety vs. the native Rust `serde_json` pipeline.
  5. Format the finding strictly into the canonical 7-section defect report skeleton (`## 1. Context and References` through `## 7. Relationship to Existing Issues`, terminating with `## Audit Source`).
  6. File the defect issue on the issue tracker using `gh issue create` (or `scripts/file_defect.sh --repo perkunas/dumpiler-01`).

### Phase 2: Systematic Debug Protocol Remediation (Rust Implementation)
- **Subagent Role**: `Micro-Task Implementer`
- **Subagent TypeName**: `code_modifier_worker`
- **Skill**: `skills/debug-protocol/SKILL.md`
- **Decomposition**:
  - **Task 2.1 (Commit Message Linter in Rust)**:
    - Add `check-commit-msg` command to `crates/verify-baseline`.
    - Port the regex pattern and non-closure invariant logic into Rust.
    - Reduce `scripts/verify_commit_messages.sh` to a <= 15-line wrapper delegating to `./target/release/verify-baseline check-commit-msg "$@"`.
  - **Task 2.2 (Subagent Output Linter in Rust)**:
    - Add subagent output integrity checks (code fence balancing, non-empty file, zero unresolved `{{REQUIRED_*}}` tokens) to `crates/verify-baseline`.
    - Reduce `scripts/verify_subagent_output.sh` to a <= 15-line wrapper.
  - **Task 2.3 (Defect Dossier Validator in Rust)**:
    - Add 7-section defect schema validation to `crates/verify-baseline`.
    - Reduce `scripts/file_defect.sh` to a thin wrapper (< 50 lines) or pure binary invocation.
  - **Task 2.4 (Gated Issue Creation in Rust)**:
    - Extend `crates/reconcile-backlog` with a `create-issue` CLI subcommand.
    - Use the existing `TrackerClient` trait (`crates/reconcile-backlog/src/tracker.rs`) and `serde_json` parsing to handle duplicate search, reopening, label creation, and issue creation.
    - Reduce `skills/spec-orchestrator/scripts/create_issue.sh` to a <= 15-line wrapper delegating to `./target/release/reconcile-backlog create-issue "$@"`.
  - **Task 2.5 (Git Hooks Setup)**:
    - Update `scripts/setup_git_hooks.sh` to invoke the native Rust binaries directly.

### Phase 3: Verification & Baseline Conformance
1. **Compilation Gate**: `cargo check --workspace` and `cargo build --release --workspace`.
2. **Script Line Count Audit**:
   - Run `find . -name "*.sh" -not -path "*/target/*" -not -path "*/.git/*" | xargs wc -l`.
   - Assert 100% of `.sh` files are <= 50 lines (true operational shells).
3. **Baseline Quality Gate**:
   - Run `./target/release/verify-baseline . --no-domain` (assert all 31 checks pass).
   - Run `./target/release/verify-baseline . --spec-only`.
4. **Issue Resolution & Tracker Updates**:
   - Update filed issue with verification evidence and mark `status:fixed-resolved`.
5. **Git Synchronization**:
   - Commit with neutral citation: `feat(toolchain): consolidate shell scripts into native rust binaries (#<id>)`.
   - Verify `git diff origin/main` is clean.

---

## 3. Human Approval Gate

Per the **Strict Planning Gate** and **Subagent Dispatch Standards** in `AGENTS.md`:
- The coordinator is locked from executing code modifications or dispatching subagents until this plan is reviewed and approved.
- To authorize Phase 1 dispatch to the Adversarial Code Auditor, reply with `PROCEED`.
