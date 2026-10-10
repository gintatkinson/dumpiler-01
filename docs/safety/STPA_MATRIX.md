# STPA Safety & Failure Mode Tracking Matrix

## 1. Formal Safety Constraints
| SC ID | Constraint Statement / Description | Controller / Subsystem | Traceability / UCA |
| :--- | :--- | :--- | :--- |
| **SC-001** | System shall prevent Not providing during OA_01_Ingest_OEM_Artifacts | DEAPCompilerSystem | UCA-001 |
| **SC-002** | System shall prevent Providing during OA_01_Ingest_OEM_Artifacts | DEAPCompilerSystem | UCA-002 |
| **SC-003** | System shall prevent Too early / Too late / Out of order during OA_01_Ingest_OEM_Artifacts | DEAPCompilerSystem | UCA-003 |
| **SC-004** | System shall prevent Stopped too soon / Applied too long during OA_01_Ingest_OEM_Artifacts | DEAPCompilerSystem | UCA-004 |
| **SC-005** | System shall prevent Not providing during OA_02_Parse_SysML_AST | DEAPCompilerSystem | UCA-005 |
| **SC-006** | System shall prevent Providing during OA_02_Parse_SysML_AST | DEAPCompilerSystem | UCA-006 |
| **SC-007** | System shall prevent Too early / Too late / Out of order during OA_02_Parse_SysML_AST | DEAPCompilerSystem | UCA-007 |
| **SC-008** | System shall prevent Stopped too soon / Applied too long during OA_02_Parse_SysML_AST | DEAPCompilerSystem | UCA-008 |
| **SC-009** | System shall prevent Not providing during OA_03_Validate_Model_Semantics | DEAPCompilerSystem | UCA-009 |
| **SC-010** | System shall prevent Providing during OA_03_Validate_Model_Semantics | DEAPCompilerSystem | UCA-010 |
| **SC-011** | System shall prevent Too early / Too late / Out of order during OA_03_Validate_Model_Semantics | DEAPCompilerSystem | UCA-011 |
| **SC-012** | System shall prevent Stopped too soon / Applied too long during OA_03_Validate_Model_Semantics | DEAPCompilerSystem | UCA-012 |
| **SC-013** | System shall prevent Not providing during OA_04_Transpile_Safety_Artifacts | DEAPCompilerSystem | UCA-013 |
| **SC-014** | System shall prevent Providing during OA_04_Transpile_Safety_Artifacts | DEAPCompilerSystem | UCA-014 |
| **SC-015** | System shall prevent Too early / Too late / Out of order during OA_04_Transpile_Safety_Artifacts | DEAPCompilerSystem | UCA-015 |
| **SC-016** | System shall prevent Stopped too soon / Applied too long during OA_04_Transpile_Safety_Artifacts | DEAPCompilerSystem | UCA-016 |
| **SC-017** | System shall prevent Not providing during OA_05_Synthesize_Downstream_Projections | DEAPCompilerSystem | UCA-017 |
| **SC-018** | System shall prevent Providing during OA_05_Synthesize_Downstream_Projections | DEAPCompilerSystem | UCA-018 |
| **SC-019** | System shall prevent Too early / Too late / Out of order during OA_05_Synthesize_Downstream_Projections | DEAPCompilerSystem | UCA-019 |
| **SC-020** | System shall prevent Stopped too soon / Applied too long during OA_05_Synthesize_Downstream_Projections | DEAPCompilerSystem | UCA-020 |
| **SC-021** | System shall prevent Not providing during OA_06_Verify_Baseline_Parity | DEAPCompilerSystem | UCA-021 |
| **SC-022** | System shall prevent Providing during OA_06_Verify_Baseline_Parity | DEAPCompilerSystem | UCA-022 |
| **SC-023** | System shall prevent Too early / Too late / Out of order during OA_06_Verify_Baseline_Parity | DEAPCompilerSystem | UCA-023 |
| **SC-024** | System shall prevent Stopped too soon / Applied too long during OA_06_Verify_Baseline_Parity | DEAPCompilerSystem | UCA-024 |

## 2. STPA Unsafe Control Actions (UCA) Matrix
| UCA ID | Controller | Control Action | Guide Word | Hazard | Safety Constraint |
| :--- | :--- | :--- | :--- | :--- | :--- |
| UCA-001 | DEAPCompilerSystem | OA_01_Ingest_OEM_Artifacts | Not providing | H-1 | SC-001 |
| UCA-002 | DEAPCompilerSystem | OA_01_Ingest_OEM_Artifacts | Providing | H-1 | SC-002 |
| UCA-003 | DEAPCompilerSystem | OA_01_Ingest_OEM_Artifacts | Too early / Too late / Out of order | H-1 | SC-003 |
| UCA-004 | DEAPCompilerSystem | OA_01_Ingest_OEM_Artifacts | Stopped too soon / Applied too long | H-1 | SC-004 |
| UCA-005 | DEAPCompilerSystem | OA_02_Parse_SysML_AST | Not providing | H-2 | SC-005 |
| UCA-006 | DEAPCompilerSystem | OA_02_Parse_SysML_AST | Providing | H-2 | SC-006 |
| UCA-007 | DEAPCompilerSystem | OA_02_Parse_SysML_AST | Too early / Too late / Out of order | H-2 | SC-007 |
| UCA-008 | DEAPCompilerSystem | OA_02_Parse_SysML_AST | Stopped too soon / Applied too long | H-2 | SC-008 |
| UCA-009 | DEAPCompilerSystem | OA_03_Validate_Model_Semantics | Not providing | H-3 | SC-009 |
| UCA-010 | DEAPCompilerSystem | OA_03_Validate_Model_Semantics | Providing | H-3 | SC-010 |
| UCA-011 | DEAPCompilerSystem | OA_03_Validate_Model_Semantics | Too early / Too late / Out of order | H-3 | SC-011 |
| UCA-012 | DEAPCompilerSystem | OA_03_Validate_Model_Semantics | Stopped too soon / Applied too long | H-3 | SC-012 |
| UCA-013 | DEAPCompilerSystem | OA_04_Transpile_Safety_Artifacts | Not providing | H-4 | SC-013 |
| UCA-014 | DEAPCompilerSystem | OA_04_Transpile_Safety_Artifacts | Providing | H-4 | SC-014 |
| UCA-015 | DEAPCompilerSystem | OA_04_Transpile_Safety_Artifacts | Too early / Too late / Out of order | H-4 | SC-015 |
| UCA-016 | DEAPCompilerSystem | OA_04_Transpile_Safety_Artifacts | Stopped too soon / Applied too long | H-4 | SC-016 |
| UCA-017 | DEAPCompilerSystem | OA_05_Synthesize_Downstream_Projections | Not providing | H-5 | SC-017 |
| UCA-018 | DEAPCompilerSystem | OA_05_Synthesize_Downstream_Projections | Providing | H-5 | SC-018 |
| UCA-019 | DEAPCompilerSystem | OA_05_Synthesize_Downstream_Projections | Too early / Too late / Out of order | H-5 | SC-019 |
| UCA-020 | DEAPCompilerSystem | OA_05_Synthesize_Downstream_Projections | Stopped too soon / Applied too long | H-5 | SC-020 |
| UCA-021 | DEAPCompilerSystem | OA_06_Verify_Baseline_Parity | Not providing | H-6 | SC-021 |
| UCA-022 | DEAPCompilerSystem | OA_06_Verify_Baseline_Parity | Providing | H-6 | SC-022 |
| UCA-023 | DEAPCompilerSystem | OA_06_Verify_Baseline_Parity | Too early / Too late / Out of order | H-6 | SC-023 |
| UCA-024 | DEAPCompilerSystem | OA_06_Verify_Baseline_Parity | Stopped too soon / Applied too long | H-6 | SC-024 |

