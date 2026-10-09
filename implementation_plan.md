# Implementation Plan: Pipeline Enhancement & SysML Model Correctness Audit

## 1. Context & Objectives
1. **SysML Model Correctness Audit**: The user has requested spinning up a specialized model auditor agent to rigorously inspect the correctness, completeness, and metamodel validity of `schema/model.sysml` (12,652 lines, synthesized from 199 requirement specifications).
2. **Native Rust Toolchain Integration (`crates/assemble-conops`)**: Port `scripts/assemble_conops.py` to a native compiled Rust crate to provide a 100% native Rust execution path for Worker 0A.

---

## 2. Work Packages (Micro-Tasks)

All file writing and coding operations will be executed by context-isolated subagents in accordance with `AGENTS.md` and `rules/subagent-dispatch-standards.md`.

### Work Package 1: Create `crates/assemble-conops` [IN PROGRESS]
- **Target Files**:
  - `crates/assemble-conops/Cargo.toml`
  - `crates/assemble-conops/src/lib.rs`
  - `crates/assemble-conops/src/params.rs`
  - `crates/assemble-conops/src/toc.rs`
  - `crates/assemble-conops/src/sanitize.rs`
  - `crates/assemble-conops/src/assembler.rs`
  - `crates/assemble-conops/src/main.rs`
- **Deliverables**: CLI parser, unit tests, parameter binding, TOC slugification, Level 1B sanitization, and unit assembly.

### Work Package 2: Cargo Workspace & Python Launcher Delegation [IN PROGRESS]
- **Target Files**:
  - `Cargo.toml`: Add `"crates/assemble-conops"` to workspace members.
  - `scripts/assemble_conops.py`: Add `_run_rust_assemble_conops()` to delegate to `target/release/assemble-conops`.

### Work Package 3: Pipeline Prompts, Skills & Guidelines Update
- **Target Files**: `docs/OPERATOR_PROMPT_CATALOG.md`, `README.md`, `CLAUDE.md`, `skills/spec-orchestrator/SKILL.md`.

### Work Package 4: Quality Gate Verification & Remote Synchronization
- **Deliverables**: Build binary, run `cargo test --workspace`, run `./target/release/verify-baseline . --no-domain`, audit zero em dashes, commit and push to `origin/main`.

### Work Package 5: Dispatch SysML Model Auditor Subagent
- **Role**: `SysML Model Auditor` (TypeName: `self` or `research`)
- **Target**: [`schema/model.sysml`](schema/model.sysml) (1.1 MB, 12,652 lines) and 199 source specifications in `schema/REQ-*.md`.
- **Audit Scope & Pillars**:
  1. **OMG SysML v2 / KerML Metamodel & Syntax Compliance**: Verify grammar tokens, block delimiters (`package`, `part def`, `port def`, `attribute def`, `constraint def`, `assert constraint`), semicolon terminations, and namespace qualifiers.
  2. **Topological & Metamodel Consistency**: Verify subsystem decomposition hierarchy, part def containment, port interface binding, and bidirectional flow rules.
  3. **Factual Grounding & Requirement Traceability**: Cross-check coverage across all 199 requirement files (`schema/REQ-0001.md` through `schema/REQ-0199.md`). Ensure every constraint, threshold, and parameter in `schema/model.sysml` matches its source requirement.
  4. **Mathematical & SI Unit Metrology**: Verify dimensional consistency, numerical ranges, and KaTeX mathematical alignment.
  5. **Compiler Diagnostics & Parity Gates**: Execute `./target/release/compile-sysml --compile --schema schema/model.sysml` and `./target/release/verify-baseline . --no-domain` to empirically verify zero AST parser errors or parity gate violations.
- **Deliverable**: Formal Model Audit Dossier with structural metrics, risk assessment, and verification findings.

---

## 3. Strict Governance Invariants
- **Zero Em Dashes**: Strict prohibition of `\u2014`.
- **Coordinator Direct Writing Lock**: Source writes delegated exclusively to context-isolated subagents.
- **Commit Message Non-Closure Invariant**: Use neutral citations.
- **Remote Synchronization**: Task is not complete until pushed to `origin/main`.
