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

## 4. Strict Governance Invariants
- **Zero Em Dashes**: Strict prohibition of `\u2014`.
- **Pure Schema-Driven**: All attributes and ACs derived directly from `schema/REQ-*.md`.
- **Coordinator Direct Writing Lock**: Source code edits delegated exclusively to subagents.
- **Remote Synchronization**: Task is complete only when pushed to `origin/main`.
