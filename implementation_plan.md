# Implementation Plan: Full Pipeline Documentation, Prompts & Instruction Upgrade for Native Rust Toolchain

## 1. Context & Objectives
Now that the core pipeline toolchain has been ported to high-performance native Rust:
1. **Ground 0.0 Ingestion:** `crates/ingest-sysml` (`./target/release/ingest-sysml`)
2. **Model Compilation & STPA Transpilation:** `crates/compile-sysml` (`./target/release/compile-sysml`)
3. **Downstream Baseline Quality Gate Verifier:** `crates/verify-baseline` (`./target/release/verify-baseline`)

The repository documentation, operator prompt catalog, agent instructions, and skills must be updated so that autonomous agents and human operators use the compiled Rust toolchain as the primary execution commands while retaining transparent Python backwards compatibility.

---

## 2. Target Documentation & Prompt Files

| File | Target Sections | Key Updates |
|---|---|---|
| [`README.md`](README.md) | Universal Initialization, Pipeline 0 & 1, Section 9 Operator Prompts | Introduce the Cargo workspace architecture; update operator prompts to use native Rust commands (`ingest-sysml`, `compile-sysml`, `verify-baseline`). |
| [`docs/OPERATOR_PROMPT_CATALOG.md`](docs/OPERATOR_PROMPT_CATALOG.md) | Pipeline 0 Prompts (Worker 00, Step 0), Pipeline 1 Forward/Reverse Sync | Update canonical agent prompts to execute `./target/release/ingest-sysml` and `./target/release/compile-sysml`. |
| [`AGENTS.md`](AGENTS.md) | Mandatory Session Initialization Gate (Step 5), Acceptance Testing | Update baseline verification to document `./target/release/verify-baseline . --no-domain`. |
| [`CLAUDE.md`](CLAUDE.md) | Universal Initialization & Verification commands | Document native Rust binary commands for baseline verification and model compilation. |
| [`skills/spec-orchestrator/SKILL.md`](skills/spec-orchestrator/SKILL.md) | Step 0.0 (OEM Ingestion), Step 0 (Compilation Gate), Sync cycles | Update orchestrator sequence diagrams and worker instructions to reference `ingest-sysml` and `compile-sysml`. |

---

## 3. Work Packages (Micro-Tasks)

All file writing operations will be executed by context-isolated subagents in accordance with `AGENTS.md` and `rules/subagent-dispatch-standards.md`.

### Work Package 1: Update Operational Prompts & Catalog [COMPLETE]
- **Target Files:** `docs/OPERATOR_PROMPT_CATALOG.md`
- **Deliverables:**
  - [x] Update Worker 00 prompt to instruct execution of `./target/release/ingest-sysml --schema schema/ --out schema/model.sysml` (with fallback to `python3 skills/spec-orchestrator/scripts/sysmlv2_ingest.py`).
  - [x] Update Step 0 SysML Compilation Gate prompt to execute `./target/release/compile-sysml --compile --schema schema/model.sysml`.
  - [x] Update Forward-Sync and Reverse-Sync prompts to execute `./target/release/compile-sysml --forward-sync` and `--reverse-sync`.
  - [x] Update baseline verification prompts to execute `./target/release/verify-baseline . --no-domain`.
- **Verification:** Grep checks and syntax inspection confirmed zero em dashes and valid markdown links.

### Work Package 2: Update Repository README & Multi-Pipeline Architecture [COMPLETE]
- **Target Files:** `README.md`
- **Deliverables:**
  - [x] Add "High-Performance Native Rust Toolchain" section describing `crates/deap-core`, `crates/compile-sysml`, `crates/verify-baseline`, and `crates/ingest-sysml`.
  - [x] Update Section 5 (Universal Initialization Sequence) with `./target/release/verify-baseline . --no-domain`.
  - [x] Update Section 9 (Multi-Pipeline Operator Prompt Catalog) matching `docs/OPERATOR_PROMPT_CATALOG.md`.
- **Verification:** Markdown lint, link validation, and zero em dash audit.

### Work Package 3: Update Agent Instructions (`AGENTS.md`, `CLAUDE.md`, and `skills/spec-orchestrator/SKILL.md`) [COMPLETE]
- **Target Files:** `AGENTS.md`, `CLAUDE.md`, `skills/spec-orchestrator/SKILL.md`
- **Deliverables:**
  - [x] Update Section 3.3 Step 5 in `AGENTS.md` to reference `./target/release/verify-baseline . --no-domain`.
  - [x] Update `CLAUDE.md` initialization commands with `./target/release/verify-baseline . --no-domain`.
  - [x] Update Step 0.0 and Step 0 in `skills/spec-orchestrator/SKILL.md` sequence diagrams and text to cite `ingest-sysml` and `compile-sysml`.
- **Verification:** Rule compliance checks via `cargo test --workspace` and baseline verification.

### Work Package 4: Verification & Final Quality Gate Audit [COMPLETE]
- **Deliverables:**
  - [x] Run `./target/release/verify-baseline . --no-domain` to ensure 100% compliance across all 22 quality gates.
  - [x] Verify zero Unicode em dashes (`\u2014`) across all documentation files.
  - [x] Test the updated prompt instructions with a live dry-run verification.

---

## 4. Strict Governance Invariants
- **Zero Em Dashes:** Strict prohibition of `\u2014`.
- **Document References Must Resolve:** All links must resolve to existing files.
- **TDD & Baseline Gate:** Exit code 0 across all checks before completion.
