# Handoff Report: Milestone 2 Taxonomy Standardization Exploration

## 1. Observation
1. **`skills/spec-orchestrator/SKILL.md` (49 worker matches, 15 fractional phase references)**:
   - Line 19: `coordinating the sequential execution of specialized Worker skills across all specification phases (Phases 0.5, 0.75, 1, 1.5, 2, and 3)`
   - Line 26: `If any phase, worker, compiler, or validation gate fails during orchestration (worker error...`
   - Line 43: `Role Micro-Task Implementer (TypeName: code_modifier_worker)`
   - Line 73: `apply platform/domain constraints to all worker dispatches.`
   - Line 76: `Phase 0.5 Normative-Completeness Research`
   - Lines 82-89: `dispatch Phase Worker subagents (TypeName: self)... Step 0.0: OEM Ingestion & Model Synthesizer (Worker 00), Phase 0.5: Normative Research Worker, Phase 0.75: ConOps & Mission Intent Tree Worker (Worker ConOps), Phase 1: Structural Spec Worker, Phase 1.5: Interface Spec Worker (Worker ICD), Phase 2: Behavioral Spec Worker, Phase 3: System Interaction Spec Worker`
   - Line 90: `All such operations must be delegated to the Worker subagents.`
   - Line 92: `When executing a phase, the worker agent must follow this lifecycle:`
   - Lines 115-116: `template in the worker skill`, `The worker agent aggregates the outputs`
   - Line 138: `Each parallel worker operates on independent schema modules`
   - Lines 150-159: Mermaid sequence diagram lifelines: `W_00`, `W_R`, `W_CO`, `W_A`, `W_ICD`, `W_B`, `W_C`, `W_D`
   - Line 209: `Step 0.0 Level 0 OEM Ground Truth Ingestion (Worker 00)`
   - Line 212: `stated here rather than in a worker skill because the manifest is produced in this phase and no worker owns it`
   - Line 218: `## Phase 0.5: Normative-Completeness Research Step (Worker Research)`
   - Lines 219, 225, 226: `Role: Normative Research Worker`, `research workers`, `workers`
   - Line 238: `execute Phase 0.75 immediately without pausing for user approval.`
   - Line 240: `## Phase 0.75: Hierarchical ConOps & Mission Intent Tree Engineering (Worker ConOps)`
   - Lines 241, 242: `Role: ConOps & Mission Intent Tree Worker`, `The ConOps & Mission Intent Tree Worker subagent ingests...`
   - Lines 253-255: `## Phase 1: Structural Extraction (Worker A)`, `Role: Structural Spec Worker`
   - Line 263: `execute Phase 1.5 immediately without pausing for user approval.`
   - Lines 265-267: `## Phase 1.5: Interface Extraction & Logical ICD Engineering (Worker ICD)`, `Role: Interface Spec Worker`
   - Lines 277-279: `## Phase 2 [P]: Behavioral Extraction - User Stories (Worker B)`, `Role: Behavioral Spec Worker`
   - Lines 289-291: `## Phase 3: System Interaction Extraction - UML Use Cases (Worker C)`, `Role: System Interaction Spec Worker`
   - Lines 302-305: `Worker C will find the User Story issues as soon as Worker B... dispatching both workers...`
   - Line 318: `## Phase 4: Reconciliation & Automated Verification (Worker D & Coverage Check)`

2. **`skills/feature-driven-implementation/SKILL.md` (0 worker matches, 22 generic agent references)**:
   - Line 15: `an agent never reaches Closed`
   - Line 17: `ensuring that agents cannot drift`
   - Line 24: `the agent must check off the items... The agent stops there`
   - Line 28: `The primary agent MUST NOT self-verify... Dispatch a separate Validator Subagent if available.`
   - Line 31: `Each micro-task SHOULD be dispatched to a fresh subagent with isolated context.`
   - Line 40: `delegate all framework/dependency research tasks (Step 1.5) to a dedicated research subagent, and all codebase/specification micro-task write operations (Step 3) to dedicated implementer subagents.`
   - Lines 106, 108, 110, 144: `Dispatch Implementer (Fresh Context)`, `micro-task implementer subagent`, `The implementer receives ONLY`
   - Lines 203-204: `Dispatch separate spec compliance and code quality reviewer subagents... Single-Agent Fallback: The coordinator agent performs both reviews`
   - Lines 242-243: `Dispatch a separate Validator Subagent to read the draft walkthrough`
   - Line 272: `dispatch a fresh context-isolated subagent with skills/adversarial-code-auditor/SKILL.md`

3. **`.pipeline/constitution.md` (2 worker matches)**:
   - Line 107: `Epics exceeding 15 Features MUST be split by the schema-specification-engineering worker during Step 1 decomposition`
   - Line 108: `Enforced by verify-baseline and spec worker review gates.`

4. **Rules Bundle Compilation State**:
   - Neither `crates/verify-baseline`, `crates/compile-sysml`, nor `crates/reconcile-backlog` contains a subcommand to recompile `.pipeline/ACTIVE_RULES_BUNDLE.md`.
   - `scripts/install_pipeline.sh` previously delegated to Python `scripts/installer/scaffolding.py` which had `compile_active_rules_bundle`. Following commit `f3fbfdd`, the installer was trimmed to 102 lines and no longer performs bundling.
   - All 20 files in `rules/*.md` are currently present in `.pipeline/ACTIVE_RULES_BUNDLE.md`.
   - 4 files in `rules/` (`role-boundary-lock.md:10`, `constitution-first.md:18`, `uml-model-integrity.md:12, 14`, `subagent-dispatch-standards.md:25`) contain 6 legacy occurrences of "worker" that must be sanitized before recompilation.

5. **Zero Em Dash Invariant Audit**:
   - `grep -n -P '\u2014' skills/spec-orchestrator/SKILL.md skills/feature-driven-implementation/SKILL.md .pipeline/constitution.md .pipeline/ACTIVE_RULES_BUNDLE.md rules/*.md` returned 0 matches.

---

## 2. Logic Chain
1. *Macro Milestones vs Procedural Steps*:
   - In `skills/spec-orchestrator/SKILL.md`, fractional numbers (`Phase 0.5`, `Phase 0.75`, `Phase 1.5`) arose historically when research, ConOps, and ICD tasks were inserted between major phases.
   - Under standard Systems Engineering taxonomy, Macro Milestones are whole integer Phases (Phase 0, Phase 1, Phase 2, Phase 3, Phase 4, Phase 5).
   - Research (`Phase 0.5`) and ConOps (`Phase 0.75`) logically belong inside Phase 0 as procedural steps: Step 0.2 (Normative Research) and Step 0.3 (ConOps & Mission Intent Engineering).
   - ICD generation (`Phase 1.5`) logically belongs inside Phase 1 as Step 1.2 (Interface Extraction & Logical ICD Engineering), complementing Step 1.1 (Structural Extraction).
   - Therefore, standardizing fractional phases into procedural steps under integer Phases eliminates arbitrary fraction decimals and establishes a clean hierarchical model.

2. *Worker vs Context-Isolated Subagent with Explicit Role*:
   - Pipeline rules (`rules/subagent-dispatch-standards.md`, `.pipeline/constitution.md`) mandate context-isolated subagents.
   - The term "Worker" is legacy jargon. In `spec-orchestrator`, terms like "Worker A", "Worker B", "Worker C", "Worker D", "Worker ICD", "Worker ConOps", and "Worker 00" obscure the actual functional capability.
   - Replacing them with explicit Subagent Roles (`OEM Ingestion & Model Synthesizer`, `Normative Research Engineer`, `ConOps & Mission Intent Engineer`, `Structural Specification Engineer`, `Interface Specification Engineer`, `Behavioral Specification Engineer`, `System Interaction Specification Engineer`, `Backlog Reconciler & Verification Auditor`) provides clear, unambiguous prompts and logs.
   - Similarly, in `feature-driven-implementation`, standardizing generic "agent" / "implementer" / "reviewer" / "validator" references into explicit Roles (`Codebase Researcher`, `Micro-Task Implementer`, `Spec Compliance Reviewer`, `Code Quality Reviewer`, `Walkthrough Validator`, `Adversarial Code Auditor`) ensures consistency across all subagent dispatches.

3. *Constitution and Rules Bundle Sanitization*:
   - In `.pipeline/constitution.md`, lines 107 and 108 reference "schema-specification-engineering worker" and "spec worker review gates". Replacing these with "schema-specification-engineering subagent" and "spec subagent review gates" removes the last vestiges of worker jargon from the core constitution.
   - In `rules/`, updating the 4 files containing "worker" ensures that when `.pipeline/ACTIVE_RULES_BUNDLE.md` is recompiled, the resulting consolidated manifest is completely free of legacy worker references.

---

## 3. Caveats
1. **Secondary Skills**:
   - Other skill files under `skills/` (such as `skills/spec-conops-engineering/SKILL.md` with 12 matches, `skills/spec-wbs-engineering/SKILL.md` with 33 matches, `skills/spec-icd-engineering/SKILL.md` with 8 matches) also reference "Worker ConOps", "Phase 0.75", etc.
   - Milestone 2 specifically scopes its targets to `skills/spec-orchestrator/SKILL.md`, `skills/feature-driven-implementation/SKILL.md`, `.pipeline/constitution.md`, and `.pipeline/ACTIVE_RULES_BUNDLE.md`.
   - Updating secondary skills is recommended as follow-up work to prevent cross-skill terminology drift.
2. **Bundle Generator Script**:
   - Since `install_pipeline.sh` no longer bundles rules and Rust crates do not have a bundle CLI, the implementer will execute a deterministic script (e.g. via Python or shell) to produce the exact quad-anchor formatted `.pipeline/ACTIVE_RULES_BUNDLE.md`.

---

## 4. Conclusion
The problem boundary, exact lines, verbatim text, and standardized replacements for Milestone 2 are fully mapped and verified.
- `skills/spec-orchestrator/SKILL.md`: Purge 49 "worker" references and 15 fractional phase references; adopt Phase 0-5 macro milestones, Step X.Y procedural steps, and 8 explicit Subagent Roles.
- `skills/feature-driven-implementation/SKILL.md`: Standardize 22 generic agent/implementer references into 6 explicit Subagent Roles.
- `.pipeline/constitution.md`: Replace lines 107-108 worker references.
- `rules/*.md`: Sanitize 4 rule files (`role-boundary-lock.md`, `constitution-first.md`, `uml-model-integrity.md`, `subagent-dispatch-standards.md`).
- `.pipeline/ACTIVE_RULES_BUNDLE.md`: Recompile using canonical quad-anchor formatting and alphabetized table of contents.
- Zero Unicode em dashes across all artifacts.

---

## 5. Verification Method
1. Verify worker purge in `skills/spec-orchestrator/SKILL.md`:
   ```bash
   grep -n -i "worker" skills/spec-orchestrator/SKILL.md || echo "0 worker matches - PASS"
   grep -n "Phase 0\." skills/spec-orchestrator/SKILL.md || echo "0 fractional Phase 0 matches - PASS"
   grep -n "Phase 1\.5" skills/spec-orchestrator/SKILL.md || echo "0 fractional Phase 1.5 matches - PASS"
   ```
2. Verify worker purge in `.pipeline/constitution.md`:
   ```bash
   grep -n -i "worker" .pipeline/constitution.md || echo "0 worker matches - PASS"
   ```
3. Verify rules and bundle:
   ```bash
   python3 -c "
   import glob, os
   bundle = open('.pipeline/ACTIVE_RULES_BUNDLE.md').read()
   for r in sorted(glob.glob('rules/*.md')):
       b = os.path.basename(r)
       assert f'## Rule: {b}' in bundle, f'Missing {b}'
   print('All 20 rules present in bundle - PASS')
   "
   ```
4. Verify Zero Em Dash Invariant across all target files:
   ```bash
   python3 -c "
   targets = ['skills/spec-orchestrator/SKILL.md', 'skills/feature-driven-implementation/SKILL.md', '.pipeline/constitution.md', '.pipeline/ACTIVE_RULES_BUNDLE.md']
   for t in targets:
       for i, line in enumerate(open(t)):
           if '\u2014' in line:
               raise AssertionError(f'Em dash in {t}:{i+1}')
   print('Zero em dashes across all targets - PASS')
   "
   ```
5. Run full baseline conformance verification:
   ```bash
   ./target/release/verify-baseline . --no-domain
   ```
