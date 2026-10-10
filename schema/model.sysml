doc /* Abstract Model-Based Systems Engineering (MBSE) Compiler System Architecture */
package DEAP_Compiler_System {
    doc /* Pipeline flow: raw tokens to node arena AST graph */
    connection def c_ingest_to_arena {
        connect UniversalIngestionEngine.token_out to NodeArenaASTGraphEngine.token_in;
    }
    doc /* Pipeline flow: AST graph to grammar lowering engine */
    connection def c_arena_to_grammar {
        connect NodeArenaASTGraphEngine.ast_graph_out to GrammarLoweringEngine.ast_in;
    }
    doc /* Pipeline flow: lowered AST to 7D physical metrology flow solver */
    connection def c_grammar_to_metrology {
        connect GrammarLoweringEngine.ast_out to MetrologyFlowEngine.ast_in;
    }
    doc /* Pipeline flow: lowered AST to discrete state machine solver */
    connection def c_grammar_to_statemachine {
        connect GrammarLoweringEngine.ast_out to StateMachineSolverEngine.ast_in;
    }
    doc /* Pipeline flow: state reachability to formal safety verification */
    connection def c_solver_to_safety {
        connect StateMachineSolverEngine.state_out to SafetyAssuranceEngine.state_in;
    }
    doc /* Pipeline flow: safety constraints to Level 1C ICD interconnect contracts */
    connection def c_safety_to_icd {
        connect SafetyAssuranceEngine.safety_out to ICDEngine.safety_in;
    }
    doc /* Pipeline flow: ICD contracts to downstream agile specification projections */
    connection def c_icd_to_projections {
        connect ICDEngine.icd_out to AgileProjectionEngine.icd_in;
    }
    doc /* Pipeline flow: agile specifications to multi-target code generation and simulation */
    connection def c_projections_to_codegen {
        connect AgileProjectionEngine.specs_out to CodeGenEngine.specs_in;
    }
}