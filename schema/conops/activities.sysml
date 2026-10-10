doc /* ConOps Level 0 Operational Activities */
package ConOps {
    doc /* Ingest OEM documentation and structural schema artifacts into the compiler */
    action def OA_01_Ingest_OEM_Artifacts;

    doc /* Parse ingested schema sources into SysML v2 / KerML Abstract Syntax Tree */
    action def OA_02_Parse_SysML_AST;

    doc /* Validate AST semantics, typing, referential integrity, and domain constraints */
    action def OA_03_Validate_Model_Semantics;

    doc /* Transpile verified model into 10-pillar STPA and safety assurance artifacts */
    action def OA_04_Transpile_Safety_Artifacts;

    doc /* Synthesize downstream architectural projections, ICD interfaces, and code */
    action def OA_05_Synthesize_Downstream_Projections;

    doc /* Verify multi-file baseline parity, AST alignment, and governance quality gates */
    action def OA_06_Verify_Baseline_Parity;
}
