doc /* Abstract Model-Based Systems Engineering (MBSE) Compiler System Architecture */
package DEAP_Compiler_System {
    import ConOps::*;
    import Subsystem_1_System_Vision::*;
    import Subsystem_2_Universal_Schema_Ingestion_Engine::*;
    import Subsystem_3_Core_Metamodel_Node_Arena::*;
    import Subsystem_4_Complete_SysMLv2_KerML_Grammar::*;
    import Subsystem_5_7D_Physical_Metrology_Flow_Networks::*;
    import Subsystem_6_Spatio_Temporal_State_Solvers::*;
    import Subsystem_7_Formal_Safety_Traceability_Verification::*;
    import Subsystem_8_Level_1C_ICD_Interconnect_Contracts::*;
    import Subsystem_9_Downstream_Specification_Projections::*;
    import Subsystem_10_Multi_Target_CodeGen_Simulation_Bindings::*;
    import Subsystem_11_Standardized_Diagnostic_Error_Catalog::*;
    import Subsystem_12_Compiler_Performance_CLI_Assurance::*;

    doc /* Level 1 System of Interest (SoI) Architecture Definition */
    part def DEAPCompilerSystem {
        part systemVision : SystemVisionEngine;
        part universalIngestion : UniversalIngestionEngine;
        part nodeArenaASTGraph : NodeArenaASTGraphEngine;
        part grammarLowering : GrammarLoweringEngine;
        part metrologyFlow : MetrologyFlowEngine;
        part stateMachineSolver : StateMachineSolverEngine;
        part safetyAssurance : SafetyAssuranceEngine;
        part icdEngine : ICDEngine;
        part agileProjection : AgileProjectionEngine;
        part codeGen : CodeGenEngine;
        part diagnosticCatalog : DiagnosticErrorCatalogEngine;
        part compilerAssurance : CompilerAssuranceEngine;

        connect universalIngestion.token_out to nodeArenaASTGraph.token_in;
        connect nodeArenaASTGraph.ast_graph_out to grammarLowering.ast_in;
        connect grammarLowering.ast_out to metrologyFlow.ast_in;
        connect grammarLowering.ast_out to stateMachineSolver.ast_in;
        connect stateMachineSolver.state_out to safetyAssurance.state_in;
        connect safetyAssurance.safety_out to icdEngine.safety_in;
        connect icdEngine.icd_out to agileProjection.icd_in;
        connect agileProjection.specs_out to codeGen.specs_in;
    }
}