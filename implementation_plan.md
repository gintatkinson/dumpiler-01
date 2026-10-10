# Implementation Plan: Restructure SysML Model with Requirement Attributes and Encapsulated Acceptance Criteria

## 1. Problem Statement & User Findings
Inspection of `schema/model.sysml` revealed architectural discrepancies:
1. **Detached Acceptance Criteria (ACs)**: Acceptance Criteria (e.g., `part def AC_01_Canonical_Behavioral_Action_Ingestion { }`) were being emitted as disconnected, empty `part def`s dumped at the subsystem package level, detached from the `requirement def`s that originated them.
2. **Missing Requirement Attributes**: The formal `requirement def` constructs were missing explicit attributes. Metadata (UUIDv5, Complexity Class, Governing Standard, Diagnostic Codes) and Acceptance Criteria (Given, When, Then, Diagnostic BDD statements) were not modeled as formal attributes inside the requirement definitions.
3. **Metamodel Misalignment**: Acceptance criteria are verification and conformance specifications of requirements, not standalone physical/logical subsystem components (`part def`). Subsystem parts must be reserved for actual architectural blocks (e.g., primary execution engines like `UniversalIngestionEngine`).

---

## 2. Proposed Target SysML v2 Metamodel Architecture

Every requirement specification (`schema/REQ-XXXX.md`) will be modeled as a fully-attributed, self-contained `requirement def` inside its respective subsystem package:

```sysml
package Subsystem_2_Universal_Schema_Ingestion_Engine {
    doc /* Universal Schema Ingestion Engine */

    requirement def REQ_0032_Deterministic_Qualified_Name_Symbol_Sorting_for_Canonical_Model_Emission {
        id = "REQ-0032";
        text = "The textual emission and model serialization engine shall sort all model declarations--packages, classifiers, ports, attributes, connections, constraints, and behaviors--strictly by canonical fully qualified name prior to canonical model emission (schema/model.sysml, REQ-0031) and serialized";
        
        // Metadata Attributes
        attribute uuidv5 : String = "2f859e57-faf5-5088-8de9-da3a720d19be";
        attribute complexity : String = "Class P (O(L))";
        attribute governing_standard : String = "IEEE 29148-2018 / RFC 2119 / OMG SysML v2";
        attribute diagnostic_codes : String = "E0100, E0102, E0199";

        // Acceptance Criteria Attributes (Encapsulated BDD Scenarios)
        attribute ac_01_permutation_invariance_and_zero_diff_churn : String = "Given: AST with 500 declarations across packages, classifiers, ports, and attributes in arbitrary order. When: Sorting symbols by qualified name and emitting canonical SysML v2 text across 20 randomized orderings. Then: All 20 emitted output byte streams produce identical SHA-256 digests, confirming zero diff churn. Diagnostic: E0100.";
        attribute ac_02_hierarchical_scope_qualified_name_ordering : String = "Given: Nested AST elements. When: Sorting declarations prior to canonical emission. Then: Emits top-level packages alphabetically, and inside Package_A, orders members alphabetically. Diagnostic: E0100.";
        attribute ac_03_lexicographical_ascii_byte_order_and_case_precedence : String = "Given: Sibling declarations. When: Applying qualified-name symbol sorting. Then: Sorts strictly by ASCII byte value. Diagnostic: E0100.";
        attribute ac_04_duplicate_qualified_name_collision_recovery : String = "Given: AST containing two distinct classifier declarations with identical qualified name. When: Executing symbol sorting and verification. Then: Detects symbol collision, records diagnostic E0102, substitutes sentinel, and resumes sorting. Diagnostic: E0102.";

        // Verification & Realization Bindings
        verify by AC_01_Permutation_Invariance_and_Zero_Diff_Churn;
        verify by AC_02_Hierarchical_Scope_Qualified_Name_Ordering;
        verify by AC_03_Lexicographical_ASCII_Byte_Order_and_Case_Precedence;
        verify by AC_04_Duplicate_Qualified_Name_Collision_Recovery;
        satisfy by UniversalIngestionEngine;
    }

    // Subsystem components only contain actual execution engines and structural blocks
    part def UniversalIngestionEngine {
        port in schema_in : RawSchemaStreamPort;
        port out token_out : TokenStreamPort;
    }
}
```

---

## 3. Work Packages (Micro-Tasks)

All code and model modifications will be executed by context-isolated subagents in accordance with `AGENTS.md` and `rules/subagent-dispatch-standards.md`.

### Work Package 1: Extend `RequirementDef` AST, Grammar, and Serializer
- **Target Files**:
  - `crates/deap-core/src/sysml_ast.rs`
  - `crates/compile-sysml/src/semantic/serializer.rs`
  - `crates/compile-sysml/src/parser/grammar.rs`
- **Deliverables**:
  - Add `pub attributes: Vec<AttributeDef>` to `RequirementDef` in `deap-core`.
  - Update `RequirementDef::to_sysml` in `compile-sysml` to serialize `attribute` statements inside `requirement def { ... }`.
  - Update `SysmlParser::parse_requirement_decl` in `compile-sysml` to parse `attribute` declarations within requirement blocks.
  - Update `parse_requirement_defs` in `deap-core` to extract `attribute` statements from requirement text.
  - Add unit tests verifying serialization and round-trip parsing of requirements with attributes.

### Work Package 2: Ingest Requirement Attributes & Encapsulate ACs in `ingest-sysml`
- **Target Files**:
  - `crates/ingest-sysml/src/translators/markdown.rs`
- **Deliverables**:
  - Extract metadata from table: `uuidv5`, `complexity`, `governing_standard`, `diagnostic_codes` as `AttributeDef`s on `RequirementDef`.
  - Parse each AC in Section 4 (`### AC-XX: <Title>` with Given-When-Then-Diagnostic) into:
    1. An `AttributeDef` on the `RequirementDef` storing the full BDD scenario text.
    2. A `verify by <AC_ID_Title>;` entry in `RequirementDef.verified_by`.
  - Remove detached `part def AC_...` from package-level `part_defs` when synthesizing requirement models, so only actual execution engines and structural blocks remain in `part_defs`.
  - Update unit tests in `ingest-sysml` to assert that ACs and metadata are attached directly to their parent `RequirementDef`.

### Work Package 3: Re-synthesize, Compile & Verify
- **Deliverables**:
  - Re-run `./target/release/ingest-sysml --schema schema/ --format markdown --out schema/model.sysml`.
  - Re-run `./target/release/compile-sysml --compile --schema schema/model.sysml`.
  - Run `./target/release/verify-baseline . --no-domain`.
  - Run `python3 scripts/verify_downstream_baseline.py --no-domain`.
  - Run `cargo test --workspace` (assert 100% green).
  - Verify zero Unicode em dashes (`\u2014`).
  - Stage, commit with non-auto-closing message:
    `git commit -m "feat(schema): encapsulate acceptance criteria and metadata attributes directly inside requirement definitions"`
  - Push to `origin/main` and verify `git diff origin/main` is empty.

---

## 4. Feature 1 Status: Completed & Resolved
- **Commit**: `69968a6` (`feat(schema): encapsulate acceptance criteria and metadata attributes directly inside requirement definitions (refs #1, refs #425)`)
- **Remote Issues**: Downstream [#1](https://github.com/gintatkinson/dumpiler-01/issues/1) and Upstream [#425](https://github.com/gintatkinson/DEAP01-spec-core/issues/425) labeled `status:fixed-resolved` with verification evidence.
- **Verification**: `cargo test --workspace` passed 100%, model compiled cleanly, baseline verified 31/31 checks.

---

# Feature 2 Implementation Plan: Formal Invariant Constraints Lowering, Requirement Derivations, and Subsystem Assertions

## 1. Problem Statement & User Findings
An architectural analysis of the requirements model in `schema/model.sysml` and `crates/ingest-sysml` revealed that the requirements model does not use, specify, or derive constraints:
1. **Zero Constraint Definitions & Assertions**: `schema/model.sysml` contains 0 `constraint def`, 0 `assert constraint`, 0 `require <constraint>`, and 0 `assume <constraint>` statements.
2. **Ingestion Drop of Formal Invariants**: In the 199 Markdown source files under `schema/REQ-*.md`, every requirement contains `## 2. Formal Invariant` with mathematical definitions (strict total ordering relations, determinism invariants, complexity bounds, diagnostic implications). However, `ingest-sysml` completely skips Section 2 and Section 3 during translation.
3. **Missing Requirement Derivation Tracking**: Requirements frequently cross-reference parent, child, or peer requirements (e.g. `REQ-0032` referencing `REQ-0031`, `REQ-0019`, `REQ-0044`), but `RequirementDef` lacks derivation fields (`derived_from`, `derives`), and `ingest-sysml` does not parse or emit SysML v2 `derive requirement ... from ...;` / `derived from` relationships.
4. **Subsystem Package Assembly Gap**: In `translate_files()`, `PackageDef.constraint_defs` is explicitly omitted (`..Default::default()`), dropping any parsed constraints from the 12 subsystem packages. Furthermore, primary execution engines (`part def UniversalIngestionEngine`, etc.) do not assert the invariants of their constituent requirements.

---

## 2. Proposed Target SysML v2 Architecture
Every subsystem package will contain formal `constraint def`s lowered from the Markdown formal invariants, requirements will explicitly specify constraints (`require`, `assume`) and derivations (`derived from`), and subsystem engines will assert them:

```sysml
package Subsystem_2_Universal_Schema_Ingestion_Engine {
    doc /* Universal Schema Ingestion Engine */

    // 1. Formal Constraint Definitions Lowered from Section 2 (Formal Invariants)
    constraint def Invariant_REQ_0032_StrictTotalOrdering {
        doc /* \forall d1 != d2 in D_valid, (d1 <_sym d2) ^ (d2 <_sym d1) */
    }

    constraint def Invariant_REQ_0032_DeterminismAndZeroDiffChurn {
        doc /* SHA256(E(A1; s1)) == SHA256(E(A2; s2)) */
    }

    // 2. Requirement Specifying & Deriving Constraints
    requirement def REQ_0032_Deterministic_Qualified_Name_Symbol_Sorting_for_Canonical_Model_Emission {
        id = "REQ-0032";
        text = "The textual emission and model serialization engine shall sort all model declarations...";
        
        // Metadata Attributes
        attribute uuidv5 : String = "2f859e57-faf5-5088-8de9-da3a720d19be";
        attribute complexity_class : String = "Class P (O(L))";
        attribute governing_standard : String = "IEEE 29148-2018 / RFC 2119 / OMG SysML v2";
        attribute diagnostic_codes : String = "E0100, E0102, E0199";

        // Acceptance Criteria
        attribute ac_01_permutation_invariance_and_zero_diff_churn : String = "...";
        ...

        // Specifying Constraints
        require Invariant_REQ_0032_StrictTotalOrdering;
        require Invariant_REQ_0032_DeterminismAndZeroDiffChurn;

        // Deriving Requirements
        derived from REQ_0031_Canonical_SysML_v2_Textual_Model_Emission;
        derived from REQ_0019_Identifier_Sanitization_and_Keyword_Escaping;

        // Verification & Satisfaction
        verify by AC_01_Permutation_Invariance_and_Zero_Diff_Churn;
        satisfy by UniversalIngestionEngine;
    }

    // 3. Subsystem Execution Engine Asserting Constraints
    part def UniversalIngestionEngine {
        port in schema_in : RawSchemaStreamPort;
        port out token_out : TokenStreamPort;

        assert constraint Invariant_REQ_0032_StrictTotalOrdering;
        assert constraint Invariant_REQ_0032_DeterminismAndZeroDiffChurn;
    }
}
```

---

## 3. Work Packages & Subagent Decomposition

### Phase 1: Adversarial Audit & Defect/Feature Dossier Creation & Filing
- **Subagent**: Adversarial Code Auditor (`skills/adversarial-code-auditor/SKILL.md`)
- **Pillar**: Semantic Traceability
- **Tasks**:
  1. Deeply inspect `crates/ingest-sysml/src/translators/markdown.rs`, `crates/deap-core/src/sysml_ast.rs`, and `schema/model.sysml`.
  2. Author 7-section defect dossier at `.pipeline/defects/dossier_invariant_constraints_and_derivations.md`.
  3. Validate dossier schema using `python3 scripts/file_defect.py --dry-run`.
  4. Post feature issue to downstream tracker (`gintatkinson/dumpiler-01`) with label `feature`.
  5. Post feature issue to upstream compiler core (`gintatkinson/DEAP01-spec-core`) with label `feature`.
  6. Return created issue numbers (`#<downstream_id>`, `#<upstream_id>`).

### Phase 2: Feature-Driven Implementation (`skills/feature-driven-implementation/SKILL.md`)

#### Work Package 2.1: AST, Parser & Serializer Extensions
- **Subagent**: Rust Systems Engineer
- **Target Files**:
  - `crates/deap-core/src/sysml_ast.rs`
  - `crates/compile-sysml/src/semantic/serializer.rs`
  - `crates/compile-sysml/src/parser/grammar.rs`
- **Deliverables**:
  1. Add `pub derived_from: Vec<String>` to `RequirementDef`.
  2. Add `pub derives: Vec<String>` to `RequirementDef`.
  3. Update `parse_requirement_defs()` in `sysml_ast.rs` to parse `require`, `assume`, and `derived from`.
  4. Update `SysmlSerializable for RequirementDef` in `serializer.rs` to serialize:
     - `require <name>;` for each item in `requires`
     - `assume <name>;` for each item in `assumes`
     - `derived from <name>;` for each item in `derived_from`
  5. Update `parse_requirement_decl()` in `grammar.rs` to parse `derived from` and populated fields.
  6. Update `PartDef` serialization / AST if needed to support `assert constraint <name>;`.
  7. Add driving unit tests in `deap-core` and `compile-sysml`.

#### Work Package 2.2: Markdown Ingestion of Invariants & Requirement Cross-References
- **Subagent**: Rust Systems Engineer
- **Target Files**:
  - `crates/ingest-sysml/src/translators/markdown.rs`
- **Deliverables**:
  1. Implement `extract_formal_invariants(content: &str, req_num: &str) -> Vec<ConstraintDef>`:
     - Parses `## 2. Formal Invariant` blocks.
     - Extracts named propositions, invariant formulas, and bounds.
     - Constructs clean `ConstraintDef` entities with sanitized names (`Invariant_REQ_XXXX_<Slug>`).
  2. Implement `extract_requirement_cross_references(content: &str, current_req_id: &str) -> Vec<String>`:
     - Extracts all `REQ-XXXX` citations appearing in Section 1 and Section 2.
     - Resolves canonical requirement symbol names (`REQ_XXXX_<Title>`).
     - Populates `RequirementDef.derived_from`.
  3. Update `translate()`:
     - Attaches invariant names to `RequirementDef.requires`.
     - Populates `pkg.constraint_defs`.
  4. Update `translate_files()`:
     - Collects `constraint_defs` by subsystem index.
     - Populates each subsystem `PackageDef.constraint_defs`.
     - Adds `assert constraint` references to the subsystem engine part.
  5. Add driving unit tests in `ingest-sysml` verifying constraint extraction and derivation mapping.

#### Work Package 2.3: Re-synthesis, Full Compilation & Verification
- **Deliverables**:
  1. Run `cargo test --workspace` (assert 100% green).
  2. Re-synthesize model: `./target/release/ingest-sysml --schema schema/ --format markdown --out schema/model.sysml`.
  3. Compile model: `./target/release/compile-sysml --compile --schema schema/model.sysml`.
  4. Verify that `schema/model.sysml` contains > 0 `constraint def`, `require`, and `derived from` statements.
  5. Run baseline verifiers:
     - `./target/release/verify-baseline . --no-domain`
     - `python3 scripts/verify_downstream_baseline.py --no-domain`
  6. Check for zero Unicode em dashes (`\u2014`).

### Phase 3: Remote Synchronization, Issue Transition & Walkthrough
- Stage and commit with neutral non-auto-closing message:
  `git commit -m "feat(schema): formalize invariant constraints, requirement derivations, and subsystem assertions (refs #<downstream_id>, refs #<upstream_id>)"`
- Push to remote: `git push origin main`.
- Verify `git diff origin/main` is empty.
- Transition downstream and upstream issues to `status:fixed-resolved` with verification evidence comments.
- Inspect published live issue payloads (`gh issue view`).
- Present final report to user.

---

## 4. Strict Governance Invariants
- **Zero Em Dashes**: Strict prohibition of `\u2014`.
- **Pure Schema-Driven**: Invariants and derivations derived strictly from `schema/REQ-*.md`.
- **Coordinator Direct Writing Lock**: All code/spec modifications executed exclusively by subagents.
- **Commit Message Non-Closure Invariant**: Neutral citations `(refs #<id>)` only.
- **Remote Synchronization**: Verified push to `origin/main` before declaring completion.

