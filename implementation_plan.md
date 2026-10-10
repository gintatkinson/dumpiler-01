# Implementation Plan -- Native Rust Forward-Sync Engine Remediation, STPA Transpilation & Specification Projection

## 1. Executive Summary & Baseline Ground Truth
- **Repository:** `gintatkinson/dumpiler-01` (`DOWNSTREAM_CUSTOMER_PROJECT`)
- **Current Git Branch:** `main` (commit `671dcb2` -- up to date with `origin/main`)
- **Baseline Health:** 31/31 baseline checks passing (`./target/release/verify-baseline . --no-domain`)
- **Workspace Test Suite:** 100% passing (`cargo test --workspace`, 131 unit, integration, and doc-tests)
- **Completed Foundation:**
  - 2D Multi-Facet Model Decomposition complete across Level 0 ConOps, Level 1 SoI, and Level 2 Subsystems 01--12.
  - Native multi-file recursive compiler and scanner operational (`crates/compile-sysml`).
  - All legacy Python scripts deleted (`compile_sysml.py`, `assemble_conops.py`, `verify_downstream_baseline.py`, `sysmlv2_ingest.py`, and test files).
  - Tooling callers standardized directly on `./target/release/` binaries.
- **Problem Statement:**
  1. Downstream specification landing zones (`docs/epics/`, `docs/features/`, `docs/use-cases/`, `docs/user-stories/`) have not yet been projected from the 2D model AST.
  2. The 10-pillar STPA safety suite (`docs/safety/`) has not been synthesized.
  3. `crates/compile-sysml/src/sync/forward.rs` currently inspects only the root `PackageDef` (ignoring `pkg.sub_packages`) and contains hardcoded fallback domain concepts (`"CoreController"`, `"TelemetrySync"`, `"ExecuteAutonomousMission"`), violating the **Pure Schema-Driven Compiler Invariant**.
- **Architectural Solution:**
  1. Audit `crates/compile-sysml/src/sync/forward.rs` and file an issue via `scripts/file_defect.py`.
  2. Remediate `crates/compile-sysml/src/sync/forward.rs` in native Rust to recursively aggregate across all `sub_packages` and eliminate all hardcoded domain fallbacks (TDD RED-GREEN).
  3. Execute STPA safety suite transpilation to generate `docs/safety/`.
  4. Execute forward specification projection to generate `docs/epics/`, `docs/features/`, `docs/use-cases/`, `docs/user-stories/`.
  5. Verify baseline conformance, reconcile backlog, and push to `origin/main`.

---

## 2. Phased Implementation Roadmap & Micro-Tasks

```mermaid
flowchart TD
    P0["Phase 0: Adversarial Audit & Defect Submission<br/>(Audit crates/compile-sysml/src/sync/forward.rs for hardcoded domain fallbacks and shallow subpackage omission)"]
    P1["Phase 1: Native Rust Forward-Sync Engine Remediation<br/>(Recursive subpackage AST aggregation, eliminate hardcoded fallbacks, TDD RED-GREEN)"]
    P2["Phase 2: STPA Safety Suite Transpilation<br/>(Transpile schema AST into 10-pillar safety artifact suite under docs/safety/)"]
    P3["Phase 3: Forward Specification Projection<br/>(Project Epics, Features, Use Cases, User Stories into docs/ from 2D model AST)"]
    P4["Phase 4: Full Quality Gate, Backlog Reconciliation & Remote Sync<br/>(target/release/verify-baseline, cargo test --workspace, reconcile_backlog.py, push to origin)"]

    P0 --> P1
    P1 --> P2
    P2 --> P3
    P3 --> P4
```

---

### Phase 0: Adversarial Defect Audit & Issue Creation

#### Task 0.1: Adversarial Audit of `crates/compile-sysml/src/sync/forward.rs`
- **Pillar:** Semantic Traceability / Correctness
- **Severity:** Important
- **Target File:** `crates/compile-sysml/src/sync/forward.rs:58-68, 78, 218-233, 323-340`
- **Defect Description:**
  1. `forward_sync_sysml_to_specs` only inspects top-level collections in root `PackageDef` without traversing `pkg.sub_packages`, causing all 12 subsystem packages to be omitted during forward projection.
  2. When collections are empty in the root `PackageDef`, `forward.rs` injects hardcoded fallback domain concepts (`"TelemetrySync"`, `"CommandExecution"`, `"ExecuteAutonomousMission"`, `"CoreController"`, `"SensorSuite"`, `"OperatorConsole"`), violating the Pure Schema-Driven Compiler Invariant (Zero Hardcoded Domain Concepts) and creating topological drift under Gate 21.
- **Action:** Dispatch subagent with `skills/adversarial-code-auditor/SKILL.md` to produce a 7-section defect dossier and submit via `python3 scripts/file_defect.py` to GitHub.

---

### Phase 1: Native Rust Forward-Sync Engine Remediation (TDD)

#### Micro-Task 1.1: Recursive Subpackage Aggregation & Hardcoded Concept Elimination
- **Target Files:**
  - `crates/compile-sysml/src/sync/forward.rs`
  - `crates/deap-core/src/sysml_ast.rs`
- **Expected Changes:**
  1. Add recursive collector methods to `PackageDef`:
     - `get_all_capabilities(&self) -> Vec<CapabilityDef>`
     - `get_all_parts(&self) -> Vec<PartDef>`
     - `get_all_use_cases(&self) -> Vec<UseCaseDef>`
     - `get_all_interactions(&self) -> Vec<InteractionDef>`
     - `get_all_actions(&self) -> Vec<ActionDef>`
  2. In `crates/compile-sysml/src/sync/forward.rs`:
     - Replace direct root collection accesses with recursive collection methods across the entire package hierarchy.
     - Eliminate all hardcoded fallback domain strings (`"CoreController"`, `"TelemetrySync"`, `"ExecuteAutonomousMission"`, etc.).
     - Derive Epics directly from subsystem package names and capabilities.
     - Derive Features directly from execution engine part definitions and their action ports.
     - Derive Use Cases directly from AST `UseCaseDef` nodes present in `behavior.sysml`.
     - Derive User Stories directly from AST interaction nodes or action flows.
     - When a collection has zero declarations in the user schema, emit zero spurious specifications (preserving clean landing zones without phantom elements).
- **Driving Test (RED):** Add unit tests in `crates/compile-sysml/src/sync/forward.rs` asserting:
  1. Nested package trees with subpackages project all subsystem epics and subsystem part features.
  2. Zero hardcoded domain strings are present in generated specifications.
  3. Clean empty handling when no use cases are declared.
- **3-Layer DoD:**
  - Layer 1 (Data Model): Recursive traversal over `PackageDef.sub_packages`.
  - Layer 2 (Logic): Pure schema-derived naming and structure with zero hardcoded domain strings.
  - Layer 3 (Interface Binding): Clean forward-sync projection to target markdown directories.

---

### Phase 2: STPA Safety Suite Transpilation

#### Micro-Task 2.1: Transpile Schema AST into 10-Pillar Safety Suite
- **Target Files:**
  - `docs/safety/01_LOSSES_HAZARDS_TOPOLOGY.md`
  - `docs/safety/02_UCA_COMBINATORIAL_MATRIX.md`
  - `docs/safety/03_LOSS_SCENARIOS.md`
  - `docs/safety/04_SAFETY_CONSTRAINTS.md`
  - `docs/safety/05_FMECA_MATRIX.md`
  - `docs/safety/06_REGULATORY_OBJECTIVES_ASSESSMENT.md`
  - `docs/safety/06_SORA_SAIL_ASSESSMENT.md`
  - `docs/safety/07_RTA_ARCHITECTURE.md`
  - `docs/safety/HAZARD_LOG.md`
  - `docs/safety/SLDV_FORMAL_PROOFS.m`
  - `docs/safety/STPA_MATRIX.md`
- **Execution Command:** `./target/release/compile-sysml --stpa-transpile --out-dir docs/safety`
- **Verification Criteria:**
  - All 11 safety artifact files generated under `docs/safety/`.
  - Zero unquoted `<` or `>` characters in Mermaid diagrams.
  - Check 17 and Check 13/13B pass cleanly.
- **3-Layer DoD:**
  - Layer 1: Hazards and safety constraints mapped from AST.
  - Layer 2: UCA matrices and loss scenarios computed deterministically.
  - Layer 3: Markdown and SLDV formal proof files persisted on disk.

---

### Phase 3: Forward Specification Projection

#### Micro-Task 3.1: Project Specifications from 2D Model
- **Target Directories:**
  - `docs/epics/` (12 Epics corresponding to Subsystems 01--12)
  - `docs/features/` (Features corresponding to subsystem execution engine parts)
  - `docs/use-cases/` (Use cases derived from subsystem behavior models)
  - `docs/user-stories/` (User stories derived from interactions and action flows)
- **Execution Command:** `./target/release/compile-sysml --forward-sync --docs docs/`
- **Verification Criteria:**
  - Specifications projected deterministically from AST without hardcoded domain concepts.
  - Conforms to frontmatter schema (`title`, `version`, `date`, `type`, `subsystem`, `generation_mode: subagent`).
  - Conforms to Mermaid syntax and diagram integrity rules (no leaking fences, no unquoted angle brackets).
- **3-Layer DoD:**
  - Layer 1: Subsystem packages mapped to Epics with capability rosters.
  - Layer 2: Part definitions and actions mapped to Features with class diagrams.
  - Layer 3: Use cases and user stories mapped with sequence diagrams and acceptance scenarios.

---

### Phase 0: Adversarial Defect Audit & Issue Creation [COMPLETED -- Commit bbd3680, Issue #9]
- Audited `crates/compile-sysml/src/sync/forward.rs` and filed defect dossier for Issue #9.
- Updated issue tracker with reproduction steps and architectural impact.

---

### Phase 1: Native Rust Forward-Sync Engine Remediation [COMPLETED -- Commit 2e952bd, refs #9]
- Implemented recursive AST collectors on `PackageDef` in `crates/deap-core/src/sysml_ast.rs`.
- Remediated `crates/compile-sysml/src/sync/forward.rs` to traverse all 12 subsystem packages and eliminated all hardcoded fallback domain concepts.
- Added comprehensive unit tests in `forward.rs` verifying recursive traversal.

---

### Phase 2: STPA Safety Suite Transpilation [COMPLETED -- Commit b512138, refs #9]
- Transpiled 10-pillar safety suite into `docs/safety/` (11 artifacts including `01_LOSSES_HAZARDS_TOPOLOGY.md`, `05_FMECA_MATRIX.md`, `HAZARD_LOG.md`, `STPA_MATRIX.md`).
- Added formal SLDV proofs and SORA/SAIL risk assessments.

---

### Phase 3: Forward Specification Projection [COMPLETED -- Commit b512138, refs #9]
- Forward-projected 80 specifications into `docs/epics/` (14 Epics) and `docs/features/` (65 Features) derived directly from SysML AST.
- Clean landing zones maintained with zero spurious specifications.

---

### Phase 4: Full Quality Gate, SSOT Parity Remediation & Remote Sync

#### Micro-Task 4.1: Closed-Loop STPA Control Structure Topology (Gate 30 Compliance)
- **Target File:** `crates/compile-sysml/src/stpa/safety_suite.rs`
- **Root Cause:**
  `render_losses_hazards_topology` emits a 2-node graph (`DEAPCompilerSystem --> ControlledProcess`), which lacks downward control actions, actuator abstractions, and upward sensor feedback paths required by Gate 30 (`architecture_viewpoint_validator.py:1370-1375`).
- **Implementation Details:**
  1. In `crates/compile-sysml/src/stpa/safety_suite.rs:514-535`, expand the Mermaid diagram generated for `01_LOSSES_HAZARDS_TOPOLOGY.md` into a formal 4-tier closed-loop control structure:
     - **Controller:** `DEAPCompilerSystem["DEAPCompilerSystem (Compiler Supervisory Controller)"]`
     - **Actuators / Engines:** `IngestionActuators["Universal Ingestion & Lowering Engines (Actuators)"]`
     - **Controlled Process:** `ControlledProcess["Target Compilation & Synthesis Process"]`
     - **Sensors / Diagnostics:** `DiagnosticSensors["Diagnostic Catalog & Verification Probes (Sensors)"]`
     - **Downward Control Actions:** `dispatch_parse`, `emit_code`, `execute_lowering`
     - **Upward Feedback Paths:** `diagnostic_errors`, `telemetry_events`, `coverage_metrics`
  2. Verify all node labels and subgraph titles are properly double-quoted.
  3. Recompile release binary: `cargo build --release -p compile-sysml`.
  4. Regenerate safety suite: `./target/release/compile-sysml --stpa-transpile --out-dir docs/safety`.
- **Verification:** Inspect `docs/safety/01_LOSSES_HAZARDS_TOPOLOGY.md` to ensure valid Mermaid syntax, >= 4 edges, controller/actuator/process/sensor terms, and closed-loop topology.

#### Micro-Task 4.2: Reverse-Sync AST SSOT Parity & Identifier Remediation (Check 31 Compliance)
- **Target Files:**
  - `crates/compile-sysml/src/sync/reverse.rs`
  - `.pipeline/schema.sysml`
  - `.pipeline/schema-digest.json`
- **Root Cause:**
  1. In `reverse.rs:144-150`, frontmatter `part` values such as `_1_Normative_Statement` were transformed via `to_pascal_case`, which stripped leading underscores and emitted `1NormativeStatement` (an invalid KerML identifier starting with a digit).
  2. In `reverse.rs:111`, `extracted_parts` only loaded root `pkg.part_defs`, ignoring nested subsystem parts in `pkg.subpackages` (`pkg.get_all_parts()`), causing reverse-sync to synthesize duplicate phantom `part def` entries in `.pipeline/schema.sysml`.
  3. This triggered Check 31 failure in `./target/release/verify-baseline . --no-domain`:
     `part def defined in .pipeline/schema.sysml but missing in schema/*.sysml: ["3ComputationalComplexityAlgorithmicBounds", "2FormalInvariant", "1NormativeStatement", "4VerificationConformanceCriteria"]`.
- **Implementation Details:**
  1. In `crates/compile-sysml/src/sync/reverse.rs`:
     - Update `to_pascal_case` to enforce the KerML identifier invariant: prefix with `_` if the initial character is an ASCII digit.
     - Preserve frontmatter `part` and `part_def` verbatim when they already constitute valid KerML identifiers (e.g. `_1_Normative_Statement`).
     - Populate `extracted_parts` using `pkg.get_all_parts()` to ensure all subsystem parts are indexed.
     - When synchronizing parts, do not append to root `pkg.part_defs` if the part is already present in a subsystem subpackage.
  2. Recompile release binary: `cargo build --release -p compile-sysml`.
  3. Re-run `./target/release/compile-sysml --reverse-sync --docs docs` to regenerate clean `.pipeline/schema.sysml` and `.pipeline/schema-digest.json`.
- **Verification:** Run `./target/release/verify-baseline . --no-domain` and verify Check 31 passes with exit code 0.

#### Micro-Task 4.3: Full Quality Gate & Backlog Reconciliation
- **Verification Commands:**
  1. `cargo test --workspace` (Assert 100% pass across all 132+ tests).
  2. `./target/release/verify-baseline . --no-domain` (Assert all 31 baseline checks pass with exit code 0).
  3. Execute `python3 scripts/reconcile_backlog.py --linter-timeout 1200` to synchronize local specifications, checklists, and tracker state.
  4. Verify zero Unicode em dashes (`\u2014`) across all files.

#### Micro-Task 4.4: Remote Synchronization & Walkthrough
- **Action:**
  1. Commit all changes with neutral citation: `(refs #9)`.
  2. Push all commits to `origin/main`.
  3. Verify `git diff origin/main` is empty.
  4. Present comprehensive final completion report.

---

## Phase 5: Adversarial Audit of Porting Contamination, Clean-Slate Reset & Autonomous Zero-Contamination Native Rust Port

### 5.1 Stage 1: Adversarial Audits of Python-to-Rust Contamination Anti-Patterns
Dispatch dedicated subagents with `skills/adversarial-code-auditor/SKILL.md` to analyze each porting risk cluster, produce compliant 7-section defect dossiers, and file issues via `python3 scripts/file_defect.py --repo gintatkinson/dumpiler-01`:

1. **Audit 1: Regex Proliferation & Engine Backtracking Overhead**
   - **Target:** `skills/spec-orchestrator/parity_auditor/src/parity_auditor/parsers/regex.py`, `parsers/mermaid.py`, `.pipeline/logical-ui/codebase_rules.json` and legacy `crates/verify-baseline/src/checks/`.
   - **Pillar:** Resource Lifecycle / Performance Degradation under Load.
   - **Focus:** Scanning 199+ files with dynamic regex compilation and backtracking creates 1,200s timeouts; porting regexes into Rust recreates engine startup overhead and disables zero-copy tokenization.

2. **Audit 2: Panic-Happy Error Handling & Unchecked Invariants (`unwrap()` / `expect()`)**
   - **Target:** Legacy `crates/verify-baseline/src/checks/` (30+ instances of inline `Regex::new().unwrap()`) and translation of Python dynamic indexing into Rust `.unwrap()`.
   - **Pillar:** Memory Safety / Robustness.
   - **Focus:** DO-178C Level A / ISO 26262 ASIL D mandates fail-closed error handling; `.unwrap()` panics in production baseline check paths violate safety invariants.

3. **Audit 3: Stringly-Typed Dynamic Models vs Strongly-Typed SysML v2 AST**
   - **Target:** `skills/spec-orchestrator/parity_auditor/src/parity_auditor/core/models.py` and `parsers/mermaid.py`.
   - **Pillar:** Semantic Traceability / Type Safety.
   - **Focus:** Python dynamically used `dict[str, Any]` and untyped tuples; porting must bind directly to `deap_core::sysml_ast` (`PackageDef`, `PartDef`, `AttributeDef`, `StateDef`, `TransitionDef`, `ActionDef`) rather than untyped string hash maps.

4. **Audit 4: Quadratic O(N × M) Linear Scans vs O(1) Pre-Indexed Symbol Tables**
   - **Target:** `skills/spec-orchestrator/parity_auditor/src/parity_auditor/validators/uml.py` and `utils/sysml_loader.py`.
   - **Pillar:** Resource Lifecycle / Algorithmic Complexity.
   - **Focus:** Linearly iterating through all model elements for each diagram element across 199 files creates an O(N*M) bottleneck; Rust port must pre-index symbols into `HashSet<&str>` / `HashMap<&str, SymbolInfo>`.

5. **Audit 5: Redundant Disk File I/O in Hot Loops vs Single-Pass In-Memory AST Sharing**
   - **Target:** `skills/spec-orchestrator/parity_auditor/src/parity_auditor/validators/*.py`.
   - **Pillar:** Resource Lifecycle / Concurrency.
   - **Focus:** In Python, every validator independently opened and read files from disk; Rust port must read each file once into memory, stream through `pulldown-cmark` into `MarkdownDoc` once, and share references across parallel threads via `rayon`.

6. **Audit 6: Excessive Heap Allocations & Cloning vs Zero-Copy Slicing**
   - **Target:** Python dynamic string slicing and allocations translated to `.to_string()`, `.clone()`, and `format!()` in hot loops.
   - **Pillar:** Memory Safety / Heap Allocation Churn.
   - **Focus:** Unbounded heap allocations in file traversal loops waste CPU cycles and trigger allocator contention; Rust port must use borrowed slices (`&str`) and zero-copy token views.

7. **Audit 7: Subprocess Shelling Out vs In-Process Deterministic Verification**
   - **Target:** `skills/spec-orchestrator/parity_auditor/src/parity_auditor/core/workspace.py` (shelling out to `gh` / `git`).
   - **Pillar:** Concurrency / Process Isolation.
   - **Focus:** Subprocess calls in verification routines fail offline, breach sandbox constraints, and degrade performance; all verification must run purely in-process.

---

### 5.2 Stage 2: Clean-Slate Reset & Baseline Re-Verification
1. Revert or reset any uncommitted experimental code to ensure a clean, known-good foundation.
2. Re-verify baseline conformance by running `./target/release/verify-baseline . --no-domain` (assert 31/31 checks pass cleanly with exit code 0).
3. Confirm clean starting status with `git status`.

---

### 5.3 Stage 3: Autonomous Zero-Contamination Native Rust Port & Quality Harness
All code implementation must be delegated strictly to context-isolated subagents adhering to **Zero-Regex**, **Zero-Unwrap**, **Strongly-Typed AST**, and **Zero-Mocking** mandates:

1. **Subagent 1 (Markdown AST, Section Rules & Metadata Engine)**
   - `crates/verify-baseline/src/spec_audit/markdown_ast.rs`: Streaming zero-copy pull parser (`pulldown-cmark`). Extracts headings, table metadata, frontmatter, prose, Mermaid blocks, and template placeholders using byte-level token scans. ZERO REGEX.
   - `crates/verify-baseline/src/spec_audit/sections.rs`: Pure AST section validation. Compares heading level and normalized alphanumeric token streams. ZERO REGEX.
   - `crates/verify-baseline/src/spec_audit/metadata.rs`: Byte-level ISO 8601 date validator, slice-based semver validator, prefix-stripping title normalizer, and delimiter-split filename validator. ZERO REGEX.

2. **Subagent 2 (Mermaid AST Lexer & Strongly-Typed SysML UML Model Validator)**
   - `crates/verify-baseline/src/spec_audit/diagram_ast.rs`: Deterministic streaming line/token parser for `classDiagram`, `stateDiagram-v2`, and `sequenceDiagram` using `strip_prefix`, `split_once`, and token streams. ZERO REGEX.
   - `crates/verify-baseline/src/spec_audit/uml_validator.rs`: Pre-indexes `deap_core::sysml_ast` into O(1) symbol tables. Cross-references diagram classes, attributes, operations, and states against the SysML model. Validates diagram syntax invariants (matching fences, zero curly braces/colons in member strings).

3. **Subagent 3 (Behavioral Triggers & LUMI 3-Layer Quality Validator)**
   - `crates/verify-baseline/src/spec_audit/behavioral.rs`: Evaluates `rules/behavioral_triggers.json` against AST nodes using token matching. Verifies trigger coverage in User Stories / Use Cases. ZERO REGEX.
   - `crates/verify-baseline/src/spec_audit/logical_ui.rs`: Validates LUMI 3-layer semantic chain and CSS container queries (`@container`). ZERO REGEX.

4. **Subagent 4 (Provenance & ConOps Completeness Engine)**
   - `crates/verify-baseline/src/spec_audit/provenance.rs`: Validates empirical numbers, units, and assertions are grounded in `schema/` AST or standards citations, and verifies verbatim clause citations in `## Source References`. ZERO REGEX.
   - `crates/verify-baseline/src/spec_audit/conops_audit.rs`: Audits ConOps operational modes, threat envelopes, and activity allocations against `schema/conops/` and `schema/`. ZERO REGEX.

5. **Coordinator Integration (Harness & Parallel Execution)**
   - `crates/verify-baseline/src/spec_audit/mod.rs`:
     - Fail-closed `SpecAuditError` and structured `SpecAuditFinding` / `SpecAuditSummary`.
     - Multi-core data-parallel file traversal via `rayon::par_iter()`. Single-pass disk read per file.
   - Wire into `crates/verify-baseline/src/runner.rs` and `main.rs` (adding `--spec-only`, `--only <path>`, `--gate <name>`).

---

### 5.4 Stage 4: Tooling Caller Updates & Legacy Python Deletion
1. Update `scripts/reconcile_backlog.py` and `skills/spec-orchestrator/scripts/reconcile_backlog.py` to invoke native Rust `./target/release/verify-baseline . --spec-only --allow-missing-specs`.
2. Update `skills/spec-orchestrator/scripts/create_issue.sh` and `scripts/e2e_acceptance_harness.py`.
3. Delete superseded Python files:
   - `skills/spec-orchestrator/parity_auditor/`
   - `skills/spec-orchestrator/scripts/verify_model_coverage.py`
   - `skills/spec-orchestrator/scripts/kerml_compiler.py` (if present).

---

### 5.5 Stage 5: Final End-to-End Verification, Performance Benchmarking & Remote Sync
1. `cargo test --workspace` (assert 100% of 134+ tests pass cleanly).
2. `./target/release/verify-baseline . --no-domain` (assert 31/31 baseline checks pass).
3. Full spec audit benchmark: assert complete verification of all 199+ markdown files in `<2.0s`.
4. Git commit with neutral citation `(refs #9)` and push to `origin/main` (`git diff origin/main` completely empty).

---

## Strict Operating Invariants
1. **Zero Regular Expressions in `spec_audit`**: All AST matching, section validation, metadata checks, dates, and placeholders must use zero-copy `pulldown-cmark` events, byte-level checks, and token comparisons.
2. **Zero `unwrap()` / `expect()` / `panic!()`**: Robust fail-closed error handling with `Result<T, SpecAuditError>` per DO-178C Level A.
3. **Coordinator Direct Writing Lock**: Coordinator writes only `implementation_plan.md`. All code modifications and defect investigations are delegated to context-isolated subagents.
4. **Subagent Governance Preamble**: Every subagent prompt must include the mandatory un-degraded governance preamble terminated by `---GOVERNANCE-END---` and authorized with `PROCEED`.
5. **Immediate Subagent Reclaim**: Every spawned subagent must be terminated immediately upon task completion.
6. **Zero Unicode Em Dashes**: Unicode `\u2014` is strictly forbidden. Use ASCII `--` exclusively.
7. **Commit Message Non-Closure Invariant**: All git commits must use neutral citations: `(#<id>)` or `(refs #<id>)`. Auto-closing keywords are strictly prohibited.

