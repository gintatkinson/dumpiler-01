# Implementation Plan: Worker 00 -- OEM Prose / BOM Ingestion & Initial SysML v2 Model Synthesis (Step 0.0)

## 1. Context & Objectives
The repository currently contains 199 normative requirement documents under `schema/` (`REQ-0001.md` through `REQ-0199.md`).
In accordance with `skills/spec-orchestrator/SKILL.md` (Step 0.0 Level 0 OEM Ground Truth Ingestion) and the operator prompt catalog:
1. **Ground 0.0 Ingestion**: Use `./target/release/ingest-sysml` to ingest all 199 requirement files in `schema/` and synthesize the canonical SysML v2 textual model in `schema/model.sysml`.
2. **Step 0 SysML Compilation Gate**: Use `./target/release/compile-sysml --compile --schema schema/model.sysml` to validate semantics, build the formal AST, serialize `.pipeline/schema.sysml`, and generate `.pipeline/schema-digest.json`.
3. **Baseline Conformance & Remote Sync**: Verify baseline quality gates via `./target/release/verify-baseline . --no-domain`, commit generated models, and push to `origin/main`.

---

## 2. Work Packages (Micro-Tasks)

All file writing and model synthesis operations will be executed by context-isolated subagents in accordance with `AGENTS.md` and `rules/subagent-dispatch-standards.md`.

### Work Package 1: Ground 0.0 Schema Ingestion Subagent Dispatch [COMPLETE]
- **Role**: `Worker 00 -- OEM Ingestion & Model Synthesis Worker`
- **Target Ingestion Command**:
  ```bash
  ./target/release/ingest-sysml --schema schema/ --format markdown --out schema/model.sysml
  ```
- **Expected Outputs**:
  - `schema/model.sysml`: Synthesized SysML v2 textual model defining system `package`, subsystem packages, `part def` components, `port def` interfaces, attributes, and constraints extracted from all 199 requirement specifications.
- **Verification**:
  - [x] File existence check on `schema/model.sysml` (1,114,845 bytes).
  - [x] Non-empty model verification with valid SysML v2 package boundaries across all 199 specifications.

### Work Package 2: Step 0 SysML Compilation Gate Execution [COMPLETE]
- **Target Compilation Command**:
  ```bash
  ./target/release/compile-sysml --compile --schema schema/model.sysml
  ```
- **Expected Outputs**:
  - `.pipeline/schema.sysml`: Canonical serialized AST representation.
  - `.pipeline/schema-digest.json`: Canonical SHA-256 integrity hash and node population inventory.
- **Verification**:
  - [x] Compiler exit code 0.
  - [x] Non-empty digest JSON (1,222,467 bytes) with verified node counts (793 elements, SHA-256: 6080a00c...).

### Work Package 3: Baseline Quality Gate Verification & Remote Synchronization [COMPLETE]
- **Verification Commands**:
  - [x] `./target/release/verify-baseline . --no-domain` (All 22 active checks pass with exit code 0).
  - [x] Check zero Unicode em dashes (`\u2014`) across modified/generated files.
  - [x] Stage, commit with non-auto-closing message:
    `git commit -m "feat(schema): synthesize canonical model.sysml from schema specifications via ingest-sysml"`
  - [x] Remote sync: `git push origin main`.
  - [x] Verify `git diff origin/main` is empty.

---

## 3. Strict Governance Invariants
- **Zero Em Dashes**: Strict prohibition of `\u2014`.
- **Pure Schema-Driven**: All synthesized components and ports derive deterministically from `schema/REQ-*.md` inputs.
- **Coordinator Direct Writing Lock**: Synthesis operations delegated exclusively to context-isolated subagents.
- **Remote Synchronization**: Task is not complete until successfully pushed and verified on `origin/main`.
