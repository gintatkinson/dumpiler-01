# Complete Implementation Plan -- Pipeline Defect Remediation & Total Upstream Refactoring (#115--#120)

## 1. Pipeline Execution Defect Remediation (Work Package 0)

### 1.1 Root Cause & Enforced Invariants
The pipeline coordinator defectively altered user prompts and bypassed the preview gate by injecting synthetic preambles and attempting concurrent multi-prompt dispatches. This is permanently remediated by adding two non-negotiable invariants to the governance tier:

#### A. In `rules/user-authorization-lock.md`:
Add Section: **User Intent Integrity & Verbatim Pass-Through Mandate**
```markdown
## User Intent Integrity & Verbatim Pass-Through Mandate

**ALWAYS enforce:** Agents and coordinators are strictly prohibited from overriding, altering, rewriting, summarizing, or substituting the user's stated intentions, prompt text, or architectural parameters under any circumstances.
- When the user provides a task prompt (including `/teamwork-preview`), that prompt MUST be preserved and passed to executing agents verbatim.
- Coordinators are strictly forbidden from rewriting user prompts, injecting synthetic constraints, or altering the execution scope in background thought blocks.
- Subagents must ingest repository rules directly from disk (`.pipeline/constitution.md` and `.pipeline/ACTIVE_RULES_BUNDLE.md`) rather than requiring prompt modification by the coordinator.
```

#### B. In `rules/subagent-dispatch-standards.md`:
Replace coordinator-preamble injection with:
```markdown
### 1. Verbatim User Payload Mandate
The subagent prompt payload MUST contain the user's exact instructions verbatim. The coordinator is strictly prohibited from altering, summarizing, or wrapping the user's prompt with synthetic boilerplate.

### 2. Autonomous On-Disk Governance Initialization
Every subagent must autonomously execute `view_file` on `.pipeline/constitution.md` and `.pipeline/ACTIVE_RULES_BUNDLE.md` as its first step, without requiring prompt modification by the coordinator.

### 3. Single-Prompt Serial Dispatch Rule
Coordinators must dispatch exactly ONE subagent with ONE prompt at a time. Multi-agent concurrent dispatches are prohibited unless explicitly structured and approved by the user.

### 4. Mandatory Teamwork Preview Gate
When `/teamwork-preview` is invoked, the coordinator MUST present the full execution plan and verbatim prompt in the chat, halt, and await human approval before dispatching any subagent.
```

#### C. In `.agents/AGENTS.md` and `.pipeline/constitution.md`:
Add identical clauses to guarantee three-tier governance parity across agent operating rules, functional constitution, and active rule files.

### 1.2 Purge Tier 3 Platform Implementation Profile Leaks from Root Compiler Governance (Work Package 0.2)
- **Root Cause**:
  `Step 4: Load Platform Profile: Read the target platform execution profile (e.g., .pipeline/profiles/flutter.md...)` was copied into the root compiler repository's `AGENTS.md` and `README.md` from a downstream application delivery template.
  This caused agents to violate Tier 1 / Tier 3 platform isolation by parsing `flutter.md` on session startup, despite this repository being a 100% native Rust compiler workspace that builds no Flutter applications and does not govern Tier 3 implementation profiles.
- **Concrete Fix**:
  1. In `AGENTS.md` and `.agents/AGENTS.md`:
     - In Section 3.3 (Mandatory Session Initialization Gate), replace Step 4:
       - Old: `4. Load Platform Profile: Read the target platform execution profile (e.g., .pipeline/profiles/flutter.md, .pipeline/profiles/react.md, .pipeline/profiles/ros2_cpp.md, or .pipeline/profiles/px4_module.md) to establish platform-specific constraints.`
       - New: `4. Verify Compiler Toolchain Baseline: Verify that the compiler workspace builds cleanly by executing cargo check --workspace.` (In downstream customer workspaces executing feature-driven-implementation, load the project's designated profile).
     - Remove the downstream application directory constraint: `Flutter application code resides under app_flutter/; React application code resides under web_react/.` from the root compiler repository rules.
  2. In `rules/constitution-first.md`:
     - Reaffirm that upstream compiler / spec-core workspaces operate exclusively at Tier 1 (abstract specifications and native Rust compiler toolchain) and MUST NOT parse or enforce Tier 3 platform implementation profiles.
  3. In `.pipeline/constitution.md`:
     - Reiterate under Architecture: Three-Tier Platform Isolation that Tier 3 implementation profiles are governed in dedicated implementation profile repositories and downstream workspaces, never in the upstream compiler core.
  4. In `README.md`:
     - Synchronize the 6-step initialization instructions to remove `flutter.md` loading from the compiler repository startup gate.
  5. Recompile `.pipeline/ACTIVE_RULES_BUNDLE.md` to reflect these governance updates.

---

## 2. Upstream Architecture Refactoring Solution (Issues #115--#120)

### 2.1 Issue #115: Clean Structural Architecture (Eliminate Pseudo-Parts)
- **Files Modified**: All 12 `schema/subsystems/*/architecture.sysml`.
- **Root Cause**: Non-structural document part defs (`_1_Normative_Statement`, `_2_Formal_Invariant`, `_3_Computational_Complexity_Algorithmic_Bounds`, `_4_Verification_Conformance_Criteria`) polluted the AST, causing artificial 5-feature clustering and duplicate title stem collisions.
- **Concrete Solution**:
  - Delete all 48 pseudo-hardware part defs across all 12 files.
  - In each subsystem, declare 2 to 4 genuine functional structural components (`part def`) with typed ports and attributes.
  - Examples:
    - `UniversalSchemaIngestion`: `part def FormatClassifier`, `part def CommonMarkTableLexer`, `part def ProtobufParser`, `part def OpenApiParser`.
    - `CoreMetamodelNodeArena`: `part def ArenaAllocator`, `part def NodeTableIndex`, `part def AstInterner`.
    - `SysmlGrammarLowering`: `part def KerMLTokenStream`, `part def SysMLv2GrammarParser`, `part def ASTLoweringEngine`.
    - `CompilerAssurance`: `part def PerformanceProfiler`, `part def ConformanceTestRunner`, `part def DiagnosticAggregator`.

### 2.2 Issue #116: ConOps Level 0 Operational Activities Decomposition
- **File Modified**: `schema/conops/activities.sysml`.
- **Root Cause**: 6 monolithic Level 0 activities (`OA_01`--`OA_06`) starved downstream User Story generation.
- **Concrete Solution**:
  - Decompose each Level 0 activity into 3 Level 1 operational activities (18 Level 1 activities total) aligned directly with subsystem capabilities:
    - `OA_01` (Ingest) -> `OA_01_1_Format_Detection`, `OA_01_2_Token_Lexing`, `OA_01_3_Syntax_Normalization`.
    - `OA_02` (Parse) -> `OA_02_1_KerML_AST_Build`, `OA_02_2_Node_Allocation`, `OA_02_3_Topological_Index`.
    - `OA_03` (Validate) -> `OA_03_1_Type_Checking`, `OA_03_2_Metrology_Verification`, `OA_03_3_State_Reachability`.
    - `OA_04` (Safety Transpile) -> `OA_04_1_STPA_Matrix_Synthesis`, `OA_04_2_UCA_Derivation`, `OA_04_3_FMECA_Generation`.
    - `OA_05` (Project) -> `OA_05_1_Agile_Backlog_Projection`, `OA_05_2_Multi_Target_CodeGen`, `OA_05_3_Interface_Binding`.
    - `OA_06` (Assure) -> `OA_06_1_Diagnostic_Catalog_Scan`, `OA_06_2_Baseline_Parity_Audit`, `OA_06_3_Performance_Benchmarking`.

### 2.3 Issue #117: Behavioral Model Authoring Across All Subsystems
- **Files Modified**: All 12 `schema/subsystems/*/behavior.sysml`.
- **Root Cause**: `behavior.sysml` files were empty packages (116 bytes), trapping statecharts and actions inside requirement docstrings.
- **Concrete Solution**:
  - Author first-class SysML v2 behavioral definitions in all 12 files:
    - Formal `action def` elements for each operational flow with typed inputs/outputs.
    - Formal `state def` and `transition def` state machines (e.g. the 7-state DPDA table lexer FSM $Q = \{ q_{\text{scan}}, q_{\text{header}}, q_{\text{delimiter}}, q_{\text{row}}, q_{\text{cell}}, q_{\text{escape}}, q_{\text{halt}} \}$ in Ingestion; memory page lifecycle in Arena; reachability graph sweeps in Traceability).
    - Formal `interaction def` elements with typed participant lifelines and message exchanges for User Stories.
    - Formal `use case def` elements with preconditions, triggers, 6--10 step Main Success Scenarios, and 8--15 Alternate/Exception Flows (`5a`--`5o`).

### 2.4 Issue #118: Dynamic JSON Schemas & BDD Synthesis (Eliminate Canned Mocks)
- **File Modified**: `crates/compile-sysml/src/sync/forward.rs`.
- **Root Cause**: Static mock JSON fixtures (`{"status": "nominal"}`) and canned BDD strings (`AC-01`..`AC-04`) broke test integrity and benchmark parity.
- **Concrete Solution**:
  - Delete all hardcoded mock JSON and canned strings from `forward.rs`.
  - Implement dynamic synthesis:
    - Synthesize Draft 2020-12 JSON Schema interface payloads directly from `PortDef` types, data flows, and owned properties.
    - Synthesize BDD acceptance criteria directly from `RequirementDef` nodes associated with each part (`ac_*` attributes, LaTeX invariants, bounds, and diagnostic error codes $E0100$--$E0999$).

### 2.5 Issue #119: AST-Anchored Realization Matrices (Eliminate Index Arithmetic)
- **File Modified**: `crates/compile-sysml/src/sync/forward.rs`.
- **Root Cause**: `canonical_use_cases` array and naive index math caused cross-wired and phantom links.
- **Concrete Solution**:
  - Delete `CANONICAL_SUBSYSTEMS`, `CanonicalUS`, and `CanonicalUC` static arrays.
  - Dynamically resolve Realization Matrices by querying the AST relationship graph for `UserStory` and `Feature` nodes belonging to the same package or linked via `satisfy`/`verify`/`allocates` edges.

### 2.6 Issue #120: Complete Level 1 SoI Pipeline Connectivity
- **File Modified**: `schema/model.sysml`.
- **Root Cause**: Dangling subsystem ports and unrouted pipeline connectivity in `part def DEAPCompilerSystem`.
- **Concrete Solution**:
  - Declare external boundary ports: `port in raw_schema_in : SchemaInputPort` and `port out generated_code_out : CodeOutputPort`.
  - Wire complete internal port routing and connections across all 12 engines (including `systemVision`, `metrologyFlow`, `diagnosticCatalog`, and `compilerAssurance`).

### 2.7 Pathology #7: Eradicate Synthetic Prefixes & String Sniffing
- **Directories Renamed**:
  - `schema/subsystems/subsystem_01_system_vision` -> `system_vision`
  - `schema/subsystems/subsystem_02_universal_schema_ingestion_engine` -> `universal_schema_ingestion`
  - `schema/subsystems/subsystem_03_core_metamodel_node_arena` -> `core_metamodel_node_arena`
  - `schema/subsystems/subsystem_04_complete_sysmlv2_kerml_grammar` -> `sysml_grammar_lowering`
  - `schema/subsystems/subsystem_05_7d_physical_metrology_flow_networks` -> `physical_metrology_flows`
  - `schema/subsystems/subsystem_06_spatio_temporal_state_solvers` -> `spatio_temporal_state_solvers`
  - `schema/subsystems/subsystem_07_formal_safety_traceability_verification` -> `formal_safety_traceability`
  - `schema/subsystems/subsystem_08_level_1c_icd_interconnect_contracts` -> `interconnect_contracts`
  - `schema/subsystems/subsystem_09_downstream_specification_projections` -> `downstream_agile_projections`
  - `schema/subsystems/subsystem_10_multi_target_codegen_simulation_bindings` -> `multi_target_codegen`
  - `schema/subsystems/subsystem_11_standardized_diagnostic_error_catalog` -> `diagnostic_error_catalog`
  - `schema/subsystems/subsystem_12_compiler_performance_cli_assurance` -> `compiler_assurance`
- **Compiler Code**: Delete `let is_deap = ...` and all hardcoded actor strings (`"HumanEngineer"`, `"CIContinuousIntegrationRunner"`).

---

## 3. The Single Unified Prompt for Execution

This single prompt will be dispatched to execute this entire solution end-to-end:

```markdown
Execute the total remediation and architecture refactoring plan in gintatkinson/dumpiler-01 to resolve registered GitHub issues (#115, #116, #117, #118, #119, #120), eliminate domain-specific naming pathologies, and establish the repository as the domain-free upstream foundation for deap-compiler.

### Phase 0: Pipeline Defect Remediation
1. In `rules/user-authorization-lock.md`, add the User Intent Integrity & Verbatim Pass-Through Mandate prohibiting coordinators from altering or rewriting user prompts.
2. In `rules/subagent-dispatch-standards.md`, abolish coordinator preamble injection, enforce autonomous on-disk rule reading, and enforce the Single-Prompt Serial Dispatch Rule.
3. In `.agents/AGENTS.md` and `.pipeline/constitution.md`, synchronize these governance invariants.

### Phase 1: Abstract Compiler Lowering Engine (#118 & #119)
In `crates/compile-sysml/src/sync/forward.rs`:
- Purge all hardcoded arrays (CANONICAL_SUBSYSTEMS, CanonicalUS, CanonicalUC) and delete `let is_deap = ...`.
- Purge canned BDD strings (AC-01..AC-04) and mock JSON ({"status": "nominal"}).
- Implement dynamic lowering:
  - Epics from top-level PackageDef nodes.
  - Features from structural PartDef nodes, synthesizing Draft 2020-12 JSON Schemas from PortDef types and extracting invariants from RequirementDef nodes.
  - User Stories from InteractionDef and ActionDef nodes with sequence diagrams and stateDiagram-v2 machines.
  - Use Cases from UseCaseDef nodes with AST-anchored Realization Matrices.

### Phase 2: SysML Metamodel & Architecture Normalization (#115 & #120)
- Strip `subsystem_XX_` prefixes across directory names in `schema/subsystems/` and update package identifiers to clean PascalCase.
- In all 12 `architecture.sysml` files, delete pseudo-hardware parts (_1_Normative_Statement, etc.) and declare 2 to 4 genuine functional structural components per subsystem.
- In `schema/model.sysml`, declare boundary ports (raw_schema_in, generated_code_out) and wire internal connections across all 12 engines.

### Phase 3: Behavioral Model Authoring (#116 & #117)
- In `schema/conops/activities.sysml`, decompose Level 0 activities (OA_01--OA_06) into 18 Level 1 operational activities.
- In all 12 `behavior.sysml` files, author first-class action def, state def (DPDA table lexer FSM, Arena page lifecycles, DAG sweeps), interaction def, and use case def elements with 8-15 alternate flows (5a-5o).

### Phase 4: Closed-Loop Toolchain & Parity Verification
- Run `cargo build --release --workspace` (clean compilation).
- Run `./target/release/compile-sysml --compile` (clean AST parsing and .pipeline/schema.sysml serialization).
- Run `./target/release/compile-sysml --forward-sync --force` (project specifications to docs/).
- Run `./target/release/compile-sysml --reverse-sync` (bidirectional parity verification).
- Run `./target/release/reconcile-backlog --workspace .` (sync local specifications with live GitHub issues).
- Run `./target/release/verify-baseline . --no-domain` (all 31 baseline checks pass).
- Run `./target/release/verify-baseline . --spec-only` (100% specification quality audit passes).
- Push all commits to origin/main and verify git diff origin/main is empty.

### Invariants:
- Zero Em Dash Invariant: Unicode em dashes (\u2014) are strictly prohibited. Use ASCII -- exclusively.
- Commit Message Non-Closure Invariant: Issue references in commits MUST use neutral citations: (#115), (refs #115), etc.

PROCEED
```
