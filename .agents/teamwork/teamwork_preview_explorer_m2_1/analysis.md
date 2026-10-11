# Milestone 2: Taxonomy Standardization Analysis Report

## Executive Summary
This investigation analyzes the requirements for **Milestone 2: Taxonomy Standardization (Purge "Worker" & Fractional Phases)** across `skills/spec-orchestrator/SKILL.md`, `skills/feature-driven-implementation/SKILL.md`, `.pipeline/constitution.md`, and the recompilation of `.pipeline/ACTIVE_RULES_BUNDLE.md`.

The investigation established:
1. `skills/spec-orchestrator/SKILL.md` contains 49 occurrences of "worker" / "Worker" and 15 references to fractional phases (`Phase 0.5`, `Phase 0.75`, `Phase 1.5`).
2. `skills/feature-driven-implementation/SKILL.md` contains 0 occurrences of "worker", but contains 22 generic "agent" / "implementer" / "reviewer" references that require formal standardization to context-isolated Subagents with explicit Roles (`Codebase Researcher`, `Micro-Task Implementer`, `Spec Compliance Reviewer`, `Code Quality Reviewer`, `Walkthrough Validator`, `Adversarial Code Auditor`).
3. `.pipeline/constitution.md` contains exactly 2 occurrences of "worker" at lines 107 and 108.
4. `.pipeline/ACTIVE_RULES_BUNDLE.md` was historically compiled by `scripts/installer/scaffolding.py` (purged in commit `f3fbfdd`). No active Rust subcommand currently emits the bundle. We document the exact deterministic compilation schema (quad-anchor tags `<a id="...">` and table of contents) to regenerate it cleanly. Furthermore, 4 files in `rules/` (`role-boundary-lock.md`, `constitution-first.md`, `uml-model-integrity.md`, `subagent-dispatch-standards.md`) contain 6 legacy occurrences of "worker" that must be sanitized prior to recompiling the bundle.
5. All target files currently have 0 Unicode em dashes (`\u2014`), confirming 100% compliance with the Zero Em Dash Invariant.

---

## 1. `skills/spec-orchestrator/SKILL.md` Audit & Proposed Mapping

### 1.1 Structural Taxonomy Shift
The goal is to eliminate informal worker jargon and fractional numbers, replacing them with a strict 3-tier hierarchy:
- **Phase (Macro Milestone)**: Top-level engineering stage (Phases 0 through 5).
- **Step (Procedural Step)**: Ordered procedural unit within a phase (e.g., Step 0.0, Step 0.1, Step 0.2, Step 0.3, Step 1.1, Step 1.2).
- **Subagent Role**: Explicit role string passed to context-isolated subagent invocations (e.g., `OEM Ingestion & Model Synthesizer`, `Normative Research Engineer`, `ConOps & Mission Intent Engineer`, `Structural Specification Engineer`, `Interface Specification Engineer`, `Behavioral Specification Engineer`, `System Interaction Specification Engineer`).

### 1.2 Macro Milestone & Procedural Step Mapping

| Legacy Identifier | Legacy Nomenclature | New Standardized Tier & Number | New Standardized Name | New Subagent Role |
| :--- | :--- | :--- | :--- | :--- |
| Phase 0 / Step 0.0 | Level 0 OEM Ground Truth Ingestion (Worker 00) | Phase 0, Step 0.0 | Level 0 OEM Ground Truth Ingestion | `OEM Ingestion & Model Synthesizer` |
| Phase 0 / Step 0 | Step 0 SysML Compilation Gate | Phase 0, Step 0.1 | SysML Compilation & Manifest Validation Gate | N/A (Tool Gate) |
| Phase 0.5 | Normative-Completeness Research Step (Worker Research) | Phase 0, Step 0.2 | Normative-Completeness Research | `Normative Research Engineer` |
| Phase 0.75 | Hierarchical ConOps & Mission Intent Tree Engineering (Worker ConOps) | Phase 0, Step 0.3 | Hierarchical ConOps & Mission Intent Tree Engineering | `ConOps & Mission Intent Engineer` |
| Phase 1 | Structural Extraction (Worker A) | Phase 1, Step 1.1 | Structural Extraction (Epics & Features) | `Structural Specification Engineer` |
| Phase 1.5 | Interface Extraction & Logical ICD Engineering (Worker ICD) | Phase 1, Step 1.2 | Interface Extraction & Logical ICD Engineering | `Interface Specification Engineer` |
| Phase 2 | Behavioral Extraction - User Stories (Worker B) | Phase 2, Step 2.1 | Behavioral Extraction (User Stories) | `Behavioral Specification Engineer` |
| Phase 3 | System Interaction Extraction - UML Use Cases (Worker C) | Phase 3, Step 3.1 | System Interaction Extraction (UML Use Cases) | `System Interaction Specification Engineer` |
| Phase 4 | Reconciliation & Automated Verification (Worker D) | Phase 4, Step 4.1 | Automated Model Reconciliation & Verification | `Backlog Reconciler & Verification Auditor` |
| Phase 5 | Final Reporting | Phase 5, Step 5.1 | Final Backlog & Architecture Reporting | N/A (Coordinator Reporting) |

### 1.3 Detailed Inventory of "Worker" & Fractional Phase Occurrences

Below is the line-by-line catalog of all 49 worker occurrences and fractional phase references in `skills/spec-orchestrator/SKILL.md`:

| Line | Current Text (Verbatim Excerpt) | Recommended Standardized Replacement | Rationale |
| :--- | :--- | :--- | :--- |
| 19 | `coordinating the sequential execution of specialized Worker skills across all specification phases (Phases 0.5, 0.75, 1, 1.5, 2, and 3)` | `coordinating the sequential execution of specialized specification skills across all macro phases (Phase 0 through Phase 4)` | Purge "Worker" and fractional phase list |
| 26 | `If any phase, worker, compiler, or validation gate fails during orchestration (worker error, schema parsing fault...` | `If any phase, subagent, compiler, or validation gate fails during orchestration (subagent error, schema parsing fault...` | Replace "worker" with "subagent" |
| 43 | `Role Micro-Task Implementer (TypeName: code_modifier_worker)` | `Role Micro-Task Implementer (TypeName: code_modifier)` | Purge worker type name suffix |
| 73 | `apply platform/domain constraints to all worker dispatches.` | `apply platform/domain constraints to all subagent dispatches.` | Replace "worker" with "subagent" |
| 76 | `standards for Phase 0.5 Normative-Completeness Research` | `standards for Phase 0 Step 0.2 Normative-Completeness Research` | Eliminate fractional phase 0.5 |
| 82 | `dispatch Phase Worker subagents (TypeName: self) for Step 0.0... Phase 0.5, Phase 0.75, Phase 1, Phase 1.5, Phase 2, and Phase 3:` | `dispatch context-isolated Subagents with explicit Roles (TypeName: self) across each phase and procedural step:` | Purge "Phase Worker" and standardize dispatch language |
| 83 | `* Step 0.0: OEM Ingestion & Model Synthesizer (Worker 00)` | `* Phase 0 Step 0.0: Role OEM Ingestion & Model Synthesizer` | Purge "Worker 00" |
| 84 | `* Phase 0.5: Normative Research Worker` | `* Phase 0 Step 0.2: Role Normative Research Engineer` | Purge fractional phase and "Worker" role |
| 85 | `* Phase 0.75: ConOps & Mission Intent Tree Worker (Worker ConOps)` | `* Phase 0 Step 0.3: Role ConOps & Mission Intent Engineer` | Purge fractional phase and "Worker" role |
| 86 | `* Phase 1: Structural Spec Worker` | `* Phase 1 Step 1.1: Role Structural Specification Engineer` | Standardize to procedural step and explicit role |
| 87 | `* Phase 1.5: Interface Spec Worker (Worker ICD)` | `* Phase 1 Step 1.2: Role Interface Specification Engineer` | Purge fractional phase and "Worker" role |
| 88 | `* Phase 2: Behavioral Spec Worker` | `* Phase 2 Step 2.1: Role Behavioral Specification Engineer` | Standardize to procedural step and explicit role |
| 89 | `* Phase 3: System Interaction Spec Worker` | `* Phase 3 Step 3.1: Role System Interaction Specification Engineer` | Standardize to procedural step and explicit role |
| 90 | `All such operations must be delegated to the Worker subagents.` | `All such operations must be delegated to context-isolated Subagents.` | Purge "Worker subagents" |
| 92 | `When executing a phase, the worker agent must follow this lifecycle:` | `When executing a phase or procedural step, the dispatched subagent must follow this lifecycle:` | Purge "worker agent" |
| 115 | `defined by the item's own template in the worker skill` | `defined by the item's own template in the specification skill` | Purge "worker skill" |
| 116 | `The worker agent aggregates the outputs, links them...` | `The subagent aggregates the outputs, links them...` | Purge "worker agent" |
| 138 | `Each parallel worker operates on independent schema modules` | `Each parallel subagent operates on independent schema modules` | Purge "parallel worker" |
| 150 | `participant W_00 as "Step 0.0: OEM Ingestion Worker (Worker 00)"` | `participant Sub_OEM as "Phase 0 Step 0.0: OEM Ingestion Synthesizer"` | Standardize Mermaid sequence diagram lifelines |
| 153 | `participant W_R as "Phase 0.5: Normative Research Worker"` | `participant Sub_Res as "Phase 0 Step 0.2: Normative Research Engineer"` | Standardize Mermaid sequence diagram lifelines |
| 154 | `participant W_CO as "Phase 0.75: ConOps & Mission Intent Tree Worker"` | `participant Sub_ConOps as "Phase 0 Step 0.3: ConOps & Mission Intent Engineer"` | Standardize Mermaid sequence diagram lifelines |
| 155 | `participant W_A as "Phase 1: Structural Spec Worker"` | `participant Sub_Struct as "Phase 1 Step 1.1: Structural Spec Engineer"` | Standardize Mermaid sequence diagram lifelines |
| 156 | `participant W_ICD as "Phase 1.5: Interface Spec Worker"` | `participant Sub_ICD as "Phase 1 Step 1.2: Interface Spec Engineer"` | Standardize Mermaid sequence diagram lifelines |
| 157 | `participant W_B as "Phase 2: Behavioral Spec Worker"` | `participant Sub_Behav as "Phase 2 Step 2.1: Behavioral Spec Engineer"` | Standardize Mermaid sequence diagram lifelines |
| 158 | `participant W_C as "Phase 3: System Interaction Spec Worker"` | `participant Sub_Interact as "Phase 3 Step 3.1: System Interaction Spec Engineer"` | Standardize Mermaid sequence diagram lifelines |
| 159 | `participant W_D as "Phase 4: Reconciliation & Verification"` | `participant Sub_Reconcile as "Phase 4 Step 4.1: Reconciliation & Verification Auditor"` | Standardize Mermaid sequence diagram lifelines |
| 162-205 | Sequence Diagram Messages (`Coord->>W_00`, `W_R`, `W_CO`, `W_ICD`, notes with fractional phases) | Standardized notes and participant targets: `Coord->>Sub_OEM`, `Coord->>Sub_Res`, `Note: Phase 0 Step 0.2`, `Note: Phase 0 Step 0.3`, `Coord->>Sub_Struct`, `Note: Phase 1 Step 1.2`, `Coord->>Sub_ICD`, etc. | Complete taxonomy alignment in sequence diagram |
| 209 | `Step 0.0 Level 0 OEM Ground Truth Ingestion (Worker 00)... Worker 00 provides... The worker ingests... The worker then synthesizes...` | `Step 0.0 Level 0 OEM Ground Truth Ingestion (Role: OEM Ingestion & Model Synthesizer)... The subagent provides... The subagent ingests... The subagent then synthesizes...` | Purge "Worker 00" and "worker" references |
| 212 | `stated here rather than in a worker skill because the manifest is produced in this phase and no worker owns it` | `stated here rather than in a specification skill because the manifest is produced in this phase and no single subagent owns it` | Purge "worker skill" and "worker" |
| 218 | `## Phase 0.5: Normative-Completeness Research Step (Worker Research)` | `### Step 0.2: Normative-Completeness Research (Role: Normative Research Engineer)` | Eliminate Phase 0.5; nest under Phase 0; purge "Worker Research" |
| 219 | `Role: Normative Research Worker` | `Role: Normative Research Engineer` | Standardize subagent role |
| 225 | `Dispatch N context-isolated research workers` | `Dispatch N context-isolated research subagents` | Purge "research workers" |
| 226 | `Instruct workers to evaluate the 4 Universal Failure Dimensions` | `Instruct subagents to evaluate the 4 Universal Failure Dimensions` | Purge "workers" |
| 238 | `execute Phase 0.75 immediately without pausing for user approval.` | `execute Step 0.3 immediately without pausing for user approval.` | Standardize transition reference |
| 240 | `## Phase 0.75: Hierarchical ConOps & Mission Intent Tree Engineering (Worker ConOps)` | `### Step 0.3: Hierarchical ConOps & Mission Intent Tree Engineering (Role: ConOps & Mission Intent Engineer)` | Eliminate Phase 0.75; nest under Phase 0; purge "Worker ConOps" |
| 241 | `Role: ConOps & Mission Intent Tree Worker` | `Role: ConOps & Mission Intent Engineer` | Standardize subagent role |
| 242 | `The ConOps & Mission Intent Tree Worker subagent ingests...` | `The ConOps & Mission Intent Engineer subagent ingests...` | Purge "Worker" in subagent title |
| 253 | `## Phase 1: Structural Extraction (Worker A)` | `## Phase 1: Structural & Interface Extraction` (with `### Step 1.1: Structural Extraction - Epics & Features`) | Standardize macro phase and purge "Worker A" |
| 254 | `Role: Structural Spec Worker` | `Role: Structural Specification Engineer` | Standardize subagent role |
| 255 | `The Structural Spec Worker subagent parses...` | `The Structural Specification Engineer subagent parses...` | Purge "Worker" in title |
| 263 | `execute Phase 1.5 immediately without pausing for user approval.` | `execute Step 1.2 immediately without pausing for user approval.` | Standardize transition reference |
| 265 | `## Phase 1.5: Interface Extraction & Logical ICD Engineering (Worker ICD)` | `### Step 1.2: Interface Extraction & Logical ICD Engineering (Role: Interface Specification Engineer)` | Eliminate Phase 1.5; nest under Phase 1; purge "Worker ICD" |
| 266 | `Role: Interface Spec Worker` | `Role: Interface Specification Engineer` | Standardize subagent role |
| 267 | `The Interface Spec Worker subagent parses...` | `The Interface Specification Engineer subagent parses...` | Purge "Worker" in title |
| 277 | `## Phase 2 [P]: Behavioral Extraction - User Stories (Worker B)` | `## Phase 2 [P]: Behavioral Extraction - User Stories (Role: Behavioral Specification Engineer)` | Purge "Worker B" |
| 278 | `Role: Behavioral Spec Worker` | `Role: Behavioral Specification Engineer` | Standardize subagent role |
| 279 | `The Behavioral Spec Worker subagent parses...` | `The Behavioral Specification Engineer subagent parses...` | Purge "Worker" in title |
| 289 | `## Phase 3: System Interaction Extraction - UML Use Cases (Worker C)` | `## Phase 3: System Interaction Extraction - UML Use Cases (Role: System Interaction Specification Engineer)` | Purge "Worker C" |
| 290 | `Role: System Interaction Spec Worker` | `Role: System Interaction Specification Engineer` | Standardize subagent role |
| 291 | `The System Interaction Spec Worker subagent performs...` | `The System Interaction Specification Engineer subagent performs...` | Purge "Worker" in title |
| 302 | `Worker C will find the User Story issues as soon as Worker B creates them` | `the System Interaction subagent will find the User Story issues as soon as the Behavioral subagent creates them` | Purge Worker C / Worker B references |
| 304 | `dispatching both workers simultaneously lets Worker C read the tracker before Worker B has finished writing to it` | `dispatching both subagents simultaneously lets the System Interaction subagent read the tracker before the Behavioral subagent has finished writing to it` | Purge workers / Worker C / Worker B |
| 318 | `## Phase 4: Reconciliation & Automated Verification (Worker D & Coverage Check)` | `## Phase 4: Reconciliation & Automated Verification (Role: Backlog Reconciler & Verification Auditor)` | Purge "Worker D" |

---

## 2. `skills/feature-driven-implementation/SKILL.md` Agent Reference Standardization

### 2.1 Current State
`skills/feature-driven-implementation/SKILL.md` has 0 occurrences of "worker". However, it uses generic phrases like "agent", "the primary agent", "implementer", "fresh implementer", "reviewer", and "auditor" without explicit subagent role declarations.

### 2.2 Standardized Subagent Roles Taxonomy
For feature-driven implementation, every subagent dispatch must declare one of the following explicit roles:
1. `Codebase Researcher` (Step 1.5 Tech Stack Research)
2. `Micro-Task Implementer` (Step 3 Micro-Task TDD Execution)
3. `Spec Compliance Reviewer` (Step 3.3 Stage 1 Spec Review)
4. `Code Quality Reviewer` (Step 3.3 Stage 2 Code Quality Review)
5. `Walkthrough Validator` (Step 4.6 Verification & Audit)
6. `Adversarial Code Auditor` (Error Recovery Tooling Bug Audit)

### 2.3 Proposed Edits by Line Number

| Line | Current Text | Recommended Standardized Replacement | Rationale |
| :--- | :--- | :--- | :--- |
| 15 | `an agent never reaches Closed` | `a coordinator or subagent never reaches Closed` | Explicit distinction between coordinator and subagent |
| 17 | `ensuring that agents cannot drift` | `ensuring that coordinators and subagents cannot drift` | Explicit role framing |
| 24 | `the agent must check off the items in the local Epic markdown... The agent stops there` | `the coordinator must check off the items in the local Epic markdown... The coordinator stops there` | Clarify coordinator duty |
| 28 | `The primary agent MUST NOT self-verify... Dispatch a separate Validator Subagent if available.` | `The coordinator MUST NOT self-verify... Dispatch a separate context-isolated Validator Subagent (Role: Walkthrough Validator) if available.` | Bind explicit Subagent Role |
| 31 | `Each micro-task SHOULD be dispatched to a fresh subagent with isolated context.` | `Each micro-task MUST be dispatched to a fresh context-isolated Subagent with Role Micro-Task Implementer.` | Mandate isolated subagent with explicit Role |
| 33 | `the agent MUST provide concrete proof of correctness` | `the subagent or coordinator MUST provide concrete proof of correctness` | Clarify role responsibility |
| 40 | `delegate all framework/dependency research tasks (Step 1.5) to a dedicated research subagent, and all codebase/specification micro-task write operations (Step 3) to dedicated implementer subagents.` | `delegate all framework/dependency research tasks (Step 1.5) to a dedicated context-isolated Subagent with Role Codebase Researcher, and all codebase/specification micro-task write operations (Step 3) to dedicated context-isolated Subagents with Role Micro-Task Implementer.` | Explicit Role binding |
| 41 | `the agent MUST run gh issue view... agents must cite empirical output` | `the coordinator MUST run gh issue view... coordinators and subagents must cite empirical output` | Explicit role framing |
| 50 | `BEFORE the downstream agent begins work.` | `BEFORE the downstream coordinator begins work.` | Precision in role naming |
| 94 | `then dispatches a fresh implementer per task with two-stage review after each.` | `then dispatches a fresh context-isolated Subagent with Role Micro-Task Implementer per task with two-stage review after each.` | Explicit role binding |
| 106 | `**A. Dispatch Implementer (Fresh Context)**` | `**A. Dispatch Micro-Task Implementer Subagent (Fresh Context)**` | Section heading standardization |
| 108 | `delegate all write operations to a micro-task implementer subagent.` | `delegate all write operations to a context-isolated Subagent with Role Micro-Task Implementer.` | Explicit role binding |
| 110 | `The implementer receives ONLY` | `The Micro-Task Implementer subagent receives ONLY` | Precision in role naming |
| 144 | `The implementer MUST NOT receive the full session history` | `The Micro-Task Implementer subagent MUST NOT receive the full session history` | Precision in role naming |
| 151 | `Native Context-Isolated Agents: Use native tool-based subagent calls` | `Native Context-Isolated Subagents: Use native tool-based subagent calls with explicit Roles` | Clarify subagent invocation |
| 155 | `**B. Implementer Executes TDD Cycle**` | `**B. Micro-Task Implementer Executes TDD Cycle**` | Section heading standardization |
| 160 | `SELF-REVIEW: Implementer reviews own changes` | `SELF-REVIEW: Micro-Task Implementer reviews own changes` | Role precision |
| 171 | `**C. Handle Implementer Status**` | `**C. Handle Micro-Task Implementer Status**` | Section heading standardization |
| 191 | `Implementer fixes -> re-review.` | `Micro-Task Implementer fixes -> re-review.` | Role precision |
| 198 | `Implementer fixes -> re-review.` | `Micro-Task Implementer fixes -> re-review.` | Role precision |
| 203 | `Dispatch separate spec compliance and code quality reviewer subagents with the diff` | `Dispatch separate context-isolated Reviewer Subagents with Role Spec Compliance Reviewer and Role Code Quality Reviewer with the diff` | Explicit Role binding |
| 204 | `Single-Agent Fallback: The coordinator agent performs both reviews` | `Single-Agent Fallback: The coordinator performs both reviews` | Terminology cleanup |
| 220 | `Never dispatch multiple implementer subagents in parallel` | `Never dispatch multiple Micro-Task Implementer subagents in parallel` | Role precision |
| 222 | `reviewer found issues = implementer fixes = review again` | `reviewer found issues = Micro-Task Implementer fixes = review again` | Role precision |
| 242-243 | `Dispatch a separate Validator Subagent to read the draft walkthrough` | `Dispatch a separate context-isolated Subagent with Role Walkthrough Validator to read the draft walkthrough` | Explicit Role binding |
| 272 | `dispatch a fresh context-isolated subagent with skills/adversarial-code-auditor/SKILL.md` | `dispatch a fresh context-isolated subagent with Role Adversarial Code Auditor adopting skills/adversarial-code-auditor/SKILL.md` | Explicit Role binding |

---

## 3. `.pipeline/constitution.md` Legacy Worker References

In `.pipeline/constitution.md`, exactly two occurrences of "worker" exist:
- **Line 107**:
  - *Current*: `Epics exceeding 15 Features MUST be split by the schema-specification-engineering worker during Step 1 decomposition; Epics with fewer than 3 Features MUST be reviewed for consolidation.`
  - *Replacement*: `Epics exceeding 15 Features MUST be split by the schema-specification-engineering subagent during Step 1 decomposition; Epics with fewer than 3 Features MUST be reviewed for consolidation.`
- **Line 108**:
  - *Current*: `Enforced by verify-baseline and spec worker review gates.`
  - *Replacement*: `Enforced by verify-baseline and spec subagent review gates.`

---

## 4. Recompilation of `.pipeline/ACTIVE_RULES_BUNDLE.md`

### 4.1 Historical Mechanism & Current Tooling State
- In historical commits (prior to Python purge commit `f3fbfdd`), `.pipeline/ACTIVE_RULES_BUNDLE.md` was built by `scripts/installer/scaffolding.py` (`compile_active_rules_bundle`).
- Following the native Rust rewrite and Python purge, `scripts/install_pipeline.sh` was shortened to a 102-line POSIX installer that builds the Rust workspace binaries but does not currently recompile `ACTIVE_RULES_BUNDLE.md`.
- No native Rust CLI subcommand (`compile-sysml`, `verify-baseline`, `reconcile-backlog`) currently exposes a bundle compilation command.

### 4.2 Exact Canonical Bundle Structure
The bundle must be regenerated according to the canonical specification:
1. Header:
   ```markdown
   # ACTIVE RULES BUNDLE -- Consolidated Governance Manifest

   > **Notice:** This consolidated governance manifest is compiled automatically at installation time by `scripts/install_pipeline.sh`.
   > It aggregates 100% of the active governance rules from `rules/` into a single, unified source of truth.
   > Autonomous agents (Antigravity, Claude Code, Cursor) MUST execute `view_file` on this file to ingest the full suite of active governance rules in a single read before executing any implementation or orchestration tasks.

   ## Table of Contents
   ```
2. Table of Contents: Alphabetical list of all 20 rule files linking to `#rule-{slug}`:
   ```markdown
   - [behavioral-trigger-coverage.md](#rule-behavioral-trigger-coverage-md)
   ...
   ```
3. Divider:
   ```markdown
   ---
   ```
4. Rule Body Sections: For each rule file in alphabetical order:
   ```markdown
   <a id="{slug}"></a>
   <a id="rule-{slug}"></a>
   <a id="{stem_slug}"></a>
   <a id="rule-{stem_slug}"></a>
   ## Rule: {rule_base}

   {unabridged rule content}

   ---
   ```

### 4.3 Prerequisite: Sanitizing Legacy "Worker" in `rules/*.md`
Prior to compiling `.pipeline/ACTIVE_RULES_BUNDLE.md`, 4 files in `rules/` must be sanitized of legacy worker terminology so the compiled manifest is 100% compliant:
1. `rules/role-boundary-lock.md:10`:
   - *Current*: `Spec workers and specification subagents are strictly forbidden from reading...`
   - *Replacement*: `Specification subagents are strictly forbidden from reading...`
2. `rules/constitution-first.md:18`:
   - *Current*: `Specification workers/modules MUST NOT read implementation profiles...`
   - *Replacement*: `Specification subagents/modules MUST NOT read implementation profiles...`
3. `rules/uml-model-integrity.md:12, 14`:
   - *Current*: `stating them in any one worker skill would fragment them... The worker skills own the templates; this file owns the rules...`
   - *Replacement*: `stating them in any one specification skill would fragment them... The specification skills own the templates; this file owns the rules...`
4. `rules/subagent-dispatch-standards.md:25`:
   - *Current*: `Prompts launching workers, auditors, or validators MUST explicitly instruct...`
   - *Replacement*: `Prompts launching implementers, auditors, or validators MUST explicitly instruct...`
*(Note: `rules/codebase-compliance.md:67` mentions "background isolate or worker" in the context of Dart/Web threading, which is domain-accurate concurrency terminology and not an agent taxonomy violation).*

---

## 5. Zero Em Dash Invariant Audit

An empirical regex scan was performed across all target files:
- `skills/spec-orchestrator/SKILL.md`: 0 em dashes found.
- `skills/feature-driven-implementation/SKILL.md`: 0 em dashes found.
- `.pipeline/constitution.md`: 0 em dashes found.
- `.pipeline/ACTIVE_RULES_BUNDLE.md`: 0 em dashes found.
- All 20 files in `rules/*.md`: 0 em dashes found.

Every proposed change preserves the Zero Em Dash Invariant by using ASCII `--` exclusively.
