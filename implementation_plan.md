# Implementation Plan: Redesign & Re-synthesize SysML v2 Model to Reflect 12 Compiler Subsystems and Interrelationships

## 1. Problem Statement & Root Cause
The current `schema/model.sysml` (synthesized during early Phase 0) flattened all 199 requirement files into a single root `package schema { ... }` with isolated `part def AC_XX_*` blocks.
This modeling had major deficiencies:
1. **Lost 12 Compiler Subsystems**: The 12 logical compiler subsystems specified in the YAML frontmatter (`subsystem: "Subsystem X: <Title>"`) were flattened into a single package.
2. **Missing `requirement def` Constructs**: The 199 requirements were not modeled as formal SysML v2 `requirement def REQ_XXXX { ... }` entities with their IDs, titles, UUIDs, complexity classes, governing standards, and diagnostic error codes.
3. **Missing Architectural Interrelationships**: The pipeline dependencies, component realizations (`satisfy REQ_XXXX;`), inter-subsystem data flows, and port contracts between compilation stages were completely absent.

---

## 2. Target Architectural Hierarchy

```sysml
package DEAP_Compiler_System {

    // Subsystem 1: System Vision, Bootstrapping & Foundational Invariants (REQ-0001..REQ-0013)
    package Subsystem_1_System_Vision {
        requirement def REQ_0001_Abstract_MBSE_Compiler_Mandate { ... }
        ...
        part def SystemVisionEngine {
            satisfy REQ_0001_Abstract_MBSE_Compiler_Mandate;
            port rules_out : CompilerRulePort;
        }
    }

    // Subsystem 2: Universal Schema Ingestion Engine (REQ-0014..REQ-0033)
    package Subsystem_2_Universal_Schema_Ingestion_Engine {
        requirement def REQ_0014_File_Format_Detection { ... }
        ...
        part def UniversalIngestionEngine {
            satisfy REQ_0014_File_Format_Detection;
            port schema_in : RawSchemaStreamPort;
            port token_out : TokenStreamPort;
        }
    }

    // Subsystem 3: Core Metamodel, Node Arena & AST Graph Engine (REQ-0034..REQ-0053)
    package Subsystem_3_Core_Metamodel_Node_Arena {
        requirement def REQ_0034_Contiguous_Memory_Arena { ... }
        ...
        part def NodeArenaASTGraphEngine {
            satisfy REQ_0034_Contiguous_Memory_Arena;
            port token_in : TokenStreamPort;
            port ast_graph_out : ASTGraphPort;
        }
    }

    // Subsystem 4: Complete OMG SysML v2 / KerML Metamodel Lowering & Grammar (REQ-0054..REQ-0092)
    package Subsystem_4_Complete_SysMLv2_KerML_Grammar { ... }

    // Subsystem 5: 7D Physical Metrology & Abstract Flow Conservation Networks (REQ-0093..REQ-0108)
    package Subsystem_5_7D_Physical_Metrology_Flow_Networks { ... }

    // Subsystem 6: Spatio-Temporal Dynamics & Discrete State Machine Solvers (REQ-0109..REQ-0122)
    package Subsystem_6_Spatio_Temporal_State_Solvers { ... }

    // Subsystem 7: Formal Safety, Traceability & Regulatory Verification (REQ-0123..REQ-0139)
    package Subsystem_7_Formal_Safety_Traceability_Verification { ... }

    // Subsystem 8: Level 1C Interface Control Documents & Interconnect Contracts (REQ-0140..REQ-0153)
    package Subsystem_8_Level_1C_ICD_Interconnect_Contracts { ... }

    // Subsystem 9: Downstream Specification Projections (REQ-0154..REQ-0169)
    package Subsystem_9_Downstream_Specification_Projections { ... }

    // Subsystem 10: Multi-Target Code Generation, Simulation & Transport Bindings (REQ-0170..REQ-0184)
    package Subsystem_10_Multi_Target_CodeGen_Simulation_Bindings { ... }

    // Subsystem 11: Standardized Compiler Diagnostic Error Catalog (REQ-0185..REQ-0189)
    package Subsystem_11_Standardized_Diagnostic_Error_Catalog { ... }

    // Subsystem 12: Compiler Performance, CLI, Assurance & Regression Inoculation (REQ-0190..REQ-0199)
    package Subsystem_12_Compiler_Performance_CLI_Assurance { ... }

    // Inter-Subsystem Pipeline Flow Interconnections
    connection c_ingest_to_arena connect Subsystem_2_Universal_Schema_Ingestion_Engine.UniversalIngestionEngine.token_out to Subsystem_3_Core_Metamodel_Node_Arena.NodeArenaASTGraphEngine.token_in;
    connection c_arena_to_grammar connect Subsystem_3_Core_Metamodel_Node_Arena.NodeArenaASTGraphEngine.ast_graph_out to Subsystem_4_Complete_SysMLv2_KerML_Grammar.GrammarLoweringEngine.ast_in;
    connection c_grammar_to_metrology connect Subsystem_4_Complete_SysMLv2_KerML_Grammar.GrammarLoweringEngine.ast_out to Subsystem_5_7D_Physical_Metrology_Flow_Networks.MetrologyFlowEngine.ast_in;
    connection c_grammar_to_statemachine connect Subsystem_4_Complete_SysMLv2_KerML_Grammar.GrammarLoweringEngine.ast_out to Subsystem_6_Spatio_Temporal_State_Solvers.StateMachineSolverEngine.ast_in;
    connection c_solver_to_safety connect Subsystem_6_Spatio_Temporal_State_Solvers.StateMachineSolverEngine.state_out to Subsystem_7_Formal_Safety_Traceability_Verification.SafetyAssuranceEngine.state_in;
    connection c_safety_to_icd connect Subsystem_7_Formal_Safety_Traceability_Verification.SafetyAssuranceEngine.safety_out to Subsystem_8_Level_1C_ICD_Interconnect_Contracts.ICDEngine.safety_in;
    connection c_icd_to_projections connect Subsystem_8_Level_1C_ICD_Interconnect_Contracts.ICDEngine.icd_out to Subsystem_9_Downstream_Specification_Projections.AgileProjectionEngine.icd_in;
    connection c_projections_to_codegen connect Subsystem_9_Downstream_Specification_Projections.AgileProjectionEngine.specs_out to Subsystem_10_Multi_Target_CodeGen_Simulation_Bindings.CodeGenEngine.specs_in;
}
```

---

## 3. Work Packages (Micro-Tasks)

All file writing and coding operations will be executed by context-isolated subagents in accordance with `AGENTS.md` and `rules/subagent-dispatch-standards.md`.

### Work Package 1: Upgrade `crates/ingest-sysml` Markdown Translator
- **Target Files**:
  - `crates/ingest-sysml/src/translators/markdown.rs`
  - `crates/ingest-sysml/src/table.rs`
- **Deliverables**:
  - Parse YAML frontmatter: `id`, `title`, `subsystem`, `uuidv5`.
  - Parse markdown tables in each REQ: `Complexity Class`, `Governing Standard`, `Diagnostic Code Bindings`.
  - Group requirements into the 12 logical compiler subsystem packages:
    `Subsystem_1_System_Vision`, `Subsystem_2_Universal_Schema_Ingestion_Engine`, ..., `Subsystem_12_Compiler_Performance_CLI_Assurance`.
  - In each subsystem package:
    - Generate a formal `requirement def REQ_XXXX_<Title>` for every requirement.
    - Generate the subsystem's primary `part def <Engine>` containing `satisfy` statements referencing every constituent requirement.
    - Declare input/output ports on each engine.
  - At the root package, synthesize inter-subsystem `connection` definitions establishing the end-to-end compiler pipeline data flows.
  - Update unit tests in `crates/ingest-sysml`.

### Work Package 2: Re-synthesize & Compile Canonical `schema/model.sysml`
- **Deliverables**:
  - Run `./target/release/ingest-sysml --schema schema/ --format markdown --out schema/model.sysml`.
  - Run `./target/release/compile-sysml --compile --schema schema/model.sysml`.
  - Verify that `.pipeline/schema.sysml` and `.pipeline/schema-digest.json` capture the 12 subsystem packages, 199 formal requirement definitions, and inter-subsystem connections.

### Work Package 3: Baseline Quality Gate Verification & Remote Synchronization
- **Deliverables**:
  - Run `cargo test --workspace` (assert 100% pass).
  - Run `./target/release/verify-baseline . --no-domain`.
  - Verify zero Unicode em dashes (`\u2014`).
  - Stage, commit with non-auto-closing message:
    `git commit -m "feat(schema): remodel model.sysml into 12 compiler subsystems with formal requirements and inter-subsystem connections"`
  - Push to `origin/main` and verify `git diff origin/main` is empty.

---

## 4. Strict Governance Invariants
- **Zero Em Dashes**: Strict prohibition of `\u2014`.
- **Pure Schema-Driven**: Derived 100% from input `schema/REQ-*.md` metadata and content.
- **Coordinator Direct Writing Lock**: Source writes delegated exclusively to context-isolated subagents.
- **Remote Synchronization**: Task is not complete until successfully pushed to `origin/main`.
