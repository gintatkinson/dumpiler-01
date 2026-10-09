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
    doc /* System Vision, Bootstrapping & Foundational Invariants */
    package Subsystem_1_System_Vision {
        doc /* UUIDv5: 5a4d7a99-0419-5c2b-ba0e-ccabdb05f1c9 | Complexity: Class P (O(N) linear scan & AST graph construction) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100 */
        requirement def REQ_0001_Abstract_MBSE_Compiler_Mandate {
            id = "REQ-0001";
            text = "The compiler platform shall function strictly as an abstract Model-Based Systems Engineering (MBSE) compiler, deriving all synthesized intermediate representations, verification models, downstream specification projections, and interface definitions deterministically from user-provided schema";
            satisfy by SystemVisionEngine;
        }
        doc /* UUIDv5: 154d02cc-ed4d-528f-ba8e-6c244e349d6b | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100 */
        requirement def REQ_0002_Surjective_Lexical_Provenance_Gate {
            id = "REQ-0002";
            text = "The compiler platform shall enforce a strict, surjective lexical provenance gate across all synthesized abstract syntax tree (AST) elements. Every generated classifier, feature usage, port, connector, attribute, constraint, behavior, action, and state identifier shall establish a verifiable";
            satisfy by SystemVisionEngine;
        }
        doc /* UUIDv5: 4f1f2692-3af9-56d5-ac0f-99331047c4ca | Complexity: Class P (O(M \log M)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100 */
        requirement def REQ_0003_Bitwise_Determinism {
            id = "REQ-0003";
            text = "The compiler pipeline shall guarantee bitwise deterministic artifact emission across repeated invocations on identical input schemas, producing bit-for-bit identical outputs. The pipeline must eliminate all sources of entropy and platform variance: hash iteration orders, thread scheduling";
            satisfy by SystemVisionEngine;
        }
        doc /* UUIDv5: f6b38db1-7eca-59e4-8390-6e692d430cf6 | Complexity: Class P (O(D)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100 */
        requirement def REQ_0004_Workspace_Sovereignty {
            id = "REQ-0004";
            text = "The compiler platform shall operate in a self-contained, sovereign repository architecture wherein all filesystem operations, cross-module schema imports, configuration lookups, and generated artifact paths resolve dynamically using canonical workspace-relative paths derived from an authenticated";
            satisfy by SystemVisionEngine;
        }
        doc /* UUIDv5: 2ff6b53f-76da-5c95-9977-f8c64761a265 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100 */
        requirement def REQ_0005_Standalone_Self_Contained_Execution {
            id = "REQ-0005";
            text = "The compiler platform shall execute as an autonomous, self-contained compiler binary that operates independently of host environment configuration, external service daemons, network connectivity, or implicit ambient filesystem state. The compiler must not require external language runtimes, dynamic";
            satisfy by SystemVisionEngine;
        }
        doc /* UUIDv5: a09507e5-336e-5cda-9ea9-6c0013e2c2eb | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100 */
        requirement def REQ_0006_Incremental_Compilation_Dependency_Tracking {
            id = "REQ-0006";
            text = "The compiler platform shall maintain fine-grained dependency tracking across all modular compilation units within an explicit compilation unit dependency directed acyclic graph (DAG). The incremental compilation subsystem must compute deterministic cryptographic content digests for each input";
            satisfy by SystemVisionEngine;
        }
        doc /* UUIDv5: b914a09f-4d01-5108-87c5-c718f4cb795a | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100 */
        requirement def REQ_0007_Multi_File_Compilation_Unit_Resolution {
            id = "REQ-0007";
            text = "The compiler architecture shall resolve multi-file compilation units and enforce hierarchical package scoping across modular schema libraries without cross-module symbol collision or namespace pollution. Each compilation unit ingested from the workspace shall bind to a hierarchical package";
            satisfy by SystemVisionEngine;
        }
        doc /* UUIDv5: ed8d2166-1bef-5eaf-a7ae-edefc41aa67b | Complexity: Class P (O(N)) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0100 */
        requirement def REQ_0008_Sovereign_Single_Source_of_Truth_Multi_File_AST_Model {
            id = "REQ-0008";
            text = "The compiler platform shall establish and maintain the unified, multi-file SysML v2 / KerML Abstract Syntax Tree (AST) synthesized from modular schemas in the schema/ directory as the sovereign Single Source of Truth (SSOT) for all architectural structures, interfaces, and constraints across the";
            satisfy by SystemVisionEngine;
        }
        doc /* UUIDv5: 59bc84c8-6687-597b-bb0b-6da541d3d5b0 | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100 */
        requirement def REQ_0009_Zero_Copy_Bump_Arena_Memory_Management {
            id = "REQ-0009";
            text = "The compiler front-end, lexical analyzer, parser, and core abstract syntax tree (AST) engine shall utilize zero-copy memory management via contiguous bump allocation arenas for all parsed AST nodes, token streams, syntax trees, and intermediate representation graphs. Lexical tokens and string";
            satisfy by SystemVisionEngine;
        }
        doc /* UUIDv5: 97ed814a-bee5-59d3-984e-6b286b199013 | Complexity: Class P (O(L) = O( | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100 */
        requirement def REQ_0010_Deterministic_RFC_4122_UUIDv5_Topological_Namespace_Hashing {
            id = "REQ-0010";
            text = "The compiler platform shall generate all synthetic entity identifiers, specification document anchors (Epics, Features, User Stories, Use Cases), intermediate representation node handles, and downstream artifact keys exclusively via deterministic RFC 4122 UUIDv5 namespace hashing. In accordance";
            satisfy by SystemVisionEngine;
        }
        doc /* UUIDv5: 9985a57d-c8a1-5892-bf7d-70fe274e6f69 | Complexity: Class P (O(N)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100 */
        requirement def REQ_0011_Deterministic_Non_Panicking_Execution_Contract {
            id = "REQ-0011";
            text = "Production compiler library code and release executable binaries shall strictly enforce a deterministic, non-panicking execution contract with guaranteed total-function termination on all valid, invalid, truncated, malformed, and adversarial schema inputs. The compiler platform must strictly";
            satisfy by SystemVisionEngine;
        }
        doc /* UUIDv5: f5fee3b3-2536-555e-a862-4fb046974715 | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100 */
        requirement def REQ_0012_Bounded_Work_Stealing_Parallelism {
            id = "REQ-0012";
            text = "All concurrent compilation operations--including parallel schema ingestion, multi-file AST parsing, graph traversals, STPA Cartesian product hazard tensor expansions, temporal reachability evaluations, and downstream artifact code generation--shall execute exclusively through a bounded";
            satisfy by SystemVisionEngine;
        }
        doc /* UUIDv5: 23dadb43-7181-565c-9eb3-f710662cedb2 | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0100, E0102, E0103, E0199 */
        requirement def REQ_0013_Synchronization_Token_Error_Recovery_Architecture {
            id = "REQ-0013";
            text = "All front-end schema and language parsers--including CommonMark tabular schema parsers, KerML and SysML v2 grammar parsers, Protocol Buffer parsers, IDL parsers, and structural ADL parsers--shall implement Synchronization Token Error Recovery in accordance with Directive 4. Front-end parsers must";
            satisfy by SystemVisionEngine;
        }
        doc /* Primary execution engine for System Vision, Bootstrapping & Foundational Invariants */
        part def SystemVisionEngine {
            port out rules_out : CompilerRulePort;
        }
        doc /* - **Given:** Schema configuration $`\mathcal{I}`$ with abstract MBSE entities (`Package_0`, `Classifier_Alpha`, `Port_1`, `Flow_A`, `param_x : Real`). - **When:** The compiler executes repeated independent runs $``\text{Run}_A``$ and $``\text{Run}_B``$ at timestamps $``t_1 \ne t_2``$ across different hosts. - **Then:** Emitted artifacts satisfy $``\mathbf{b}_k^{(A)} = \mathbf{b}_k^{(B)}``$, $``\text{SHA256}(\mathbf{b}_k^{(A)}) \equiv \text{SHA256}(\mathbf{b}_k^{(B)})``$, and $``\text{Diff}(\mathcal{E}(\mathcal{I}, \text{Run}_A), \mathcal{E}(\mathcal{I}, \text{Run}_B)) = \emptyset``$. - **Diagnostic:** `E0100` on byte divergence or digest mismatch. */
        part def AC_01_Bitwise_Re_Execution_Invariance_and_Digest_Parity {
        }
        doc /* - **Given:** Host platform with $``C_{\text{logical}}``$ cores and compiler runtime configured with ceiling $``N_{\text{max\_workers}}``$. - **When:** The compiler initializes thread pool $``P_{\text{workers}}``$ and dispatches parallel passes over model elements (`Package_0`, `Classifier_Alpha`, `Port_1`). - **Then:** Active worker count satisfies $``|P_{\text{workers}}| = \min(C_{\text{logical}}, N_{\text{max\_workers}})``$, total OS threads satisfy $``|\mathcal{T}_{\text{spawned}}| \le |P_{\text{workers}}| + 1``$, and unmanaged thread spawning is prohibited. - **Diagnostic:** `E0100` emitted if active OS threads exceed $``N_{\text{max\_workers}} + 1``$ or unmanaged thread instantiation occurs. */
        part def AC_01_Bounded_Worker_Thread_Allocation_Gate {
        }
        doc /* - **Given:** A valid input model AST rooted in `Package_0` located within the sovereign workspace root, with host environment variables purged ($``\mathcal{V}_{\text{env}} = \emptyset``$) and zero ambient service daemons running. - **When:** The compiler binary is invoked with explicit workspace configuration `--workspace-root.`. - **Then:** Compilation completes successfully, bootstrapping internal metamodel closures from embedded binary resources and workspace paths, emitting identical artifact byte streams with zero reliance on host variables. - **Diagnostic:** `E0100` (Compiler initialization failure or missing bootstrap definition on violation). */
        part def AC_01_Hermetic_Execution_in_Cleared_Environment_Sandbox {
        }
        doc /* - **Given:** Multi-unit model in `Package_0` comprising `CompilationUnit_Alpha`, `CompilationUnit_Beta`, and `CompilationUnit_Gamma` with dependency path $`\text{Alpha} \to \text{Beta} \to \text{Gamma}`$, with all units cached in the compiler AST cache. - **When:** Leaf unit `CompilationUnit_Gamma` content digest changes and incremental compilation executes. - **Then:** The compiler marks strictly $``\text{Invalidated}(M) = \{ \text{CompilationUnit\_Gamma} \}``$, re-parses only `CompilationUnit_Gamma`, reuses cached AST nodes for `CompilationUnit_Alpha` and `CompilationUnit_Beta` ($``T_{\text{parse}} = 0``$), and emits composite AST $``\mathcal{A}_{\text{inc}}``$ where $``\text{MerkleRoot}(\mathcal{A}_{\text{inc}}) = \text{MerkleRoot}(\mathcal{A}_{\text{full}})``$. - **Diagnostic:** `E0100` on redundant re-parsing of unaffected units or AST parity mismatch. */
        part def AC_01_Leaf_Compilation_Unit_Mutation_and_Transitive_Invalidation {
        }
        doc /* - **Given:** Malformed schema $`\mathcal{S}`$ containing $`K`$ independent syntax errors (in `Package_0`, `Classifier_Alpha`, and `param_x`) separated by synchronization tokens $``\mathcal{T}_{\text{sync}}``$, where $``K \lt C_{\text{max\_errors}}``$. - **When:** The compiler executes the front-end parser over $`\mathcal{S}`$ in a single compilation pass. - **Then:** The parser recovers at each synchronization boundary, resumes parsing subsequent declarations, and emits exactly $`K`$ structured diagnostics into sink $`\mathcal{D}`$ without aborting prematurely. - **Diagnostic:** Emits localized diagnostics (`E0100`, `E0102`, `E0103`) with precise 1-indexed line, column, and byte span coordinates. */
        part def AC_01_Multi_Error_Accumulation_Without_Premature_Abort {
        }
        doc /* - **Given:** Multi-file compilation units declaring nested packages `Package_0::Package_1` across workspace files. - **When:** The compiler executes the package forest construction pass. - **Then:** A unified package tree is constructed with canonical `::` FQNs, deterministic RFC 4122 UUIDv5 anchors, and nesting depth $`D \le 16`$. - **Diagnostic:** `E0100` on nesting depth $`D \gt 16`$ or malformed path structure. */
        part def AC_01_Multi_File_Hierarchical_Package_Assembly {
        }
        doc /* - **Given:** A valid input schema parsed into schema nodes $`\text{ASTNodes}(\mathcal{S})`$ containing classifier `Classifier_Alpha` and port `Port_1`. - **When:** The compiler executes the lexical provenance gate on synthesized AST $`\mathcal{A}`$. - **Then:** Every lowered node corresponding to `Classifier_Alpha` and `Port_1` resolves to non-null provenance $`\Pi(n) \in \text{ASTNodes}(\mathcal{S})`$ with valid source byte span coordinates satisfying $`0 \le \text{ByteStart} \lt \text{ByteEnd} \le \text{Length}(\mathcal{B})`$. - **Diagnostic:** Diagnostic `E0100` emitted if provenance pointer is null or byte span coordinates exceed buffer bounds. */
        part def AC_01_Positive_Schema_Node_Provenance_Byte_Span_Verification {
        }
        doc /* - **Given:** An input schema source $`\mathcal{S}`$ containing user-defined declarations (`Package_0`, `Classifier_Alpha`, `Port_1`) and standard compiler grammar tokens $``\mathcal{K}_{\text{grammar}}``$. - **When:** The compiler executes the front-end ingestion and AST construction pass $`\mathcal{C} : \mathcal{S} \longrightarrow \mathcal{A}`$. - **Then:** Every symbol $`\sigma \in \text{Symbols}(\mathcal{A})`$ resolves strictly to $``\text{Tokens}(\mathcal{S}) \cup \mathcal{K}_{\text{grammar}} \cup \text{Synthetic}(\mathcal{S})``$, guaranteeing zero ungrounded or fabricated identifiers. - **Diagnostic:** `E0100` emitted on any symbol failing positive set containment. */
        part def AC_01_Pure_Schema_Driven_Symbol_Derivation {
        }
        doc /* - **Given:** Canonical topological path $``p = \text{Package\_0::Classifier\_Alpha::Port\_1}``$ and fixed namespace identifier $``\text{NS}_{\text{DEAP}}``$. - **When:** The compiler synthesizes identifier $``U = \text{UUIDv5}(\text{NS}_{\text{DEAP}}, p)``$. - **Then:** The identifier satisfies Version 5 bits $``(u_6 \land 0\text{xF0}) = 0\text{x50}``$ and Variant bits $``(u_8 \land 0\text{xC0}) = 0\text{x80}``$, matching regex `^[0-9a-f]{8}-[0-9a-f]{4}-5[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\$`. - **Diagnostic:** `E0100` emitted on bitwise mask or string formatting violation. */
        part def AC_01_RFC_4122_Standard_Conformance_Bitwise_Fields {
        }
        doc /* - **Given:** Modular schema input files $`\mathcal{S}`$ in `schema/` declaring interdependent packages (`Package_0`, `Package_1`) and classifiers (`Classifier_Alpha`, `Classifier_Beta`). - **When:** The compiler front-end executes schema ingestion and multi-file AST unification. - **Then:** Synthesizes sovereign root AST $``\mathcal{A}_{\text{SSOT}} = (V, E, \mu)``$ with all node handles deterministically anchored via RFC 4122 UUIDv5 hashing from $``\text{NS}_{\text{DEAP}}``$ and topological paths. - **Diagnostic:** `E0100` emitted on schema parse failure, duplicate anchor generation, or ungrounded node handles. */
        part def AC_01_Sovereign_Multi_File_AST_Synthesis_and_Unification {
        }
        doc /* - **Given:** A valid repository containing package `Package_0` under workspace root $`\mathcal{R}`$, invoked from an arbitrary subdirectory without explicit root arguments. - **When:** The compiler initializes and resolves internal schema imports for `Package_0::Classifier_Alpha`. - **Then:** The compiler discovers root $`\mathcal{R}`$ via upward parent inspection ($`D \le 64`$), normalizes relative path $``p_{\text{rel}}``$, and constructs canonical handle $``P = \mathcal{R} \bowtie p_{\text{rel}}``$ within the repository subtree. - **Diagnostic:** E0100 on root discovery failure. */
        part def AC_01_Sovereign_Workspace_Root_Discovery_In_Tree_Path_Resolution {
        }
        doc /* - **Given:** A fuzz-testing corpus of $`10^6`$ malformed, truncated, syntactically invalid, and boundary-value schema inputs $`s \in \mathcal{S}`$. - **When:** The compiler executes front-end ingestion, lexical parsing, and AST lowering passes. - **Then:** Zero executions produce an unhandled panic, assertion failure, abnormal process abort, or fatal OS signal (`SIGSEGV`, `SIGABRT`, `SIGILL`), satisfying $`\text{AbnormalTermination}(s) \equiv \text{false}`$. - **Diagnostic:** `E0100` emitted on any unhandled crash, panic, or abnormal process exit. */
        part def AC_01_Total_Function_Non_Panicking_Contract_on_Adversarial_Inputs {
        }
        doc /* - **Given:** A memory-mapped source file buffer $``\mathcal{B}_{\text{file}}``$ of length $`L`$ containing abstract MBSE declarations (`Package_0`, `Classifier_Alpha`, `Port_1`, `Flow_A`, `param_x : Real`). - **When:** The lexical scanner and parser extract token byte slices for identifiers and keywords. - **Then:** Every token slice $``T = \text{Slice}(\mathcal{B}_{\text{file}}, s, l)``$ directly references buffer interval $``[\text{Base}(\mathcal{B}_{\text{file}}) + s, \text{Base}(\mathcal{B}_{\text{file}}) + s + l)``$ with $`0 \le s \le s+l \le L`$ without dynamic heap string allocation. - **Diagnostic:** `E0100` emitted if slice coordinates violate buffer bounds or heap string cloning is detected. */
        part def AC_01_Zero_Copy_Borrowed_Token_Byte_Slices {
        }
        doc /* - **Given:** An input schema specifying an external traversal sequence (`../../etc/shadow`), an absolute machine path (`/usr/local/include`), or a user home expansion (`~/models`). - **When:** The ingestion engine resolves and normalizes import paths during schema loading. - **Then:** The compiler rejects the path as $``p \in \mathcal{P}_{\text{invalid}}``$, aborts compilation before issuing external filesystem reads, and emits diagnostic error code `E0100` citing the offending token and source span. - **Diagnostic:** E0100. */
        part def AC_02_Boundary_Containment_Directory_Traversal_Rejection {
        }
        doc /* - **Given:** An AST compilation unit containing $`M`$ declarations $``\mathcal{D} = \{ d_1, \dots, d_M \}``$ in arbitrary iteration order. - **When:** The emission engine serializes declarations to textual or binary format. - **Then:** Declarations are serialized in ascending order $``\kappa(d_i) \lt_{\text{lex}} \kappa(d_j)``$ for all $`i \lt j`$, enforcing total ordering $``d_i \prec_{\text{det}} d_j``$. - **Diagnostic:** `E0100` if serialized entity sequences violate canonical total ordering. */
        part def AC_02_Canonical_Declaration_Sorting_and_Stable_Key_Ordering {
        }
        doc /* - **Given:** An active bump arena segment $``\mathcal{A}_{\text{arena}}``$ with capacity $`C`$ and current offset $``\text{ArenaOffset}_k``$. - **When:** The compiler allocates successive AST nodes for structural elements (`Classifier_Alpha`, `Port_1`). - **Then:** The allocator advances $``\text{ArenaOffset}_{k+1} = \text{Align}(\text{ArenaOffset}_k + \text{sizeof}(\text{Node}_k), 8)``$ in strict $`O(1)`$ time, all allocated addresses satisfy $``\text{Addr}(r_k) \equiv 0 \pmod 8``$, and reference addresses remain immutable throughout $``\tau_{\text{arena}}``$. - **Diagnostic:** `E0100` emitted if alignment arithmetic fails or an allocation causes segment overflow without chunk chaining. */
        part def AC_02_Constant_Time_Monotonic_Bump_Allocation_Alignment {
        }
        doc /* - **Given:** Resolved sovereign AST $``\mathcal{A}_{\text{SSOT}}``$ and projection mapping $``\psi_k``$ for downstream artifact $``D_k``$ (e.g., ICD tables or target code). - **When:** Projection generator $``\psi_k(\mathcal{A}_{\text{SSOT}})``$ executes across repeated invocations or varied host environments. - **Then:** Emitted byte streams satisfy $``D_k = \psi_k(\mathcal{A}_{\text{SSOT}})``$ with 0-byte diff churn and identical SHA-256 digests. - **Diagnostic:** `E0100` emitted if output streams diverge across repeated compilations of an identical AST. */
        part def AC_02_Deterministic_Downstream_Projection_Parity {
        }
        doc /* - **Given:** An intermediate structural scaffolding node (e.g., root namespace `Package_0`) synthetically generated without a direct source token. - **When:** The compiler lowers `Package_0` and evaluates its provenance anchor. - **Then:** Its provenance descriptor binds to a deterministic RFC 4122 UUIDv5 anchor derived from $``\text{OID}_{\text{DEAP}}``$ and canonical topological path `Package_0`, satisfying $`\Pi(n) \in \text{TopologicalAnchors}(\mathcal{S})`$. - **Diagnostic:** Diagnostic `E0100` emitted if synthetic anchor fails to match deterministic RFC 4122 UUIDv5 path hash. */
        part def AC_02_Deterministic_Synthetic_Topological_Anchor_Provenance {
        }
        doc /* - **Given:** A schema declaring entity path `Package_0::Subsystem_Alpha::Classifier_Beta` compiled in two environments $``\mathcal{E}_1``$ and $``\mathcal{E}_2``$ differing in OS, architecture, endianness, mount path, thread allocation, and timestamp. - **When:** The compiler synthesizes UUIDv5 identifiers in both environments. - **Then:** Emitted bytes and strings satisfy $``U(\mathcal{N}; \mathcal{E}_1) = U(\mathcal{N}; \mathcal{E}_2)``$, ensuring 0-byte diff churn. - **Diagnostic:** `E0100` emitted if emitted representations differ between environments. */
        part def AC_02_Environmental_Invariance_Zero_Diff_Churn {
        }
        doc /* - **Given:** Distinct packages `Package_0` and `Package_1` declaring identical local symbol `Classifier_Alpha`. - **When:** Unqualified lookup for `Classifier_Alpha` is evaluated within `Package_0`. - **Then:** Binds strictly to `Package_0::Classifier_Alpha`, satisfying $``\text{QualifiedNamespace}(\text{Package\_0}) \cap \text{QualifiedNamespace}(\text{Package\_1}) = \emptyset``$. - **Diagnostic:** `E0100` on cross-module collision or scope corruption. */
        part def AC_02_Local_Declaration_Precedence_Namespace_Isolation {
        }
        doc /* - **Given:** A compiler process initiated within an execution environment containing active network interfaces. - **When:** Any compilation pass, schema ingestion step, or diagnostic emission routine executes. - **Then:** Zero transport sockets (TCP, UDP, or external UNIX domain sockets) are opened, zero DNS resolutions are triggered ($`\text{SocketsActive}(\mathcal{C}) = \emptyset`$), and compilation proceeds entirely air-gapped. - **Diagnostic:** `E0100` (Unauthorized network socket creation or connection attempt on violation). */
        part def AC_02_Network_Socket_Isolation_Enforcement {
        }
        doc /* - **Given:** Multi-unit DAG $`G = (V, E)`$ with root unit `CompilationUnit_Alpha` and dependents `CompilationUnit_Beta` and `CompilationUnit_Gamma`. - **When:** Root unit `CompilationUnit_Alpha` content digest changes and incremental compilation executes. - **Then:** Forward reachability identifies $``\text{Invalidated}(M) = \{ \text{CompilationUnit\_Alpha}, \text{CompilationUnit\_Beta}, \text{CompilationUnit\_Gamma} \}``$, recomputing all three units, updating cache records, and emitting AST $``\mathcal{A}_{\text{inc}} \equiv \mathcal{A}_{\text{full}}``$. - **Diagnostic:** `E0100` if any transitively dependent unit is omitted from invalidation. */
        part def AC_02_Root_Dependency_Mutation_and_Full_Forward_Closure_Propagation {
        }
        doc /* - **Given:** Concurrent compilation passes processing synthetic AST nodes across worker pool $``P_{\text{workers}}``$. - **When:** Concurrency audit harnesses inspect memory access traces $``\text{Reads}(\tau_i)``$ and $``\text{Writes}(\tau_i)``$ across all active workers. - **Then:** $``\text{SharedMutableState}(P_{\text{workers}}) = \emptyset``$ holds identically, all shared AST references are strictly immutable, and mutations remain confined to thread-local accumulators. - **Diagnostic:** `E0100` emitted upon detection of any cross-thread shared mutable reference, unsynchronized heap access, or data race. */
        part def AC_02_Strict_Thread_Isolation_Zero_Shared_Mutable_State {
        }
        doc /* - **Given:** Pathological schema inputs containing consecutive unrecognized tokens, malformed nested blocks, and unclosed delimiters. - **When:** The parser triggers error recovery upon encountering syntax faults. - **Then:** The stream position satisfies $``\text{StreamPosition}_{t+1} \gt \text{StreamPosition}_t``$ across all recovery transitions, guaranteeing termination in at most $`N + 1`$ parser steps without livelocks or infinite loops. - **Diagnostic:** `E0100` emitted on recovery faults; fail-closed termination if stream pointer fails to advance. */
        part def AC_02_Strictly_Monotonic_Forward_Progress_Loop_Prevention {
        }
        doc /* - **Given:** An invalid schema input containing syntactically malformed constructs, unresolvable symbol references, or metamodel invariant violations. - **When:** The compiler processes the invalid input. - **Then:** The compiler cleanly terminates and returns a structured diagnostic collection $`\mathcal{D} \neq \emptyset`$ containing source byte spans, AST node handles, and diagnostic codes bound to taxonomy ranges `E01xx` through `E05xx`. - **Diagnostic:** `E0100` emitted if structured diagnostic creation fails or if execution terminates without error descriptors. */
        part def AC_02_Structured_Diagnostic_Error_Capture_and_Propagation {
        }
        doc /* - **Given:** An arbitrary schema $`\mathcal{S}`$ compiled against standard lowering rules, code generators, and intermediate representation emitters. - **When:** The AST validation pass evaluates $`\text{Symbols}(\mathcal{A})`$ against predefined domain vocabularies $``\mathcal{V}_{\text{domain\_hardcoded}}``$. - **Then:** The intersection $``\text{Symbols}(\mathcal{A}) \cap \mathcal{V}_{\text{domain\_hardcoded}} = \emptyset``$ holds identically, ensuring zero hardcoded domain nouns or concrete domain assumptions. - **Diagnostic:** `E0100` emitted if any AST symbol references a prohibited domain dictionary entry. */
        part def AC_02_Zero_Domain_Vocabulary_Contamination {
        }
        doc /* - **Given:** Downstream artifact $``D_k^{\text{disk}}``$ containing uncoordinated modifications (e.g., manual alteration of `Port_1` or unmapped attribute `param_x : Real`). - **When:** The compiler reconciliation gate evaluates $``\text{Reconcile}(D_k^{\text{disk}}, \mathcal{A}_{\text{SSOT}})``$. - **Then:** Detects drift ($``D_k^{\text{disk}} \neq \psi_k(\mathcal{A}_{\text{SSOT}})``$), enforces AST primacy, halts compilation, and rejects downstream mutation. - **Diagnostic:** `E0100` emitted citing artifact path, byte offsets, divergent symbol, and expected AST digest. */
        part def AC_03_Bidirectional_Reconciliation_and_Anti_Drift_Primacy {
        }
        doc /* - **Given:** An identical schema input set $`\mathcal{I}`$ compiled in two distinct workspace mount directories $``\mathcal{R}_A``$ and $``\mathcal{R}_B``$ ($``\mathcal{R}_A \neq \mathcal{R}_B``$) on independent filesystems. - **When:** The compiler executes full compilation passes $``\mathcal{C}(\mathcal{I}, \mathcal{R}_A)``$ and $``\mathcal{C}(\mathcal{I}, \mathcal{R}_B)``$. - **Then:** Emitted binary artifacts and serialized model files achieve 0-byte difference, satisfying $``\text{SHA256}(\mathcal{C}(\mathcal{I}, \mathcal{R}_A)) \equiv \text{SHA256}(\mathcal{C}(\mathcal{I}, \mathcal{R}_B))``$. - **Diagnostic:** E0100 on digest mismatch. */
        part def AC_03_Bitwise_Output_Parity_Across_Distinct_Mount_Roots {
        }
        doc /* - **Given:** Primary syntax error at token $``\tau_{\text{last}}``$ followed by secondary syntax misalignment faults at distance $``j - \tau_{\text{last}} \le \delta``$ (where $`\delta = 3`$). - **When:** The parser processes tokens immediately following a synchronization recovery event. - **Then:** Secondary faults within the proximity window are suppressed from diagnostic sink $`\mathcal{D}`$, preventing false cascading diagnostic noise. - **Diagnostic:** Primary fault records corresponding diagnostic `E0100` (or `E0102`), while secondary faults within $`\delta \le 3`$ emit zero duplicate diagnostics. */
        part def AC_03_Cascading_Error_Suppression_Proximity_Window {
        }
        doc /* - **Given:** An incremental edit introducing a cyclic dependency $`u \to^+ u`$ (e.g., `CompilationUnit_Alpha` imports `CompilationUnit_Gamma`). - **When:** The compiler executes dependency DAG update and cycle detection. - **Then:** The compiler detects non-acyclicity, aborts AST merge, invalidates affected cache entries, and emits diagnostic error code `E0100` detailing circular path coordinates and affected unit identifiers without panicking. - **Diagnostic:** `E0100` (Cyclic dependency detected in compilation unit DAG). */
        part def AC_03_Dependency_Cycle_Detection_and_Invalidation_Fault_Rejection {
        }
        doc /* - **Given:** A structural AST node with canonical topological path $`p \in \text{TopologicalPaths}(\mathcal{S})`$ (e.g., `Package_0::Classifier_Alpha::Port_1`). - **When:** The compiler synthesizes a node identifier or document anchor. - **Then:** The generated identifier matches $``\text{UUIDv5}(\text{NS}_{\text{DEAP}}, p)``$ with version bits $``(u_6 \land 0\text{xF0}) = 0\text{x50}``$ and variant bits $``(u_8 \land 0\text{xC0}) = 0\text{x80}``$, invariant across execution hosts, environments, and timestamps. - **Diagnostic:** `E0100` emitted on UUIDv5 computation failure or bitwise variant mismatch. */
        part def AC_03_Deterministic_RFC_4122_UUIDv5_Topological_Path_Anchors {
        }
        doc /* - **Given:** An input schema referencing a source file or an artifact emission target directed outside the sovereign workspace boundary (e.g., `/etc/ambient_cfg`, `/tmp/ambient`, or user home directory). - **When:** The compiler attempts path resolution during lexical ingestion or artifact emission. - **Then:** The path confinement check detects $`p \notin \text{Workspace}(\mathcal{I}) \cup \text{BinarySelf}(\mathcal{C})`$, rejects the file operation, halts compilation immediately, and produces no filesystem mutation. - **Diagnostic:** `E0100` (Filesystem confinement boundary violation on violation). */
        part def AC_03_Filesystem_Path_Boundary_Confinement {
        }
        doc /* - **Given:** An existing on-disk artifact matching newly generated in-memory buffer $``\mathbf{b}_k``$, evaluated on any operating system. - **When:** The emission pass evaluates byte stream $``\mathbf{b}_k``$ for disk persistence. - **Then:** Textual outputs contain zero carriage return bytes ($``0\text{x0D} \notin \{ b_{k,1}, \dots, b_{k,L} \}``$), and disk writes are bypassed ($``\text{Read}(\text{path}_k) = \mathbf{b}_k``$), producing zero git diff churn. - **Diagnostic:** `E0100` if carriage return byte `0x0D` is emitted or file modification occurs on unchanged content. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_03_Line_Ending_Normalization_and_Zero_Write_Churn_Bypass {
        }
        doc /* - **Given:** Package `Package_src` importing `Package_tgt` which exports `Classifier_Beta`. - **When:** Resolving unqualified `Classifier_Beta` in `Package_src` or explicit path `Package_tgt::Classifier_Beta`. - **Then:** Evaluates unambiguously to `Package_tgt::Classifier_Beta`, verifying $``|\text{ImportTargets}(P_{\text{src}}, \text{Classifier\_Beta})| = 1``$. - **Diagnostic:** `E0100` if target symbol cannot be resolved or is private. */
        part def AC_03_Qualified_Path_Unambiguous_Import_Resolution {
        }
        doc /* - **Given:** A reference benchmark suite of canonical MBSE schemas containing $`N \le 10{,}000`$ AST nodes (`Package_0`, `Classifier_Alpha`, `Port_1`, `Flow_A`, `param_x : Real`). - **When:** The compiler executes in compiled Release mode (`--release`) within a dedicated benchmark harness on reference execution hardware. - **Then:** The 99th percentile wall-clock execution latency across 1,000 iterations satisfies $``p_{99} \le 25\text{ ms}``$ ($``\Delta t \le T_{\max}``$). - **Diagnostic:** `E0100` emitted if 99th percentile compilation latency exceeds 25 ms. */
        part def AC_03_Release_Compilation_Latency_Bound_le_25_text {
        }
        doc /* - **Given:** An AST pass requiring entity handles or an input model containing entity identifier attributes. - **When:** Identifier generation or ingestion is evaluated. - **Then:** Per Directive 1, the compiler rejects all time-based UUIDs (UUIDv1, UUIDv6, UUIDv7) and random UUIDs (UUIDv4), enforcing deterministic RFC 4122 UUIDv5 exclusively to protect Merkle root digests. - **Diagnostic:** `E0100` emitted on detection of unauthorized UUID variants or time-dependent identifier schemes. */
        part def AC_03_Strict_Prohibition_of_Time_Based_Random_UUIDs {
        }
        doc /* - **Given:** An input schema source containing a declared attribute `param_x : Real` in $`\text{ASTNodes}(\mathcal{S})`$, but where an erroneous lowering pass drops the attribute from synthesized AST $`\mathcal{A}`$. - **When:** The provenance gate verifies range completeness $`\text{Range}(\Pi) \supseteq \text{ASTNodes}(\mathcal{S})`$. - **Then:** The compiler detects the unmapped source node in $`\text{ASTNodes}(\mathcal{S})`$, halts compilation immediately, and refuses downstream code generation. - **Diagnostic:** Diagnostic `E0100` emitted with source file identifier, line, column, and token byte span of `param_x`. */
        part def AC_03_Surjective_Lexical_Range_Completeness_Enforcement {
        }
        doc /* - **Given:** An unbalanced workload distributed across worker-local deques $``Q_i``$. - **When:** Worker thread $``\tau_i``$ empties local deque $``Q_i``$ while remote deque $``Q_j \ne \emptyset``$ contains pending tasks. - **Then:** Worker $``\tau_i``$ steals tasks from the top of remote deque $``Q_j``$ via lock-free atomic operations without blocking other workers, sustaining throughput until all task deques are exhausted. - **Diagnostic:** `E0100` emitted if thread starvation loops exceed timeout bounds or if deque corruption occurs. */
        part def AC_03_Work_Stealing_Deque_Execution_Dynamic_Load_Balancing {
        }
        doc /* - **Given:** Front-end lexical analysis and AST construction executing on input schema buffer $``\mathcal{B}_{\text{file}}``$. - **When:** A memory profiling test harness intercepts dynamic heap allocator calls during $``\text{ParsePass}(\mathcal{B}_{\text{file}})``$. - **Then:** The measured individual heap allocation count satisfies $``\text{HeapAllocs}(\text{ParsePass}(\mathcal{B}_{\text{file}})) = 0``$, with the sole permitted exception being string byte copies into the global deduplicated symbol interner pool per REQ-0036. - **Diagnostic:** `E0100` emitted if an unauthorized individual node or token heap allocation occurs during parsing. */
        part def AC_03_Zero_Individual_Heap_Allocation_Enforcement {
        }
        doc /* - **Given:** A compiled workspace rooted at absolute filesystem path $`\mathcal{R}`$. - **When:** Downstream code generators and artifact sinks emit generated code, debug metadata, and serialized AST caches. - **Then:** Binary and textual inspection across 100% of generated artifacts $`a \in \text{Artifacts}(\mathcal{C}(\mathcal{I}, \mathcal{R}))`$ confirms $`\text{ContainsSubstring}(a, \text{PathString}(\mathcal{R})) \equiv \text{false}`$, with zero host usernames or machine prefixes. - **Diagnostic:** E0100 on path string leakage. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Absolute_Path_Non_Leakage_in_Generated_Artifacts {
        }
        doc /* - **Given:** Two identical input schema token streams $``\mathcal{S}_1``$ and $``\mathcal{S}_2``$ such that $``\mathcal{S}_1 = \mathcal{S}_2``$. - **When:** The compilation pipeline $`\mathcal{C}`$ executes in isolated environments or independent process invocations. - **Then:** The resulting AST models and emitted byte streams satisfy $``\mathcal{C}(\mathcal{S}_1) = \mathcal{C}(\mathcal{S}_2)``$ with 0-byte diff churn. - **Diagnostic:** `E0100` emitted if serialized outputs diverge across repeated compilations of identical inputs. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Bitwise_Determinism_across_Repeated_Invocations {
        }
        doc /* - **Given:** Degenerate schema document containing $`M`$ syntax errors where $``M \ge C_{\text{max\_errors}}``$. - **When:** The front-end parser accumulates diagnostics up to capacity limit $``C_{\text{max\_errors}}``$. - **Then:** The parser halts further error reporting, appends a final diagnostic sentinel indicating capacity exhaustion, and gracefully concludes the parse pass without crashing or allocating unbounded memory. - **Diagnostic:** Diagnostic `E0199` emitted as the terminating diagnostic indicating maximum error ceiling exceeded. */
        part def AC_04_Bounded_Diagnostic_Sink_Capacity_Graceful_Termination {
        }
        doc /* - **Given:** A bump arena segment $``\mathcal{A}_{\text{arena}}``$ holding $`N`$ allocated AST nodes following completion of a compilation unit pass. - **When:** The compiler front-end releases AST memory resources via $``\text{Reset}(\mathcal{A}_{\text{arena}})``$. - **Then:** The entire arena chunk is recycled or deallocated in a single bulk operation with $``\text{ArenaOffset}_{\text{reset}} = 0``$ in $`O(1)`$ constant time, avoiding per-node destructor traversal or individual free list maintenance. - **Diagnostic:** `E0100` emitted if arena pointer reset fails or individual node deallocations are invoked. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Bulk_Arena_Deallocation_Lifetime_Reset {
        }
        doc /* - **Given:** Package `Package_src` importing `Package_1` and `Package_2`, both exporting `Classifier_Gamma`. - **When:** Resolving unqualified `Classifier_Gamma` in `Package_src`. - **Then:** Rejects binding due to multiple targets ($``|\text{ImportTargets}(P_{\text{src}}, \text{Classifier\_Gamma})| = 2 \gt 1``$), recording diagnostic into error sink. - **Diagnostic:** `E0100` citing ambiguous symbol and conflicting source packages. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Conflicting_Import_Ambiguity_Detection {
        }
        doc /* - **Given:** An AST cache state where the cached entry for `CompilationUnit_Beta` is missing or fails hash integrity verification. - **When:** Incremental compilation queries the cache during dependency resolution. - **Then:** The compiler detects cache inconsistency, discards corrupted entries for `CompilationUnit_Beta` and its dependents, recomputes the affected subgraph from source, updates cache records, and emits valid AST $``\mathcal{A}_{\text{inc}} \equiv \mathcal{A}_{\text{full}}``$. - **Diagnostic:** `E0100` on unhandled cache read faults or unverified AST emission. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Corrupted_Cache_Record_Invalidation_and_Fallback_Recovery {
        }
        doc /* - **Given:** Identical input schema specification `Package_0` compiled on two distinct host platforms $``\mathcal{E}_1``$ and $``\mathcal{E}_2``$ differing in hostname, UID/GID, system locale, and timezone. - **When:** The compiler processes the model and emits target artifacts and intermediate representations. - **Then:** Emitted artifacts across $``\mathcal{E}_1``$ and $``\mathcal{E}_2``$ produce bitwise-identical cryptographic digests ($``\mathcal{C}(\mathcal{I}, \mathcal{E}_1) \equiv \mathcal{C}(\mathcal{I}, \mathcal{E}_2)``$) with zero byte drift. - **Diagnostic:** `E0100` (Non-deterministic environmental leakage or digest mismatch on violation). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Cross_Host_Bitwise_Output_Reproducibility {
        }
        doc /* - **Given:** Downstream artifact $``D_k^{\text{disk}}``$ evaluated during reverse-synchronization or ingestion passes. - **When:** Extraction operator $``\mathcal{F}_{\text{arch}}(D_k^{\text{disk}})``$ parses structural elements. - **Then:** Confirms $``\mathcal{F}_{\text{arch}}(D_k^{\text{disk}}) \subseteq V(\mathcal{A}_{\text{SSOT}})``$ and $``\mathcal{F}_{\text{arch}}(D_k^{\text{disk}}) \setminus V(\mathcal{A}_{\text{SSOT}}) = \emptyset``$, rejecting invented classifiers or ports. - **Diagnostic:** `E0100` emitted if downstream content introduces structural elements absent from $``\mathcal{A}_{\text{SSOT}}``$. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Downstream_Non_Invention_Enforcement {
        }
        doc /* - **Given:** An AST node originating from an absolute host filesystem path (e.g., `/opt/workspace/model/Package_0.sysml`). - **When:** Canonical path $``\mathcal{N}_{\text{topological}}``$ is constructed for UUIDv5 generation. - **Then:** The compiler strips all filesystem roots, drive letters, and host paths, constructing $``\mathcal{N}_{\text{topological}}``$ strictly from model-relative package qualifiers (`Package_0::Classifier_Alpha`). - **Diagnostic:** `E0100` emitted if un-sanitized filesystem mount paths or host environment strings contaminate the topological namespace. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Host_Filesystem_Path_Stripping_Canonical_Scope_Normalization {
        }
        doc /* - **Given:** Compilation pipeline execution under standard continuous integration (CI) functional logic test runs versus dedicated performance benchmark runs. - **When:** CI tests execute in non-release mode or uncalibrated virtualized environments ($`\text{IsolatedFromCI}(\mathcal{E}) \equiv \text{false}`$). - **Then:** Latency threshold gates are deactivated ($`\text{BenchmarkingGate} = \text{Inactive}`$), preventing CI test flakiness, and activate strictly within the isolated release benchmark harness ($``\mathcal{E} = \mathcal{E}_{\text{release}}``$). - **Diagnostic:** `E0100` emitted if benchmark performance gates are evaluated within standard CI logic runs. */
        part def AC_04_Isolated_Performance_Benchmarking_Gate {
        }
        doc /* - **Given:** A synthesized AST $`\mathcal{A}`$ containing an ungrounded node `Classifier_Beta` inserted without a corresponding entry in $`\text{ASTNodes}(\mathcal{S})`$ and without a valid RFC 4122 UUIDv5 topological anchor. - **When:** The provenance gate traverses $`\text{Nodes}(\mathcal{A})`$ and checks $`\Pi(n)`$. - **Then:** The compiler detects $`\Pi(n) = \bot`$, halts compilation in a fail-closed manner, and emits a structured error. - **Diagnostic:** Diagnostic `E0100` emitted with offending AST node identifier and error message detailing lack of lexical provenance. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Rejection_of_Hallucinated_or_Ungrounded_AST_Nodes {
        }
        doc /* - **Given:** Synthetic MBSE model elements (`Package_0`, `Classifier_Alpha`, `Port_1`, `Flow_A`, `param_x : Real`) compiled under varying thread counts ($`P \in \{1, 2, 4, 8\}`$) and randomized scheduling delays. - **When:** Parallel worker tasks complete and merge intermediate results into the final unified AST and emitted artifacts. - **Then:** Deterministic reduction ordering produces 100% bitwise identical output representations across all execution schedules ($``\mathcal{O}(\pi_1) = \mathcal{O}(\pi_2)``$), asserting 0-byte diff churn against single-threaded baselines. - **Diagnostic:** `E0100` emitted if emitted AST digests or generated artifacts diverge across different thread counts or execution schedules. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Schedule_Independent_Bitwise_Determinism_across_Reductions {
        }
        doc /* - **Given:** Deeply nested or cyclic schema declarations up to maximum hierarchy depth $``D_{\max} = 16``$. - **When:** The compiler executes symbol resolution and cyclic dependency analysis. - **Then:** Execution terminates in bounded elementary computational steps $`\text{Steps}(\mathcal{C}(s)) \le K(|s|) \lt \infty`$ without infinite recursion, thread starvation, or deadlock. - **Diagnostic:** `E0100` emitted if execution step cutoff is exceeded or recursion cycle fails to resolve. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_05_Deterministic_Finite_Step_Termination {
        }
        doc /* - **Given:** Syntactically invalid schema documents compiled in Release mode across multiple execution environments and thread scheduling configurations. - **When:** The compiler executes the synchronization recovery engine. - **Then:** Execution completes under a total-function contract with zero unhandled panics or crashes, returning a structured non-zero error status with 100% bitwise identical diagnostic output across repeated executions. - **Diagnostic:** `E0100` through `E0199` emitted in structured JSON or text format with zero panic stack unwinding. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_05_Total_Determinism_Panic_Free_Non_Zero_Exit {
        }
        doc /* The compiler platform shall function strictly as an abstract Model-Based Systems Engineering (MBSE) compiler, deriving all synthesized intermediate representations, verification models, downstream specification projections, and interface definitions deterministically from user-provided schema inputs. The compiler must operate exclusively on generic systems engineering metamodel primitives: Classifiers, Feature Usages, Abstract Ports, Directional Connectors, Mathematical Constraints, Discrete State Transitions, and Occurrence Lifecycles. Compilation passes, lowering pipelines, code generators, and autonomous tooling agents are strictly prohibited from hardcoding, injecting, or assuming domain-specific concepts, domain vocabularies, or heuristic domain assumptions into pipeline logic, templates, intermediate representations, or emitted artifacts. All illustrative examples, test fixtures, and internal representations shall utilize purely synthetic abstract placeholders (e.g., `Package_0`, `Classifier_Alpha`, `Port_1`, `Flow_A`, `param_x : Real`). When synthetic structural identifiers or topological anchors are generated for intermediate representations or scaffolding nodes, they shall be deterministically derived via RFC 4122 UUIDv5 namespace hashing rooted in a fixed compiler namespace UUID constant ($``\text{NS}_{\text{DEAP}}``$) and the fully qualified topological path of the element within the abstract syntax tree containment hierarchy. If any compilation stage detects an ungrounded domain term or non-schema symbol outside the formal grammar vocabulary and synthetic anchor set, the compiler shall halt execution immediately and emit diagnostic error code `E0100`. --- */
        part def _1_Normative_Statement {
        }
        doc /* Let $`\mathcal{S}`$ denote the set of input schema tokens and $``\mathcal{K}_{\text{grammar}}``$ denote the fixed vocabulary of compiler grammar keywords. Let $`\text{Symbols}(\mathcal{A})`$ denote the set of all symbol identifiers present in synthesized abstract syntax tree $`\mathcal{A}`$. Let $`\text{TopologicalPaths}(\mathcal{S})`$ denote the set of fully qualified topological paths derived from $`\mathcal{S}`$, and let $``\text{NS}_{\text{DEAP}} \in \{0, 1\}^{128}``$ denote the fixed RFC 4122 namespace UUID constant. Universal Symbol Grounding Invariant: \forall \sigma \in \text{Symbols}(\mathcal{A}), \quad \sigma \in \text{Tokens}(\mathcal{S}) \cup \mathcal{K}_{\text{grammar}} \cup \text{Synthetic}(\mathcal{S}) where synthetic symbols derive deterministically via RFC 4122 UUIDv5 topological path hashing: \text{Synthetic}(\mathcal{S}) = \{ \text{UUIDv5}(\text{NS}_{\text{DEAP}}, p) \mid p \in \text{TopologicalPaths}(\mathcal{S}) \} Deterministic Pipeline Mapping Invariant: The compiler pipeline execution is modeled as a total deterministic mapping $`\mathcal{C}`$: \mathcal{C} : \mathcal{S} \longrightarrow \mathcal{A} such that identical input schema token streams yield identical abstract syntax tree structures: \forall \mathcal{S}_1, \mathcal{S}_2, \quad \mathcal{S}_1 = \mathcal{S}_2 \implies \mathcal{C}(\mathcal{S}_1) = \mathcal{C}(\mathcal{S}_2) Zero Hardcoded Domain Concepts Invariant: Let $``\mathcal{V}_{\text{domain\_hardcoded}}``$ represent any predefined domain-specific terminology, domain ontology, or non-schema concept dictionary. The synthesized AST satisfies: \text{Symbols}(\mathcal{A}) \cap \mathcal{V}_{\text{domain\_hardcoded}} = \emptyset Synthetic Identifier RFC 4122 Bit Invariant: For each synthetic identifier $``U = \text{UUIDv5}(\text{NS}_{\text{DEAP}}, p) = (u_0, u_1, \dots, u_{15}) \in (\mathbb{Z}_{256})^{16}``$, the version and variant fields satisfy: \begin{aligned} (u_6 \land 0\text{xF0}) &= 0\text{x50} \\ (u_8 \land 0\text{xC0}) &= 0\text{x80} \end{aligned} --- */
        part def _2_Formal_Invariant {
        }
        doc /* The compilation pipeline operates within Complexity Class $`\mathbf{P}`$. Token scanning, symbol table interning, and schema set membership verification execute in deterministic linear time $`O(N)`$ with respect to total input schema token count $`N = |\text{Tokens}(\mathcal{S})|`$. Synthetic topological anchor generation and path hashing execute in $`O(V + E)`$ where $`V = |\text{Nodes}(\mathcal{A})|`$ and $`E = |\text{Edges}(\mathcal{A})|`$ represent AST hierarchy vertices and containment edges. Foundational schema ingestion and validation require no combinatorial search, bypassing NP-hard frontiers (e.g., NP-1 through NP-8) and guaranteeing total-function polynomial termination. --- */
        part def _3_Computational_Complexity_Algorithmic_Bounds {
        }
        part def _4_Verification_Conformance_Criteria {
        }
    }
    doc /* Universal Schema Ingestion Engine */
    package Subsystem_2_Universal_Schema_Ingestion_Engine {
        doc /* UUIDv5: a5840107-5c1d-59b3-bdf6-acd7ea1d1e16 | Complexity: Class P (O(K) = O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100 */
        requirement def REQ_0014_File_Format_Detection_Engine_by_Extension {
            id = "REQ-0014";
            text = "The compiler ingestion engine shall classify input schema files into target schema formats using file extensions and deterministic content prefix signatures across 5 supported formats: CommonMark Markdown tables (.md, .markdown), Protocol Buffers (.proto), OMG IDL (.idl), OpenAPI schemas (.json,";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: d51a9578-d15d-5631-893d-786553664acf | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100, E0102 */
        requirement def REQ_0015_Event_Driven_CommonMark_Table_Lexer {
            id = "REQ-0015";
            text = "The ingestion engine shall parse CommonMark Markdown tables containing component declarations, interfaces, attributes, and constraints using an explicit deterministic pushdown automaton (DPDA) that emits an event stream of structural tokens. Lexing and tokenization must strictly prohibit regular";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: 9669c5f2-4c8c-5b0e-b489-c8e5fb38258d | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0102, E0199 */
        requirement def REQ_0016_Synchronization_Token_Recovery_on_Table_Delimiter_Boundaries {
            id = "REQ-0016";
            text = "The CommonMark table parser within the Universal Schema Ingestion Engine shall implement Synchronization Token Error Recovery on table delimiter boundaries per Architectural Directive 4. When encountering unexpected formatting, unescaped pipe characters, malformed scalar literals, or delimiter";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: 5ea507dc-aeda-56ff-8536-2f8238aa0ab7 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0102 */
        requirement def REQ_0017_Dynamic_Semantic_Header_Key_Normalization {
            id = "REQ-0017";
            text = "The CommonMark tabular schema parser within the Universal Schema Ingestion Engine shall implement dynamic semantic header key normalization and order-independent column binding for all tabular model specifications. The parser shall accept column headers in arbitrary horizontal order and normalize";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: ccce39a3-18dd-539a-8528-1eddf58848cf | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100, E0102 */
        requirement def REQ_0018_Multi_Line_Table_Cell_Block_Token_Preservation {
            id = "REQ-0018";
            text = "The CommonMark table parser within the Universal Schema Ingestion Engine shall preserve multi-line cell content, nested bullet points, list items, and inline code spans within table cells without dropping formatting, truncating text, or losing structural hierarchy. The engine must normalize";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: 1519acae-b878-52ea-b0cf-f40957205d2e | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0102 */
        requirement def REQ_0019_Table_Row_to_Entity_Structural_Mapping {
            id = "REQ-0019";
            text = "The CommonMark table parser within the Universal Schema Ingestion Engine shall map each valid table row to a corresponding intermediate representation (IR) entity in contiguous memory storage while sanitizing raw entity names into valid OMG SysML v2 and KerML basic identifiers using deterministic";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: dc278a56-3a19-5113-a2ee-85edd2f01cf3 | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0102 */
        requirement def REQ_0020_Disambiguation_of_Array_Indexing_Syntax_in_Tabular_Schemas {
            id = "REQ-0020";
            text = "The CommonMark table parser within the Universal Schema Ingestion Engine shall implement deterministic lexical disambiguation of array indexing syntax across tabular MBSE schemas. When ingesting cell tokens for structural identifiers, component references, port bindings, or interconnect endpoints,";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: 6e0f876b-a57c-55e4-bee6-606761e29ebf | Complexity: Class P (O(R \cdot C) = O(R)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0102, E0103 */
        requirement def REQ_0021_Tabular_Schema_Ingestion_for_Structural_Parts {
            id = "REQ-0021";
            text = "The Universal Schema Ingestion Engine shall parse CommonMark tabular schemas specifying structural parts and component assemblies into IngestedPart intermediate entities. For each data row, the parser shall extract the part definition or usage name, the classifier type reference, the multiplicity";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: 630738dc-98d6-5c15-b60e-be7d63747ff4 | Complexity: Class P (O(N)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0102, E0199 */
        requirement def REQ_0022_Tabular_Schema_Ingestion_for_Directed_Ports {
            id = "REQ-0022";
            text = "The CommonMark table parser within the Universal Schema Ingestion Engine shall parse tabular schemas specifying directed ports into intermediate IngestedPort AST entities. For each data row, the parser shall extract the port identifier, owning component handle, declared direction (in, out, inout),";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: b6878261-7ad9-5e86-8860-11f38dabeb81 | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0103, E0199 */
        requirement def REQ_0023_Tabular_Schema_Ingestion_for_Attributes_Data_Types {
            id = "REQ-0023";
            text = "The Universal Schema Ingestion Engine shall parse CommonMark tabular schemas specifying classifier attributes, scalar types, default values, engineering units, and numerical bounds into IngestedAttr AST entities. The parser shall map columns via an order-independent binding vector into canonical";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: e4fb977a-d151-565b-8da7-606b66917657 | Complexity: Class P (O(R) = O(N)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0102, E0103, E0199 */
        requirement def REQ_0024_Tabular_Schema_Ingestion_for_Formal_Constraints {
            id = "REQ-0024";
            text = "The Universal Schema Ingestion Engine shall parse CommonMark tabular schemas defining formal constraints, safety conditions, and operational envelopes into strongly typed IngestedConstraint AST entities. For each row, the parser shall extract the constraint identifier (id), owning classifier";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: ae9aa9c2-1f29-5263-a58e-3cba1992ff78 | Complexity: Class P (O(N)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0102, E0104, E0199 */
        requirement def REQ_0025_Tabular_Schema_Ingestion_for_Topological_Connections {
            id = "REQ-0025";
            text = "The CommonMark table parser within the Universal Schema Ingestion Engine shall parse tabular schemas specifying topological connections into IngestedConnection intermediate AST entities. For each data row, the parser must extract the connection identifier, source port endpoint path (P_{src}),";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: e6cb1f58-e661-5f2d-9527-46446efe9c27 | Complexity: Class P (O(N)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0102, E0199 */
        requirement def REQ_0026_Tabular_Schema_Ingestion_for_Behaviors_Actions {
            id = "REQ-0026";
            text = "The Universal Schema Ingestion Engine shall parse CommonMark tables specifying behavioral actions, activities, and discrete state transitions into intermediate IngestedAction and IngestedTransition AST entities. For action rows, the parser must extract action identifier id, owning classifier";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: 5b117440-5bfe-5366-b221-545d6925be8e | Complexity: Class P (O(N)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100, E0102, E0103 */
        requirement def REQ_0027_Protocol_Buffer_AST_Ingestion_for_Messages_Fields {
            id = "REQ-0027";
            text = "The compiler ingestion engine shall provide a native Protocol Buffer version 3 (Proto3) parser that ingests .proto schemas into intermediate schema representation (IR) without external toolchain dependencies. The engine shall lower Protobuf messages to IngestedPart definitions, fields to typed";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: a9a1f791-92a5-55df-acd8-b9cab8846282 | Complexity: Class P (O(N)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0102, E0103 */
        requirement def REQ_0028_OMG_IDL_AST_Ingestion_for_Structs_Interfaces {
            id = "REQ-0028";
            text = "The compiler ingestion engine shall parse OMG IDL (.idl) specifications into intermediate schema representation (IR) without external preprocessors. The engine shall lower IDL module namespaces to nested IngestedPackage scopes, struct definitions to IngestedClassifierDef data types with sequential";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: 06c88f7d-e7cc-5a68-b123-8eee898e6222 | Complexity: Class P (O(N)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100, E0102, E0103, E0199 */
        requirement def REQ_0029_OpenAPI_Schema_Ingestion_for_Paths_Operations {
            id = "REQ-0029";
            text = "The Universal Schema Ingestion Engine shall parse OpenAPI 3.0 and 3.1 specifications in JSON and YAML formats into intermediate schema IR without external dependencies. The root document lowers to an IngestedPackage (e.g., Package_0::Spec_Alpha). Schema objects under components/schemas lower to";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: bceb80d9-77ea-515d-ae33-a6759f04e5a4 | Complexity: Class P (O(N)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100, E0102, E0103, E0199 */
        requirement def REQ_0030_XML_Schema_Definition {
            id = "REQ-0030";
            text = "The Universal Schema Ingestion Engine shall provide a native XML Schema Definition (W3C XSD) and Architecture Description Language (ADL) parser that ingests structural schemas and component topologies into intermediate schema IR without external toolchains. The parser must execute via a";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: a6c05a65-2060-5b96-ac10-393764de929f | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0102, E0103, E0199 */
        requirement def REQ_0031_Canonical_SysML_v2_Textual_Model_Emission {
            id = "REQ-0031";
            text = "The compiler ingestion engine shall provide a canonical SysML v2 textual concrete syntax emitter (E_{sysml}) that serializes parsed intermediate schema IR entities into standard-compliant OMG SysML v2 textual notation, writing the unified model atomically to schema/model.sysml.";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: 2f859e57-faf5-5088-8de9-da3a720d19be | Complexity: Class P (O(L)) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0100, E0102, E0199 */
        requirement def REQ_0032_Deterministic_Qualified_Name_Symbol_Sorting_for_Canonical_Model_Emission {
            id = "REQ-0032";
            text = "The textual emission and model serialization engine shall sort all model declarations--packages, classifiers, ports, attributes, connections, constraints, and behaviors--strictly by canonical fully qualified name prior to canonical model emission (schema/model.sysml, REQ-0031) and serialized";
            satisfy by UniversalIngestionEngine;
        }
        doc /* UUIDv5: 2d5fcd67-d3b5-5eb5-bfe7-275743473fc2 | Complexity: Class P (O(B)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100, E0102 */
        requirement def REQ_0033_Multi_File_Cryptographic_Digest_Computation {
            id = "REQ-0033";
            text = "The compiler ingestion engine shall compute, record, verify, and persist a multi-file cryptographic manifest recording SHA-256 content hashes, byte sizes, line counts, and AST entity counts for all workspace schema input files and the emitted canonical model (schema/model.sysml). The manifest shall";
            satisfy by UniversalIngestionEngine;
        }
        doc /* Primary execution engine for Universal Schema Ingestion Engine */
        part def UniversalIngestionEngine {
            port in schema_in : RawSchemaStreamPort;
            port out token_out : TokenStreamPort;
        }
        doc /* - **Given:** CommonMark table declaring actions `Action_0` and `Activity_Alpha` with inputs (`param_in : Real`), outputs (`param_out : Integer`), trigger `Event_0`, guard `guard_cond_0`, and constraints `pre_0`, `post_0`. - **When:** The parser ingests and lowers table rows. - **Then:** 100% of rows lower into `IngestedAction` AST nodes in contiguous AST storage with valid symbol handles, disjoint parameter sets, and zero diagnostics. - **Diagnostic:** `E0102` emitted on extraction or parameter syntax failure. */
        part def AC_01_Canonical_Behavioral_Action_Ingestion {
        }
        doc /* - **Given:** A CommonMark table declaring structural parts with names, classifier types, and multiplicity strings (`[1..*]`, `[0..1]`, `[2..4]`). - **When:** Lowering table rows into `IngestedPart` entities. - **Then:** 100% of rows lower into valid typed arena nodes with interned `SymbolId` handles, accurate bounds $`\langle l, u \rangle`$, and stable node offsets. - **Diagnostic:** `E0102` on AST generation failure. */
        part def AC_01_Canonical_Component_Definition_Lowering {
        }
        doc /* - **Given:** Valid XSD/ADL document declaring complex type `Type_Alpha` and component `Component_Alpha` with attributes `param_x : Real` and `param_y : Int32`. - **When:** Lowering the XML AST into intermediate schema IR. - **Then:** Emits `IngestedPart` entities containing `IngestedAttr` entries with exact scalar types in AST storage without diagnostics. - **Diagnostic:** `E0100` on XML grammar failure. */
        part def AC_01_Canonical_Component_and_Complex_Type_Lowering {
        }
        doc /* - **Given:** Valid table declaring connection `Conn_0` between `Part_0::Port_1` and `Part_1::Port_2` with protocol `Protocol_A` and latency bound `5.0`. - **When:** Lowering the connection row. - **Then:** Emits `IngestedConnection` with decomposed `OwnerPath` and `PortIdentifier` in AST storage without diagnostics. - **Diagnostic:** `E0104` on failure. */
        part def AC_01_Canonical_Connection_Ingestion_and_Endpoint_Decomposition {
        }
        doc /* - **Given:** Valid Proto3 schema with message `Message_Alpha`, fields (`Field_1 : int32 = 1`, `Field_2 : string = 2`, `Field_3 : Message_Beta = 3`), and multiplicity qualifiers (\texttt{repeated}, \texttt{optional}, singular). - **When:** Lowering the AST into intermediate schema IR. - **Then:** Emits `IngestedPart` and `IngestedAttr` with exact types, tags, and multiplicities ($`\langle 0, \infty \rangle`$, $`\langle 0, 1 \rangle`$, $`\langle 1, 1 \rangle`$) without diagnostics. - **Diagnostic:** `E0100` on parsing failure. */
        part def AC_01_Canonical_Message_and_Field_Lowering {
        }
        doc /* - **Given:** Valid OpenAPI 3.0/3.1 document declaring schema `Schema_Alpha` and path `/endpoint_alpha` (`get`, `post`). - **When:** Ingesting and lowering into schema IR. - **Then:** Synthesizes `IngestedPackage`, `IngestedClassifierDef`, and two `IngestedAction` entities in AST storage without diagnostics. - **Diagnostic:** `E0100` or `E0102` on lowering failure. */
        part def AC_01_Canonical_Schema_and_Path_Lowering {
        }
        doc /* - **Given:** Valid IDL declaring `struct Struct_Alpha { long field_1; boolean flag_2; };`, `union Union_Beta switch (short) { case 1: long v1; default: boolean v2; };`, and `typedef double Real_Alias;`. - **When:** The parser ingests and lowers declarations into intermediate schema IR. - **Then:** Emits `IngestedClassifierDef` (kind: Struct, Union) with typed members and discriminant cases, emits `IngestedTypeDef`, and allocates nodes in contiguous AST storage with stable offsets. - **Diagnostic:** `E0102` on syntax fault; `E0103` on discriminant type mismatch. */
        part def AC_01_Canonical_Struct_Union_and_Typedef_Lowering {
        }
        doc /* - **Given:** Schema IR with `Package_0`, `Classifier_Alpha`, ports `Port_1`, `Port_2`, attributes, connections, constraints, and actions. - **When:** Synthesizing the canonical SysML v2 model via $``\mathcal{E}_{\text{sysml}}``$. - **Then:** Emits valid concrete syntax to `schema/model.sysml` parsing cleanly with zero diagnostics. - **Diagnostic:** `E0102` on syntax mapping failure. */
        part def AC_01_Canonical_SysML_v2_Syntax_Emission {
        }
        doc /* - **Given:** A valid CommonMark table declaring MBSE structural entities (`Package_0`, `Classifier_Alpha`, `Port_1`, `Flow_A`, `param_x : Real`) encoded as a contiguous UTF-8 byte stream. - **When:** The table lexer $``M_{\text{table}}``$ executes the lexical analysis pass. - **Then:** The lexer emits a balanced stream of structural tokens $``\mathcal{S}_{\text{events}}``$ on-the-fly via the streaming sink, satisfying $``\text{count}(\text{StartCell}, \mathcal{S}_{\text{events}}) = \text{count}(\text{EndCell}, \mathcal{S}_{\text{events}})``$ and $``\text{count}(\text{StartRow}, \mathcal{S}_{\text{events}}) = \text{count}(\text{EndRow}, \mathcal{S}_{\text{events}})``$ without intermediate full-tree buffering. - **Diagnostic:** `E0100` emitted on token stream generation failure or unbalanced structural tags. */
        part def AC_01_Deterministic_Event_Driven_Streaming_Tokenization {
        }
        doc /* - **Given:** CommonMark table cell $``C_{\text{raw}}``$ containing break variants (`<br>`, `<br/>`, `<br />`, `<BR>`, `<BR/>`, `<BR />`) and escaped linefeeds (`\n`, `\r\n`) around text tokens (`param_x : Real`). - **When:** Block normalizer pass $``\Phi_{\text{block}}``$ executes during table ingestion. - **Then:** Every break sequence normalizes to $``\text{LineBreak}(\text{SYM}_{\text{LF}})``$, preserving surrounding text without loss. - **Diagnostic:** `E0100` emitted on invalid escape sequences or corrupted break delimiters. */
        part def AC_01_HTML_Line_Break_Variant_and_Escaped_Linefeed_Normalization {
        }
        doc /* - **Given:** 5-row CommonMark table with entities (`Package_0`, `Classifier_Alpha`, `Port_1`, `Flow_A`, `param_x : Real`) and syntax faults in rows 2 and 4. - **When:** The parser ingests the table in a single compilation pass. - **Then:** Rows 1, 3, and 5 lower into valid AST nodes, rows 2 and 4 retain valid cells with $``\bot_{\text{cell}}``$ at faulted positions, and exactly 2 diagnostics are emitted. - **Diagnostic:** Emits localized `E0102` diagnostics with 1-indexed coordinates and byte spans. */
        part def AC_01_Multi_Error_Resynchronization_Across_Row_Boundaries {
        }
        doc /* - **Given:** Canonical schema files covering all 5 supported formats containing synthetic MBSE declarations (`Package_0`, `Classifier_Alpha`, `Port_1`, `Flow_A`, `param_x : Real`). - **When:** The ingestion engine executes format classification $`\Delta(F)`$. - **Then:** Each file is classified into its matching format (`MarkdownTable`, `Protobuf`, `OmgIdl`, `OpenApi`, `XmlSchema`) with 100% precision and zero false positives. - **Diagnostic:** None emitted on valid format classification. */
        part def AC_01_Multi_Format_Classification_Precision {
        }
        doc /* - **Given:** A CommonMark table defining component `Classifier_Alpha` with canonical columns $`\langle \text{Name}, \text{Type}, \text{Multiplicity}, \text{Description} \rangle`$. - **When:** The compiler ingests tables across all $`4! = 24`$ column permutations (e.g., $`\langle \text{Description}, \text{Name}, \text{Type}, \text{Multiplicity} \rangle`$). - **Then:** All 24 permuted tables synthesize bitwise identical AST entities with zero diff churn. - **Diagnostic:** Deterministic AST generation; zero diagnostics emitted. */
        part def AC_01_Order_Independent_Column_Permutation_Invariance {
        }
        doc /* - **Given:** AST with 500 declarations across packages, classifiers, ports, and attributes in arbitrary order. - **When:** Sorting symbols by qualified name and emitting canonical SysML v2 text across 20 randomized orderings. - **Then:** All 20 emitted output byte streams produce identical SHA-256 digests, confirming zero diff churn ($`\text{Diff} = \emptyset`$). - **Diagnostic:** `E0100` on bitwise determinism mismatch. */
        part def AC_01_Permutation_Invariance_and_Zero_Diff_Churn {
        }
        doc /* - **Given:** Tabular cells with bracketed identifiers (`Part_Alpha[0]`, `Port_1[42]`, `Flow_A[65535]`). - **When:** Lowering cells via disambiguation pass $``\theta_{\text{array}}``$. - **Then:** Decomposes into interned base symbol `SymbolId` and 32-bit unsigned integers ($`0, 42, 65535`$) in `IndexedReferenceNode`. - **Diagnostic:** `E0102` on decomposition failure. */
        part def AC_01_Positive_Single_Dimensional_Array_Indexing {
        }
        doc /* - **Given:** A tabular schema with attributes across `Real`, `Integer`, `Boolean`, and `String`, valid intervals (`[0.0, 100.0]`, `(0, 50]`, `[-10, 10]`, `[0.0, +inf)`), defaults, and SI units (`"m/s"`, `"kg"`). - **When:** The parser processes table rows. - **Then:** Each row synthesizes an `IngestedAttr` AST node with exact SI exponent vector $`\mathbf{u} \in \mathbb{Q}^7`$, exact boundary limits, and zero diagnostics. - **Diagnostic:** None emitted. */
        part def AC_01_Valid_Attribute_Numerical_Envelope_Extraction {
        }
        doc /* - **Given:** A table row declaring an entity with raw name cell $``S_{\text{raw}} = \text{"Classifier\_Alpha"}``$ conforming to $`\text{BasicIdentifier}`$. - **When:** The ingestion engine executes identifier sanitization $``\sigma_{\text{id}}(S_{\text{raw}})``$. - **Then:** The identifier passes through unaltered with $``\sigma_{\text{id}}(S_{\text{raw}}) = \text{"Classifier\_Alpha"}``$. - **Diagnostic:** Diagnostic `E0102` emitted if a valid basic identifier is mutated or rejected. */
        part def AC_01_Valid_Basic_Identifier_Passthrough {
        }
        doc /* - **Given:** Tabular rows containing constraint expressions (`param_x >= 0.0 && param_x <= 100.0`, `param_a + param_b == param_c`, `!(flag_1 && flag_2) || state == State_A`). - **When:** Ingestion pass executes. - **Then:** 100% of raw expression strings in synthesized `IngestedConstraint` AST entities match source cell byte slices with 0-byte divergence. - **Diagnostic:** `E0102` on cell extraction failure or byte mutation. */
        part def AC_01_Verbatim_Constraint_Expression_Ingestion {
        }
        doc /* - **Given:** Schema input file $`F`$ of size $`|F| \ge 10\,\text{MB}`$. - **When:** The format detection engine inspects file $`F`$. - **Then:** Exactly $`\min(|F|, K) \le 512`$ bytes are read from disk or buffer, static assertions confirm $`\text{RegexEvaluations}(\Delta) = 0`$ and $`\text{BacktrackCount}(\Delta) = 0`$, and execution terminates in $`O(1)`$ time. - **Diagnostic:** `E0100` emitted if reading fails or content is unclassifiable. */
        part def AC_02_Bounded_Window_Inspection_Regex_Prohibition {
        }
        doc /* - **Given:** Schema rows specifying conjugated ports (`~Port_1` or conjugation flag `true`) for directions `in`, `out`, and `inout`. - **When:** Evaluating effective directions via involution operator $``\tau_{\text{conj}}``$. - **Then:** Directions invert polarity ($`\text{In} \mapsto \text{Out}`$, $`\text{Out} \mapsto \text{In}`$, $`\text{InOut} \mapsto \text{InOut}`$), satisfying identity $``\tau_{\text{conj}}(\tau_{\text{conj}}(d)) \equiv d``$. - **Diagnostic:** `E0102` on direction polarity resolution failure. */
        part def AC_02_Conjugated_Port_Direction_Involution {
        }
        doc /* - **Given:** Tabular rows omitting `kind` and `severity`. - **When:** Parser synthesizes `IngestedConstraint` entities. - **Then:** Omitted `kind` fields evaluate to `Assert` and omitted `severity` fields evaluate to `Critical`. - **Diagnostic:** `E0102` on failure to apply normative defaults. */
        part def AC_02_Constraint_Kind_and_Severity_Defaulting {
        }
        doc /* - **Given:** A structural part table row with an empty multiplicity cell ($`M = \bot`$). - **When:** Applying multiplicity evaluation $`\text{ParseMultiplicity}`$. - **Then:** Assigns the default interval $`\langle 1, 1 \rangle`$ to the entity without emitting diagnostics. - **Diagnostic:** `E0103` on default multiplicity derivation failure. */
        part def AC_02_Default_Multiplicity_Assignment {
        }
        doc /* - **Given:** Table rows with singleton intervals ($`L = U = 10.0`$) and default $``v_{\text{default}} = 10.0``$. - **When:** Parser evaluates closed `[10.0, 10.0]` versus open `(10.0, 10.0)`. - **Then:** Closed `[10.0, 10.0]` succeeds; open `(10.0, 10.0)` is rejected as empty, substituting sentinel $``\bot_{\text{attr}}``$. - **Diagnostic:** `E0103` on open singleton interval. */
        part def AC_02_Degenerate_Singleton_Interval_Validation {
        }
        doc /* - **Given:** Input schema files discovered across varying filesystem traversal orders. - **When:** Manifest generation evaluates entry order and composite hash $``\mathcal{H}_{\text{root}}``$. - **Then:** Entries are sorted strictly by ascending ASCII path ($``P_{i} \prec_{\text{lex}} P_{i+1}``$), producing identical composite hashes and 0-byte diff churn across repeated runs. - **Diagnostic:** `E0100` emitted on determinism failure or sorting inconsistency. */
        part def AC_02_Deterministic_Lexicographical_Sorting_Diff_Invariance {
        }
        doc /* - **Given:** Schema IR declaring child entities in reverse order within `Package_0`. - **When:** Lowering child entities to text. - **Then:** Emits child elements in ascending order $``\prec_{\text{sym}}``$ by fully qualified name per REQ-0032. - **Diagnostic:** `E0102` on ordering violation. */
        part def AC_02_Deterministic_Qualified_Name_Symbol_Ordering {
        }
        doc /* - **Given:** Connection row with malformed endpoint path having fewer than two segments (`Port_1`) or empty segments (`Part_0::::Port_1`). - **When:** Performing endpoint path structural validation. - **Then:** Rejects path, substitutes sentinel $``\bot_{\text{conn}}``$, and records localized diagnostic with byte span $``[p_{\text{start}}, p_{\text{end}})``$. - **Diagnostic:** Emits `E0104` with source span coordinates. */
        part def AC_02_Endpoint_Path_Well_Formedness_Enforcement {
        }
        doc /* - **Given:** Proto3 messages with field tags at boundaries ($`i = 1`$, $`i = 536{,}870{,}911`$), out-of-range ($`i = 0`$, $`i = 536{,}870{,}912`$), or in reserved range ($`i \in [19000, 19999]`$). - **When:** Evaluating field tag validity during ingestion. - **Then:** Boundary tags lower cleanly; invalid tags ($`i \le 0`$, $`i \gt 2^{29}-1`$, or $`i \in [19000, 19999]`$) emit structured diagnostics. - **Diagnostic:** `E0103` on invalid field tags. */
        part def AC_02_Field_Tag_Range_and_Reserved_Boundary_Enforcement {
        }
        doc /* - **Given:** Nested AST elements (`Package_B::Classifier_1`, `Package_A::Subsystem_1::Classifier_Alpha`, `Package_A::Classifier_Beta`). - **When:** Sorting declarations prior to canonical emission. - **Then:** Emits top-level packages alphabetically (`Package_A` before `Package_B`), and inside `Package_A`, orders members alphabetically (`Package_A::Classifier_Beta` before `Package_A::Subsystem_1`). - **Diagnostic:** `E0100` on scope ordering inversion. */
        part def AC_02_Hierarchical_Scope_Qualified_Name_Ordering {
        }
        doc /* - **Given:** Interface `Interface_Gamma` declaring `long op_step(in Real p_in, out Real p_out, inout Real p_state);`. - **When:** Lowering the operation declaration into intermediate schema IR. - **Then:** Emits `IngestedAction` where `p_in` is partitioned into `inputs`, `p_out` into `outputs`, `p_state` into both `inputs` and `outputs`, and non-void return `long` synthesizes output parameter `result : long`. - **Diagnostic:** `E0102` on parameter signature failure. */
        part def AC_02_Interface_Operation_and_Directional_Parameter_Partitioning {
        }
        doc /* - **Given:** Header strings with varied case (`"NAME"`, `"name"`), whitespace (`" Name "`), punctuation (`"part-name"`, `"part_name"`, `"[Part Name]"`), and aliases (`"id"`, `"identifier"`, `"name"`). - **When:** The parser executes normalization $`\eta(H)`$ and alias lookup. - **Then:** All header variations resolve deterministically to identical canonical key $``k_{\text{name}}``$. - **Diagnostic:** Successful resolution to $``k_{\text{name}}``$; zero diagnostics emitted. */
        part def AC_02_Multi_Stage_Semantic_Header_Normalization_Equivalence {
        }
        doc /* - **Given:** A table row with raw name cell $``S_{\text{raw}} = \text{"123-Alpha (Beta)"}``$. - **When:** The ingestion engine executes the sanitization transformation pipeline. - **Then:** The sanitized identifier equals $``\text{"id\_123\_Alpha\_Beta\_"}``$, confirming underscore mapping, delimiter collapse, `id_` prefixing, and trailing underscore retention. - **Diagnostic:** Diagnostic `E0102` emitted if non-alphanumeric characters or leading digits fail canonical sanitization. */
        part def AC_02_Non_Alphanumeric_Character_Sanitization_Leading_Digit_Prefixing {
        }
        doc /* - **Given:** Path `/endpoint_alpha/{param_x}` with operation parameter `param_x` (`in: path`, `required: true`). - **When:** Validating route template consistency. - **Then:** Maps `param_x` to required input parameter with multiplicity $`\langle 1, 1 \rangle`$; template mismatch triggers diagnostic. - **Diagnostic:** Emits `E0102` on route mismatch. */
        part def AC_02_Path_Route_Template_and_Parameter_Consistency {
        }
        doc /* - **Given:** Tabular cells with unindexed scalar identifiers (`Classifier_Alpha`, `Port_1`, `Flow_A`). - **When:** Lowering cells via $``\theta_{\text{array}}``$. - **Then:** Evaluates to scalar references $`\langle \text{base}, \bot \rangle`$ without triggering array logic. - **Diagnostic:** `E0102` on false-positive index detection. */
        part def AC_02_Scalar_Identifier_Passthrough {
        }
        doc /* - **Given:** CommonMark table declaring transitions `Transition_0` and `Transition_1` in `StateMachine_0` between states `State_Idle` and `State_Active` with trigger `Event_Start` and effect `Action_Notify`. - **When:** The parser resolves transition rows against state scope $``\text{States}(\text{StateMachine\_0})``$. - **Then:** Rows lower into `IngestedTransition` AST entities with verified endpoint handles $``s_{\text{source}}, s_{\text{target}} \in \text{States}(\text{StateMachine\_0})``$. - **Diagnostic:** `E0102` emitted if $``s_{\text{source}}``$ or $``s_{\text{target}}``$ fails scope resolution. */
        part def AC_02_State_Transition_Table_Ingestion_Endpoint_Scoping {
        }
        doc /* - **Given:** Corrupt table input containing consecutive invalid delimiter sequences and unmatched pipes. - **When:** The parser triggers error recovery upon syntax faults. - **Then:** Stream position satisfies $``\text{ByteOffset}_{t+1} \gt \text{ByteOffset}_t``$, terminating in at most $`N + 1`$ steps without livelocks. - **Diagnostic:** `E0102` emitted on recovery transitions; fail-closed termination if the pointer fails to advance. */
        part def AC_02_Strictly_Monotonic_Stream_Progress_Loop_Prevention {
        }
        doc /* - **Given:** Table cell containing an inline code span enclosed in backticks (`` `Port_1 <br> Port_2 | Flow_A` ``). - **When:** Block normalizer encounters code span delimiters during cell lexing. - **Then:** Content is emitted verbatim as a single `CodeSpan` token without normalizing embedded HTML breaks or splitting on pipes. - **Diagnostic:** `E0102` emitted if an unclosed code span reaches column delimiter pipe (`|`). */
        part def AC_02_Verbatim_Code_Span_Preservation {
        }
        doc /* - **Given:** An input schema file containing CommonMark Markdown tables. - **When:** Lexical analysis and token classification are executed across the byte stream. - **Then:** Byte scanning advances monotonically ($``\text{pos}_{t+1} \ge \text{pos}_t``$) with zero backtracking ($`\text{BacktrackCount} = 0`$) and zero regular expression evaluations ($`\text{RegexEvaluations} = 0`$), executing purely via scalar byte-matching transitions. - **Diagnostic:** `E0100` emitted on non-monotonic stream cursor rollback or regular expression library invocation. */
        part def AC_02_Zero_Backtracking_and_Zero_Regular_Expression_Execution {
        }
        doc /* - **Given:** A deeply nested or complex tabular markdown sequence. - **When:** The pushdown automaton stack transitions are evaluated during table parsing. - **Then:** The pushdown stack depth remains strictly bounded by $``|\text{stack}_t| \le D \le 4``$ across all evaluation steps $`t`$, rejecting unclosed frames or exceeding depths deterministically. - **Diagnostic:** `E0102` emitted if table nesting depth exceeds 4 or stack underflow occurs. */
        part def AC_03_Bounded_Pushdown_Stack_Depth_Invariant {
        }
        doc /* - **Given:** Primary delimiter fault at byte $``\tau_{\text{last}}``$ followed by secondary faults at distance $``q - \tau_{\text{last}} \le \delta``$ ($`\delta = 3`$). - **When:** The parser evaluates tokens following a synchronization recovery event. - **Then:** Secondary faults within window $`\delta`$ are suppressed from diagnostic sink $`\mathcal{D}`$. - **Diagnostic:** Primary fault records `E0102`; secondary faults within $`\delta \le 3`$ emit zero duplicate diagnostics. */
        part def AC_03_Cascading_Error_Suppression_Proximity_Window {
        }
        doc /* - **Given:** ADL connector `Conn_0` connecting `Component_Alpha::Port_1` (`Out`) to `Component_Beta::Port_2` (`In`), and invalid connector `Conn_1` connecting `Component_Beta::Port_2` (`In`) to `Component_Alpha::Port_1` (`Out`). - **When:** Validating topological connections and port endpoint directions. - **Then:** Lowers `Conn_0` into an `IngestedConnection` link; rejects `Conn_1` due to reversed flow, substitutes sentinel $``\bot_{\text{conn}}``$, and emits a structured diagnostic. - **Diagnostic:** `E0102` on directional mismatch or unresolvable endpoint path. */
        part def AC_03_Connector_Topology_Lowering_and_Directional_Compatibility_Gate {
        }
        doc /* - **Given:** Message `Message_Alpha` declaring fields `Field_1` and `Field_2` both with tag $`i = 5`$. - **When:** Ingesting field declarations within `Message_Alpha`. - **Then:** Detects tag collision, logs structured diagnostic, and substitutes sentinel $``\bot_{\text{field}}``$. - **Diagnostic:** `E0102` on duplicate field tag collision. */
        part def AC_03_Duplicate_Field_Tag_Collision_Detection {
        }
        doc /* - **Given:** Schema IR entities with identifiers colliding with reserved keywords (`package`, `part`, `def`, `attribute`, `connect`, `flow`, `action`). - **When:** Serializing identifier tokens. - **Then:** Encloses colliding identifiers in single backticks (e.g., `` `package` ``) while emitting valid identifiers unescaped. - **Diagnostic:** `E0102` on escaping failure. */
        part def AC_03_Identifier_Sanitization_and_Keyword_Escaping {
        }
        doc /* - **Given:** A table containing duplicate column headers or distinct headers resolving to identical key $``k_{\text{name}}``$ (e.g., columns `"Name"` and `"Identifier"`). - **When:** The parser constructs binding vector $`\vec{\beta}`$. - **Then:** Injective assignment fails, entity synthesis halts, synchronization token recovery engages, and a structured diagnostic is emitted. - **Diagnostic:** Emits `E0102` with colliding column indices, raw header tokens, and source span coordinates. */
        part def AC_03_Injective_Column_Assignment_Duplicate_Header_Collision_Detection {
        }
        doc /* - **Given:** Table rows with inverted bounds ($`L \gt U`$, e.g. `[100.0, 50.0]`) or defaults violating bounds ($``v_{\text{default}} = 150.0``$ for `[0.0, 100.0]`). - **When:** Interval validity and default containment predicates are evaluated. - **Then:** Validation fails closed, substituting sentinel $``\bot_{\text{attr}}``$ into the AST with exact source span mapping. - **Diagnostic:** `E0103`. */
        part def AC_03_Inverted_Interval_Bounds_Default_Boundary_Violation {
        }
        doc /* - **Given:** Sibling declarations named `Classifier_1`, `Classifier_10`, `Classifier_2`, `Classifier_Alpha`, `Classifier_alpha`. - **When:** Applying qualified-name symbol sorting. - **Then:** Sorts strictly by ASCII byte value (`Classifier_1` $``\prec_{\text{lex}}``$ `Classifier_10` $``\prec_{\text{lex}}``$ `Classifier_2` $``\prec_{\text{lex}}``$ `Classifier_Alpha` $``\prec_{\text{lex}}``$ `Classifier_alpha`). - **Diagnostic:** `E0100` on collation order mismatch. */
        part def AC_03_Lexicographical_ASCII_Byte_Order_and_Case_Precedence {
        }
        doc /* - **Given:** IDL operation omitting an explicit direction token (`void op_bad(Real p_missing);`) or specifying an illegal keyword (`void op_bad2(input Real p_bad);`). - **When:** Validating parameter direction tokens during parsing. - **Then:** Emits diagnostic `E0102` with precise byte span, substitutes sentinel $``\bot_{\text{action}}``$, and continues parsing subsequent declarations. - **Diagnostic:** `E0102` emitted on missing or invalid parameter direction. */
        part def AC_03_Missing_or_Invalid_Parameter_Direction_Diagnostic_Binding {
        }
        doc /* - **Given:** Tabular cells with multi-dimensional indexing (`Matrix_Node[2][5]`, `Node_Alpha[1][0][7]`) with rank $`K \le 8`$. - **When:** Lowering cells via $``\theta_{\text{multi}}``$. - **Then:** Decomposes into base symbol and index tuples ($`\langle 2, 5 \rangle`$, $`\langle 1, 0, 7 \rangle`$); rejects $`K \gt 8`$. - **Diagnostic:** `E0102` on rank overflow ($`K \gt 8`$). */
        part def AC_03_Multi_Dimensional_Array_Indexing_Bounds {
        }
        doc /* - **Given:** A component definition table with malformed multiplicity (`[5..2]`, `[-1..3]`, `[alpha]`, `[1..`). - **When:** Parsing multiplicity cells during schema ingestion. - **Then:** Rejects invalid tokens, substitutes sentinel $``\bot_{\text{mult}}``$, emits diagnostic `E0103` with byte coordinates, and recovers at the next row delimiter. - **Diagnostic:** `E0103` recorded in diagnostic sink $`\mathcal{D}`$. */
        part def AC_03_Multiplicity_Syntax_and_Inverted_Range_Rejection {
        }
        doc /* - **Given:** Table cell containing multi-line bullet items with space indentation (`- Item_Alpha<br> - Subitem_Beta<br> - Subitem_Gamma`). - **When:** Normalizer evaluates leading whitespace following a normalized line break. - **Then:** Items lower into ordered `ListItem` tokens with indentation mapped to bullet depth $`d \in \{1, 2, 3\}`$ and marker kinds preserved. - **Diagnostic:** `E0100` emitted if bullet nesting depth exceeds bound $``D_{\text{max\_bullet}} = 8``$. */
        part def AC_03_Nested_List_Item_Hierarchy_and_Bullet_Depth_Extraction {
        }
        doc /* - **Given:** Behavioral table row with duplicate parameter names (`param_x : Real, param_x : Integer`) or non-disjoint parameter sets ($`\mathcal{I} \cap \mathcal{O} \ne \emptyset`$). - **When:** The parameter parser tokenizes and validates declared parameter sets. - **Then:** The row is rejected, sentinel $``\bot_{\text{action}}``$ is substituted, and parsing resumes. - **Diagnostic:** `E0102` emitted with exact byte span and parameter error classification. */
        part def AC_03_Parameter_Signature_Well_Formedness_Disjointness_Gate {
        }
        doc /* - **Given:** Declared ports with payload type `Flow_A`, multiplicity bounds $`[1..1]`$, and invariant constraints. - **When:** Applying involution $``\tau_{\text{conj}}``$ during port lowering. - **Then:** Inverted port entities retain bitwise identical payload type handles, multiplicity bounds, and invariant constraints. - **Diagnostic:** `E0102` on payload mutation or type mismatch under conjugation. */
        part def AC_03_Payload_Typing_and_Contract_Preservation {
        }
        doc /* - **Given:** Operation declaring `requestBody` schema `Payload_0` (`required: true`) and response status 200 schema `Response_Alpha`. - **When:** Lowering payloads. - **Then:** Synthesizes input parameter `payload : Payload_0` ($`\langle 1, 1 \rangle`$) and output parameter `result : Response_Alpha` ($`\langle 1, 1 \rangle`$). - **Diagnostic:** Emits `E0102` or `E0103` on binding failure. */
        part def AC_03_Request_Body_and_Response_Payload_Binding {
        }
        doc /* - **Given:** An input table containing three distinct rows declaring entities with identical raw name $``S_{\text{raw}} = \text{"Port\_1"}``$ in parent scope `Package_0`. - **When:** The engine processes rows sequentially and executes collision resolution $`\text{Disambiguate}`$. - **Then:** The engine assigns distinct identifiers $``\text{"Port\_1"}``$, $``\text{"Port\_1\_2"}``$, and $``\text{"Port\_1\_3"}``$, ensuring scope injectivity. - **Diagnostic:** Diagnostic `E0102` emitted on unhandled identifier collision or non-deterministic disambiguation index assignment. */
        part def AC_03_Scope_Sibling_Collision_Disambiguation {
        }
        doc /* - **Given:** Schema declaring two constraints with duplicate identifier `Constraint_1` under owner `Classifier_Alpha`. - **When:** Parser validates scoped uniqueness. - **Then:** Detects identifier collision, emits `E0102`, substitutes sentinel $``\bot_{\text{constraint}}``$, and continues row processing. - **Diagnostic:** `E0102` with duplicate identifier byte span. */
        part def AC_03_Scoped_Constraint_Identifier_Uniqueness {
        }
        doc /* - **Given:** Connection row specifying identical endpoints (`Part_0::Port_1` to `Part_0::Port_1`). - **When:** Evaluated with unbuffered delay flag ($`\delta = \text{false}`$) versus explicit delay flag ($`\delta = \text{true}`$). - **Then:** Unbuffered self-loop is rejected with sentinel substitution; explicit delay self-loop lowers successfully into AST entity. - **Diagnostic:** Emits `E0104` when $`\delta = \text{false}`$; zero diagnostics when $`\delta = \text{true}`$. */
        part def AC_03_Self_Loop_Detection_and_Explicit_Delay_Enforcement {
        }
        doc /* - **Given:** A cached `.pipeline/schema-digest.json` file and subsequent compiler invocation. - **When:** Live workspace digests are compared against the cached manifest ($``\Psi_{\text{cache}}``$). - **Then:** Identical inputs reuse the pre-compiled AST and bypass re-emission of `schema/model.sysml`; modifying a single byte invalidates the cache and triggers full recompilation. - **Diagnostic:** None emitted on valid cache hit or normal recompilation. */
        part def AC_03_Single_Byte_Invalidation_Cache_Model_Reuse {
        }
        doc /* - **Given:** Input files with unrecognized extensions, empty files ($`|F| = 0`$), truncated fragments ($`|F| \lt K`$), arbitrary binary blobs, or contradictory signatures. - **When:** The classifier evaluates input file $`F`$. - **Then:** $`\Delta(F)`$ evaluates to `Unknown`, constructing diagnostic `E0100` with byte span $`[0, \min(|F|, K)]`$, and recovers to process subsequent compilation units without aborting. - **Diagnostic:** `E0100` emitted into diagnostic sink $`\mathcal{D}`$. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_03_Unknown_Corrupted_Payload_Diagnostic_Binding {
        }
        doc /* - **Given:** Schema IR targeting `schema/model.sysml` with simulated failure prior to `AtomicRename`. - **When:** Executing file persistence to disk. - **Then:** Destination `schema/model.sysml` retains its prior valid state or transitions completely, leaving zero corrupted files. - **Diagnostic:** `E0199` on I/O write or rename failure. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Atomic_File_Persistence_and_Integrity {
        }
        doc /* - **Given:** An active manifest write targeting `.pipeline/schema-digest.json`. - **When:** The engine serializes the manifest document to disk. - **Then:** Content is written to `.pipeline/schema-digest.json.tmp.<pid>`, flushed with `fsync`, and atomically renamed to `.pipeline/schema-digest.json`, preventing corrupted or partial file states. - **Diagnostic:** `E0100` emitted on filesystem write permission failure or disk saturation. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Atomic_Staging_Crash_Consistent_Persistence {
        }
        doc /* - **Given:** Normalized token sequence $``\mathcal{T} = \Phi_{\text{block}}(C_{\text{raw}})``$ from a schema cell defining synthetic ports (`Port_1`, `Port_2`). - **When:** Serialization pass emits $`\mathcal{T}`$ via $``\Psi_{\text{emit}}``$ and re-ingests the resulting string via $``\Phi_{\text{block}}``$. - **Then:** Round-trip identity $``\Phi_{\text{block}}(\Psi_{\text{emit}}(\mathcal{T})) \equiv \mathcal{T}``$ holds with 0-byte diff churn. - **Diagnostic:** `E0100` emitted on round-trip token divergence or information loss. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Bijective_Round_Trip_Serialization {
        }
        doc /* - **Given:** Degenerate table schema containing $``M \ge C_{\text{max\_errors}}``$ syntax faults. - **When:** Diagnostic accumulation reaches capacity limit $``C_{\text{max\_errors}}``$. - **Then:** The parser halts parsing, appends a final sentinel, and concludes ingestion gracefully. - **Diagnostic:** Diagnostic `E0199` emitted indicating error ceiling reached. */
        part def AC_04_Bounded_Diagnostic_Sink_Capacity_Graceful_Termination {
        }
        doc /* - **Given:** 10-row behavioral table with syntax faults on rows 3 and 7 (unclosed delimiter and malformed parameter syntax). - **When:** The parser ingests the table under Synchronization Token Error Recovery. - **Then:** Rows 1, 2, 4, 5, 6, 8, 9, 10 lower into valid AST entities, rows 3 and 7 record $``\bot_{\text{action}}``$, exactly 2 diagnostics are logged, and parsing resumes on $``\text{SYM}_{\text{LF}}``$ boundaries. - **Diagnostic:** `E0102` emitted for rows 3 and 7; `E0199` emitted if fault count reaches $``C_{\text{max\_errors}}``$. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Synchronization_Recovery_on_Row_Boundaries {
        }
        doc /* - **Given:** AST containing two distinct classifier declarations with identical qualified name `Package_0::Classifier_Alpha` and identical metaclass in the same scope. - **When:** Executing symbol sorting and verification. - **Then:** Detects symbol collision, records diagnostic `E0102`, substitutes sentinel $``\bot_{\text{sym}}``$, and resumes sorting remaining declarations. - **Diagnostic:** `E0102` on duplicate symbol declaration collision. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Duplicate_Qualified_Name_Collision_Recovery {
        }
        doc /* - **Given:** Enum `Enum_0` with first constant at tag 1, and parent message `Message_Alpha` declaring inner message `Message_Beta`. - **When:** Ingesting enum definitions and resolving nested scopes. - **Then:** Rejects `Enum_0` for missing tag-0 default, and resolves `Message_Beta` to path `Package_0::Message_Alpha::Message_Beta`. - **Diagnostic:** `E0103` on missing tag-0 default; `E0100` on scope failure. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Enum_Tag_Zero_Default_and_Nested_Scope_Resolution {
        }
        doc /* - **Given:** Schemas with local pointer references (`#/components/schemas/Schema_Alpha`) including recursive reference (`Schema_Beta` to `Schema_Beta`). - **When:** Resolving references during type binding. - **Then:** Resolves targets via handle indirection without recursion overflow; unresolvable reference emits diagnostic. - **Diagnostic:** Emits `E0102` on unresolvable target. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_JSON_Pointer_Dereferencing_and_Cycle_Safety {
        }
        doc /* - **Given:** Connection rows specifying negative latency ($``\tau_{\text{lat}} = -5.0``$) or duplicate identifier `Conn_0` in scope `Package_0::Classifier_Alpha`. - **When:** Validating temporal bounds and scope uniqueness. - **Then:** Rejects invalid rows with diagnostic emission and sentinel substitution $``\bot_{\text{conn}}``$. - **Diagnostic:** Emits `E0104` on envelope or uniqueness violation. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Latency_Bounds_and_Scoped_Identifier_Uniqueness {
        }
        doc /* - **Given:** A table omitting mandatory attribute $``k_{\text{type}} \in \mathcal{M}(T_{\text{entity}})``$, or an unmapped header in strict mode, or a table exceeding $``C = 33 \gt C_{\text{max\_cols}}``$ columns. - **When:** The parser inspects the table header row and validates binding vector $`\vec{\beta}`$. - **Then:** The parser halts schema ingestion prior to row processing and emits a structured diagnostic without allocating unbounded buffers. - **Diagnostic:** Emits `E0102` identifying missing mandatory attribute, unmapped header, or column limit exceeded. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Mandatory_Coverage_Bounded_Column_Arity_Enforcement {
        }
        doc /* - **Given:** A row with non-numeric attribute type (`Boolean`, `String`) declaring a restrictive numerical envelope or non-zero unit vector (`param_flag : Boolean` with `[0, 1]`). - **When:** Type-envelope compatibility rules are verified. - **Then:** Incompatible envelopes are rejected and sentinel $``\bot_{\text{attr}}``$ is substituted. - **Diagnostic:** `E0103`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Non_Numeric_Type_Envelope_Incompatibility {
        }
        doc /* - **Given:** XSD elements with valid bounds (`minOccurs="0"`, `maxOccurs="1"`, and `minOccurs="1"`, `maxOccurs="unbounded"`), and an invalid element with `minOccurs="5"` and `maxOccurs="2"`. - **When:** Parsing occurrence attributes and computing multiplicity interval $`\mu(e)`$. - **Then:** Lowers valid elements with multiplicity $`\langle 0, 1 \rangle`$ and $`\langle 1, \infty \rangle`$; rejects invalid declaration with $`\text{minOccurs} \gt \text{maxOccurs}`$, logs a structured diagnostic, and substitutes sentinel $``\bot_{\text{attr}}``$. - **Diagnostic:** `E0103` on inverted occurrence bounds ($`\text{minOccurs} \gt \text{maxOccurs}`$). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Occurrence_Bound_Multiplicity_and_Validation {
        }
        doc /* - **Given:** Rows specifying valid envelopes (`[0.0, 100.0]`) alongside an invalid row with inverted bounds (`[100.0, 10.0]`). - **When:** Parser evaluates interval consistency. - **Then:** Valid intervals yield $``\mathcal{I}_i \in \mathbb{E}``$; inverted row emits `E0103` and substitutes sentinel $``\bot_{\text{constraint}}``$. - **Diagnostic:** `E0103` on inverted or degenerate open bounds. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Operational_Envelope_Interval_Consistency {
        }
        doc /* - **Given:** A table row declaring an entity whose raw name matches reserved keyword $``S_{\text{raw}} = \text{"part"}``$. - **When:** The ingestion engine evaluates $``S_{\text{raw}}``$ against $``\mathcal{K}_{\text{reserved}}``$ and executes sanitization. - **Then:** The engine prepends `id_`, producing sanitized identifier $``\text{"id\_part"}``$. - **Diagnostic:** Diagnostic `E0102` emitted if a reserved keyword is lowered without `id_` prefix disambiguation. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Reserved_Keyword_Disambiguation {
        }
        doc /* - **Given:** Table rows declaring duplicate port identifier `Port_1` under the identical owning component `Classifier_Alpha`. - **When:** Ingesting the colliding row during AST construction. - **Then:** Emits structured diagnostic `E0102` with 1-indexed coordinates and byte span, substitutes sentinel $``\bot_{\text{port}}``$, and preserves the original port entity. - **Diagnostic:** `E0102` emitted upon scoped identifier collision. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Scoped_Port_Identifier_Collision_Rejection {
        }
        doc /* - **Given:** IDL declarations containing bounded sequence `sequence<Real, 16>`, unbounded sequence `sequence<Real>`, and fixed array `Real arr[8]`. - **When:** Lowering type expressions into schema IR attributes. - **Then:** Assigns exact multiplicity intervals $`\langle 0, 16 \rangle`$, $`\langle 0, \infty \rangle`$, and $`\langle 8, 8 \rangle`$ respectively. - **Diagnostic:** `E0103` on malformed sequence bound. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Sequence_and_Fixed_Array_Multiplicity_Lowering {
        }
        doc /* - **Given:** Schema cells with type multiplicity bounds (`Classifier_Alpha[1..*]`, `DataType_Beta[0..1]`). - **When:** Processing type columns versus instance columns. - **Then:** Decomposes type cells to multiplicity $`\langle L, U \rangle`$; rejects multiplicity syntax in instance columns. - **Diagnostic:** `E0102` on multiplicity syntax in instance columns. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Strict_Lexical_Separation_of_Type_Multiplicity_Ranges {
        }
        doc /* - **Given:** A multi-tier assembly table specifying hierarchical nesting (`Assembly_0` containing `Subsystem_1`, containing `Part_1`). - **When:** Constructing the structural containment graph $``G_{\text{contain}}``$. - **Then:** Constructs an acyclic forest where parent handles match owning assemblies and root assemblies have $`\text{parent} = \bot`$. - **Diagnostic:** `E0102` on parent handle resolution failure. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Structural_Containment_Forest_and_Hierarchy {
        }
        doc /* - **Given:** A malformed table input containing unclosed cells, illegal byte sequences, or truncated row delimiter lines. - **When:** The lexer encounters a lexical anomaly or delimiter mismatch. - **Then:** The engine terminates without panicking, emits a structured diagnostic with exact byte span and line/column coordinates, and resynchronizes to the next delimiter boundary. - **Diagnostic:** `E0102` emitted for table delimiter or cell framing anomalies. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Total_Function_Non_Panicking_Contract_and_Delimiter_Synchronization {
        }
        doc /* - **Given:** Invalid CommonMark tables compiled in Release mode across varying platforms and worker thread allocations. - **When:** The compiler executes delimiter synchronization recovery. - **Then:** Execution completes under a total-function contract with zero unhandled panics and bitwise identical diagnostic output. - **Diagnostic:** `E0102` through `E0199` emitted in structured format with zero panic unwinding. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_05_Total_Determinism_Panic_Free_Non_Zero_Exit {
        }
        doc /* The compiler ingestion engine shall classify input schema files into target schema formats using file extensions and deterministic content prefix signatures across 5 supported formats: CommonMark Markdown tables (`.md`, `.markdown`), Protocol Buffers (`.proto`), OMG IDL (`.idl`), OpenAPI schemas (`.json`, `.yaml`, `.yml`), and XML Schema Definitions (`.xml`, `.xsd`). Detection shall evaluate canonical lowercase file extensions followed by an initial bounded prefix window $`\text{head}(F, K)`$ of at most $`K = 512`$ bytes using deterministic scalar byte matching. Classification must execute strictly without regular expressions ($`\text{RegexEvaluations} = 0`$) or exploratory backtracking ($`\text{BacktrackCount} = 0`$). If a file cannot be classified or exhibits an unrecognized, corrupt, or contradictory signature, the engine shall classify it as `Unknown` and emit structured diagnostic `E0100`., the engine shall implement synchronization recovery, recording the diagnostic and proceeding to subsequent compilation units to accumulate all diagnostics without aborting prematurely. --- */
        part def _1_Normative_Statement {
        }
        doc /* Let $`\mathcal{F}`$ denote input schema files. For file $`F \in \mathcal{F}`$, let $``|F| \in \mathbb{N}_{0}``$ denote byte length, $`\text{ext}(F) \in \Sigma^*`$ canonical lowercase extension, $``B(F) = \langle b_{0}, \dots, b_{|F|-1} \rangle``$ raw bytes ($``b_{i} \in \{0, \dots, 255\}``$), and $`K = 512`$ the prefix inspection window bound. Bounded prefix sequence: \text{head}(F, K) = \langle b_{0}, \dots, b_{m-1} \rangle, \quad m = \min(|F|, K) The target format domain $`\mathcal{M}`$ is defined as: \mathcal{M} = \{ \text{MarkdownTable}, \text{Protobuf}, \text{OmgIdl}, \text{OpenApi}, \text{XmlSchema}, \text{Unknown} \} The deterministic format classifier function $`\Delta : \mathcal{F} \longrightarrow \mathcal{M}`$ is defined as: \Delta(F) = \begin{cases} \text{MarkdownTable}, & \text{if } \text{ext}(F) \in \{\text{".md"}, \text{".markdown"}\} \wedge \text{HasMarkdownTable}(\text{head}(F, K)) \\ \text{Protobuf}, & \text{if } \text{ext}(F) = \text{".proto"} \vee \text{HasPrefix}(\text{head}(F, K), \text{"syntax = proto"}) \\ \text{OmgIdl}, & \text{if } \text{ext}(F) = \text{".idl"} \vee \text{HasKeyword}(\text{head}(F, K), \text{"module"}) \\ \text{OpenApi}, & \text{if } \text{ext}(F) \in \{\text{".json"}, \text{".yaml"}, \text{".yml"}\} \wedge \text{HasKeys}(\text{head}(F, K), \{\text{"openapi"}, \text{"swagger"}\}) \\ \text{XmlSchema}, & \text{if } \text{ext}(F) \in \{\text{".xml"}, \text{".xsd"}\} \wedge \text{HasXmlRoot}(\text{head}(F, K)) \\ \text{Unknown}, & \text{otherwise} \end{cases} Bounded inspection, zero regex, and zero backtracking: \forall F \in \mathcal{F}, \quad \text{BytesInspected}(F) = \min(|F|, K) \le K = 512 \text{RegexEvaluations}(\Delta) = 0 \quad \wedge \quad \text{BacktrackCount}(\Delta) = 0 Total function determinism and diagnostic emission: \forall F \in \mathcal{F}, \quad \text{Panic}(\Delta(F)) \equiv \text{false} \quad \wedge \quad \Delta(F) \in \mathcal{M} \Delta(F) = \text{Unknown} \implies \mathcal{D}_{\text{emit}}(F) = \langle \text{E0100}, \text{path}(F), \text{span}(0, \min(|F|, K)) \rangle \forall D \in \mathcal{D}_{\text{format}}, \quad \text{code}(D) \in \mathcal{E}_{\text{ingest}} = \{ e \in \mathbb{N} \mid 100 \le e \le 199 \} --- */
        part def _2_Formal_Invariant {
        }
        doc /* The format detection engine operates within Complexity Class $`\mathbf{P}`$. Classification of an individual file executes in strict $`O(K) = O(1)`$ constant time relative to total file size $`|F|`$, inspecting at most $`K = 512`$ bytes without heap allocation. File extension matching operates in $``O(L_{\text{ext}}) = O(1)``$ time for $``L_{\text{ext}} \le 16``$. Content prefix scanning executes via single-pass exact byte comparison over $`[0, \min(|F|, K)]`$, guaranteeing each byte is inspected at most $`O(1)`$ times with zero backtracking. For $`M`$ schema files, sequential detection time is $`O(M \cdot K) = O(M)`$ linear time;, parallel wall-clock time scales as $``O(\lceil M / N_{\text{max\_workers}} \rceil \cdot K) = O(M / N_{\text{max\_workers}})``$. Auxiliary memory is bounded by $`O(K) = O(1)`$ space per worker thread. Purely linear deterministic prefix scanning operates strictly in $`\mathbf{P}`$, bypassing all NP frontiers (NP-1--NP-8). --- */
        part def _3_Computational_Complexity_Algorithmic_Bounds {
        }
        part def _4_Verification_Conformance_Criteria {
        }
    }
    doc /* Core Metamodel, Node Arena & AST Graph Engine */
    package Subsystem_3_Core_Metamodel_Node_Arena {
        doc /* UUIDv5: daf29dfd-e618-5203-9859-b49422a84842 | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0200 */
        requirement def REQ_0034_Contiguous_Memory_Lowering {
            id = "REQ-0034";
            text = "The compiler core metamodel lowering engine shall lower all ingested schema abstract syntax tree (AST) entities (packages, part definitions, port definitions, action definitions, constraint definitions) into contiguous virtual memory allocations within a typed node arena. AST entities must be";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: 2027c355-5976-5f18-85f6-1c40e2e06bba | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0200 */
        requirement def REQ_0035_Deterministic_Node_Handle_Addressing {
            id = "REQ-0035";
            text = "The compiler metamodel, node arena storage, and abstract syntax tree (AST) graph engine shall address, reference, and interconnect all AST nodes throughout the compilation pipeline exclusively via deterministic typed integer handles (NodeHandle<T>). Raw virtual memory pointers (*const T, *mut T),";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: b0dfa9b7-cb12-5c1d-9fed-da91f097631c | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0200 */
        requirement def REQ_0036_Concurrent_String_Interning {
            id = "REQ-0036";
            text = "The compiler core metamodel, lexical analyzer, and abstract syntax tree (AST) graph engine shall intern all identifier strings, type names, docstrings, and qualified paths across compilation units into a thread-safe concurrent string interner pool, mapping each distinct string to a 32-bit scalar";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: 9df7852d-6325-5ec6-9c14-cec7bc0c51aa | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0200 */
        requirement def REQ_0037_Classifier_Definition {
            id = "REQ-0037";
            text = "The core metamodel shall enforce a strict formal duality and architectural partition between classifier definitions (ClassifierDef) representing reusable types and feature usages (FeatureUsage) representing contextual occurrences within enclosing namespaces. Structural elements in the abstract";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: 2128f8b9-0c5f-56ea-99be-e1b350e936dc | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0199, E0201 */
        requirement def REQ_0038_Strongly_Typed_Port_Directions {
            id = "REQ-0038";
            text = "The Core Metamodel, Node Arena & AST Graph Engine shall enforce strongly typed port directionality (in, out, inout) on all port definitions and usages, verifying directional compatibility across topological connection bindings. Port definitions shall declare an immutable base direction d_{decl} \in";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: 202d2e0f-6949-5794-95cf-e3a582f03c7d | Complexity: Class P (O(H)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0199, E0202 */
        requirement def REQ_0039_Flow_Payload_Binding {
            id = "REQ-0039";
            text = "The Core Metamodel, Node Arena & AST Graph Engine shall bind item flow payloads to authoritative classifier definitions and validate stream transmission rate multiplicities across connectors and channels. Every item flow (ItemFlow or FlowUsage) connecting source port P_{src} and target port P_{tgt}";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: ae00cb7d-b97e-5771-a84b-7d60fce442fa | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0200 */
        requirement def REQ_0040_Two_Pass_Symbol_Hoisting {
            id = "REQ-0040";
            text = "The core abstract syntax tree (AST) engine shall execute a deterministic two-pass symbol resolution pipeline across workspace compilation units, decoupling declaration order from reference order.";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: a5e64058-2009-5e05-bfa7-a33611ac63fe | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100, E0199, E0200 */
        requirement def REQ_0041_Lexical_Scope_Lookup {
            id = "REQ-0041";
            text = "The Core Metamodel, Node Arena & AST Graph Engine shall implement hierarchical lexical scope lookup and path evaluation using double-colon scoping (::) to resolve identifier references across nested lexical scopes, package boundaries, and imported namespaces.";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: b2716f9c-c48b-5897-8021-7dab9787528c | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0199, E0203 */
        requirement def REQ_0042_Circular_Dependency {
            id = "REQ-0042";
            text = "The core abstract syntax tree (AST) engine shall implement a deterministic cycle detection engine utilizing Tarjan's strongly connected components (SCC) algorithm to identify, isolate, and reject circular dependencies across metamodel relationship graphs during compile-time semantic analysis.";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: a1b617cc-9c61-5bdd-a43a-3d53ae820fc2 | Complexity: Class P (O(L)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0199, E0200 */
        requirement def REQ_0043_Multi_File_Module_Ingestion {
            id = "REQ-0043";
            text = "The compiler shall support multi-file models partitioned across hierarchical directories, deterministically mapping relative filesystem paths to nested package namespaces within the abstract syntax tree (AST). For every source file ingested beneath the workspace schema root directory (R_{schema}),";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: 59348ea5-f96f-5c9e-8879-11a3c2be41ad | Complexity: Class P (O(N + E + M) = O(N)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0199, E0200 */
        requirement def REQ_0044_Lossless_AST_Serialization {
            id = "REQ-0044";
            text = "The Core Metamodel, Node Arena & AST Graph Engine shall provide deterministic, bidirectional, lossless serialization and deserialization of compiled Abstract Syntax Trees (AST) to and from minified JSON (RFC 8259) and binary CBOR (RFC 8949). Codecs must preserve all AST structural entities:";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: 7814e7b1-e163-5828-90f0-5146ed48d963 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0199, E0200 */
        requirement def REQ_0045_Immutable_AST_Graph_Traversal_Engine_with_Bounded_Linear_Complexity {
            id = "REQ-0045";
            text = "The Core Metamodel, Node Arena & AST Graph Engine shall provide an immutable graph traversal engine that visits vertices and directed edges of the abstract syntax tree (AST) multigraph G = (V_{AST}, E_{AST}) in topological, depth-first (pre-order and post-order), or breadth-first (level-order)";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: 670b4084-8483-5958-b95a-7f84e98185fb | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0200 */
        requirement def REQ_0046_Mutable_AST_Transformation {
            id = "REQ-0046";
            text = "The abstract syntax tree (AST) engine shall provide a deterministic, mutable transformation pass engine for lowering, syntactic desugaring, optimization rewrites, constant propagation, and semantic enrichments while strictly preserving graph topological integrity and typed reference safety. All AST";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: a4c7e39d-7336-50db-b9cf-082884b38897 | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0200, E0203 */
        requirement def REQ_0047_Graph_Theoretic_AST_Representation {
            id = "REQ-0047";
            text = "The compiler core shall construct, maintain, and query an in-memory bidirectional directed property multigraph G = (V, E) over abstract syntax tree (AST) nodes stored in the AST. The multigraph implementation must remain strictly technology-neutral, clean-room engineered, and decoupled from";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: 0dba3619-fdda-50fb-81b5-e61f6ea66fb5 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0199, E0200, E0203 */
        requirement def REQ_0048_Topological_Sort_Dependency_Scheduling_Tarjan_SCC {
            id = "REQ-0048";
            text = "The core abstract syntax tree (AST) graph engine shall provide deterministic topological dependency scheduling, cycle detection, and shortest-path routing across model elements. Vertices represent lowered AST entities (packages, classifier definitions, feature usages, and ports) in the AST";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: 99ff3654-b23b-5c45-aebe-5158bd651f34 | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0199, E0200, E0201 */
        requirement def REQ_0049_Context_Bounded_AST_Slicing_for_Token_Isolated_Subagents {
            id = "REQ-0049";
            text = "The core metamodel, node arena, and AST graph engine shall provide a deterministic, depth-bounded semantic AST slicing facility (query_slice) to extract self-contained subgraphs surrounding a target element for focused reasoning, code generation, and micro-verification within context-isolated";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: c52b4749-c122-58ca-ae07-5ee9651f2767 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0199, E0200 */
        requirement def REQ_0050_AST_Slice_Serialization_Contract_with_Reified_Dependency_Envelopes {
            id = "REQ-0050";
            text = "The core metamodel and AST graph engine shall serialize extracted abstract syntax tree (AST) slices into standalone packages with reified dependency envelopes. Each serialized package must encapsulate the sliced subgraph alongside all referenced external classifier definitions, port contracts,";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: b559cfe1-5118-57c7-9ca6-acb5a95dbce9 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0200, E0203 */
        requirement def REQ_0051_Incremental_Compilation_Cache_Invalidation_via_Module_Dependency_DAG {
            id = "REQ-0051";
            text = "The compiler core metamodel and AST graph engine shall implement a deterministic incremental compilation caching subsystem structured upon an explicit module dependency directed acyclic graph (DAG) G = (V, E). For each module M \in V, the compiler shall compute a 64-bit cryptographic content hash";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: 7341d8f8-89e8-5c16-9b39-fa7fe1e24050 | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0200 */
        requirement def REQ_0052_Memory_Mapped_Diff_Engine {
            id = "REQ-0052";
            text = "The persistence engine shall perform read-only memory-mapped diffing of candidate artifact byte buffers against on-disk files prior to writing. It shall bypass file emission when generated content matches on-disk bytes identically, preserving modification timestamps (mtime), inodes, and metadata";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* UUIDv5: 9ab78e33-0ab5-5c52-9948-b11a4487080f | Complexity: Class P (O(N_{prev} + N_{act})) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0200 */
        requirement def REQ_0053_Tombstone_Pruning_Engine_for_Renamed {
            id = "REQ-0053";
            text = "The compilation persistence engine shall maintain a centralized artifact manifest (CodegenManifest) and execute automated tombstone pruning (prune_tombstones) during each compilation pass. When any AST element (such as Package_0, Classifier_Alpha, or Port_1) is deleted, renamed, or relocated, the";
            satisfy by NodeArenaASTGraphEngine;
        }
        doc /* Primary execution engine for Core Metamodel, Node Arena & AST Graph Engine */
        part def NodeArenaASTGraphEngine {
            port in token_in : TokenStreamPort;
            port out ast_graph_out : ASTGraphPort;
        }
        doc /* - **Given:** AST nodes `Package_0`, `Classifier_Alpha`, `Classifier_Beta`, and `Port_1`. - **When:** The multigraph builder inserts directed edges across kinds `Contains`, `Specializes`, and `ConnectsTo`. - **Then:** Every edge $`e`$ is queryable in both $`\text{OutEdges}(\text{src}(e))`$ and $`\text{InEdges}(\text{dst}(e))`$, satisfying $``\sum_{v \in V} |\text{OutEdges}(v)| = |E| = \sum_{v \in V} |\text{InEdges}(v)|``$. - **Diagnostic:** `E0200` emitted on adjacency registration discrepancy. */
        part def AC_01_Bidirectional_Adjacency_Registration_Degree_Conservation {
        }
        doc /* - **Given:** A compiled model AST $`\mathcal{A}`$ containing abstract MBSE entities (`Package_0`, `Classifier_Alpha`, `Port_1`, `Flow_A`, `param_x : Real`). - **When:** The compiler serializes $`\mathcal{A}`$ to minified JSON or binary CBOR and deserializes back into AST $``\mathcal{A}' = \mathcal{D}_{\mathcal{F}}(\mathcal{S}_{\mathcal{F}}(\mathcal{A}))``$. - **Then:** Reconstructed AST satisfies $`\mathcal{A}' \cong \mathcal{A}`$ and $``\forall n \in \mathcal{V}, \text{Deref}(\mathcal{D}_{\mathcal{F}}(\mathcal{S}_{\mathcal{F}}(n))) \equiv n``$, preserving node count, hierarchy, edge targets, span coordinates, node flags, and RFC 4122 UUIDv5 hashes. - **Diagnostic:** `E0200` emitted on structural discrepancy, attribute divergence, or span mismatch between $`\mathcal{A}`$ and $`\mathcal{A}'`$. */
        part def AC_01_Bidirectional_Structural_Round_Trip_Isomorphism_Dereference_Equality {
        }
        doc /* - **Given:** A compilation unit at relative path `schema/package_0/module_alpha/unit_beta/model_alpha.sysml`. - **When:** The compiler executes path normalization and directory-to-namespace mapping. - **Then:** The file binds deterministically to leaf package `Package0::ModuleAlpha::UnitBeta`, and all top-level AST declarations are registered as owned members of that package node. - **Diagnostic:** `E0200` emitted on namespace resolution failure or invalid identifier mapping. */
        part def AC_01_Canonical_Directory_to_Namespace_Hierarchy_Resolution {
        }
        doc /* - **Given:** Model containing `Package_0::Classifier_Alpha` with manifested artifacts $``\mathcal{A}_{\text{manifest}}``$, where `Classifier_Alpha` is renamed to `Package_0::Classifier_Beta`. - **When:** Code generation invokes `prune_tombstones`. - **Then:** Obsolete files for `Classifier_Alpha` are added to $``\mathcal{T}_{\text{prune}}``$ and unlinked ($`\text{FileExists} \equiv \text{false}`$), new files exist, and $``\mathcal{A}_{\text{manifest}}^{\text{updated}}``$ records strictly active files. - **Diagnostic:** `E0200` emitted on unlinking failure or residual obsolete files. */
        part def AC_01_Classifier_Renaming_and_Tombstone_Pruning {
        }
        doc /* - **Given:** AST entities (`Package_0`, `PartDef_Alpha`) lowered into arena $``\mathcal{A}_{\text{node}}``$ with $`N = 10^4`$ nodes. - **When:** Lowering commits entities into sequential arena slots. - **Then:** For all consecutive pairs $`(i, i+1)`$, $``\text{Address}(\text{Node}_{i+1}) - \text{Address}(\text{Node}_i) = S_{\text{slot}}``$ and $``\text{Address}(\text{Node}_i) \equiv 0 \pmod 8``$. - **Diagnostic:** `E0200` emitted on non-contiguous layout or alignment violation. */
        part def AC_01_Contiguous_Virtual_Memory_Layout_Alignment {
        }
        doc /* - **Given:** Abstract MBSE tokens with repeated identifier strings (`Package_0`, `Classifier_Alpha`, `Port_1`, `Flow_A`, `param_x : Real`). - **When:** The compiler lexical scanner interns each token into the global symbol interner pool. - **Then:** Identical strings map to identical 32-bit scalar handles ($``\sigma_a = \sigma_b \iff s_a = s_b``$), handle memory footprint satisfies $`\text{sizeof}(\sigma) \le 4\text{ bytes}`$, and identifier comparisons during type checking execute in $`O(1)`$ constant time via scalar integer equality with zero character iteration. - **Diagnostic:** `E0200` emitted if duplicate string values receive distinct handles or scalar equality evaluation fails. */
        part def AC_01_Deduplicated_Scalar_Handle_Assignment_O_Equality {
        }
        doc /* - **Given:** A 6-level containment hierarchy (`Package_0` down to `Part_5`) and depth bound $`k = 2`$. - **When:** `query_slice` targets mid-level entity `Part_2`. - **Then:** Subgraph contains strictly nodes at distance $``\text{dist}_{G}(n_{\text{target}}, v) \le 2``$; nodes at distance $`d \gt 2`$ without dependencies are excluded. - **Diagnostic:** `E0200` emitted on traversal violation. */
        part def AC_01_Depth_Bounded_Metric_Neighborhood_Extraction {
        }
        doc /* - **Given:** A DAG over elements `Package_0`, `Classifier_Alpha`, `Classifier_Beta`, `Classifier_Gamma`, and `Classifier_Delta`, where `Classifier_Alpha` precedes `Classifier_Beta` and `Classifier_Gamma`, and both precede `Classifier_Delta`. - **When:** Kahn topological sorting executes to establish compilation schedule $`\mathcal{L}`$. - **Then:** Sequence $`\mathcal{L}`$ orders `Classifier_Alpha` before `Classifier_Beta` and `Classifier_Gamma`, and both before `Classifier_Delta`, satisfying $`\text{Index}(u, \mathcal{L}) \lt \text{Index}(v, \mathcal{L})`$ for all $`(u, v) \in E`$. - **Diagnostic:** `E0200` on ordering violation. */
        part def AC_01_Diamond_DAG_Topological_Scheduling_Dependency_Invariant {
        }
        doc /* - **Given:** Classifier `Classifier_Alpha` declared with self-specialization `Classifier_Alpha :> Classifier_Alpha`. - **When:** Cycle detection executes on specialization graph $``G_{\text{inherit}}``$. - **Then:** Tarjan SCC analysis identifies a self-loop of size 1, extracts traceback $``\langle \text{Classifier\_Alpha}, \text{Classifier\_Alpha} \rangle``$, and emits diagnostic `E0203`. - **Diagnostic:** `E0203` emitted on direct self-specialization cycle. */
        part def AC_01_Direct_Self_Specialization_Cycle_Detection {
        }
        doc /* - **Given:** An input AST containing structural definitions and usages within `Package_0`. - **When:** The compiler lowers nodes into core AST arena structures. - **Then:** Every structural node is partitioned into $`\mathcal{C}`$ or $`\mathcal{U}`$ such that $`\mathcal{C} \cap \mathcal{U} = \emptyset`$; instantiating a definition directly as a bare usage fails compilation. - **Diagnostic:** `E0200` emitted on structural definition-usage partition violation. */
        part def AC_01_Disjoint_Duality_Partition_Enforcement {
        }
        doc /* - **Given:** Arena $`\mathcal{A}`$ with slot $`k`$ containing `Classifier_Alpha` referenced by handle $``H_1 = \langle k, g, \text{Tag}_{\text{Alpha}} \rangle``$. - **When:** Slot $`k`$ is recycled to store `Classifier_Beta`, advancing its generation counter to $`(g + 1) \pmod{2^{16}}`$. - **Then:** Evaluating $``\text{Deref}(H_1, \mathcal{A})``$ deterministically returns $`\bot`$, while newly allocated handle $``H_2 = \langle k, g + 1, \text{Tag}_{\text{Beta}} \rangle``$ dereferences in $`O(1)`$ time. - **Diagnostic:** `E0200` emitted on attempted access via stale handle $``H_1``$. */
        part def AC_01_Generational_Invalidation_on_Slot_Recycling {
        }
        doc /* - **Given:** Node `Classifier_Alpha` in arena slot $`k`$ with address $``\text{Base}(\mathcal{A}) + k \cdot S_{\text{slot}}``$. - **When:** The engine applies an attribute modification or desugaring rewrite pass. - **Then:** Slot index satisfies $``\text{Index}(\text{Classifier\_Alpha}, \mathcal{A}_{t+1}) = k``$, virtual memory address remains invariant, and zero reallocations occur. - **Diagnostic:** `E0200` emitted on slot relocation or index divergence. */
        part def AC_01_In_Place_Slot_Index_and_Physical_Address_Invariance {
        }
        doc /* - **Given:** A dependency DAG in `Package_0` structured as `Module_Alpha -> Module_Beta -> Module_Gamma`, with state hashes matching cached records. - **When:** Leaf module `Module_Gamma` source is mutated ($``H_{\text{source}}(\text{Module\_Gamma}) \neq H_{\text{cached\_source}}(\text{Module\_Gamma})``$) and incremental compilation executes. - **Then:** Strictly `Module_Gamma` is marked for recomputation ($``\mathcal{R} = \{ \text{Module\_Gamma} \}``$); upstream `Module_Alpha` and `Module_Beta` are reused directly from cache ($``T_{\text{recompile}} = 0``$). - **Diagnostic:** `E0200` emitted on redundant re-analysis of unaffected modules. */
        part def AC_01_Leaf_Module_Mutation_and_Isolated_Recompilation {
        }
        doc /* - **Given:** AST hierarchy `Package_Root::Package_0::Classifier_Alpha` with `param_x : Real` in `Package_0` and local `param_x : Real` in `Classifier_Alpha`. - **When:** Resolving unqualified `param_x` within `Classifier_Alpha` and qualified `::Package_Root::Package_0::param_x`. - **Then:** Unqualified `param_x` resolves to `Classifier_Alpha` local handle; qualified path resolves to `Package_0` handle with zero diagnostics. - **Diagnostic:** `E0200` on shadow resolution failure or qualified path fault. */
        part def AC_01_Lexical_Scope_Shadowing {
        }
        doc /* - **Given:** Synthetic AST multigraphs rooted at `Package_0` scaling from $`10^3`$ to $`10^5`$ vertices and edges (`Classifier_Alpha`, `Port_1`, `Flow_A`). - **When:** The traversal engine executes DFS pre-order, DFS post-order, and BFS passes. - **Then:** Runtime scales linearly satisfying $``T(V, E) \le c_1 \cdot (V + E) + c_0``$ ($`R^2 \ge 0.99`$), visiting all reachable vertices exactly once ($`\text{VisitedCount}(v) = 1`$) and unreachable vertices zero times. - **Diagnostic:** `E0200` emitted on traversal failure or non-linear scaling termination. */
        part def AC_01_Linear_Traversal_Scaling_Across_Scale_Topologies {
        }
        doc /* - **Given:** Sibling packages `Package_0` and `Package_1` where `Classifier_Alpha` in `Package_0` references `Package_1::Classifier_Beta`, and `Classifier_Beta` in `Package_1` references `Package_0::Classifier_Alpha`. - **When:** Pass 1 hoists symbols and Pass 2 resolves references. - **Then:** Both cross-references resolve to exact 32-bit arena node handles in $`\Gamma`$ with zero diagnostics emitted. - **Diagnostic:** `E0200` on resolution failure. */
        part def AC_01_Mutual_Recursion_Forward_Reference_Resolution {
        }
        doc /* - **Given:** Sibling instances `Part_0` and `Part_1` declaring peer connections: `(Out, In)`, `(In, Out)`, and `(InOut, InOut)`. - **When:** The AST type checking pass validates peer connection directionality. - **Then:** All three connection edges evaluate to valid, node handles are marked validated, and zero diagnostics are emitted. - **Diagnostic:** `E0201` on unexpected validation rejection. */
        part def AC_01_Peer_to_Peer_Anti_Parallel_Direction_Verification {
        }
        doc /* - **Given:** Extracted slice $``G_{\text{slice}}``$ rooted at `Classifier_Alpha` within `Package_0` referencing external type `Type_0` and unit `Unit_0`. - **When:** The serialization engine computes envelope $``\text{Deps}(G_{\text{slice}})``$ and serializes package $``\mathcal{P}_{\text{slice}}``$. - **Then:** Deserialization into an isolated arena yields $``\text{UnresolvedSymbols}(G_{\text{standalone}}) = \emptyset``$ and $``\text{ValidateSlice}(G_{\text{standalone}}) \equiv \text{Valid}``$ without parent AST access. - **Diagnostic:** `E0200` emitted on any missing external symbol declaration. */
        part def AC_01_Standalone_Dependency_Closure_and_Symbol_Resolution {
        }
        doc /* - **Given:** Target output path $`P`$ containing an existing on-disk artifact with modification timestamp $``t_0``$, and freshly generated byte buffer $``B_{\text{new}}``$ with identical content. - **When:** The persistence engine processes artifact $`P`$ during compilation pass $``t_1 \gt t_0``$. - **Then:** $``\text{ShouldWrite}(P, B_{\text{new}})``$ evaluates to false, zero write system calls execute, and $``\text{mtime}(P, t_1) = t_0``$. - **Diagnostic:** `E0200` emitted on unexpected filesystem error. */
        part def AC_01_Timestamp_Invariance_on_Identical_Re_Emission {
        }
        doc /* - **Given:** Ports `Port_1 : Classifier_Beta` and `Port_2 : Classifier_Alpha` with `Classifier_Beta :> Classifier_Alpha`, connected by flow `Flow_A` with payload `Classifier_Beta` and rate `[10.0, 50.0]` Hz. - **When:** Flow type checking executes. - **Then:** The engine validates $``\tau_F :> \tau(P_{\text{src}})``$ and $``\tau_F :> \tau(P_{\text{tgt}})``$, passing with zero diagnostics. - **Diagnostic:** `E0202` on covariance failure. */
        part def AC_01_Valid_Payload_Type_Binding_and_Covariance {
        }
        doc /* - **Given:** Sibling scopes `Package_Root::Package_0::Classifier_Alpha` and `Package_Root::Package_1::Classifier_Beta`. - **When:** `Classifier_Beta` resolves absolute path `::Package_Root::Package_0::Classifier_Alpha` and `Package_Root` resolves relative path `Package_0::Classifier_Alpha`. - **Then:** Both paths resolve to `Classifier_Alpha` 32-bit arena handle with 0-byte diff churn. - **Diagnostic:** `E0200` on qualified path traversal fault. */
        part def AC_02_Absolute_vs_Relative_Qualified_Path_Resolution {
        }
        doc /* - **Given:** A classifier definition `Classifier_Alpha` and feature usages `Usage_1 : Classifier_Alpha` and `Usage_2 : Classifier_Alpha`. - **When:** The type checker executes symbol typing pass $`\tau : \mathcal{U} \longrightarrow \mathcal{C}`$. - **Then:** 100% of feature usages resolve to the arena handle of `Classifier_Alpha` with zero diagnostics emitted. - **Diagnostic:** `E0200` emitted if a feature usage contains an unresolved classifier reference or lacks a type binding. */
        part def AC_02_Authoritative_Classifier_Typing_Resolution {
        }
        doc /* - **Given:** A compiled AST model $`\mathcal{A}`$ comprising $`|\mathcal{V}| \ge 100`$ nodes. - **When:** The AST is serialized to canonical minified JSON and canonical binary CBOR. - **Then:** Serialized byte sizes satisfy $``|\mathcal{S}_{\text{CBOR}}(\mathcal{A})| \le 0.40 \cdot |\mathcal{S}_{\text{JSON}}(\mathcal{A})|``$, achieving at least a 60% compaction gain. - **Diagnostic:** `E0200` emitted if the emitted CBOR artifact exceeds 40% of the minified JSON byte size. */
        part def AC_02_CBOR_Binary_Compaction_Bound {
        }
        doc /* - **Given:** Node arena with $`N = 10^5`$ AST nodes addressed via handles (`NodeIndex`). - **When:** Executing $`10^6`$ randomized index lookups across the arena buffer. - **Then:** Every slot dereference computes in $`O(1)`$ constant time via base-plus-offset arithmetic with $``\text{PointerIndirectionDepth}(\mathcal{A}_{\text{node}}) = 0``$. - **Diagnostic:** `E0200` emitted on invalid handle dereference or non-zero pointer indirection. */
        part def AC_02_Constant_Time_Random_Access_Zero_Pointer_Indirection {
        }
        doc /* - **Given:** An AST model with 500 definitions and 1,000 cross-references permuted into 10 distinct declaration sequences $``\pi_1, \dots, \pi_{10}``$. - **When:** The two-pass symbol pipeline executes on each permutation. - **Then:** All 10 runs produce bitwise identical symbol tables $`\Gamma`$ and resolved AST graphs with 0-byte diff churn. - **Diagnostic:** `E0200` if resolved handles depend on declaration order. */
        part def AC_02_Declaration_Order_Permutation_Invariance {
        }
        doc /* - **Given:** Sibling nodes `Classifier_Beta` and `Classifier_Gamma` in `Package_0` attaining in-degree zero simultaneously in ready queue $`Q`$. - **When:** Kahn algorithm dequeues the next schedulable node handle. - **Then:** Node `Package_0::Classifier_Beta` is selected before `Package_0::Classifier_Gamma` by lexicographical order of interned `SymbolId` tokens, producing identical schedule $`\mathcal{L}`$ across edge insertion permutations. - **Diagnostic:** `E0200` on non-deterministic tie-breaking. */
        part def AC_02_Deterministic_Lexicographical_Tie_Breaking {
        }
        doc /* - **Given:** Model containing `Package_0::SubPackage_1::Classifier_Alpha` whose output directory `generated/Package_0/SubPackage_1/` contains strictly files from `Classifier_Alpha`. - **When:** `Classifier_Alpha` is deleted and compilation executes. - **Then:** All generated files are unlinked, empty directory `generated/Package_0/SubPackage_1/` is deleted, and non-empty ancestor `generated/Package_0/` is preserved. - **Diagnostic:** `E0200` emitted on directory deletion failure. */
        part def AC_02_Element_Deletion_and_Recursive_Directory_Pruning {
        }
        doc /* - **Given:** Node handle $``H_1 = \langle k, g, \tau \rangle``$ referencing slot $`k`$ with generation $`g`$. - **When:** Slot $`k`$ undergoes in-place mutation or replacement at step $`t \to t+1`$. - **Then:** Generation increments to $`(g + 1) \pmod{2^{16}}`$, dereferencing $``H_1``$ returns $`\bot`$, and new handle $``H_2 = \langle k, (g + 1) \pmod{2^{16}}, \tau \rangle``$ dereferences in $`O(1)`$ time. - **Diagnostic:** `E0200` emitted on stale handle access. */
        part def AC_02_Generational_Counter_Monotonicity_Stale_Dereference_Invalidation {
        }
        doc /* - **Given:** Component `Component_Alpha` with boundary ports connected to child `Part_0` ports: outer `In` to inner `In`, inner `Out` to outer `Out`, and outer `InOut` to inner `InOut`. - **When:** The type checking pass evaluates delegation connections across containment boundaries. - **Then:** All delegation connections satisfy $``P_{\text{outer}}.d_{\text{eff}} = P_{\text{inner}}.d_{\text{eff}}``$ and are accepted with zero diagnostics. - **Diagnostic:** `E0201` on valid delegation rejection. */
        part def AC_02_Hierarchical_Delegation_Flow_Preservation {
        }
        doc /* - **Given:** Sibling source files sharing common directory prefixes (`schema/package_0/module_alpha/unit_0/part_a.sysml` and `schema/package_0/module_alpha/unit_1/part_b.sysml`). - **When:** The compiler constructs package hierarchy nodes in the AST. - **Then:** Intermediate package container nodes for `Package0` and `Package0::ModuleAlpha` are synthesized exactly once, reused across sibling files, and assigned deterministic RFC 4122 UUIDv5 identifiers. - **Diagnostic:** `E0200` emitted if duplicate package handles are allocated or parent-child linkages diverge. */
        part def AC_02_Idempotent_Intermediate_Package_Synthesis {
        }
        doc /* - **Given:** A populated node arena $``\mathcal{A}_{\text{node}}``$ containing synthetic elements `Package_0`, `Classifier_Alpha`, and `Port_1`, instrumented with SHA-256 digests and allocator hooks. - **When:** The traversal engine executes DFS and BFS passes across the full model graph. - **Then:** Post-traversal SHA-256 arena digests are bitwise identical to pre-traversal digests ($`\text{Mutations} = 0`$), and allocator hooks record zero heap allocations ($`\text{HeapAllocs} = 0`$). - **Diagnostic:** `E0200` emitted on arena byte alteration or unexpected heap allocation. */
        part def AC_02_Immutability_and_Zero_Heap_Allocation_Verification {
        }
        doc /* - **Given:** Disjoint ports `Port_1 : Classifier_Alpha` and `Port_2 : Classifier_Gamma` connected by flow `Flow_Err` with payload `Classifier_Gamma` without an adapter ($``\mathcal{A}_F = \bot``$). - **When:** Flow type checking executes. - **Then:** Rejects flow, binds sentinel $``\bot_{\text{flow}}``$, and emits structured diagnostic `E0202` with source byte span coordinates. - **Diagnostic:** Emits `E0202` (`PayloadTypeIncompatibility`). */
        part def AC_02_Incompatible_Payload_Type_Rejection_Without_Adapter {
        }
        doc /* - **Given:** External classifier `Classifier_Beta` referenced by $``G_{\text{slice}}``$, defining public port `Port_1 : Type_0`, private subcomponents, and behavioral actions. - **When:** The engine reifies `Classifier_Beta` into dependency envelope node set $``V_{\text{deps}}``$. - **Then:** Synthesized stubs retain public signatures (`Port_1`, `Type_0`) with behavioral bodies stripped ($`\text{Body}(v) = \emptyset`$). - **Diagnostic:** `E0200` emitted if unexported private members or internal bodies leak into the envelope. */
        part def AC_02_Minimal_Interface_Stub_Synthesis_and_Structural_Pruning {
        }
        doc /* - **Given:** An AST model declaring mutual specialization (`Classifier_Alpha :> Classifier_Beta`, `Classifier_Beta :> Classifier_Alpha`) or a 4-node circular chain ($`A :> B :> C :> D :> A`$). - **When:** Cycle detection evaluates specialization graph $``G_{\text{inherit}}``$. - **Then:** The engine detects the multi-node SCC, derives deterministic cycle path $``\mathcal{P}_{\text{cycle}}``$ ordered by minimum handle, and rejects compilation. - **Diagnostic:** `E0203` emitted on cyclic inheritance chains. */
        part def AC_02_Mutual_and_Multi_Node_Inheritance_Cycle_Rejection {
        }
        doc /* - **Given:** AST nodes `Port_1` and `Port_2`. - **When:** The compiler records connection edge $``e_1``$ (`ConnectsTo`) and two flow edges $``e_2, e_3``$ (`FlowsTo` for `Flow_A` and `Flow_B`) between $``(\text{Port\_1}, \text{Port\_2})``$. - **Then:** All three edges are assigned distinct 32-bit `EdgeId` keys without collision or property loss. - **Diagnostic:** `E0200` emitted if parallel edge insertion collapses distinct edge identities. */
        part def AC_02_Parallel_Multigraph_Edge_Admissibility {
        }
        doc /* - **Given:** A dependency chain `Module_Alpha -> Module_Beta -> Module_Gamma` and disjoint `Module_Delta` in `Package_0`. - **When:** Root module `Module_Alpha` source is mutated. - **Then:** The compiler identifies $``\text{TransitiveDependents}(\text{Module\_Alpha}) = \{ \text{Module\_Beta}, \text{Module\_Gamma} \}``$, recomputes $``\mathcal{R} = \{ \text{Module\_Alpha}, \text{Module\_Beta}, \text{Module\_Gamma} \}``$, and reuses `Module_Delta` from cache. - **Diagnostic:** `E0200` emitted if any transitive dependent is omitted from invalidation or if `Module_Delta` is re-analyzed. */
        part def AC_02_Root_Module_Mutation_and_Transitive_Downstream_Invalidation {
        }
        doc /* - **Given:** Target path $`P`$ where $``\text{FileSize}(P) \ne |B_{\text{new}}|``$. - **When:** The persistence engine evaluates the emission decision predicate. - **Then:** $``\text{ShouldWrite}(P, B_{\text{new}})``$ evaluates to true in $`O(1)`$ time, memory mapping is strictly bypassed ($`\text{MmapCreated}(P) = \text{false}`$), and the file is atomically rewritten. - **Diagnostic:** `E0200` emitted on atomic commit failure. */
        part def AC_02_Size_Discrepancy_Fast_Short_Circuit {
        }
        doc /* - **Given:** `Classifier_Alpha` referencing type `DataType_Sigma` and constraint `Constraint_Alpha` outside metric ball ($`d \gt k`$). - **When:** `query_slice` is executed on `Classifier_Alpha` and slice is compiled in an isolated subagent context. - **Then:** `DataType_Sigma` and `Constraint_Alpha` are included in $``V_{\text{slice}}``$, satisfying $``\text{UnresolvedSymbols}(G_{\text{slice}}) = \emptyset``$. - **Diagnostic:** `E0200` emitted on unresolvable symbol. */
        part def AC_02_Transitive_Semantic_Closure_and_Independent_Compilability {
        }
        doc /* - **Given:** Arena slot $`k`$ storing `Package_0` with tag $``\text{Tag}_{\text{Package}}``$, and handle $``H_{\text{mismatch}} = \langle k, g, \text{Tag}_{\text{Port}} \rangle``$. - **When:** The compiler evaluates $``\text{Deref}(H_{\text{mismatch}}, \mathcal{A})``$. - **Then:** Validation fails, dereferencing evaluates to $`\bot`$, and execution halts without panics. - **Diagnostic:** `E0200` emitted on type tag mismatch. */
        part def AC_02_Type_Tag_Discriminator_Validation {
        }
        doc /* - **Given:** A memory-mapped source file buffer $``\mathcal{B}_{\text{file}}``$ ingested during `ParsePass`. - **When:** The compiler profiles dynamic heap allocations during lexical analysis and AST construction. - **Then:** Dynamic heap allocations during parsing are strictly confined to the symbol interner pool ($``\text{HeapAllocs}(\text{ParsePass}(\mathcal{B}_{\text{file}})) \subseteq \text{Storage}(\text{StringInternerPool})``$), while all AST nodes reside in bump arenas or borrow slices from $``\mathcal{B}_{\text{file}}``$. - **Diagnostic:** `E0200` emitted if unauthorized heap string allocations occur outside the interner pool during parsing. */
        part def AC_02_Zero_Copy_Allocation_Boundary_Exception {
        }
        doc /* - **Given:** Ports `Port_1 : Classifier_Alpha` and `Port_2 : Classifier_Gamma` connected by flow `Flow_Adapt` with adapter `Adapter_AlphaToGamma` ($``\text{InType} = \text{Classifier\_Alpha}``$, $``\text{OutType} = \text{Classifier\_Gamma}``$). - **When:** Evaluating adapter payload compatibility. - **Then:** Confirms $``\tau(P_{\text{src}}) \le \text{InType}(\mathcal{A}_F)``$ and $``\text{OutType}(\mathcal{A}_F) \le \tau(P_{\text{tgt}})``$, passing with zero diagnostics. - **Diagnostic:** `E0202` on adapter mismatch. */
        part def AC_03_Adapter_Mediated_Payload_Conformance {
        }
        doc /* - **Given:** Arena $`\mathcal{A}`$ of capacity $``C_{\text{arena}}``$, out-of-bounds handle $``H_{\text{oob}} = \langle C_{\text{arena}} + 10, 0, 0 \rangle``$, and null sentinel $``H_{\text{null}} = \pi_{\text{pack}}(2^{32} - 1, 0, 0)``$. - **When:** The compiler evaluates $``\text{Deref}(H_{\text{oob}}, \mathcal{A})``$ or $``\text{Deref}(H_{\text{null}}, \mathcal{A})``$. - **Then:** Both evaluate to $`\bot`$, preserving $`\text{Valid}(H, \mathcal{A}) = \text{false}`$ and zero dangling pointers. - **Diagnostic:** `E0200` emitted when dereferencing out-of-bounds or null handles. */
        part def AC_03_Arena_Capacity_Bounds_and_Sentinel_Safety {
        }
        doc /* - **Given:** Worker threads ($``T \le N_{\text{max\_workers}}``$) scheduled on the bounded work-stealing pool processing disjoint AST units with overlapping synthetic identifiers. - **When:** Threads concurrently intern strings and perform bidirectional resolution. - **Then:** For all interned strings, $`\text{resolve}(\text{intern}(s)) = s`$ and $`\text{intern}(\text{resolve}(\sigma)) = \sigma`$ without data races, deadlocks, or handle divergence across threads ($``\text{intern}_{t_a}(s) = \text{intern}_{t_b}(s)``$). - **Diagnostic:** `E0200` emitted if round-trip resolution diverges or concurrent race conditions produce inconsistent handles. */
        part def AC_03_Bijective_Inversion_Thread_Safe_Bounded_Concurrency {
        }
        doc /* - **Given:** `Port_1` on `Part_0` connected across slice boundary to external `Port_2`. - **When:** `query_slice` extracts `Part_0` while excluding `Port_2`'s parent classifier. - **Then:** Boundary stub `Port_Stub` is synthesized preserving direction (`in`, `out`, `inout`) and payload type without including external hierarchies. - **Diagnostic:** `E0201` emitted on interface signature mismatch. */
        part def AC_03_Boundary_Port_Reification_and_Stub_Synthesis {
        }
        doc /* - **Given:** An unmodified workspace where all module source hashes match cached records ($``H_{\text{source}}(M) = H_{\text{cached\_source}}(M)``$ for all $`M \in V`$). - **When:** Incremental compilation executes. - **Then:** All module state hashes match cached state hashes ($``H_{\text{state}}(M) = H_{\text{cached}}(M)``$), all AST subgraphs are reused from cache ($``T_{\text{recompile}}(M) = 0``$), and Merkle root parity is preserved. - **Diagnostic:** `E0200` emitted if any module undergoes re-parsing during an unmodified build. */
        part def AC_03_Clean_No_Op_Incremental_Cache_Hit_Bypass {
        }
        doc /* - **Given:** A synthetic AST multigraph with circular references (`Classifier_Alpha -> Classifier_Beta -> Classifier_Alpha` and self-loop `Port_1 -> Port_1`). - **When:** The engine executes traversal starting from root vertex `Package_0`. - **Then:** The visited bitset detects back-edges, skips redundant exploration, terminates deterministically without infinite loops, and records $`\text{VisitedCount}(v) = 1`$ for all reachable cycle nodes in $`O(V + E)`$ steps. - **Diagnostic:** `E0200` emitted on cycle-induced divergence or duplicate node visitation. */
        part def AC_03_Cyclic_Graph_Termination_and_Single_Visit_Invariant {
        }
        doc /* - **Given:** An AST containing composite interconnect declarations between `Port_1` and `Port_2`. - **When:** A desugaring pass lowers composite connectors into directed primitive flows. - **Then:** 100% of emitted directed edges connect active, valid node slots in $``\mathcal{A}_{t+1}``$, satisfying $``\text{DanglingEdges}(\mathcal{A}_{t+1}) = \emptyset``$. - **Diagnostic:** `E0200` emitted on dangling edge or invalid endpoint handle. */
        part def AC_03_Desugaring_Structural_Integrity_Zero_Dangling_Edges {
        }
        doc /* - **Given:** An AST declaring two classifier definitions with identical name `Classifier_Alpha` in scope `Package_0`. - **When:** Pass 1 hoists definitions in `Package_0`. - **Then:** Pass 1 rejects the duplicate declaration, retains the primary definition handle in $`\Gamma`$, records exact source coordinates, and continues AST traversal. - **Diagnostic:** `E0200` on duplicate symbol declaration in the same scope. */
        part def AC_03_Duplicate_Symbol_Declaration_Rejection {
        }
        doc /* - **Given:** A source file at `schema/package_0/module_alpha/unit_0/part_a.sysml` containing explicit declaration `package ConflictingRoot::ModuleBeta;`. - **When:** Semantic analysis compares the declared package with directory-derived namespace `Package0::ModuleAlpha::Unit0`. - **Then:** The compiler rejects the conflicting declaration, emits diagnostic `E0200`, and executes synchronization token error recovery to resume parsing at the next file boundary. - **Diagnostic:** `E0200` emitted on namespace path discrepancy. */
        part def AC_03_Explicit_Package_Declaration_Reconciliation_and_Conflict_Rejection {
        }
        doc /* - **Given:** Synthetic AST models scaling from $`N = 10^3`$ to $`N = 10^6`$ entities. - **When:** Lowering transforms the model into the contiguous arena in a single pass. - **Then:** Lowering latency satisfies $``T_{\text{lower}}(N) \le c_1 \cdot N``$ with regression fit $`R^2 \ge 0.99`$. - **Diagnostic:** `E0200` emitted if lowering throughput exceeds linear algorithmic bounds. */
        part def AC_03_Linear_Lowering_Throughput_Scaling {
        }
        doc /* - **Given:** Package `Package_0` declaring private member `Feature_A` and public member `Feature_B`. - **When:** Scope `Package_1` resolves `Package_0::Feature_A` and `Package_0::Feature_B`. - **Then:** Resolution of `Feature_B` succeeds; resolution of `Feature_A` is rejected with diagnostic `E0200` with source spans. - **Diagnostic:** `E0200` on inaccessible private member access across packages. */
        part def AC_03_Package_Visibility_Boundary_Enforcement {
        }
        doc /* - **Given:** Port usage `Port_2` with base direction `In` and conjugation flag $`c = \text{true}`$, connected to peer `Port_1` with base direction `In` and $`c = \text{false}`$. - **When:** Resolving effective directions and checking peer connection validity. - **Then:** Resolves $``d_{\text{eff}}(\text{Port\_2}) = \tau_{\text{conj}}(\text{In}) = \text{Out}``$, satisfies $``\text{In} \sim_{\text{peer}} \text{Out}``$, and accepts the connection with zero diagnostics. - **Diagnostic:** `E0201` on conjugation involution evaluation failure. */
        part def AC_03_Port_Conjugation_Involution_and_Effective_Direction_Resolution {
        }
        doc /* - **Given:** Sliced nodes and dependency stubs with arbitrary parent arena handles. - **When:** The serialization pass encodes node records into the output buffer. - **Then:** Handles are bijectively mapped to dense slice-relative indices $``[0, |V_{\text{slice}}| + |V_{\text{deps}}| - 1]``$, each node preserving its immutable UUIDv5 identifier $``\text{UUIDv5}(\text{OID}_{\text{DEAP}}, \text{FQN}(u))``$. - **Diagnostic:** `E0200` emitted on handle remapping collisions or non-contiguous index gaps. */
        part def AC_03_Relocatable_Handle_Remapping_and_Deterministic_UUIDv5_Anchors {
        }
        doc /* - **Given:** On-disk file $`P`$ and candidate buffer $``B_{\text{new}}``$ of identical length $`L`$, differing by 1 byte at index $`k \in \{0, \lfloor L/2 \rfloor, L-1\}`$. - **When:** Vectorized memory-mapped comparison evaluates $``\mathcal{B}_{\text{mmap}}(P)``$ against $``B_{\text{new}}``$. - **Then:** Divergence is detected at index $`k`$, $``\text{ShouldWrite}(P, B_{\text{new}})``$ evaluates to true, and $``B_{\text{new}}``$ is persisted atomically via a temporary sibling file. - **Diagnostic:** `E0200` emitted if atomic rename fails. */
        part def AC_03_Single_Byte_Divergence_Detection_and_Atomic_Commit {
        }
        doc /* - **Given:** An AST containing $`K`$ node instances referencing $`M`$ unique identifier strings ($`M \ll K`$). - **When:** The model undergoes successive serialize-deserialize-serialize cycles. - **Then:** Serialized payloads store a centralized table of exactly $`M`$ deduplicated strings, deserialization interns symbols without duplication per Directive 3, and successive serialization streams $``\mathcal{B}_1 = \mathcal{B}_2``$ exhibit zero diff churn per REQ-0003. - **Diagnostic:** `E0200` emitted on symbol duplication or bitwise divergence across serialize-deserialize cycles. */
        part def AC_03_String_Interner_Symbol_Deduplication_Idempotency {
        }
        doc /* - **Given:** An AST model where `Part_0` contains `Part_1` and `Part_1` contains `Part_0`, or where feature `Usage_1` redefines `Usage_2` (`:>>`) and `Usage_2` redefines `Usage_1`. - **When:** Cycle detection evaluates composition graph $``G_{\text{comp}}``$ and redefinition graph $``G_{\text{redef}}``$. - **Then:** The engine detects the cyclic dependency in each respective graph, rejects recursive instantiation, and emits diagnostic `E0203`. - **Diagnostic:** `E0203` emitted on structural containment or feature redefinition cycles. */
        part def AC_03_Structural_Composition_and_Feature_Redefinition_Cycle_Rejection {
        }
        doc /* - **Given:** Containment path where `Package_0` contains `Classifier_Alpha`, which contains `Port_1`. - **When:** A compilation pass attempts to insert an inverted containment edge (`Contains`) from child `Port_1` to ancestor `Package_0`. - **Then:** The engine rejects the cycle, preserves valid forest structure, and emits diagnostic `E0203` without panicking. - **Diagnostic:** `E0203` emitted on detected cycle in containment hierarchy. */
        part def AC_03_Structural_Containment_Forest_Acyclicity {
        }
        doc /* - **Given:** `Classifier_Beta` specializing `Classifier_Alpha` (`Classifier_Beta :> Classifier_Alpha`) and feature usage `Usage_Sub : Classifier_Beta`. - **When:** `Usage_Sub` is assigned to an interface slot, parameter, or port expecting `Classifier_Alpha`. - **Then:** The type checker evaluates $``\text{ConformsTo}(\text{Usage\_Sub}, \text{Classifier\_Alpha}) = \text{true}``$ because $``\tau(\text{Usage\_Sub}) \le \text{Classifier\_Alpha}``$, accepting the binding. - **Diagnostic:** `E0200` emitted if an incompatible classifier type `Classifier_Gamma` ($``\text{Classifier\_Gamma} \not\le \text{Classifier\_Alpha}``$) is bound to the target slot. */
        part def AC_03_Subtyping_Conformance_Verification {
        }
        doc /* - **Given:** An acyclic model multigraph $`G`$ containing 1,000 nodes and 2,500 edges. - **When:** Tarjan SCC decomposition executes. - **Then:** Exactly 1,000 singleton components ($``|C_i| = 1``$) are identified, producing condensation DAG $`G^{\text{scc}}`$ without self-loops and zero diagnostics emitted. - **Diagnostic:** `E0203` if false cycles are reported. */
        part def AC_03_Tarjan_SCC_Condensation_Trivial_Component_Isolation {
        }
        doc /* - **Given:** A manifest entry containing traversal tokens (`../Package_0/Escaped.sysml`). - **When:** `prune_tombstones` validates paths prior to unlinking. - **Then:** Resolution rejects unconfined paths ($`\text{IsDescendant} \equiv \text{false}`$), zero unlinking syscalls are issued, and compilation proceeds. - **Diagnostic:** `E0200` emitted on traversal violation. */
        part def AC_03_Workspace_Output_Confinement_and_Traversal_Rejection {
        }
        doc /* - **Given:** A scope importing `Package_0` and `Package_1`, both exporting identifier `Port_1` without local shadowing. - **When:** An unqualified reference to `Port_1` is evaluated. - **Then:** The resolver rejects the reference as ambiguous, emits diagnostic `E0200` citing candidate locations, and binds sentinel $``\bot_{\text{node}}``$. - **Diagnostic:** `E0200` on colliding imported identifiers. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Ambiguous_Import_Conflict_Detection {
        }
        doc /* - **Given:** Arena buffer with fixed capacity $``C_{\text{slots}}``$ and invalid index request ($``i \ge C_{\text{slots}}``$). - **When:** An operation attempts slot allocation or lookup exceeding capacity limits. - **Then:** Execution halts gracefully without panicking, recording structured diagnostic `E0200`. - **Diagnostic:** `E0200` recorded upon arena capacity exhaustion or out-of-bounds slot access. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Arena_Boundary_Enforcement_Non_Panicking_Diagnostic_Recovery {
        }
        doc /* - **Given:** An AST model containing cyclic loop `Classifier_Alpha` $`\to`$ `Classifier_Beta` $`\to`$ `Classifier_Gamma` $`\to`$ `Classifier_Alpha` and independent acyclic element `Classifier_Delta`. - **When:** Tarjan SCC evaluates the model graph. - **Then:** The engine detects component $`|C| = 3`$, extracts traceback path $``\langle \text{Classifier\_Alpha}, \text{Classifier\_Beta}, \text{Classifier\_Gamma}, \text{Classifier\_Alpha} \rangle``$, records diagnostic `E0203`, marks cyclic handles invalid, and recovers to schedule `Classifier_Delta`. - **Diagnostic:** `E0203` on cycle detection; `E0199` on diagnostic sink overflow ($``C_{\text{max\_errors}}``$). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Circular_Dependency_Detection_Traceback_Synchronization_Recovery {
        }
        doc /* - **Given:** An incremental module import introducing a cyclic dependency (`Module_Alpha -> Module_Beta -> Module_Alpha`). - **When:** The compiler executes DAG construction and cycle detection. - **Then:** The compiler detects non-acyclicity, halts lowering, rejects the invalid graph, and emits diagnostic error code `E0203` detailing cycle path coordinates without panicking. - **Diagnostic:** `E0203` (Circular module dependency detected in module DAG). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Circular_Module_Dependency_Rejection {
        }
        doc /* - **Given:** An AST graph with entities `Package_0`, `Classifier_Alpha`, and `Port_1` interconnected via typed node handles. - **When:** The graph is serialized to CBOR/JSON (REQ-0044) and deserialized in independent processes. - **Then:** Deserialized handle integers, slot offsets, and edge topologies exhibit 100% bitwise parity without pointer swizzling. - **Diagnostic:** `E0200` emitted on deserialization handle corruption. */
        part def AC_04_Cross_Platform_Serialization_Parity {
        }
        doc /* - **Given:** Structural node `Package_0::Classifier_Alpha` with canonical topological path $`p`$. - **When:** The transformation engine executes an in-place rewrite pass. - **Then:** The node's RFC 4122 UUIDv5 matches $``\text{UUIDv5}(\text{NS}_{\text{DEAP}}, p)``$ with version bits `0x50` and variant bits `0x80`, ensuring 0-byte diff churn. - **Diagnostic:** `E0200` emitted on UUIDv5 computation failure or variant mismatch. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Deterministic_RFC_4122_UUIDv5_Anchor_Preservation {
        }
        doc /* - **Given:** Validated standalone graph $``G_{\text{standalone}} = G_{\text{slice}} \cup \text{Deps}(G_{\text{slice}})``$. - **When:** The engine serializes the package into canonical binary format and deterministic JSON. - **Then:** Deserializing either format reconstructs identical AST topologies, UUIDv5 identifiers, and attribute values with bitwise parity. - **Diagnostic:** `E0200` emitted on encoding failure or deserialization structural divergence. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Dual_Format_Serialization_and_Bitwise_Parity {
        }
        doc /* - **Given:** Serialized payload inputs containing malformed byte tokens at offset $``p_{\text{byte}}``$, or a 100,000-node AST evaluated in compiled Release mode (`--release`). - **When:** Deserialization evaluates malformed streams or executes performance benchmark harnesses. - **Then:** Per Directive 4, the deserializer resynchronizes on record boundaries, emitting structured diagnostic `E0200` (or `E0199` on sink exhaustion); per Directive 5 and REQ-0196, 100,000-node CBOR deserialization latency is $`\le 15`$ ms, serialization is $`\le 25`$ ms, and RSS memory is $`\le 100`$ MB with zero panics. - **Diagnostic:** `E0200` emitted for malformed stream tokens, panics, or benchmark latency and memory limit violations. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Error_Recovery_Diagnostic_Binding_Performance_Gates {
        }
        doc /* - **Given:** An orphaned file in $``\mathcal{T}_{\text{prune}}``$ that is missing or has read-only permissions (`EACCES`). - **When:** `prune_tombstones` attempts unlinking. - **Then:** Missing files succeed as idempotent no-ops; permission faults record `E0200` and pruning continues without panicking. - **Diagnostic:** `E0200` emitted on filesystem permission or I/O failure. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Idempotent_Unlinking_and_Non_Panicking_Fault_Tolerance {
        }
        doc /* - **Given:** An edge insertion request referencing an unallocated 32-bit arena index or an expired node handle. - **When:** Endpoint handles are validated during edge insertion. - **Then:** Insertion is rejected under a total-function contract, graph state remains unchanged, and diagnostic `E0200` is recorded. - **Diagnostic:** `E0200` emitted on invalid or out-of-bounds node handle. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Invalid_and_Stale_Node_Handle_Rejection {
        }
        doc /* - **Given:** `Classifier_Alpha` declaring feature `Feature_A` with multiplicity interval $`[0, 10]`$. - **When:** A specializing classifier or usage redefines `Feature_A` with narrowed interval $`[1, 5]`$. - **Then:** The compiler verifies $`[1, 5] \subseteq [0, 10]`$ and accepts the redefinition; redefining with widened interval $`[0, 20]`$ fails compilation. - **Diagnostic:** `E0200` emitted on non-monotonic multiplicity interval widening. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Monotonic_Covariance_in_Multiplicity_Narrowing {
        }
        doc /* - **Given:** Target path $`P`$ in namespace `Package_0` where $`\text{FileExists}(P) = \text{false}`$. - **When:** The persistence engine processes output artifact $`P`$. - **Then:** $``\text{ShouldWrite}(P, B_{\text{new}})``$ evaluates to true without memory mapping, creating the destination artifact atomically. - **Diagnostic:** `E0200` emitted on directory creation or permission error. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Non_Existent_Target_Atomic_Creation {
        }
        doc /* - **Given:** Invalid peer pairings (`(In, In)`, `(Out, Out)`, `(In, InOut)`) and inverted delegation pairings (outer `In` to inner `Out`, outer `Out` to inner `In`). - **When:** Type checking processes connection topology. - **Then:** Rejects each invalid edge, logs structured `E0201` diagnostics with byte spans and port handles, and continues verification via synchronization recovery. - **Diagnostic:** `E0201` recorded in diagnostic sink $``\mathcal{D}_{\text{sink}}``$. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Peer_and_Delegation_Direction_Mismatch_Rejection {
        }
        doc /* - **Given:** Channel `Channel_0` ($``C_{\text{channel}} = 1000``$ bytes/sec), flow `Flow_Err1` with rate $`[100.0, 10.0]`$ Hz, and flow `Flow_Err2` with peak throughput $`1280`$ bytes/sec. - **When:** Validating rate multiplicity and channel capacity constraints. - **Then:** Rejects `Flow_Err1` for inverted rate bounds and `Flow_Err2` for capacity overflow, emitting structured diagnostics. - **Diagnostic:** Emits `E0202` (`MalformedRateMultiplicityInterval` or `ChannelCapacityOverflow`). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Rate_Multiplicity_Well_Formedness_and_Channel_Capacity_Bounds {
        }
        doc /* - **Given:** Sibling directories normalizing to identical PascalCase identifiers (e.g., `module_alpha` and `module-alpha`), or a path with nesting depth $`k = 17`$ exceeding $``D_{\max} = 16``$. - **When:** Directory segment normalization and depth validation execute. - **Then:** The compiler rejects the offending units, emits diagnostic `E0200` with the source coordinate, and maintains stable compiler arena state. - **Diagnostic:** `E0200` emitted on segment collision or nesting depth overflow ($`k \gt 16`$). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Segment_Normalization_Collision_Detection_and_Depth_Bounds {
        }
        doc /* - **Given:** An AST model containing two disjoint inheritance cycles alongside valid acyclic subgraphs. - **When:** Cycle detection executes with synchronization token error recovery enabled. - **Then:** The engine records distinct `E0203` diagnostics for both cycles in $``\mathcal{D}_{\text{sink}}``$, prunes closing back-edges in $``\mathcal{E}_{\text{overlay}}``$ substituting sentinel $``\bot_{\text{cycle}}``$, and completes semantic validation on remaining valid subgraphs. - **Diagnostic:** `E0203` recorded per cycle; `E0199` emitted if total diagnostics reach $``C_{\text{max\_errors}}``$. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Synchronization_Token_Error_Recovery_and_Overlay_Pruning {
        }
        doc /* - **Given:** Model $`\mathcal{A}`$ with $`10^4`$ nodes and target `Classifier_Alpha` with depth $`k \le 3`$. - **When:** Slice $``G_{\text{slice}}``$ is serialized to canonical representation. - **Then:** Serialized token volume satisfies $``|\text{Tokens}(G_{\text{slice}})| \le 0.15 \cdot |\text{Tokens}(\mathcal{A})|``$. - **Diagnostic:** `E0200` emitted on token volume violation. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Token_Volume_Reduction_and_Context_Isolation {
        }
        doc /* - **Given:** Pathological inputs (invalid UTF-8 bytes, strings exceeding $``L_{\text{max\_str}} = 65536\text{ bytes}``$, or pool capacity exhaustion), and Release mode (`--release`) benchmark harnesses. - **When:** The compiler interns malformed inputs or executes $`10^6`$ token benchmarks. - **Then:** Pathological inputs yield sentinel $``\bot_{\text{sym}} = 2^{32} - 1``$ and emit diagnostic `E0200` without panicking; release benchmarking achieves throughput exceeding $`5 \times 10^6\text{ tokens/s}`$, reverse resolution latency under $`20\text{ ns}`$, execution latency under 25 ms, and greater than 60% AST memory reduction. - **Diagnostic:** `E0200` emitted on invalid encoding, length overflow, pool exhaustion, or benchmark gate violation. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Total_Function_Sentinel_Diagnostics_Release_Performance {
        }
        doc /* - **Given:** A synthetic DAG containing hierarchy `Package_0::Classifier_Alpha::Port_1` and visitors configured with `Continue`, `Prune`, and `Halt` directives. - **When:** Executing pre-order, post-order, topological, and directive-controlled traversals. - **Then:** Pre-order visits parents before children ($`\text{pos}(u) \lt \text{pos}(v)`$); post-order visits children before parents ($`\text{pos}(u) \gt \text{pos}(v)`$); `Prune` skips child branches; `Halt` terminates traversal immediately in $`O(1)`$ steps. - **Diagnostic:** `E0200` emitted on traversal order sequence violation. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Traversal_Ordering_Sequences_and_Visitor_Control_Directives {
        }
        doc /* - **Given:** An AST containing reference $``r_1``$ targeting missing symbol `Classifier_Missing` and reference $``r_2``$ matching multiple candidate definitions across imported scopes. - **When:** Pass 2 resolves references against symbol table $`\Gamma`$. - **Then:** Pass 2 binds sentinel $``\bot_{\text{sym}}``$ to each faulted reference, accumulates structured diagnostic records, and completes traversal. - **Diagnostic:** `E0200` on unresolvable or ambiguous symbol references. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Unresolved_and_Ambiguous_Symbol_Diagnostics {
        }
        doc /* - **Given:** An AST model with $`10^6`$ nodes allocated in contiguous node arena chunks. - **When:** Dereferencing throughput and arena memory are benchmarked in Release mode (`--release`) under an isolated harness (Directive 5, REQ-0196). - **Then:** Dereferencing throughput exceeds $`10^8`$ ops/s (latency $`\lt 10\text{ ns}`$) with peak RSS below $`100\text{ MB}`$ and zero panics. - **Diagnostic:** `E0200` emitted if memory corruption or runtime failure occurs. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_05_Panic_Free_Release_Mode_Latency_and_Memory_Bounds {
        }
        doc /* The compiler core metamodel lowering engine shall lower all ingested schema abstract syntax tree (AST) entities (packages, part definitions, port definitions, action definitions, constraint definitions) into contiguous virtual memory allocations within a typed node arena. AST entities must be allocated in uniform-sized contiguous slots of size $``S_{\text{slot}} = \text{sizeof}(\text{NodeSlot})``$ with 64-bit alignment ($``A_{\text{align}} = 8\text{ bytes}``$), eliminating per-node heap allocator headers, pointer chasing, and heap fragmentation. All inter-node edges and hierarchies within the lowered AST shall reference target entities exclusively via typed scalar integer handles (`NodeIndex`), guaranteeing a pointer indirection depth of zero ($``\text{PointerIndirectionDepth}(\mathcal{A}_{\text{node}}) = 0``$). Insertion into pre-allocated arena chunks shall execute in amortized $`O(1)`$ time, and complete lowering of an AST with $`N`$ entities shall execute in deterministic linear time $`O(N)`$ with $`O(1)`$ base-plus-offset random slot access. --- */
        part def _1_Normative_Statement {
        }
        doc /* Let $``\mathcal{A}_{\text{node}}``$ denote a contiguous typed arena buffer with base address $``\text{Base}(\mathcal{A}_{\text{node}})``$, uniform slot size $``S_{\text{slot}} = \text{sizeof}(\text{NodeSlot})``$, and 64-bit alignment $``A_{\text{align}} = 8\text{ bytes}``$. Contiguous Address Arithmetic and Alignment Invariant: \begin{aligned} \forall i \in \{0, \dots, N-1\}, \quad \text{Address}(\text{Node}_i) &= \text{Base}(\mathcal{A}_{\text{node}}) + i \cdot S_{\text{slot}} \\ \forall i \in \{0, \dots, N-2\}, \quad \text{Address}(\text{Node}_{i+1}) - \text{Address}(\text{Node}_i) &= S_{\text{slot}} \\ \forall i \in \{0, \dots, N-1\}, \quad \text{Address}(\text{Node}_i) &\equiv 0 \pmod{A_{\text{align}}} \end{aligned} Zero Pointer Indirection Depth Invariant: \begin{aligned} \text{PointerIndirectionDepth}(\mathcal{A}_{\text{node}}) &= 0 \\ \forall (u, v) \in \mathcal{E}_{\text{AST}}, \quad \text{TargetHandle}(u, v) &\in \mathbb{N}_0 \end{aligned} Asymptotic Lowering and Constant-Time Access Invariants: \begin{aligned} T_{\text{lower}}(N) &\le c_1 \cdot N + c_0, \quad \forall N \ge 1 \\ T_{\text{access}}(i) &\le c_2 \cdot 1, \quad \forall i \in \{0, \dots, N-1\} \end{aligned} Spatial Cache Line Locality Bound: For cache line size $``L_{\text{cache}} \in \{64, 128\}\text{ bytes}``$, sequential traversal over $`k`$ consecutive slots incurs cache transfers bounded by: \mathcal{M}_{\text{cache}}(k) \le \left\lceil \frac{k \cdot S_{\text{slot}}}{L_{\text{cache}}} \right\rceil + 1 Capacity and Diagnostic Invariant: For arena slot capacity $``C_{\text{slots}} \in \mathbb{N}``$: i \ge C_{\text{slots}} \implies \text{Diagnostic}(\text{span}(\text{Node}_i), \text{E0200}) --- */
        part def _2_Formal_Invariant {
        }
        doc /* The contiguous memory lowering engine executes within Complexity Class $`\mathbf{P}`$. Slot allocation executes in amortized $`O(1)`$ time via pointer bump and capacity check. Complete lowering of an AST with $``N = |\mathcal{V}_{\text{AST}}|``$ nodes executes in deterministic linear time $`O(N)`$ in a single traversal pass. Random slot access executes in worst-case $`O(1)`$ constant time via base-plus-offset address arithmetic $``\text{Base} + i \cdot S_{\text{slot}}``$. Sequential traversal executes in $`O(N)`$ time with hardware cache prefetching. Total memory footprint is strictly bounded by $`O(N)`$ linear space proportional to $``N \cdot S_{\text{slot}}``$ with zero per-node heap allocator overhead. Parallel lowering across $`K`$ units on bounded work-stealing threads ($``N_{\text{max\_workers}}``$) achieves $``O(\lceil K / N_{\text{max\_workers}} \rceil \cdot N_{\text{max\_unit}})``$ wall-clock scaling. Metamodel arena lowering operates entirely in polynomial time $`\mathbf{P}`$, serving as the zero-indirection substrate for downstream tractable graph passes (e.g., NP-3 type linearization in $`O(V+E)`$). --- */
        part def _3_Computational_Complexity_Algorithmic_Bounds {
        }
        part def _4_Verification_Conformance_Criteria {
        }
    }
    doc /* Complete OMG SysML v2 / KerML Metamodel Lowering & Grammar */
    package Subsystem_4_Complete_SysMLv2_KerML_Grammar {
        doc /* UUIDv5: bb1eed77-c074-5fcf-af35-578e302d7222 | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0199, E0200, E0203 */
        requirement def REQ_0054_KerML_Root_Element_Relationship {
            id = "REQ-0054";
            text = "The compiler metamodel lowering engine shall define and enforce the foundational KerML abstract syntax root hierarchy as a rooted directed multigraph of semantic elements E, directed relationships R \subseteq E, metadata annotations M \subseteq E, and containment ownership relations O \subset E";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 9e2f0360-44cc-5d8c-8b8b-6018610e2a3d | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0199, E0200, E0203 */
        requirement def REQ_0055_KerML_Namespace_Membership_OwningMembership {
            id = "REQ-0055";
            text = "The semantic model lowering engine shall represent lexical scopes, naming environments, and containment hierarchies as formal Namespace scopes composed of typed Membership relationships, mapping interned member symbols to semantic element node handles in the AST graph.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: c1343fa7-4d7b-5a7c-8b6d-852eb849cd7c | Complexity: Class P (O(V + E)) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0200, E0203 */
        requirement def REQ_0056_KerML_Import_Declaration_Semantics {
            id = "REQ-0056";
            text = "The KerML scoping engine shall evaluate namespace import declarations as deterministic relational projections over exported membership sets across compilation units.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 8eddb83e-6d77-5e25-8cb7-99446770451d | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0100, E0199, E0200, E0203 */
        requirement def REQ_0057_KerML_Core_Classifiers {
            id = "REQ-0057";
            text = "The semantic metamodel lowering engine shall formalize the foundational KerML classifier hierarchy into a bounded subtyping poset (K, \le) rooted at Type. Classifiers shall be partitioned into structural value types (DataType) and extensional identity-bearing entities (Class, Structure) under";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 4a99d369-c8da-5c7e-a490-ab0cb4977158 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0199, E0200 */
        requirement def REQ_0058_KerML_Association_AssociationStructure {
            id = "REQ-0058";
            text = "The semantic lowering engine shall formalize multi-ary relations as Association and AssociationStructure classifiers possessing k \ge 2 participant end features (AssociationEnd), enforcing relational constraints, directional navigability, and fiber cardinality bounds over extensional Link tuples.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: f8a99dba-f533-51eb-a7a0-08837836699c | Complexity: Class P (O(K + V)) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0100, E0199, E0200, E0201, E0202, E0203 */
        requirement def REQ_0059_KerML_Interaction {
            id = "REQ-0059";
            text = "The semantic lowering engine shall formalize occurrence communications and flow exchanges as Interaction classifiers in accordance with KerML. An Interaction classifier shall multiply specialize both Behavior and Association, combining behavioral occurrence execution semantics with relational";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 87385097-1e99-5971-bbc0-c2ee18aae170 | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0199, E0200, E0201 */
        requirement def REQ_0060_KerML_Core_Features {
            id = "REQ-0060";
            text = "The semantic lowering engine and AST graph engine shall formalize properties, behavioral invocations, structural slots, directional parameters, and execution steps as instances of the unified Feature abstract syntax metaclass. In the KerML metamodel lowering pipeline, Feature shall specialize both";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: c8188a43-ccd5-570d-91e6-b128419ad088 | Complexity: Class P (O(V + E)) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0200, E0203 */
        requirement def REQ_0061_KerML_Subsetting_Relationship {
            id = "REQ-0061";
            text = "The compiler metamodel lowering engine and semantic type checker shall formalize KerML feature subsetting (Subsetting, denoted by operator :>) as value-set inclusion within the subtyping meet-semilattice. When a feature subsetting relationship f_{sub} :> f_{sup} is declared between subsetting";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: d300863e-c4c6-55b1-94c7-30ee8390eb56 | Complexity: Class P (O(V + E)) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0200, E0203 */
        requirement def REQ_0062_KerML_Redefinition_Relationship {
            id = "REQ-0062";
            text = "The metamodel lowering engine shall formalize the KerML and SysML v2 feature redefinition relationship (:>>, redefines) as contextual slot replacement over multiple inheritance directed acyclic graphs (DAGs), enforcing monotonic C3 superclass linearization, subtyping conformance, and multiplicity";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: abaf4675-a49f-5c64-82e2-bc657b129bf2 | Complexity: Class P (O(K) = O( | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0100, E0199, E0200, E0201, E0203 */
        requirement def REQ_0063_KerML_Conjugation_Relationship_Lowering {
            id = "REQ-0063";
            text = "The semantic lowering engine and AST graph engine shall formalize the KerML conjugation relationship (~) and port inversion transformation across all port definitions, interface definitions, and port usages. The engine shall evaluate conjugation as an algebraic involution over the directional";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 279a50da-8ed5-54c9-b690-386f5f3e45f8 | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0199, E0200 */
        requirement def REQ_0064_KerML_Disjoining_Differencing_Intersecting {
            id = "REQ-0064";
            text = "The semantic type checker and metamodel lowering engine shall implement a formal Boolean algebra over classifier type denotations, providing set-theoretic type operators (unioning, intersecting, differencing, disjoining) to construct compound classifiers and enforce static disjointness invariants.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: f0d53f25-68f4-50ab-ba79-c951ae49494f | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0199, E0200, E0201, E0203 */
        requirement def REQ_0065_KerML_Expressions {
            id = "REQ-0065";
            text = "The KerML expression lowering engine and semantic type checker shall transform KerML expressions into an immutable, strongly typed abstract syntax tree (AST) rooted in Expression. Expression shall specialize Step, Feature, Classifier, and Type, formalizing every expression as a computational step";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 1b6581e1-15ff-536e-b6b3-3e19ca1cce4e | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0100, E0199, E0200, E0201, E0203 */
        requirement def REQ_0066_KerML_Functions {
            id = "REQ-0066";
            text = "The functional lowering engine of Subsystem 4 shall formalize KerML Function classifiers as pure mathematical morphisms from input parameter domains to output result codomains. A Function specializes Behavior (and transitively Class, Classifier, Type) under referential transparency, total";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 467f497c-eb92-5193-bb98-1be296c8f403 | Complexity: Class P (O(V + E)) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG KerML §8.2.4 | Diagnostics: E0100, E0200, E0203 */
        requirement def REQ_0067_KerML_Occurrences {
            id = "REQ-0067";
            text = "The KerML lowering engine SHALL formalize spatio-temporal entities as OccurrenceDefinition (specializing Class) and OccurrenceUsage (specializing Feature and Occurrence). Every OccurrenceUsage MUST be typed by one or more OccurrenceDefinition classifiers via FeatureTyping; typing with";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: ed698792-bf46-5dad-a504-389464496131 | Complexity: Class P (O(1) temporal slice check, O(N) occurrence traversal) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG KerML §8.2.4 | Diagnostics: E0100, E0199, E0200 */
        requirement def REQ_0068_KerML_PortionKind_TimeSlice_Snapshot {
            id = "REQ-0068";
            text = "The KerML lowering engine SHALL formalize occurrence decomposition operators, lowering snapshot, time slice, and event occurrence constructs into rigorous geometric intersections over 4-dimensional occurrence world-lines and world-volumes (W \subseteq \mathbb{R}^3 \times \mathbb{R}). An occurrence";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: d81b9904-d2b0-5a93-b2b9-f6f7a9c809c4 | Complexity: Class P (O(1) step transition check, O(V + E) control flow traversal) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG KerML §8.2.5 | Diagnostics: E0100, E0199, E0200, E0201, E0202 */
        requirement def REQ_0069_KerML_Behaviors {
            id = "REQ-0069";
            text = "The behavioral lowering engine of Subsystem 4 SHALL formalize behaviors, actions, invocations, and temporal performance occurrences in strict accordance with the OMG Kernel Modeling Language (KerML) and Systems Modeling Language (SysML v2) specifications. Behavior SHALL specialize Class (and";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: cb9f13bb-7ca2-5402-b696-cc49dff8fafd | Complexity: Class P (O(V + E) topological sort and visibility checks) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.3 | Diagnostics: E0100, E0199, E0200, E0203 */
        requirement def REQ_0070_SysML_v2_Package {
            id = "REQ-0070";
            text = "The SysML v2 model organization engine SHALL structure models into modular package and subsystem hierarchies, formalizing visibility boundaries, package imports, and encapsulation boundaries as an acyclic package dependency graph. A package declaration (package <name> {... }) defines a sovereign";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: eacf8cba-181e-5c3c-9c99-0a174c5e85d9 | Complexity: Class P (O(V + E)) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.3 | Diagnostics: E0100, E0199, E0200, E0203 */
        requirement def REQ_0071_SysML_v2_PartDefinition {
            id = "REQ-0071";
            text = "The structural compiler SHALL formalize SysML v2 part definitions (part def, PartDefinition) and part usages (part, PartUsage) into strongly typed, compositely owned structural elements anchored within the core KerML classifier subtyping lattice (K, \le). PartDefinition SHALL specialize KerML";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: b3469699-3d65-50e9-b35a-e85caa063106 | Complexity: Class P (O(1) port resolution, O(F) feature conjugation) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.4 | Diagnostics: E0100, E0199, E0200 */
        requirement def REQ_0072_SysML_v2_PortDefinition {
            id = "REQ-0072";
            text = "The structural compiler SHALL formalize SysML v2 port definitions (port def, PortDefinition) and port usages (port, PortUsage) as interaction point classifiers specializing KerML Structure. A port definition P defines an interface protocol specifying typed directed features. Every port usage p";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 81ec112f-82ed-5723-96a1-8d571346d02c | Complexity: Class P (O(1) item typing, O(F) flow conservation) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.5 | Diagnostics: E0100, E0199, E0200 */
        requirement def REQ_0073_SysML_v2_ItemDefinition {
            id = "REQ-0073";
            text = "The data and flow modeling engine SHALL formalize SysML v2 item definitions (item def, ItemDefinition) and item usages (item, ItemUsage) as structural classifiers specializing KerML Structure. Item usages represent physical, energetic, or informational payloads flowing across interconnection";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: fccf8a19-6097-5281-abc1-4509cf95499a | Complexity: Class P (O(1) endpoint lookup, O(E) topology validation) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.6 | Diagnostics: E0100, E0199, E0200 */
        requirement def REQ_0074_SysML_v2_ConnectionDefinition {
            id = "REQ-0074";
            text = "The interconnect engine SHALL formalize SysML v2 connection definitions (connection def, ConnectionDefinition) and connection usages (connection, connect, Connector) as relational association structures binding two or more port endpoints. ConnectionDefinition SHALL specialize KerML";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 175a4875-f152-5c8c-90d6-403719d5a38a | Complexity: Class P (O(1) conjugate check, O(V + E) C3) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.6 | Diagnostics: E0100, E0199, E0200, E0201, E0202, E0220 */
        requirement def REQ_0075_SysML_v2_InterfaceDefinition {
            id = "REQ-0075";
            text = "The protocol engine SHALL formalize SysML v2 interface definitions (interface def) as contractual association structures specifying complementary end-roles, and interface usages (interface) as communication protocol bindings between component ports. InterfaceDefinition SHALL specialize KerML";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 5f2c1a0d-6d71-5b4e-bb8d-6b418141e90e | Complexity: Class P (O(1) directionality, O(F) flow checking) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.6 | Diagnostics: E0100, E0199, E0200, E0201, E0202 */
        requirement def REQ_0076_SysML_v2_ItemFlow {
            id = "REQ-0076";
            text = "The metamodel lowering engine SHALL formalize SysML v2 flow usages (ItemFlow) as directed transfers traversing connectors between port endpoints, specializing KerML Step and OccurrenceUsage in arena storage.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 95e986c4-135e-5e26-83fd-814f63b42e72 | Complexity: Class P (O(V + E) verification) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 | Diagnostics: E0100, E0199, E0200, E0203 */
        requirement def REQ_0077_SysML_v2_AllocationDefinition {
            id = "REQ-0077";
            text = "The SysML v2 lowering engine SHALL formalize allocation definitions (allocation def) and usages (allocate... to..., AllocationUsage) as a typed bipartite relation from behavioral source elements to structural target elements. AllocationDefinition SHALL specialize KerML ConnectionDefinition, and";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 1b74dcfc-dc78-551c-a61e-55c313f4670a | Complexity: Class P (O(V + E) DAG topological acyclicity) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.7 | Diagnostics: E0100, E0199, E0200, E0201, E0202, E0203 */
        requirement def REQ_0078_SysML_v2_ActionDefinition {
            id = "REQ-0078";
            text = "The compiler SHALL lower SysML v2 action definitions (action def, ActionDefinition) as process classifiers specializing KerML Behavior and OccurrenceDefinition, and action usages (action, ActionUsage) as discrete steps specializing KerML Step and OccurrenceUsage.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 0acb8a8b-8dc8-50a8-8857-b16e8246b4d7 | Complexity: Class P (O(1) lookup, O(V + E) lowering) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.7 | Diagnostics: E0100, E0199, E0200, E0203 */
        requirement def REQ_0079_SysML_v2_StateDefinition_StateUsage {
            id = "REQ-0079";
            text = "The statechart lowering engine SHALL formalize SysML v2 state machine definitions (state def, StateDefinition) and state usages (state, StateUsage) as behavioral classifiers specializing KerML ActionDefinition and ActionUsage.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: efb9e7ec-bdd3-53ae-88b0-7d28be789ccb | Complexity: Class P (O(1) precedence, O(h) LCA ladder) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.7 | Diagnostics: E0199, E0200, E0201, E0202, E0203 */
        requirement def REQ_0080_SysML_v2_TransitionUsage_with_Triggers_Guards {
            id = "REQ-0080";
            text = "The compiler SHALL lower SysML v2 transition usages (TransitionUsage) as directed behavioral edges between state configurations, specializing KerML ActionUsage and Step.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: eb2be5ec-7529-5ce0-80a6-020baaaa2ba7 | Complexity: Class P (O(1) dispatch, O(V_S + V_A) lowering) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.7 / KerML §7.4 | Diagnostics: E0100, E0199, E0200, E0201 */
        requirement def REQ_0081_SysML_v2_EntryAction_DoAction {
            id = "REQ-0081";
            text = "The state machine engine SHALL formalize SysML v2 state lifecycle hooks (entry, do, exit) as temporal occurrences bound to state activation, residence, and deactivation intervals. StateDefinition and StateUsage specialize KerML Behavior; EntryActionUsage, DoActionUsage, and ExitActionUsage";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 463a9478-f46e-5be3-8fae-2c9c3a6e34bd | Complexity: Class P (O(V + E) DAG topological evaluation) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.12 | Diagnostics: E0100, E0199, E0200, E0201, E0203 */
        requirement def REQ_0082_SysML_v2_CalculationDefinition {
            id = "REQ-0082";
            text = "The lowering engine SHALL formalize SysML v2 calculation definitions (calc def, CalculationDefinition) as functional classifiers specializing KerML Function, and calculation usages (calc, CalculationUsage) as steps specializing KerML Step.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 1ee09e4b-5e48-5858-8ef5-4d28e0e9e535 | Complexity: Class P (O(1) stack ops / evaluation, O(N + M + E) AST) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.7 | Diagnostics: E0100, E0199, E0200, E0201, E0203 */
        requirement def REQ_0083_SysML_v2_ConstraintDefinition {
            id = "REQ-0083";
            text = "The metamodel lowering engine SHALL formalize SysML v2 constraint def (ConstraintDefinition) and constraint (ConstraintUsage) as Boolean predicate functions specializing KerML Predicate and Function. Every ConstraintDefinition SHALL define a pure invariant proposition over formal parameters P_{CD}";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 147a25c4-24cc-5d6e-aede-ee0a83287b0b | Complexity: Class P (O(1) monitor step, O(V + E) AST lowering) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.4 | Diagnostics: E0100, E0199, E0200, E0201, E0203 */
        requirement def REQ_0084_SysML_v2_AssertConstraintUsage_Lowering {
            id = "REQ-0084";
            text = "The KerML/SysML v2 lowering engine SHALL lower assert constraint declarations (assert constraint, AssertConstraintUsage) into invariant assertions specializing KerML ConstraintUsage and Invariant. Every AssertConstraintUsage binds Boolean predicate \Phi to a classifier context (part def, item def,";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: e0a7f813-ecd8-5478-aa4d-32325fea1deb | Complexity: Class P (O(1) ID lookup, O(V + E) DAG sort) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.11 | Diagnostics: E0100, E0199, E0200, E0201, E0203 */
        requirement def REQ_0085_SysML_v2_RequirementDefinition {
            id = "REQ-0085";
            text = "The compiler SHALL lower SysML v2 requirement definitions (requirement def, RequirementDefinition) as contractual classifiers specializing KerML ConstraintDefinition, and requirement usages (requirement, RequirementUsage) as contextual features specializing KerML ConstraintUsage.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 8d961e04-37e9-56d4-bb4f-fdaa3335ab0c | Complexity: Class P (O(1) lookup, O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.11 | Diagnostics: E0100, E0199, E0200, E0203 */
        requirement def REQ_0086_SysML_v2_SatisfyRequirementUsage_Traceability {
            id = "REQ-0086";
            text = "The compiler SHALL lower SysML v2 satisfy requirement usages (SatisfyRequirementUsage, declared via satisfy requirement or satisfy... by...) as directed realization dependencies linking structural parts or actions to requirements, specializing KerML Feature, Step, and Relationship.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 0f2583a9-96b7-5158-9e35-405d1bce68bb | Complexity: Class P (O(1) dispatch step, O(V + E) AST lowering) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.13 | Diagnostics: E0100, E0199, E0200, E0201, E0202, E0203 */
        requirement def REQ_0087_SysML_v2_VerificationCaseDefinition {
            id = "REQ-0087";
            text = "The compiler SHALL lower SysML v2 verification case definitions (verification def, VerificationCaseDefinition) as behavioral procedures specializing KerML Behavior and SysML v2 CaseDefinition, and verification usages (verification, VerificationCaseUsage) as discrete occurrences specializing KerML";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 1a967535-f7bf-5a70-9007-3f9cd6fabcf8 | Complexity: Class P (O(V + E)) | Standard: IEEE 29148-2018 / RFC 2119 / SysML v2 §7.13 | Diagnostics: E0100, E0199, E0200, E0203 */
        requirement def REQ_0088_SysML_v2_ViewDefinition_ViewUsage {
            id = "REQ-0088";
            text = "The compiler SHALL lower SysML v2 view definitions (view def) and usages (view) into structural projection elements, and viewpoint definitions (viewpoint def) and usages (viewpoint) into requirement elements.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: a1f41091-b6c1-5fe5-86e4-b2d2ea224c96 | Complexity: Class P (O(1) lookup, O(V + E) graph projection) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.16, §8.4 | Diagnostics: E0199, E0200, E0202, E0203 */
        requirement def REQ_0089_SysML_v2_Expose_Filtering {
            id = "REQ-0089";
            text = "The compiler SHALL lower SysML v2 expose statements in ViewDefinition and ViewUsage as declarative selection expressions, projecting conformant induced subgraphs and validating viewpoint obligations.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: b6a46e5b-de7c-5040-94b7-590d8b517bda | Complexity: Class P (O(1) dictionary lookup, O(V) indexing) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.13 / KerML §7.4 | Diagnostics: E0199, E0200, E0203 */
        requirement def REQ_0090_SysML_v2_MetadataDefinition {
            id = "REQ-0090";
            text = "The compiler SHALL lower SysML v2 metadata definitions (metadata def, MetadataDefinition) as structural classifiers specializing KerML Structure and Class, and semantic annotation usages (@, MetadataUsage) as extrinsic metadata attachments linking attribute dictionaries to AST nodes without";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: a3a2c4d9-3a7c-5e7e-805c-6b6114f0d491 | Complexity: Class P (O(1) lookup / equality) | Standard: IEEE 29148-2018 / RFC 2119 / OMG KerML §7.2 | Diagnostics: E0199, E0200, E0203 (per REQ-0191) */
        requirement def REQ_0091_KerML_Standard_Library {
            id = "REQ-0091";
            text = "The compiler SHALL bootstrap KerML Base (Package_Base) into root scope at initialization, providing Anything, classifiers Element and Relationship, Nothing, and operators Op_Equal and Op_NotEqual.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 2b01c22c-5f72-5c7c-9289-643bd51ff6c5 | Complexity: Class P (O(1) scalar lowering, O(L) string interning) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG KerML §7.3 | Diagnostics: E0199, E0200 (per REQ-0191) */
        requirement def REQ_0092_Canonical_Scalar_Type_Lowering {
            id = "REQ-0092";
            text = "The compiler SHALL lower KerML ScalarValues types (Boolean, Integer, Real, String) and numeric subtypes (Natural, Positive) into canonical machine representations, preserving semantic value precision, exact integer boundaries, and IEEE 754-2019 binary64 semantics.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 0b2b3058-0632-56d4-94bd-cb187b99762b | Complexity: Class P (O(1) subtyping, O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG KerML §7.3 | Diagnostics: E0199, E0200, E0201, E0203 (per REQ-0191) */
        requirement def REQ_0093_KerML_Standard_Library {
            id = "REQ-0093";
            text = "The compiler SHALL bootstrap KerML Collections (Package_Collections) into root scope at initialization, providing Collection<T>, Set<T>, Sequence<T>, OrderedSet<T>, and Bag<T>.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 59baacb8-6746-534a-b047-2e0eb46e4d6e | Complexity: Class P (O(1) token dispatch, O(V + E) topology verification) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG KerML §7.4, §8.3 | Diagnostics: E0199, E0200, E0202, E0203 (per REQ-0191) */
        requirement def REQ_0094_KerML_Standard_Library {
            id = "REQ-0094";
            text = "The compiler SHALL bootstrap KerML ControlFunctions (Package_ControlFunctions) into root scope at initialization, providing ControlNode (specializing Feature and Step) and primitive functions Control_Fork, Control_Join, Control_Decision, and Control_Merge (specializing ControlNode and Function).";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 7f0247fc-685c-500d-b767-3dc05b1cbb74 | Complexity: Class P (O(1) scale check, O(N) lowering) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.15 | Diagnostics: E0199, E0200, E0300 (per REQ-0191) */
        requirement def REQ_0095_SysML_v2_Quantities_Library {
            id = "REQ-0095";
            text = "The compiler SHALL bootstrap SysML v2 Quantities (Package_Quantities) into root scope, formalizing quantities as magnitude-unit pairs and classifying ratio and interval scales.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: 9ebc08b9-22aa-5436-ae7a-e400a883c776 | Complexity: Class P (O(1) vector ops, O(N) lowering) | Standard: IEEE 29148-2018 / RFC 2119 / ISO 80000 | Diagnostics: E0199, E0200, E0203, E0300 */
        requirement def REQ_0096_SysML_v2_Quantities_Library {
            id = "REQ-0096";
            text = "The compiler SHALL bootstrap Package_ISQBase and Package_ISQ into root scope at initialization.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* UUIDv5: a59cc0bd-9e2b-5c09-8eb4-30712de43c71 | Complexity: Class P (O(1) conversion) | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 §7.15 | Diagnostics: E0199, E0200, E0201, E0203 (per REQ-0191) */
        requirement def REQ_0097_SysML_v2_Quantities_Library {
            id = "REQ-0097";
            text = "The compiler SHALL bootstrap Package_SI and Package_SIPrefixes into root scope, lowering UnitDefinition and PrefixDefinition into immutable AST nodes.";
            satisfy by GrammarLoweringEngine;
        }
        doc /* Primary execution engine for Complete OMG SysML v2 / KerML Metamodel Lowering & Grammar */
        part def GrammarLoweringEngine {
            port in ast_in : ASTGraphPort;
            port out ast_out : ASTGraphPort;
        }
        doc /* - **Given:** `PortDef_Alpha` declaring features `Flow_In` (`In`), `Flow_Out` (`Out`), and `Flow_Bi` (`InOut`). - **When:** Lowering processes conjugated classifier `~PortDef_Alpha`. - **Then:** Containment features invert orientations: `Flow_In` becomes `Out`, `Flow_Out` becomes `In`, and `Flow_Bi` remains `InOut`. - **Diagnostic:** `E0201` emitted on directional inversion failure. */
        part def AC_01_Algebraic_Direction_Involution_Port_Inversion {
        }
        doc /* - **Given:** Valid `action def ActionDef_Alpha` with steps `action Step_Alpha : ActionDef_Beta` and `action Step_Beta : ActionDef_Gamma`. - **When:** Lowering constructs the action workflow AST. - **Then:** Nodes are lowered into arena storage with dual KerML specializations (`Behavior`, `Step`) and zero diagnostics. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Action_Definition_and_Step_Lowering {
        }
        doc /* - **Given:** Action `Action_A` with `Port_Out : out Classifier_Alpha` allocated to `Part_Alpha` with identical `Port_Out`. - **When:** Lowering `allocate Action_A to Part_Alpha`. - **Then:** Lowered as valid bipartite edge $(s, t)$ in arena storage with mapped ports; zero diagnostics. - **Diagnostic:** `E0200` on failure. */
        part def AC_01_Canonical_Allocation_Lowering_and_Port_Realization {
        }
        doc /* - **Given:** Classifier `Classifier_Alpha` with definition `ConstraintDef_Alpha` (`in param_x : Real; in param_y : Real; param_x <= param_y;`) and usage `AssertConstraint_1`. - **When:** Lowering and parameter binding execute. - **Then:** `AssertConstraint_1` lowers into arena storage with `is_asserted` true and empty diagnostic sink. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Assert_Constraint_Lowering {
        }
        doc /* - **Given:** Initialized compiler environment. - **When:** Resolving root library symbols. - **Then:** `Anything`, `Element`, `Relationship`, `Nothing`, `==`, and `!=` resolve in $O(1)$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Base_Bootstrapping {
        }
        doc /* - **Given:** A model declaring `Behavior_Alpha` with parameter `Param_1 : Real [In]` and nested `Step_Alpha : Behavior_Alpha`. - **When:** The compiler lowers the behavior definition and action step into the AST. - **Then:** Both elements are lowered with valid 32-bit handles, verified parameter types, and zero diagnostic emissions. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Behavior_ActionUsage_Performance_Lowering {
        }
        doc /* - **Given:** Valid `calc def CalcDef_Alpha(in Param_X : Real) : Real` and usage `calc Calc_1 : CalcDef_Alpha(Param_X = 1.0)`. - **When:** Calculation lowering constructs the functional AST. - **Then:** Nodes lower into arena storage specializing KerML `Function` and `Step` with zero diagnostics. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Calculation_Lowering {
        }
        doc /* - **Given:** Initialized compiler environment. - **When:** Bootstrapping standard library packages. - **Then:** `Collection`, `Set`, `Sequence`, `OrderedSet`, and `Bag` resolve in $O(1)$ with exact matrix flags. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Collections_Bootstrapping {
        }
        doc /* - **Given:** A connection `connect Part_Alpha.Port_Out to Part_Beta.Port_In` where `Port_Out : PortDef_Alpha` and `Port_In : ~PortDef_Alpha`. - **When:** The compiler executes connection lowering and interface compatibility verification. - **Then:** The connector is lowered into arena storage with bound endpoints and zero diagnostic emissions. - **Diagnostic:** `E0200` emitted if conjugate compatibility check fails. */
        part def AC_01_Canonical_Connection_Lowering_and_Conjugate_Compatibility {
        }
        doc /* - **Given:** `Req_1 : ReqDef_Alpha` and `Part_Alpha : Classifier_Alpha` in `Package_0`. - **When:** Lowering `satisfy requirement Req_1 by Part_Alpha;` or contextual `part Part_Alpha { satisfy requirement Req_1; }`. - **Then:** Edge `(Part_Alpha, Req_1)` enters $``G_{\text{trace}}``$ with populated adjacency maps and empty diagnostic sink. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Explicit_and_Contextual_Satisfy_Lowering {
        }
        doc /* - **Given:** `Package_0` with classifiers `Classifier_Alpha` and `Classifier_Beta` connected by relation `Rel_A`. - **When:** Lowering `view def ViewDef_Alpha { expose Package_0::Classifier_Alpha, Package_0::Classifier_Beta; }`. - **Then:** Classifiers resolve into $``V_{\text{exp}}``$ and induced edge `Rel_A` is included in $``E_{\text{exp}}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Expose_Path_Resolution_and_Induced_Subgraph_Projection {
        }
        doc /* - **Given:** Classifier `Classifier_Alpha` declaring feature `Feature_Sup : Classifier_Alpha [0..10]`, and specializing classifier `Classifier_Beta :> Classifier_Alpha` declaring `Feature_Sub :> Feature_Sup : Classifier_Beta [1..5]`. - **When:** The compiler executes the metamodel lowering pass. - **Then:** The subsetting relationship is verified with co-variant typing $``\tau(\text{Feature\_Sub}) \le \tau(\text{Feature\_Sup})``$ and valid multiplicity narrowing, synthesizing an AST relationship edge with deterministic UUIDv5 anchor and zero diagnostics. - **Diagnostic:** None. */
        part def AC_01_Canonical_Feature_Subsetting_Lowering {
        }
        doc /* - **Given:** Valid `state def StateDef_Alpha` declaring composite `State_A` with sub-states `State_1` and `State_2`. - **When:** State machine lowering and hierarchy construction execute. - **Then:** States lower into arena storage with active exclusivity ($``|\text{active}(\text{State\_A})| \le 1``$) and zero diagnostics. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Hierarchical_State_Lowering {
        }
        doc /* - **Given:** Component `Part_0` with `Port_Src : out Item_0` and `Port_Tgt : in Item_0` connected by `Conn_0`. - **When:** Lowering `flow of Item_0 from Port_Src to Port_Tgt`. - **Then:** Flow lowers as KerML `Step` and `OccurrenceUsage` with zero diagnostics. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_ItemFlow_Lowering {
        }
        doc /* - **Given:** Initialized compiler root environment. - **When:** Standard library `Package_ControlFunctions` is bootstrapped. - **Then:** `Control_Fork`, `Control_Join`, `Control_Decision`, and `Control_Merge` resolve as specializations of `ControlNode` and `Function` with stable 32-bit arena handles. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Library_Bootstrap {
        }
        doc /* - **Given:** Initialized compiler runtime. - **When:** Bootstrapping `Package_ISQBase` and `Package_ISQ`. - **Then:** 7 base dimensions map to $``\mathbf{e}_1 \dots \mathbf{e}_7``$, derived dimensions register coordinates, and nodes bind deterministic UUIDv5 IDs. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Library_Bootstrapping {
        }
        doc /* - **Given:** `StateDef_Alpha` declaring `State_A`, `State_B`, and `transition Transition_1 first State_A accept Event_0 if Guard_0 do Action_Effect then State_B`. - **When:** Transition lowering executes. - **Then:** `Transition_1` lowers into arena storage with an ordered 3-phase ladder (exit `State_A`, run `Action_Effect`, enter `State_B`). - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Lowering_3_Phase_Execution {
        }
        doc /* - **Given:** `InterfaceDef_Alpha` (ends `e1 : PortDef_0`, `e2 : ~PortDef_0`) and ports `Port_1 : PortDef_0`, `Port_2 : ~PortDef_0`. - **When:** Lowering `interface InterfaceUsage_1 : InterfaceDef_Alpha connect part_1.Port_1 to part_2.Port_2;`. - **Then:** Usage lowers into arena storage with bound endpoints and empty diagnostic sink. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Lowering_and_Binding {
        }
        doc /* - **Given:** Package `Package_0` declaring `metadata def MetadataDef_Alpha { attr attr_1 : Integer; }` and `@MetadataDef_Alpha(attr_1 = 42) part def Classifier_Alpha;`. - **When:** Lowering and symbol resolution execute. - **Then:** `MetadataDef_Alpha` lowers as KerML `Structure`, attribute bindings populate dictionary $\alpha$, and diagnostic sink remains empty. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Metadata_Lowering_and_Annotation {
        }
        doc /* - **Given:** A model declaring `OccurrenceDef_Alpha` with extent `[0.0, 100.0]` and nested `OccurrenceUsage_1 : OccurrenceDef_Alpha [1..1]` with extent `[10.0, 50.0]`. - **When:** The compiler executes occurrence lowering and type validation. - **Then:** Both elements are lowered into contiguous arena storage with valid 32-bit node handles, correct feature typing, and zero diagnostic emissions. - **Diagnostic:** `E0200` emitted if type resolution or temporal extent binding fails. */
        part def AC_01_Canonical_Occurrence_Lowering_and_Temporal_Extent_Binding {
        }
        doc /* - **Given:** A valid model declaring `Package_0` containing public `Classifier_Alpha` and a distinct `Package_1` with `import Package_0::*;`. - **When:** The compiler executes package lowering and import symbol resolution. - **Then:** `Package_0` and `Package_1` are lowered into the AST, and `Classifier_Alpha` is successfully resolved within `Package_1` with zero diagnostics. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Package_Hierarchy_Public_Export_Lowering {
        }
        doc /* - **Given:** A valid schema declaring `PartDef_Alpha` containing composite `part Part_1 : PartDef_Beta [1..*]`. - **When:** The compiler executes metamodel lowering and structural validation. - **Then:** Both elements are lowered into contiguous arena storage with `is_composite = true`, default multiplicity preserved, and zero diagnostic emissions. - **Diagnostic:** `E0200` emitted if typing or composite ownership fails. */
        part def AC_01_Canonical_Part_Definition_and_Composite_Usage_Lowering {
        }
        doc /* - **Given:** A port definition `PortDef_Alpha` declaring directed features `in Flow_A : Real` and `out Flow_B : Real`, and usage `port Port_1 : ~PortDef_Alpha`. - **When:** The compiler executes port lowering and interface conjugation. - **Then:** Port usage `Port_1` is lowered into arena storage with inverted feature directions (`out Flow_A` and `in Flow_B`) and zero diagnostic emissions. - **Diagnostic:** `E0200` emitted if conjugate feature expansion fails. */
        part def AC_01_Canonical_Port_Definition_and_Conjugate_Usage_Lowering {
        }
        doc /* - **Given:** `Package_Quantities` with ratio scale `Scale_0` and unit `Unit_Alpha`. - **When:** Lowering `Quantity_Alpha = 10.0 [Unit_Alpha]` and evaluating `2.5 * Quantity_Alpha`. - **Then:** Node binds magnitude $25.0$, unit `Unit_Alpha`, scale `Scale_0`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Quantity_Lowering {
        }
        doc /* - **Given:** `ReqDef_Alpha` with subject `Subject_A : Classifier_Alpha`, assume `Subject_A.attr_a >= 0.0`, require `Subject_A.attr_a <= 100.0`. - **When:** Lowering `Req_1 : ReqDef_Alpha` binding `Subject_A = Classifier_Alpha`. - **Then:** Nodes lower into arena storage with resolved subject binding and empty diagnostic sink. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Requirement_Lowering_and_Contract_Resolution {
        }
        doc /* - **Given:** Compiler loading `Package_SI`. - **When:** Resolving base and derived units. - **Then:** Base units lower with $c = 1, o = 0$ and basis $``\mathbf{e}_i \in \mathbb{Z}^7``$; derived units preserve power products. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_SI_Base_Derived_Unit_Bootstrapping {
        }
        doc /* - **Given:** Package `Package_0` declaring scalar attributes `val_b : Boolean = true`, `val_i : Integer = 42`, `val_r : Real = 3.14159`, and `val_s : String = "alpha"`. - **When:** Lowering scalar expressions into arena storage. - **Then:** Values map to $\mathbb{B}$, $``\mathbb{Z}_{64}``$, $``\mathbb{R}_{64}``$, and interned `SymbolId` without loss. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Scalar_Lowering {
        }
        doc /* - **Given:** Occurrence `Occurrence_Alpha` with lifetime `[0.0, 100.0]`, containing `Snapshot_T0` at `t0 = 25.0`, `TimeSlice_Phase1` over `[10.0, 40.0]`, and `EventOccurrence_Ev1` at `te = 15.0` with boolean predicate `param_x > 0.0`. - **When:** The compiler executes occurrence portion lowering and validation. - **Then:** All three constructs lower into contiguous arena storage with valid 32-bit handles, verified temporal bounds, and zero diagnostic emissions. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Snapshot_TimeSlice_EventOccurrence_Lowering {
        }
        doc /* - **Given:** Valid `State_A` declaring `entry Action_Entry`, `do Action_Do`, and `exit Action_Exit`. - **When:** Lowering constructs lifecycle AST nodes. - **Then:** All three hooks lower into arena storage with valid handles and zero diagnostics. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_State_Lifecycle_Lowering_Multiplicity {
        }
        doc /* - **Given:** An immutable value item `ItemDef_Alpha : DataType` and a discrete token item `ItemDef_Beta : Class`. - **When:** The compiler executes item definition lowering and classification. - **Then:** Both elements are lowered into arena storage with correct value/token duality tags and zero diagnostic emissions. - **Diagnostic:** `E0200` emitted if classifier duality resolution fails. */
        part def AC_01_Canonical_Value_Item_and_Discrete_Token_Lowering {
        }
        doc /* - **Given:** `VerificationDef_Alpha` in `Package_0` with subject `Subject_A : Classifier_Alpha` and output `verdict : VerdictKind`, instantiated as `VerificationUsage_1` binding `Subject_A = Classifier_Alpha`. - **When:** Lowering and type checking execute. - **Then:** Nodes lower into arena storage with valid subject binding, specializing KerML `Behavior`, with empty diagnostic sink. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Verification_Case_Lowering_Verdict_Resolution {
        }
        doc /* - **Given:** `Package_0` with `viewpoint def ViewpointDef_Alpha { concern Concern_Alpha; }` and `view def ViewDef_Alpha { satisfy viewpoint ViewpointDef_Alpha; }`. - **When:** Lowering and viewpoint conformance checking execute. - **Then:** Nodes lower into arena storage with `SatisfyRequirementUsage` and empty diagnostic sink. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_ViewDefinition_and_Viewpoint_Lowering {
        }
        doc /* - **Given:** Classifier `Classifier_Alpha` defining `Feature_A : Real [0..10]`, and `Classifier_Beta :> Classifier_Alpha` declaring redefinition `Feature_A_sub :>> Feature_A : Real [1..5]`. - **When:** Lowering resolves slot bindings within `Classifier_Beta`. - **Then:** Reference lookup for `Feature_A` in `Classifier_Beta` resolves to `Feature_A_sub`, contextually shadowing `Feature_A` while preserving it in `Classifier_Alpha`. - **Diagnostic:** `E0200` emitted on slot resolution failure. */
        part def AC_01_Contextual_Slot_Replacement_and_Shadowing {
        }
        doc /* - **Given:** A KerML AST declaring interaction classifier `Interaction_Alpha` specializing both `Behavior` and `Association`. - **When:** The compiler executes the semantic lowering pass. - **Then:** The lowered AST node exhibits dual generalization edges to `Behavior` and `Association`, inheriting occurrence execution and association endpoint semantics. - **Diagnostic:** `E0200` emitted on invalid or ambiguous generalization hierarchy. */
        part def AC_01_Dual_Inheritance_Metamodel_Lowering {
        }
        doc /* - **Given:** `Classifier_Alpha` declaring `Feature_A` typed by `Classifier_Beta` via `FeatureTyping`. - **When:** Lowering executes feature type resolution. - **Then:** `Feature_A` binds to `Classifier_Beta` with node handle resolution, valid projection mapping $``\pi_{\text{Feature\_A}}``$, zero diagnostics emitted, and total-function completion. - **Diagnostic:** `E0200` emitted on unresolved feature type. */
        part def AC_01_FeatureTyping_Binding_Value_Projection_Resolution {
        }
        doc /* - **Given:** Metamodel definitions `Structure_Omega :> Class_Zeta :> Classifier_Alpha :> Type_0` and `DataType_Delta :> Classifier_Alpha`. - **When:** Subtyping poset $`(\mathcal{K}, \le)`$ construction executes. - **Then:** $``\text{Structure\_Omega} \le \text{Type\_0}``$ and $``\text{DataType\_Delta} \le \text{Type\_0}``$ evaluate to `true`; $``\text{Structure\_Omega} \le \text{DataType\_Delta}``$ evaluates to `false`; zero diagnostics emitted. - **Diagnostic:** `E0200` emitted on invalid subtyping resolution. */
        part def AC_01_Foundational_Taxonomic_Subtyping_Hierarchy {
        }
        doc /* - **Given:** Literals (`true`, `42`, `3.14159`, `"symbol_token"`, `*`, `null`) and scoped feature reference `Classifier_Alpha.param_x : Real`. - **When:** Lowering executes literal ingestion and scoped identifier resolution. - **Then:** Literals receive standard library scalar types, strings are interned, valid references resolve to type `Real`, and ungrounded identifiers or missing members are rejected. - **Diagnostic:** `E0200` emitted on unresolved identifier, missing member, or literal overflow. */
        part def AC_01_Literal_Ingestion_Feature_Navigation_Typing {
        }
        doc /* - **Given:** Model declaring `Package_0` hosting `OwningMembership` for `Classifier_Alpha` and non-owning `Membership` for `Classifier_Beta` owned by `Package_1`. - **When:** Symbol indexing resolves local members by interned `SymbolId`. - **Then:** Both resolve in amortized $`O(1)`$ time with $``\text{owner}(\text{Classifier\_Alpha}) = \text{Package\_0}``$ and $``\text{owner}(\text{Classifier\_Beta}) = \text{Package\_1}``$. - **Diagnostic:** `E0200` emitted on local lookup failure. */
        part def AC_01_Membership_Partitioning_and_O_Local_Scope_Resolution {
        }
        doc /* - **Given:** `Association_Invalid` with $`k = 1`$ end and `Association_A` with $`k = 2`$ ends (`End_1`, `End_2`). - **When:** Metamodel lowering performs association definition validation. - **Then:** `Association_Invalid` is rejected with diagnostic `E0200`, whereas `Association_A` lowers successfully. - **Diagnostic:** `E0200` emitted on arity $`k \lt 2`$. */
        part def AC_01_Multi_Ary_Association_Arity_Validation {
        }
        doc /* - **Given:** Namespace `Package_0` declaring public `Classifier_Alpha`, namespace `Package_1` declaring `public import Package_0::Classifier_Alpha;`, and namespace `Package_2` declaring `import Package_1::*;`. - **When:** Metamodel lowering resolves symbol `Classifier_Alpha` within `Package_2`. - **Then:** `Classifier_Alpha` is resolved in `Package_2` via public re-export; replacing `Package_1` with `private import` causes lookup to fail with diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted on foreign access to non-exported private import. */
        part def AC_01_Public_vs_Private_Import_Visibility_Re_export {
        }
        doc /* - **Given:** Function `Function_Alpha(Param_1 : Type_A, Param_2 : Type_B) : Type_A` declaring pure expression body $``E_{\text{body}}``$. - **When:** Functional lowering evaluates morphism $``⟦ \text{Function\_Alpha} ⟧``$ under store $`\sigma`$. - **Then:** Input parameters are immutable, evaluation produces identical outputs for identical inputs ($`\mathbf{a} = \mathbf{b} \implies ⟦ F ⟧(\mathbf{a}) = ⟦ F ⟧(\mathbf{b})`$), $``\sigma_{\text{post}} \equiv \sigma_{\text{pre}}``$, and zero diagnostics are emitted. - **Diagnostic:** `E0200` emitted on side-effect detection or state mutation within a function body. */
        part def AC_01_Pure_Mathematical_Morphism_Referential_Transparency {
        }
        doc /* - **Given:** Classifiers `Classifier_Alpha` and `Classifier_Beta` in `Package_0`. - **When:** Lowering processes `Classifier_Alpha unioning Classifier_Beta`. - **Then:** Engine emits compound type $``T_{\text{union}}``$ with $``⟦ T_{\text{union}} ⟧ = ⟦ \text{Classifier\_Alpha} ⟧ \cup ⟦ \text{Classifier\_Beta} ⟧``$, enforces covariance $``\text{Classifier\_Alpha} \le T_{\text{union}}``$ and $``\text{Classifier\_Beta} \le T_{\text{union}}``$, and binds deterministic RFC 4122 UUIDv5. - **Diagnostic:** `E0200` emitted on invalid or unresolvable operand types. */
        part def AC_01_Unioning_Compound_Type_Subtyping_Invariant {
        }
        doc /* - **Given:** Abstract model declaring `Package_0` and `Classifier_Alpha`. - **When:** Lowering allocates entities into the contiguous AST memory. - **Then:** Every element occupies an AST handle ($`\text{PointerIndirectionDepth} = 0`$), assigns an interned scalar `SymbolId`, and receives an RFC 4122 UUIDv5 identifier from $``\text{OID}_{\text{DEAP}}``$ and $`\text{FQN}(e)`$. - **Diagnostic:** `E0200` emitted on handle exhaustion, alignment fault, or invalid topological identifier formatting. */
        part def AC_01_Universal_Root_Element_Allocation_and_Deterministic_Identity {
        }
        doc /* - **Given:** Inverted `allocate Part_Alpha to Action_A` or reflexive `allocate Action_A to Action_A`. - **When:** Bipartite domain and reflexivity validation executes. - **Then:** Compile-time rejection binding sentinel $``\bot_{\text{alloc}}``$ with diagnostic `E0200`. - **Diagnostic:** `E0200` on violation. */
        part def AC_02_Bipartite_Inversion_and_Reflexive_Rejection {
        }
        doc /* - **Given:** Supertype feature `Feature_Sup : Classifier_Alpha` and subsetting declaration `Feature_Sub :> Feature_Sup : Classifier_Gamma`, where `Classifier_Gamma` does not specialize `Classifier_Alpha`. - **When:** The compiler performs subtyping verification on the subsetting declaration. - **Then:** The compiler rejects the incompatible type relationship, binds error sentinel $``\bot_{\text{type}}``$ to prevent downstream failure cascade, and emits diagnostic code `E0200`. - **Diagnostic:** `E0200`. */
        part def AC_02_Co_variant_Subtyping_Incompatibility_Rejection {
        }
        doc /* - **Given:** A connection binding two output ports directly together (`connect Part_Alpha.Port_Out1 to Part_Beta.Port_Out2`). - **When:** Semantic directionality validation analyzes endpoint interaction modes. - **Then:** The compiler rejects the conflicting output connection at compile time and emits diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted for conflicting port flow directions. */
        part def AC_02_Conflicting_Directional_Flow_Rejection {
        }
        doc /* - **Given:** Action workflow binding input pin `in param_in : Real` as data source or output pin `out param_out : Real` as target. - **When:** Data flow parameter polarity validation executes. - **Then:** Compiler rejects inverted bindings with sentinel $``\bot_{\text{action}}``$ and diagnostic `E0201`. - **Diagnostic:** `E0201` (Parameter direction mismatch). */
        part def AC_02_Conflicting_Parameter_Directionality_Rejection {
        }
        doc /* - **Given:** Flow streaming from `Port_Src : in Item_0` to `Port_Tgt : in Item_0`. - **When:** Directionality validation evaluates endpoint modes. - **Then:** Compiler rejects the declaration with diagnostic `E0201`. - **Diagnostic:** `E0201` (Flow direction mismatch). */
        part def AC_02_Conflicting_Port_Direction_Rejection {
        }
        doc /* - **Given:** `Classifier_Alpha <= Classifier_Beta` in `Package_0`. - **When:** Evaluating subtyping queries. - **Then:** `OrderedSet<Classifier_Alpha> <= Set<Classifier_Alpha>`, `OrderedSet<Classifier_Alpha> <= Sequence<Classifier_Alpha>`, and `Set<Classifier_Alpha> <= Set<Classifier_Beta>` evaluate `true`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Covariant_Subtyping_Multiple_Inheritance {
        }
        doc /* - **Given:** Classifier `Classifier_Alpha` defining `Feature_A : Classifier_Alpha [2..8]`, and `Classifier_Beta :> Classifier_Alpha` declaring `Feature_A_redef :>> Feature_A : Classifier_Beta [2..5]`. - **When:** Type checking evaluates covariance $``\tau(\text{Feature\_A\_redef}) \le \tau(\text{Feature\_A})``$ and interval containment $``\mu(\text{Feature\_A\_redef}) \subseteq \mu(\text{Feature\_A})``$. - **Then:** Conforming covariance and sub-intervals are accepted; contravariant types or widened intervals ($`[1..8]`$ or $`[2..10]`$) are rejected with error sentinel $``\bot_{\text{redef}}``$. - **Diagnostic:** `E0200` emitted on type non-conformance or multiplicity interval widening. */
        part def AC_02_Covariant_Subtyping_and_Multiplicity_Interval_Tightening {
        }
        doc /* - **Given:** Quantities `Quantity_A` (Force) and `Quantity_B` (Length). - **When:** Lowering `Quantity_A * Quantity_B`, `Quantity_A / Quantity_B`, `Quantity_B^2`. - **Then:** Product infers Energy in $O(1)$, quotient infers $(1,0,-2,0,0,0,0)$, and power infers Area. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Dimensional_Vector_Arithmetic_and_Inference {
        }
        doc /* - **Given:** Model declaring relationship `Rel_Alpha` with source $``\{ \text{Element\_Alpha} \}``$ and target $``\{ \text{Element\_Beta} \}``$. - **When:** Relationship endpoint validation executes. - **Then:** Endpoints are verified as non-empty, mutually disjoint ($`\text{source} \cap \text{target} = \emptyset`$), and allocated in active arena storage without emitting diagnostics. - **Diagnostic:** `E0200` emitted if endpoints are empty, reflexive, or unallocated. */
        part def AC_02_Directed_Relationship_Endpoints_and_Non_Reflexivity_Validation {
        }
        doc /* - **Given:** Classifier `Classifier_Invalid` declaring multiple inheritance over both `DataType_Delta` and `Class_Zeta`. - **When:** Metamodel lowering verifies classifier disjointness $`⟦ \text{DataType} ⟧ \cap ⟦ \text{Class} ⟧ = \emptyset`$. - **Then:** The compiler rejects the declaration, binds error sentinel $``\bot_{\text{classifier}}``$, and emits diagnostic `E0200`. - **Diagnostic:** `E0200` emitted on disjoint classifier specialization violation. */
        part def AC_02_Disjoint_Classifier_Specialization_Enforcement {
        }
        doc /* - **Given:** `State_A` declaring duplicate un-sequenced `entry` action hooks. - **When:** Multiplicity validation executes. - **Then:** Lowering rejects duplicate hook with sentinel $``\bot_{\text{action}}``$ and emits `E0200`. - **Diagnostic:** `E0200` on duplicate lifecycle hook. */
        part def AC_02_Duplicate_Lifecycle_Hook_Rejection {
        }
        doc /* - **Given:** Model declaring `Control_Fork` distributing to `Step_Alpha` and `Step_Beta`, converging into `Control_Join`. - **When:** Discrete execution simulation evaluates token flow. - **Then:** `Control_Fork` replicates 1 token into 2 concurrent tokens; `Control_Join` awaits both tokens and fires 1 synchronized token upon complete arrival. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Fork_Join_Token_Synchronization {
        }
        doc /* - **Given:** Two declarations with duplicate identifier `req_id = "REQ-0085"`. - **When:** Global identifier uniqueness validation executes. - **Then:** Lowering rejects duplicate declaration with source spans and emits `E0200`. - **Diagnostic:** `E0200` (Duplicate requirement identifier). */
        part def AC_02_Global_Duplicate_Requirement_Identifier_Rejection {
        }
        doc /* - **Given:** Composite `State_Composite` with substate `State_Sub_1`, parent transition $``t_{\text{parent}}``$ to `State_B` on `Event_0`, and child transition $``t_{\text{child}}``$ from `State_Sub_1` to `State_A` on `Event_0`. - **When:** `Event_0` is dispatched in active configuration $``\{ \text{State\_Composite}, \text{State\_Sub\_1} \}``$. - **Then:** Engine selects $``t_{\text{child}}``$ over $``t_{\text{parent}}``$ because $``\text{Depth}(\text{State\_Sub\_1}) > \text{Depth}(\text{State\_Composite})``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Inner_First_Conflict_Resolution_Precedence {
        }
        doc /* - **Given:** Classifiers `Classifier_Alpha` and `Classifier_Beta` in `Package_0`. - **When:** Lowering processes `Classifier_Alpha intersecting Classifier_Beta`. - **Then:** Engine emits intersection type $``T_{\text{inter}}``$ with $``⟦ T_{\text{inter}} ⟧ = ⟦ \text{Classifier\_Alpha} ⟧ \cap ⟦ \text{Classifier\_Beta} ⟧``$, enforces contravariance $``T_{\text{inter}} \le \text{Classifier\_Alpha}``$ and $``T_{\text{inter}} \le \text{Classifier\_Beta}``$, preserving feature conjunction. - **Diagnostic:** `E0200` emitted on invalid operand types. */
        part def AC_02_Intersecting_Compound_Type_Conformance_Invariant {
        }
        doc /* - **Given:** Interval scale `Scale_1` with units `Unit_Alpha` and `Unit_Beta` ($m = 1.8, c = 32.0$). - **When:** Lowering difference `Quantity_Alpha - Quantity_Beta` and sum `Quantity_Alpha + Quantity_Delta`. - **Then:** Difference lowers to $``Q_{\Delta} \in \mathcal{Q}_{\text{ratio}}``$; sum lowers to interval position in `Scale_1`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Interval_Scale_Operations {
        }
        doc /* - **Given:** `Association_A` over `Classifier_Alpha` and `Classifier_Beta`, and `Link_1` whose second participant has runtime type `Classifier_Gamma` ($``\text{Classifier\_Gamma} \not\le \text{Classifier\_Beta}``$). - **When:** Semantic type checking validates `Link_1`. - **Then:** Compilation rejects `Link_1` and records diagnostic `E0200` with exact source byte spans. - **Diagnostic:** `E0200` emitted on participant type mismatch. */
        part def AC_02_Link_Participant_Type_Conformance {
        }
        doc /* - **Given:** Unit `Unit_Alpha` ($c \in \mathbb{Q}^+$) and prefix `Prefix_Alpha` ($10^k$). - **When:** Lowering `Prefix_Alpha Unit_Alpha` and evaluating conversion. - **Then:** Factor evaluates to $10^k \cdot c$ in exact arithmetic $\mathbb{Q}$ without drift. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Metric_Prefix_Scaling_Exact_Rational_Conversion {
        }
        doc /* - **Given:** Literals $``n_1 = 2^{53}``$ and $``n_2 = 2^{53} + 1``$ promoted to `Real`. - **When:** Applying widening injection $\iota$. - **Then:** $``n_1``$ promotes losslessly ($``\text{float64}(n_1) = n_1``$); $``n_2``$ rounds within $``\frac{1}{2}\text{ulp}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Monotonic_Widening_Precision {
        }
        doc /* - **Given:** AST feature declarations with valid intervals `[0..1]`, `[1..*]` and malformed interval `[5..2]` ($``m_{\min} \gt m_{\max}``$). - **When:** Multiplicity well-formedness $``\Phi_{\text{mult}}``$ is evaluated. - **Then:** Valid intervals are accepted; malformed interval `[5..2]` is rejected and sentinel $``\bot_{\text{type}}``$ is assigned. - **Diagnostic:** `E0200` emitted on $``m_{\min} \gt m_{\max}``$. */
        part def AC_02_Multiplicity_Interval_Bounds_Validation {
        }
        doc /* - **Given:** `calc def CalcDef_Impure(inout Param_M : Real) : Real`. - **When:** Parameter directionality validation evaluates declared parameters. - **Then:** Compiler rejects the declaration with sentinel $``\bot_{\text{calc}}``$ and emits diagnostic `E0201`. - **Diagnostic:** `E0201` (Parameter directionality violation). */
        part def AC_02_Mutating_Parameter_Directionality_Rejection {
        }
        doc /* - **Given:** A structural classifier `Classifier_Alpha` that does not specialize `Behavior`. - **When:** A step is declared with invalid typing (`Step_Bad : Classifier_Alpha`). - **Then:** The compiler rejects the step declaration, binds error sentinel $``\bot_{\text{type}}``$, and emits diagnostic code `E0200`. - **Diagnostic:** `E0200` emitted for non-behavioral step typing. */
        part def AC_02_Non_Behavioral_Step_Type_Rejection {
        }
        doc /* - **Given:** Assert constraint evaluating to `Real` (`attr_a + attr_b`) or mutating state (`attr_a = param_x`). - **When:** Type checking and purity validation execute. - **Then:** Lowering rejects declaration, assigns sentinel $``\bot_{\text{assert}}``$, and emits diagnostic `E0200`. - **Diagnostic:** `E0200` (Non-Boolean codomain or state mutation). */
        part def AC_02_Non_Boolean_Codomain_Impure_Expression_Rejection {
        }
        doc /* - **Given:** Definition `ConstraintDef_Alpha` with non-Boolean body `param_x + param_y : Real`. - **When:** Validating Boolean codomain invariant $``\Phi_{\text{codomain}}``$. - **Then:** Lowering rejects definition, assigns sentinel $``\bot_{\text{type}}``$, and emits diagnostic `E0200`. - **Diagnostic:** `E0200` on non-Boolean body. */
        part def AC_02_Non_Boolean_Predicate_Rejection {
        }
        doc /* - **Given:** Definition `interface def InterfaceDef_Invalid { end e1 : PortDef_0; end e2 : PortDef_0; }`. - **When:** Validating end-role conjugate duality. - **Then:** Lowering rejects definition and emits diagnostic `E0201`. - **Diagnostic:** `E0201` on conjugate duality mismatch. */
        part def AC_02_Non_Conjugate_End_Role_Rejection {
        }
        doc /* - **Given:** A structural primitive or identity-free data type `DataType_Beta`. - **When:** An occurrence usage is declared typing a non-occurrence classifier (`OccurrenceUsage_Err : DataType_Beta`). - **Then:** The compiler rejects the declaration at compile time, assigns an error sentinel, and records diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted for invalid occurrence classifier typing. */
        part def AC_02_Non_Occurrence_Classifier_Type_Rejection {
        }
        doc /* - **Given:** A part usage attempting to apply conjugation to a non-port classifier (`port Port_Err : ~PartDef_Beta`). - **When:** Semantic type checking validates the conjugation target. - **Then:** The compiler rejects the declaration at compile time and emits diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted for invalid conjugation on non-port classifier. */
        part def AC_02_Non_Port_Classifier_Conjugation_Rejection {
        }
        doc /* - **Given:** An item definition attempting to specialize a behavioral step classifier (`ItemDef_Err : Step`). - **When:** Semantic type checking validates metamodel classifier conformance. - **Then:** The compiler rejects the declaration at compile time and emits diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted for invalid item metamodel specialization. */
        part def AC_02_Non_Structural_Item_Classifier_Rejection {
        }
        doc /* - **Given:** Operations `param_x + 5.0`, static zero division `param_x / 0.0`, invalid addition `"token" + 42`, and conditional `if flag then param_x else 0.0`. - **When:** The type checker validates operator typing and conditional branch unification. - **Then:** Valid expressions type-check successfully; operand mismatches, static division by literal zero, and un-unifiable conditional branches are rejected at compile time. - **Diagnostic:** `E0200` emitted on operator signature mismatch, division by zero, or branch unification failure. */
        part def AC_02_Operator_Conformance_Division_by_Zero_Conditional_Unification {
        }
        doc /* - **Given:** Parallel composite `ParallelState_Omega` declaring $k = 2$ orthogonal regions `Region_1` and `Region_2`. - **When:** Region partitioning is evaluated. - **Then:** Cartesian space $``\text{States}(R_1) \times \text{States}(R_2)``$ is established with $``|\text{active}(R_i)| = 1``$. - **Diagnostic:** `E0200` on region partitioning failure. */
        part def AC_02_Orthogonal_Parallel_State_and_Cartesian_Space_Conformance {
        }
        doc /* - **Given:** Model declaring `Function_Beta` containing a formal parameter with direction `inout`. - **When:** Semantic parameter validation inspects directionality tags $`\text{dir}(p) \in \{ \text{In}, \text{Out}, \text{Return} \}`$. - **Then:** The compiler rejects `Function_Beta`, binds error sentinel $``\bot_{\text{type}}``$, and emits diagnostic `E0201`. - **Diagnostic:** `E0201` emitted on illegal `inout` parameter declaration on a `Function`. */
        part def AC_02_Parameter_Directionality_Prohibition_of_inout {
        }
        doc /* - **Given:** An interaction classifier `Interaction_Alpha` declaring $`k \lt 2`$ participant end features (e.g., 1 participant `Participant_0`). - **When:** Metamodel validation evaluates structural association endpoints. - **Then:** The compiler rejects the definition and emits diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted when $``|\mathcal{P}_{I}| \lt 2``$. */
        part def AC_02_Participant_Cardinality_Lower_Bound_Enforcement {
        }
        doc /* - **Given:** `Package_0` declaring private member `Classifier_Beta` (`private Classifier_Beta`). - **When:** An external `Package_1` attempts to reference or import `Package_0::Classifier_Beta`. - **Then:** The compiler rejects the foreign access, records the offending source byte span, and emits diagnostic code `E0200`. - **Diagnostic:** `E0200` emitted for private symbol encapsulation breach. */
        part def AC_02_Private_Symbol_Encapsulation_Breach_Rejection {
        }
        doc /* - **Given:** Nested namespace hierarchy `Package_0::SubPackage_1::Classifier_Alpha` and target namespace `Package_2` declaring `import Package_0::**;`. - **When:** Scoping engine evaluates reflexive-transitive closure $``\mathcal{M}_{\text{rec}}(\text{Package\_0})``$. - **Then:** Symbol `Classifier_Alpha` resolves unqualified within `Package_2`, and visited-set cycle detection guarantees deterministic completion without infinite recursion. - **Diagnostic:** `E0203` emitted if cyclic namespace containment causes an illegal containment loop. */
        part def AC_02_Recursive_Wildcard_Import_and_Sub_Namespace_Closure {
        }
        doc /* - **Given:** A part definition declared specializing a primitive value type (`PartDef_Err : DataType_Beta`). - **When:** Semantic type checking is evaluated against the classifier lattice. - **Then:** The compiler rejects the declaration at compile time and emits diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted for identity-free value type inheritance on part definitions. */
        part def AC_02_Rejection_of_DataType_Inheritance {
        }
        doc /* - **Given:** Element `Classifier_Alpha` owned by `Package_0` via `OwningMembership`. - **When:** Lowering processes a secondary `OwningMembership` for `Classifier_Alpha` in `Package_1`. - **Then:** The compiler rejects duplicate ownership, retains singular ownership in `Package_0`, and binds sentinel $``\bot_{\text{node}}``$. - **Diagnostic:** `E0200` emitted on duplicate owning membership violation. */
        part def AC_02_Single_Ownership_Bijection_Invariant_Enforcement {
        }
        doc /* - **Given:** `PortDef_Alpha` declaring feature `Flow_A` with payload type `param_x : Real`, multiplicity `[1..2]`, and invariant constraints. - **When:** Lowering lowers `~PortDef_Alpha` into the AST. - **Then:** The conjugated feature preserves payload type `param_x : Real`, multiplicity `[1..2]`, and constraints identically. - **Diagnostic:** `E0200` emitted on payload schema or multiplicity mutation during conjugation. */
        part def AC_02_Structural_Payload_Invariant_Contract_Preservation {
        }
        doc /* - **Given:** `Req_1` with subject `Classifier_Alpha` and `Part_Beta : Classifier_Beta` ($``\text{Classifier\_Beta} \not\le \text{Classifier\_Alpha}``$). - **When:** Lowering evaluates subject subtyping. - **Then:** Lowering rejects the binding, binds sentinel $``\bot_{\text{sat}}``$, and emits diagnostic `E0200`. - **Diagnostic:** `E0200` (Subject type mismatch). */
        part def AC_02_Subject_Classifier_Subtyping_Conformance_Violation {
        }
        doc /* - **Given:** `VerificationDef_Alpha` declaring formal subject parameter with `out` directionality (`out Subject_A : Classifier_Alpha`). - **When:** Parameter directionality analysis executes. - **Then:** Lowering rejects non-`In`/`InOut` directionality with sentinel $``\bot_{\text{verif}}``$ and emits diagnostic `E0201`. - **Diagnostic:** `E0201` (Invalid subject parameter direction). */
        part def AC_02_Subject_Parameter_Directionality_Violation_Rejection {
        }
        doc /* - **Given:** Definition `MetadataDef_Alpha` restricting target to `Feature` (`about Feature`), and `part def Classifier_Alpha;` annotated with `@MetadataDef_Alpha`. - **When:** Metaclass target conformance validation executes. - **Then:** Lowering detects `Classifier_Alpha` is not a feature, rejects attachment, and emits `E0200`. - **Diagnostic:** `E0200` (Invalid annotated element target). */
        part def AC_02_Target_Metaclass_Restriction_Enforcement {
        }
        doc /* - **Given:** Occurrence `Occurrence_Alpha` with lifetime `[0.0, 100.0]`. - **When:** A snapshot `Snapshot_T1` is declared at `t0 = 120.0` ($``t_0 \gt t_{\text{end}}``$) or time slice `TimeSlice_Phase2` spans `[-10.0, 50.0]` ($``t_1 \lt t_{\text{start}}``$). - **Then:** The compiler rejects the out-of-bounds declarations, binds error sentinels, and records diagnostic code `E0200`. - **Diagnostic:** `E0200` emitted for temporal lifetime boundary breach. */
        part def AC_02_Temporal_Lifetime_Breach_Rejection {
        }
        doc /* - **Given:** Metamodel with classifier `Classifier_Alpha`. - **When:** Evaluating subtyping queries. - **Then:** `Classifier_Alpha <= Anything`, `Element <= Anything`, and `Relationship <= Element` evaluate `true`; `Anything <= Classifier_Alpha` is `false`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Top_Type_Maximality_and_Specialization {
        }
        doc /* - **Given:** Model $``\mathcal{M}_{\text{model}}``$ ($V=1000, E=2500$) matching filter predicate $``\Phi_{\text{filter}}``$. - **When:** Projection engine executes $``\pi_V``$ for `ViewDef_Alpha`. - **Then:** $``\mathcal{M}_{\text{view}}``$ contains 100% of matching vertices, 0% of non-matching vertices, and preserves induced edges. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_View_Subgraph_Model_Projection_Completeness {
        }
        doc /* - **Given:** `Package_0` with 10 parts typed by `PartDef_Alpha` and 5 ports, tagged `@Tag_Alpha`. - **When:** Lowering `view def ViewDef_Alpha { expose Package_0::*; expose filter (isKindOf(PartDef_Alpha) and @Tag_Alpha); }`. - **Then:** Shallow wildcard and filter admit exactly the tagged parts into $``V_{\text{exp}}``$ without descending into sub-packages. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Wildcard_Expansion_and_Predicate_Filtering_Boundary {
        }
        doc /* - **Given:** Usage `@MetadataDef_Alpha(attr_1 = "invalid") part def Classifier_Alpha;` where `attr_1` expects `Integer`. - **When:** Attribute argument type-checking executes. - **Then:** Lowering detects type mismatch ($``\text{String} \not\le \text{Integer}``$), substitutes sentinel $``\bot_{\text{meta}}``$, and emits `E0200`. - **Diagnostic:** `E0200` (Metadata attribute type mismatch). */
        part def AC_03_Attribute_Type_Incompatibility_Rejection {
        }
        doc /* - **Given:** An external connector attempting to bind directly to internal constituent `Part_Alpha.InternalVar` bypassing declared boundary ports. - **When:** Structural connection routing validates endpoint visibility. - **Then:** The compiler halts connection lowering and emits diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted for boundary encapsulation violation. */
        part def AC_03_Boundary_Encapsulation_Breach_Rejection {
        }
        doc /* - **Given:** Two packages declaring mutual imports (`Package_0` imports `Package_1` and `Package_1` imports `Package_0`). - **When:** The compiler constructs and traverses the package dependency graph $``G_{\text{pkg}}``$. - **Then:** The cycle is detected, topological sorting halts for the circular component, and diagnostic code `E0203` is emitted. - **Diagnostic:** `E0203` emitted for circular package dependency. */
        part def AC_03_Circular_Package_Import_Dependency_Detection {
        }
        doc /* - **Given:** A junction node with incoming flow rate `Flow_In = 10.0` and outgoing flow rate `Flow_Out = 7.0` for a conservative item. - **When:** Semantic flow validation evaluates conservation balance equations. - **Then:** The compiler detects the unbuffered rate discrepancy and emits diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted for conservative flow conservation imbalance. */
        part def AC_03_Conservative_Flow_Balance_Violation_Detection {
        }
        doc /* - **Given:** Usage `calc Calc_Err : CalcDef_Alpha(Param_X = "str")` or typed by structural `PartDef_Alpha`. - **When:** Feature typing and argument subtyping execute. - **Then:** Compiler rejects invalid typing with precise source spans and emits diagnostic `E0200`. - **Diagnostic:** `E0200` (Argument type mismatch or non-functional classifier). */
        part def AC_03_Covariant_Argument_Subtyping_and_Classifier_Conformance {
        }
        doc /* - **Given:** Data flow binding output of type `Classifier_Alpha` to incompatible input `Classifier_Beta`, or exceeding target multiplicity. - **When:** Type and multiplicity conformance checking executes. - **Then:** Compiler rejects incompatible edge and emits diagnostic `E0202`. - **Diagnostic:** `E0202` (Payload type mismatch or multiplicity overflow). */
        part def AC_03_Data_Flow_Payload_Subtyping_and_Multiplicity_Overflow {
        }
        doc /* - **Given:** A parallel state with $k \lt 2$ regions, or direct transition crossing orthogonal regions without fork/join. - **When:** Semantic validation checks region cardinality and transition boundaries. - **Then:** The compiler rejects the model and emits diagnostic `E0200`. - **Diagnostic:** `E0200` on degenerate parallel regions or unsynchronized transitions. */
        part def AC_03_Degenerate_Parallel_State_and_Cross_Region_Transition_Rejection {
        }
        doc /* - **Given:** Target namespace `Package_1` declaring local member `Classifier_Alpha` and an import `import Package_0::Classifier_Alpha;`. - **When:** Scoping engine resolves unqualified reference `Classifier_Alpha` within `Package_1`. - **Then:** Unqualified lookup binds strictly to the local member ($``\text{Find} = \mathcal{M}_{\text{owned}}``$), while the imported symbol remains accessible via fully qualified path `::Package_0::Classifier_Alpha`. - **Diagnostic:** `E0200` emitted if shadow precedence fails to bind local declaration. */
        part def AC_03_Deterministic_Shadow_Precedence {
        }
        doc /* - **Given:** Specializing classifiers where $``\text{Classifier\_Beta} \le \text{Classifier\_Alpha}``$. - **When:** Lowering evaluates `Classifier_Alpha differencing Classifier_Beta`. - **Then:** Denotation satisfies $``⟦ \text{Classifier\_Alpha} \setminus \text{Classifier\_Beta} ⟧ = ⟦ \text{Classifier\_Alpha} ⟧ \setminus ⟦ \text{Classifier\_Beta} ⟧``$; declaring an instance on empty difference $``\text{Classifier\_Beta} \setminus \text{Classifier\_Alpha}``$ binds $``\bot_{\text{type}}``$. - **Diagnostic:** `E0200` emitted on uninhabitable difference type instantiation. */
        part def AC_03_Differencing_Relative_Complement_Evaluation {
        }
        doc /* - **Given:** `Classifier_Alpha` instance possessing `Feature_A` with multiplicity `[1, 3]` and evaluated instance fiber cardinality 0 or 4. - **When:** The type verification engine validates fiber cardinality against $``\mu(\text{Feature\_A})``$. - **Then:** Cardinality violations outside $``[m_{\min}, m_{\max}]``$ are detected and rejected. - **Diagnostic:** `E0200` emitted on fiber cardinality violation. */
        part def AC_03_Fiber_Cardinality_Enforcement {
        }
        doc /* - **Given:** `Association_A` between `Classifier_Alpha` and `Classifier_Beta` with interval $``\mu_2 = [1, 3]``$ on `Classifier_Beta`. - **When:** Fiber validation evaluates instances of `Classifier_Alpha` with 0, 2, and 4 associated links. - **Then:** Instances with 0 and 4 links trigger diagnostic `E0200`, while the instance with 2 links validates. - **Diagnostic:** `E0200` emitted on fiber multiplicity bound violation. */
        part def AC_03_Fiber_Multiplicity_Bound_Enforcement {
        }
        doc /* - **Given:** Instances $``a, b \in ⟦ \text{DataType\_Delta} ⟧``$ with identical feature values (`param_x = 42.0`), and instances $``u, v \in ⟦ \text{Class\_Zeta} ⟧``$ with identical values (`param_x = 42.0`) but distinct handles ($`\text{id}(u) \neq \text{id}(v)`$). - **When:** Equivalence evaluation executes on pairs $`(a, b)`$ and $`(u, v)`$. - **Then:** Value congruence yields $``a \equiv_{\text{val}} b = \text{true}``$; object identity yields $`u = v \equiv \text{false}`$. - **Diagnostic:** `E0200` emitted on identity evaluation violation. */
        part def AC_03_Identity_Duality_Value_Congruence_vs_Object_Identity {
        }
        doc /* - **Given:** Incommensurable `Unit_Alpha` and `Unit_Beta` ($``\mathbf{d}(\text{Unit\_Alpha}) \ne \mathbf{d}(\text{Unit\_Beta})``$). - **When:** Dimensional validation executes. - **Then:** Lowering halts conversion, assigns sentinel $``\bot_{\text{unit}}``$, and records `E0201`. - **Diagnostic:** `E0201`. */
        part def AC_03_Incommensurable_Unit_Conversion_Rejection {
        }
        doc /* - **Given:** Ports `Port_Src : out Item_Super`, `Port_Tgt : in Item_Super`, and payload `Item_Unrelated` ($``\text{Item\_Unrelated} \not\le \text{Item\_Super}``$). - **When:** Type checking validates payload covariance. - **Then:** Compiler rejects the flow declaration with diagnostic `E0202`. - **Diagnostic:** `E0202` (Payload type incompatibility). */
        part def AC_03_Incompatible_Item_Payload_Subtyping {
        }
        doc /* - **Given:** `InterfaceDef_Alpha` and binding `Port_1 : PortDef_0` to `Port_3 : PortDef_Beta` ($``\text{PortDef\_Beta} \not\le {\sim}\text{PortDef\_0}``$). - **When:** Verifying port binding subtyping conformance. - **Then:** Lowering rejects binding and emits diagnostic `E0201`. - **Diagnostic:** `E0201` on port binding subtyping mismatch. */
        part def AC_03_Incompatible_Port_Binding_Rejection {
        }
        doc /* - **Given:** A connection binding incompatible port definitions `PortDef_Alpha` and `PortDef_Beta` where $``\text{PortDef\_Alpha} \not\le {\sim}\text{PortDef\_Beta}``$. - **When:** Semantic type checking validates endpoint conjugate conformance. - **Then:** The compiler rejects the connector declaration and emits diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted for port type incompatibility. */
        part def AC_03_Incompatible_Port_Type_Rejection {
        }
        doc /* - **Given:** Integer literal exceeding $2^{63}-1$ or malformed float literal. - **When:** Parsing and evaluating literal expressions. - **Then:** Rejection assigns sentinel $``\bot_{\text{scalar}}``$ and emits `E0200`. - **Diagnostic:** `E0200` (Scalar literal bounds or syntax violation). */
        part def AC_03_Integer_Overflow_Malformed_Literal_Rejection {
        }
        doc /* - **Given:** Model attempting addition (`Quantity_Alpha + Quantity_Beta`) or scaling (`2.0 * Quantity_Alpha`) in `Scale_1`. - **When:** Validating scale invariants. - **Then:** Rejection emits `E0200` and binds sentinel $``\bot_{\text{quantity}}``$. - **Diagnostic:** `E0200` (Invalid interval scale operation). */
        part def AC_03_Invalid_Interval_Scale_Rejection {
        }
        doc /* - **Given:** Malformed satisfy declaring self-satisfaction (`satisfy Req_1 by Req_1;`) or non-requirement target (`satisfy Part_Beta by Part_Alpha;`). - **When:** Bipartite domain disjointness and irreflexivity validation execute. - **Then:** Lowering halts edge insertion, binds $``\bot_{\text{sat}}``$, and emits diagnostic `E0200`. - **Diagnostic:** `E0200` (Invalid satisfaction endpoint). */
        part def AC_03_Invalid_Realization_Domain_and_Reflexive_Satisfaction_Prohibition {
        }
        doc /* - **Given:** Declarations `view def ViewDef_Alpha :> DataType_Alpha` or `satisfy viewpoint Classifier_Alpha`. - **When:** Semantic type checking executes. - **Then:** Lowering rejects invalid specializations and non-viewpoint targets with sentinel $``\bot_{\text{view}}``$ and diagnostic `E0200`. - **Diagnostic:** `E0200` (Invalid classifier specialization or unresolved viewpoint target). */
        part def AC_03_Invalid_Specialization_and_Non_Viewpoint_Target_Rejection {
        }
        doc /* - **Given:** Occurrence `Occurrence_Alpha` with lifetime `[0.0, 100.0]`. - **When:** A time slice `TimeSlice_Inv` declares inverted bounds `[60.0, 20.0]` ($``t_1 \gt t_2``$). - **Then:** The compiler rejects the inverted interval and emits diagnostic code `E0200`. - **Diagnostic:** `E0200` emitted for inverted time slice interval. */
        part def AC_03_Inverted_TimeSlice_Interval_Rejection {
        }
        doc /* - **Given:** Function `Function_Alpha(in p_in : Integer, out p_out : Integer, inout p_io : Integer) : Boolean`. - **When:** Invocations bind arguments to parameters, including binding constant literal `10` or expression `param_x + 1` to `p_out` or `p_io`. - **Then:** Valid bindings are accepted; arity or type mismatches emit `E0200`; passing immutable rvalues to $`\text{Out}`$ or $`\text{InOut}`$ parameters is rejected. - **Diagnostic:** `E0200` emitted on arity or type mismatch; `E0201` emitted on parameter directionality or mutability violation. */
        part def AC_03_Invocation_Parameter_Directionality_Mutability_LValue_Gate {
        }
        doc /* - **Given:** AST declarations containing nested operators `~~PortDef_Alpha` and `~~~PortDef_Alpha`. - **When:** Lowering evaluates operator parity normalization. - **Then:** `~~PortDef_Alpha` simplifies to `PortDef_Alpha` and `~~~PortDef_Alpha` simplifies to canonical `~PortDef_Alpha`. - **Diagnostic:** `E0200` emitted if normalization fails to resolve canonical parity forms. */
        part def AC_03_Involutive_Simplification_Normalization_Gate {
        }
        doc /* - **Given:** Namespace `Package_0` declaring distinct elements `Classifier_Alpha` and `Classifier_Beta`. - **When:** Both declarations specify identical member name `Item_X` within `Package_0`. - **Then:** The compiler rejects the second membership as a duplicate name collision, while permitting distinct memberships binding to identical elements. - **Diagnostic:** `E0200` emitted on duplicate member name collision. */
        part def AC_03_Lexical_Uniqueness_and_Colliding_Name_Rejection {
        }
        doc /* - **Given:** Model declaring `Control_Fork` with in-degree 2 or out-degree 1, or `Control_Join` with in-degree 1. - **When:** Static topology degree verification executes. - **Then:** Lowering rejects malformed nodes and emits diagnostic `E0200`. - **Diagnostic:** `E0200` (Malformed control topology). */
        part def AC_03_Malformed_Control_Node_Degree_Rejection {
        }
        doc /* - **Given:** A part usage declared with inverted multiplicity bounds `part Part_Inv : PartDef_Alpha [5..2]`. - **When:** Semantic validation checks multiplicity interval bounds. - **Then:** The compiler rejects the inverted interval and emits diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted for invalid multiplicity interval ($``m_{\min} \gt m_{\max}``$). */
        part def AC_03_Malformed_Multiplicity_Range_Rejection {
        }
        doc /* - **Given:** A message transfer step $``s_{\text{transfer}}``$ between `Participant_0` and `Participant_1` with transmission event $``e_{\text{send}}``$ and reception event $``e_{\text{recv}}``$. - **When:** Temporal causality is evaluated where $``\tau(e_{\text{recv}}) \le \tau(e_{\text{send}})``$. - **Then:** The lowering engine detects the temporal inversion and emits diagnostic error code `E0201`. - **Diagnostic:** `E0201` emitted when $``\tau(e_{\text{send}}) \ge \tau(e_{\text{recv}})``$. */
        part def AC_03_Message_Transfer_Directional_Causality_Verification {
        }
        doc /* - **Given:** Feature `Feature_Sup` with multiplicity `[0..5]` and subsetting declarations specifying invalid intervals `Feature_Sub1 :> Feature_Sup [0..8]` (widened upper bound) or `Feature_Sub2 :> Feature_Sup [6..8]` (infeasible lower bound). - **When:** The compiler evaluates multiplicity interval constraints during lowering. - **Then:** The compiler rejects each invalid interval declaration and emits diagnostic code `E0200`. - **Diagnostic:** `E0200`. */
        part def AC_03_Multiplicity_Bound_Narrowing_and_Feasibility_Violation {
        }
        doc /* - **Given:** Data type `DataType_Value` and `State_A` declaring `entry : DataType_Value`. - **When:** Classifier conformance validation evaluates hook typing. - **Then:** Lowering rejects binding with sentinel $``\bot_{\text{action}}``$ and emits `E0201`. - **Diagnostic:** `E0201` on invalid action classifier typing. */
        part def AC_03_Non_Behavioral_Classifier_Typing_Rejection {
        }
        doc /* - **Given:** Transitions with non-orthogonal endpoints, or sibling transitions sharing `Event_0` with overlapping guards. - **When:** Orthogonality and guard disjointness validations execute. - **Then:** Compiler rejects malformed definitions with sentinel $``\bot_{\text{transition}}``$ and emits `E0200`. - **Diagnostic:** `E0200` on non-orthogonal endpoints or overlapping sibling guards. */
        part def AC_03_Orthogonal_Fork_Join_Sibling_Guard_Rejection {
        }
        doc /* - **Given:** Assert constraint referencing definition with `out` parameter, or binding 1 argument for a 2-parameter definition. - **When:** Parameter directionality and binding verification execute. - **Then:** Lowering rejects non-`in` parameters with `E0201` and arity mismatches with `E0200`. - **Diagnostic:** `E0201` (Invalid parameter direction); `E0200` (Parameter arity mismatch). */
        part def AC_03_Parameter_Directionality_Arity_Violation_Rejection {
        }
        doc /* - **Given:** Definition declaring `out param_z : Real`, or usage with arity mismatch ($m \ne k$). - **When:** Validating parameter directionality and signature arity conformance. - **Then:** Directionality violation emits `E0201`; arity mismatch emits `E0200`. - **Diagnostic:** `E0201` on invalid parameter direction; `E0200` on arity mismatch. */
        part def AC_03_Parameter_Directionality_and_Arity_Rejection {
        }
        doc /* - **Given:** `Behavior_Alpha` declaring parameter `Param_In : Real [In]`. - **When:** An invocation passes an argument with incompatible type `Classifier_Beta` or attempts to mutate `Param_In` inside the body. - **Then:** The compiler rejects the invocation with diagnostic code `E0202` on subtyping failure or `E0201` on illegal mutation. - **Diagnostic:** `E0201` emitted for directionality breach; `E0202` emitted for subtyping mismatch. */
        part def AC_03_Parameter_Subtyping_Directionality_Violation_Rejection {
        }
        doc /* - **Given:** Classifier `Classifier_Alpha` defining directed port `Port_1 : in Classifier_Omega`, and `Classifier_Beta :> Classifier_Alpha` declaring redefinition `Port_1_redef :>> Port_1`. - **When:** Lowering validates port directionality $`\delta`$ and structural flags (`isOrdered`, `isUnique`). - **Then:** `Port_1_redef` must preserve `in` polarity ($`\delta = \text{In}`$) unless conjugated (`~`); unauthorized direction inversion or weakening flags is rejected. - **Diagnostic:** `E0200` emitted on polarity mismatch (`RedefinitionDirectionMismatch`). */
        part def AC_03_Port_Flow_Direction_and_Structural_Invariance {
        }
        doc /* - **Given:** `Action_A` with `Port_In : in Classifier_Alpha` allocated to `Part_Alpha` with inverted or missing `Port_In`. - **When:** Port allocation consistency is validated. - **Then:** Rejection of the allocation usage with diagnostic `E0200`. - **Diagnostic:** `E0200` on violation. */
        part def AC_03_Port_Mismatch_and_Polarity_Conflict {
        }
        doc /* - **Given:** Values $``a, b \in \mathcal{V}_{\text{val}}``$ with congruent fields, and distinct entities $``u, v \in \mathcal{O}_{\text{obj}}``$ ($\text{id}(u) \ne \text{id}(v)$). - **When:** Evaluating `a == b`, `u == v`, and cross-domain `a == u`. - **Then:** `a == b` is `true`; `u == v` and `a == u` are `false`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_03_Primitive_Equality_Semantics {
        }
        doc /* - **Given:** Function `Function_Alpha` with return type `Type_A`, whose body expression evaluates to `Type_B`. - **When:** Semantic type checking evaluates subtyping conformance $``\tau(E_{\text{body}}) \le T_{\text{ret}}``$. - **Then:** If `Type_B` specializes `Type_A`, compilation succeeds; otherwise, the compiler rejects the function, binds $``\bot_{\text{type}}``$, and emits diagnostic `E0200`. - **Diagnostic:** `E0200` emitted on return type incompatibility or unresolved return/parameter types. */
        part def AC_03_Return_Type_Specialization_Body_Expression_Conformance {
        }
        doc /* - **Given:** Expression `Quantity_A + Quantity_B` with mismatched dimensions ($``\mathbf{d}(Q_A) \ne \mathbf{d}(Q_B)``$). - **When:** Dimensional type checking executes. - **Then:** Rejection emits `E0300` and binds sentinel $``\bot_{\text{dim}}``$ to continue processing. - **Diagnostic:** `E0300` (DimensionalMismatch). */
        part def AC_03_Static_Dimensional_Homogeneity_Rejection {
        }
        doc /* - **Given:** Containment hierarchy with single ownership and an injected cycle $``\langle \text{Package\_0}, \text{Element\_Alpha}, \text{Package\_0} \rangle``$. - **When:** Containment validation and cycle analysis execute. - **Then:** Conflicting owners ($`|\text{owner}| \gt 1`$) trigger `E0200`; cycles ($`(e, e) \in \mathcal{O}^+`$) trigger `E0203` with cycle path reconstruction, and synchronization token recovery severs the back-edge. - **Diagnostic:** `E0200` for multiple owners; `E0203` for containment cycles; `E0199` upon exhausting $``C_{\text{max\_errors}}``$. */
        part def AC_03_Structural_Containment_Single_Ownership_and_Cycle_Recovery {
        }
        doc /* - **Given:** Usage `VerificationUsage_1 : VerificationDef_Alpha` omitting subject argument or binding argument of type `Classifier_Beta` ($``\text{Classifier\_Beta} \not\le \text{Classifier\_Alpha}``$). - **When:** Subject parameter conformance checking executes. - **Then:** Lowering rejects invalid bindings with sentinel $``\bot_{\text{verif}}``$, emitting `E0202` on type mismatch or `E0200` on omission. - **Diagnostic:** `E0202` on subtyping mismatch, `E0200` on missing subject argument. */
        part def AC_03_Subject_Argument_Subtyping_Mismatch_Missing_Binding {
        }
        doc /* - **Given:** Usage `Req_1 : ReqDef_Alpha` with missing subject or binding `Classifier_Beta` ($``\text{Classifier\_Beta} \not\le \text{Classifier\_Alpha}``$). - **When:** Subject parameter subtyping validation executes. - **Then:** Lowering rejects invalid binding with sentinel $``\bot_{\text{req}}``$ and emits `E0200`. - **Diagnostic:** `E0200` (Subject parameter binding mismatch). */
        part def AC_03_Subject_Parameter_Binding_Mismatch_and_Missing_Binding {
        }
        doc /* - **Given:** `Set<Classifier_Alpha>` assigned `Set<Classifier_Beta>` with `Classifier_Beta` not specializing `Classifier_Alpha`. - **When:** Validating subtyping and elements. - **Then:** Lowering rejects assignment, binds sentinel $``\bot_{\text{type}}``$, and emits `E0200`. - **Diagnostic:** `E0200` (Subtyping or element mismatch). */
        part def AC_03_Subtyping_and_Element_Type_Incompatibility {
        }
        doc /* - **Given:** An occurrence with inverted bounds `[50.0, 10.0]` ($``t_{\text{start}} \gt t_{\text{end}}``$), or a sub-occurrence `OccurrenceUsage_Child` with extent `[10.0, 60.0]` exceeding parent `OccurrenceDef_Alpha` extent `[0.0, 50.0]`. - **When:** The static semantic validation pass evaluates temporal well-formedness and containment. - **Then:** The compiler rejects the invalid interval or containment violation with exact source byte spans and diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted for temporal interval boundary or containment violations. */
        part def AC_03_Temporal_Interval_Bounds_and_Containment_Violations {
        }
        doc /* - **Given:** View declaring `expose Package_0::UndefinedClassifier;` and `expose filter (param_x + 5.0);` with `param_x : Real`. - **When:** Scoped symbol resolution and predicate type analysis execute. - **Then:** Lowering rejects undefined target with `E0200`, rejects non-boolean predicate with `E0202`, and assigns sentinel $``\bot_{\text{exp}}``$. - **Diagnostic:** `E0200` on unresolved path; `E0202` on filter type mismatch. */
        part def AC_03_Unresolved_Path_Target_and_Filter_Codomain_Type_Mismatch {
        }
        doc /* - **Given:** Namespaces `Package_0` and `Package_1` both exporting public `Classifier_Alpha`, and target namespace `Package_2` containing `import Package_0::*; import Package_1::*;` with no local `Classifier_Alpha`. - **When:** Metamodel lowering attempts unqualified resolution of `Classifier_Alpha` within `Package_2`. - **Then:** Scoping engine detects conflicting imported symbols ($`|\{e\}| \gt 1`$), rejects the resolution, and emits diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted on ambiguous unqualified import collision. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Ambiguous_Unqualified_Import_Collision_Detection {
        }
        doc /* - **Given:** Active `State_A` executing `Action_Do` after atomic `Action_Entry` ($\Delta t = 0$). - **When:** Outgoing transition $``T : \text{State\_A} \to \text{State\_B}``$ fires at $``t_{\text{fire}}``$. - **Then:** `Action_Do` aborts immediately ($``t_{\text{end}} = t_{\text{fire}}``$), and `Action_Exit` executes atomically before transition effects. - **Diagnostic:** Diagnostic sink remains empty. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Atomic_Run_to_Completion_and_Do_Preemption {
        }
        doc /* - **Given:** A deeply nested package hierarchy declaring 17 nested packages (`Package_0::Package_1::...::Package_16`). - **When:** The compiler validates package lexical nesting depth. - **Then:** The compiler detects depth $D = 17 \gt 16$, halts nested package lowering, and emits diagnostic code `E0200`. - **Diagnostic:** `E0200` emitted for exceeding maximum package nesting depth. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Bounded_Package_Nesting_Depth_Enforcement {
        }
        doc /* - **Given:** Diamond inheritance hierarchy (`Classifier_Beta :> Classifier_Alpha`, `Classifier_Gamma :> Classifier_Alpha`, `Classifier_Delta :> Classifier_Beta, Classifier_Gamma`). - **When:** The compiler computes $``\text{C3}(\text{Classifier\_Delta})``$, verifies acyclicity via Tarjan's algorithm, and resolves redefinitions of `Feature_A`. - **Then:** Precedence resolves in $`O(V + E)`$ time; conflicting unranked redefinitions trigger ambiguity errors; circular redefinitions ($``f_1 :>> f_2 :>> f_1``$) are rejected. - **Diagnostic:** `E0200` emitted on C3 inconsistency or diamond ambiguity; `E0203` emitted on circular redefinition cycle. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_C3_Monotonicity_Diamond_Disambiguation_and_Acyclicity {
        }
        doc /* - **Given:** Function `Function_Alpha(Param_1 : Type_A, Param_2 : Type_B) : Type_A` and calls $``I_1 = \text{Function\_Alpha}(a_1)``$, $``I_2 = \text{Function\_Alpha}(a_1, a_2, a_3)``$, and $``I_3 = \text{Function\_Alpha}(a_1, a_{\text{invalid}})``$. - **When:** Call-site validation checks arity and argument types against formal signatures. - **Then:** Arity mismatches ($``I_1, I_2``$) and argument type mismatch ($``I_3``$) are rejected with diagnostic `E0200`. - **Diagnostic:** `E0200` emitted on invocation arity mismatch or argument type incompatibility. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Call_Site_Arity_Argument_Subtyping_Conformance {
        }
        doc /* - **Given:** Cyclic allocation chain $``\text{Element}_1 \mapsto \text{Element}_2 \mapsto \text{Element}_3 \mapsto \text{Element}_1``$. - **When:** Topological acyclicity analysis executes over the allocation graph. - **Then:** Cycle detected via Tarjan SCC, emitting diagnostic `E0203`. - **Diagnostic:** `E0203` on violation. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Circular_Allocation_Dependency_Detection {
        }
        doc /* - **Given:** Mutually recursive definitions `ConstraintDef_Alpha` and `ConstraintDef_Beta`. - **When:** Cycle detection evaluates call graph $``\mathcal{R}_{\text{c\_dep}}``$. - **Then:** Compiler detects dependency cycle, halts topological sorting, and emits diagnostic `E0203`. - **Diagnostic:** `E0203` (Circular constraint dependency). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Circular_Constraint_Dependency_Detection {
        }
        doc /* - **Given:** Mutually recursive definitions `ConstraintDef_Alpha` and `ConstraintDef_Beta` in call graph $``\mathcal{G}_{\text{c\_dep}}``$. - **When:** Dependency cycle analysis and sync-token error recovery execute. - **Then:** Cycle detection emits `E0203`; compiler emits terminal `E0199` at limit $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0203` on cyclic dependency; `E0199` on diagnostic saturation. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Circular_Dependency_Detection_and_Recovery {
        }
        doc /* - **Given:** Cyclic containment chain `State_1 \sqsubset State_2 \sqsubset State_3 \sqsubset State_1`. - **When:** Topological acyclicity analysis traverses the containment graph. - **Then:** The compiler isolates the cycle, halts containment lowering, and emits diagnostic `E0203`. - **Diagnostic:** `E0203` on circular state containment cycle. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Circular_State_Containment_Cycle_Detection {
        }
        doc /* - **Given:** Cyclic definitions `ViewpointDef_Alpha :> ViewpointDef_Beta :> ViewpointDef_Alpha` followed by a malformed statement. - **When:** Cycle detection and delimiter recovery execute. - **Then:** Lowering detects dependency cycle `E0203`, resynchronizes on delimiter (`;`), and continues parsing. - **Diagnostic:** `E0203` (Circular viewpoint dependency); `E0199` on terminal error cutoff. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Circular_Viewpoint_Dependency_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Action definition with malformed control node (e.g., fork with in-degree 2 or join with out-degree 2). - **When:** Control node degree validation executes. - **Then:** Compiler rejects malformed topology with source spans and diagnostic `E0200`. - **Diagnostic:** `E0200` (Malformed control topology). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Control_Node_Degree_Topology_Violation {
        }
        doc /* - **Given:** Cyclic derivation `Dimension_Alpha :> Dimension_Beta` or mutation in `Package_ISQBase`. - **When:** Semantic validation and cycle detection run. - **Then:** Cycle emits `E0203`, mutation emits `E0200`, and recovery halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0203`, `E0200`, or `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Cyclic_Derivation_Immutability_and_Exponent_Range_Rejection {
        }
        doc /* - **Given:** Ternary definition `interface def InterfaceDef_Ternary`, or usage binding only one port. - **When:** Validating arity and endpoint completeness. - **Then:** Lowering rejects ternary definition with `E0200` and dangling usage with `E0220`. - **Diagnostic:** `E0200` on invalid arity; `E0220` on dangling usage. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Dangling_End_Role_and_Arity_Rejection {
        }
        doc /* - **Given:** Declaration `DataType_Delta` containing a mutable feature or behavioral action lifecycle hook. - **When:** Metamodel semantic checking inspects feature constraints. - **Then:** The compiler rejects mutable or behavioral feature declarations in `DataType_Delta`, emitting diagnostic `E0200`. - **Diagnostic:** `E0200` emitted on mutable feature declaration within a `DataType`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_DataType_Feature_Immutability_Enforcement {
        }
        doc /* - **Given:** Source buffer with malformed `@UnresolvedDef(err;;) part def Classifier_Beta;` preceding valid `part def Classifier_Alpha;`. - **When:** Parsing and synchronization error recovery execute. - **Then:** Parser resynchronizes on delimiters, records `E0200`, lowers `Classifier_Alpha`, and emits `E0199` upon reaching $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0200` on syntax/resolution fault; `E0199` on error threshold overflow. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Synchronization_and_Error_Recovery {
        }
        doc /* - **Given:** Model adding heterogeneous quantities ($``\mathbf{d}_1 \ne \mathbf{d}_2``$). - **When:** Validating dimensional consistency. - **Then:** Rejection halts lowering and emits `E0300`. - **Diagnostic:** `E0300` (Dimensional homogeneity violation). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Dimensional_Homogeneity_Rejection {
        }
        doc /* - **Given:** Classifiers declared mutually disjoint via `disjoining Classifier_Alpha, Classifier_Beta`. - **When:** Classifier `Classifier_Gamma` specializes both `Classifier_Alpha` and `Classifier_Beta`. - **Then:** Engine detects $``\text{Classifier\_Alpha} \perp \text{Classifier\_Beta}``$, identifies empty intersection $``⟦ \text{Classifier\_Gamma} ⟧ \subseteq \emptyset``$, binds sentinel $``\bot_{\text{type}}``$, and recovers at delimiter. - **Diagnostic:** `E0200` emitted with source span identifying the disjoint type conflict. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Disjoining_Mutual_Exclusion_Enforcement {
        }
        doc /* - **Given:** Feature `Feature_Sup` in `Classifier_Alpha` and directed port `Port_1 : in Classifier_Alpha`. - **When:** The compiler validates cross-classifier subsetting `Feature_Sub :> Feature_Sup` from disjoint `Classifier_Gamma`, or inverted directionality `Port_2 :> Port_1 : out Classifier_Alpha`. - **Then:** The compiler rejects the domain mismatch and conflicting flow directionality, emitting diagnostic code `E0200`. - **Diagnostic:** `E0200`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Domain_Specialization_and_Directional_Polarity_Enforcement {
        }
        doc /* - **Given:** Model declaring `Control_Decision` with non-Boolean guard `param_x + 1.0` or overlapping guards, or `Control_Join` with un-forked decision inputs. - **When:** Semantic type analysis and deadlock freedom validation execute. - **Then:** Rejection emits `E0202` for non-Boolean guards and `E0200` for ambiguous guards or join deadlock, binding sentinel $``\bot_{\text{ctrl}}``$, and emitting `E0199` at $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0200`, `E0202`, or `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Guard_Typing_and_Deadlock_Detection {
        }
        doc /* - **Given:** An item usage declared with inverted cardinality bounds `item Item_0 : ItemDef_Alpha [4..1]`. - **When:** Multiplicity interval validation is executed. - **Then:** The compiler rejects the inverted interval with exact source spans and diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted for invalid item multiplicity interval. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Item_Multiplicity_Range_Conformance {
        }
        doc /* - **Given:** Malformed `unit def Unit_Alpha :> Classifier_Alpha;` preceding valid `unit def Unit_Beta;`. - **When:** Delimiter recovery executes. - **Then:** Lowering rejects `Unit_Alpha` with `E0200`, recovers on delimiter, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0200`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Malformed_Unit_Specialization_Delimiter_Recovery {
        }
        doc /* - **Given:** `VerificationDef_Alpha` omitting verdict return parameter or specifying invalid return type `Real`. - **When:** Signature verification and verdict type unification execute. - **Then:** Lowering rejects malformed signature with sentinel $``\bot_{\text{verif}}``$ and emits diagnostic `E0200`. - **Diagnostic:** `E0200` (Malformed verification signature). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Mandatory_Tri_State_Verdict_Codomain_Violation {
        }
        doc /* - **Given:** A message transfer step $``s_{\text{transfer}}``$ declared with classifier type `Payload_Type_A` and payload entity $``\delta_{\text{payload}}``$ of type `Payload_Type_B`. - **When:** Type checking validates payload conformance against the transfer type contract. - **Then:** If `Payload_Type_B` does not specialize `Payload_Type_A` ($``\tau(\delta_{\text{payload}}) \not\le_{\text{sub}} \tau_{\text{msg}}``$), the engine emits diagnostic error code `E0202`; otherwise, compilation succeeds. - **Diagnostic:** `E0202` emitted on payload subtyping mismatch. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Message_Payload_Subtype_Conformance {
        }
        doc /* - **Given:** Narrowing assignment `param_y : Integer = 3.14159` followed by `;` and `val_pos : Positive = 1`. - **When:** Type checking and recovery execute. - **Then:** Rejection emits `E0200`, resynchronizes at `;`, lowers subsequent declarations, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0200`; `E0199` upon error threshold saturation. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Narrowing_Prohibition_Delimiter_Recovery {
        }
        doc /* - **Given:** Occurrence `Occurrence_Alpha` with lifetime `[0.0, 100.0]`. - **When:** An event occurrence `EventOccurrence_Bad` declares trigger expression `param_x + 1.0` typed as `Real` instead of `Boolean`. - **Then:** The compiler rejects the non-boolean trigger predicate and records diagnostic code `E0200`. - **Diagnostic:** `E0200` emitted for invalid trigger expression type. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Non_Boolean_Event_Trigger_Predicate_Rejection {
        }
        doc /* - **Given:** An AST model applying `~` to non-conjugable classifier `~Classifier_Alpha` (`Real`, `Integer`, or a class without ports). - **When:** Lowering validates conjugation target applicability. - **Then:** The compiler rejects the expression, assigns sentinel node $``\bot_{\text{type}}``$, and emits diagnostic `E0200`. - **Diagnostic:** `E0200` emitted when `~` is applied to non-conjugable classifiers. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Non_Conjugable_Target_Classifier_Rejection {
        }
        doc /* - **Given:** Requirement definition declaring parameter with direction `out` (`out param_x : Real`). - **When:** Parameter signature directionality analysis executes. - **Then:** Lowering rejects non-`In` directionality and emits `E0201`. - **Diagnostic:** `E0201` (Invalid requirement parameter direction). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Non_Input_Parameter_Directionality_Rejection {
        }
        doc /* - **Given:** Semantic element `Element_Alpha` with denotation $``⟦ \text{Element\_Alpha} ⟧``$. - **When:** Metadata annotation `Annotation_0` is attached to `Element_Alpha`. - **Then:** Algebraic type denotation satisfies $``⟦ \text{Element\_Alpha} \oplus \text{Annotation\_0} ⟧ \equiv ⟦ \text{Element\_Alpha} ⟧``$, preserving subtyping and operational semantics without alteration. - **Diagnostic:** `E0200` emitted if metadata alters type denotation or triggers semantic evaluation side-effects. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Non_Intrusive_Annotation_Semantics_and_Type_Invariance {
        }
        doc /* - **Given:** `Association_A` with `End_1` marked `Navigable` and `End_2` marked `NonNavigable`. - **When:** An expression attempts traversal from `End_1` to `End_2`. - **Then:** Semantic analysis halts traversal and emits diagnostic `E0200`. - **Diagnostic:** `E0200` emitted on non-navigable end access attempt. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Non_Navigable_End_Traversal_Rejection {
        }
        doc /* - **Given:** A connection referencing an inaccessible or non-existent port path `Part_Alpha.NonExistentPort`. - **When:** Endpoint namespace resolution is evaluated. - **Then:** The compiler halts connection lowering for the dangling endpoint and emits diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted for unresolved or out-of-scope connection endpoint. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Out_of_Scope_Dangling_Endpoint_Detection {
        }
        doc /* - **Given:** Circular ownership where `Package_0` owns `Package_1` and `Package_1` attempts to own `Package_0` via `OwningMembership`. - **When:** Lowering executes ownership cycle validation. - **Then:** The engine detects $`(e, e) \in \mathcal{O}^+`$, severs back-edge, binds sentinel $``\bot_{\text{node}}``$, and continues compilation. - **Diagnostic:** `E0203` emitted with cycle path trace $``\langle \text{Package\_0}, \text{Package\_1}, \text{Package\_0} \rangle``$. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Ownership_Forest_Strict_Acyclicity_Verification {
        }
        doc /* - **Given:** `Behavior_Alpha` defining parameters `Param_In` ($`\text{dir} = \text{In}`$) and `Param_Out` ($`\text{dir} = \text{Out}`$). - **When:** An invocation passes an immutable constant expression to `Param_Out` or attempts to write to `Param_In`. - **Then:** Parameter direction mismatch is detected and invocation binding is rejected. - **Diagnostic:** `E0201` emitted for invalid parameter flow or mutability mismatch. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Parameter_Directionality_Invocation_Binding {
        }
        doc /* - **Given:** Model with `InOut` parameter or alias cycle `Type_A = Set<Type_B>` and `Type_B = Sequence<Type_A>`. - **When:** Signature validation and cycle analysis execute. - **Then:** Rejection emits `E0201` or `E0203`; recovery halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0201`, `E0203`, or `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Parameter_Directionality_and_Cycle_Rejection {
        }
        doc /* - **Given:** A port usage declared with invalid direction specifier or inverted multiplicity bounds `port Port_Bad : PortDef_Alpha [3..1]`. - **When:** Semantic validation checks port multiplicity intervals. - **Then:** The compiler rejects the malformed declaration with exact source spans and diagnostic error code `E0200`. - **Diagnostic:** `E0200` emitted for invalid port multiplicity interval. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Port_Multiplicity_and_Direction_Verification {
        }
        doc /* - **Given:** Flow on `Conn_0` ($\text{Capacity} = 1000$ B/s) with inverted rate `[100.0, 10.0]` or throughput $> 1000$ B/s. - **When:** Rate multiplicity and bandwidth checks execute. - **Then:** Compiler isolates the invalid flow with diagnostic `E0202`. - **Diagnostic:** `E0202` (Malformed rate or capacity overflow). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Rate_Interval_and_Capacity_Bounds {
        }
        doc /* - **Given:** Pure expression `Expression_1`, circular constant chain ($``c_1 = c_2 + 1, c_2 = c_1 * 2``$), and error limit $``C_{\text{max\_errors}} = 50``$. - **When:** The compiler executes constant evaluation, cycle detection, and error recovery. - **Then:** Pure expression evaluation preserves store state ($``\sigma_{\text{post}} \equiv \sigma_{\text{pre}}``$); cyclic constants emit `E0203` with precise spans; sentinel $``\bot_{\text{expr}}``$ is substituted, and reaching $``C_{\text{max\_errors}}``$ emits `E0199` and halts. - **Diagnostic:** `E0203` emitted on circular constant dependency; `E0199` emitted when diagnostic capacity reaches $``C_{\text{max\_errors}}``$. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Referential_Transparency_Cycle_Detection_Error_Recovery {
        }
        doc /* - **Given:** Model redeclaring `Anything` or declaring cycle `Anything :> Classifier_Alpha`. - **When:** Namespace validation and cycle detection execute. - **Then:** Rejection emits `E0200` or `E0203`; recovery halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0200`, `E0203`, or `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Reserved_Symbol_and_Cycle_Rejection {
        }
        doc /* - **Given:** Calculation usages inducing static cycle `Calc_1 -> Calc_2 -> Calc_1` in dependency graph $``G_{\text{calc}}``$. - **When:** Topological acyclicity analysis executes via Tarjan's SCC algorithm. - **Then:** Compiler isolates the cycle, halts recursive evaluation, and emits diagnostic `E0203`. - **Diagnostic:** `E0203` (Circular calculation dependency). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Static_Circular_Calculation_Dependency_Detection {
        }
        doc /* - **Given:** A recursive physical containment cycle (`PartDef_Alpha` containing `Part_0 : PartDef_Beta [1..1]`, and `PartDef_Beta` containing `Part_1 : PartDef_Alpha [1..1]`). - **When:** The topological cycle detection pass traverses the containment graph. - **Then:** The compiler detects the cyclic dependency with non-zero lower multiplicity and emits diagnostic error code `E0203`. - **Diagnostic:** `E0203` emitted for circular composite containment. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Sub_Assembly_Containment_Cycle_Detection {
        }
        doc /* - **Given:** A synthetic cyclic sub-occurrence containment chain (`OccurrenceUsage_1` containing `OccurrenceUsage_2` containing `OccurrenceUsage_1`). - **When:** The topological cycle detection pass traverses the containment relation graph. - **Then:** The compiler detects the circular dependency, halts containment processing for the cycle, and emits diagnostic error code `E0203` detailing participating nodes. - **Diagnostic:** `E0203` emitted for circular occurrence containment dependency. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Sub_Occurrence_Containment_Acyclicity_Verification {
        }
        doc /* - **Given:** Performance `Performance_1` with lifetime `[10.0, 50.0]`. - **When:** A constituent sub-step `Step_Child` declares temporal execution bounds `[5.0, 30.0]` ($``t_{\text{start}} \lt 10.0``$) or `[20.0, 60.0]` ($``t_{\text{end}} \gt 50.0``$). - **Then:** The compiler rejects the containment violation with exact source byte spans and emits diagnostic code `E0200`. - **Diagnostic:** `E0200` emitted for sub-step temporal containment breach. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Sub_Step_Temporal_Containment_Boundary_Breach {
        }
        doc /* - **Given:** Requirements `Req_1` and `Req_2` with only `Req_1` satisfied by `Part_Alpha` under completeness enforcement. - **When:** Traceability coverage analysis and orphan detection execute. - **Then:** Coverage evaluates to $``\text{Coverage}(V_R) = 0.5``$, orphan `Req_2` is flagged, and diagnostic `E0200` is emitted. - **Diagnostic:** `E0200` (Orphan requirement violation). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Traceability_Coverage_and_Orphan_Requirement_Detection {
        }
        doc /* - **Given:** Transitions with non-event trigger `accept Classifier_Alpha`, non-boolean guard `if param_x + 1.0`, or instant cycle `State_1 -> State_2 -> State_1`. - **When:** Semantic type checking and cycle detection execute. - **Then:** Compiler emits `E0201` for trigger mismatch, `E0202` for non-boolean guard, and `E0203` for instant cycle. - **Diagnostic:** `E0201`, `E0202`, or `E0203` on corresponding violation. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Trigger_Typing_Guard_Typing_Instant_Cycle_Rejection {
        }
        doc /* - **Given:** View declaring `satisfy viewpoint ViewpointDef_Alpha;` omitting mandatory `Classifier_Alpha`, alongside cyclic views `ViewDef_Alpha` and `ViewDef_Beta`. - **When:** Conformance checking and cycle detection execute. - **Then:** Validator emits `E0200` for omission, `E0203` for cycle, recovers on `;` and `}`, and emits terminal `E0199` at $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0200` on viewpoint violation; `E0203` on cycle; `E0199` on error ceiling. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Viewpoint_Conformance_Violation_and_Circular_Expose_Recovery {
        }
        doc /* The compiler metamodel lowering engine shall define and enforce the foundational KerML abstract syntax root hierarchy as a rooted directed multigraph of semantic elements $`\mathcal{E}`$, directed relationships $`\mathcal{R} \subseteq \mathcal{E}`$, metadata annotations $`\mathcal{M} \subseteq \mathcal{E}`$, and containment ownership relations $`\mathcal{O} \subset \mathcal{E} \times \mathcal{E}`$, with `Element` as the universal root entity. A `Relationship` ($`r \in \mathcal{R}`$) specializes `Element`, connecting non-empty source ($`\text{source}(r) \subseteq \mathcal{E}`$) and target ($`\text{target}(r) \subseteq \mathcal{E}`$) endpoints. Directed non-reflexive relationships require $`\text{source}(r) \cap \text{target}(r) = \emptyset`$. Empty, reflexive, or dangling endpoints shall emit diagnostic `E0200` per REQ-0191. Containment $`\mathcal{O}`$ forms a strict directed forest enforcing single ownership ($`\forall v \in \mathcal{E}, |\text{owner}(v)| \le 1`$). Cycles ($`(e, e) \in \mathcal{O}^+`$) are prohibited; detected cycles shall emit diagnostic `E0203` with cycle path $``\mathcal{P}_{\text{cycle}}``$ per REQ-0042. Conflicting multiple ownership shall emit `E0200`. `Annotation` ($`\alpha \in \mathcal{M}`$) specializes `Element`, attaching metadata such that $`⟦ e \oplus \alpha ⟧ \equiv ⟦ e ⟧`$. --- */
        part def _1_Normative_Statement {
        }
        doc /* Let $``\mathcal{V}_{\text{arena}} \subset \mathbb{N}_{32}``$ denote contiguous arena slot handles. The KerML root multigraph is: G_{\text{KerML}} = \langle \mathcal{E}, \mathcal{R}, \mathcal{M}, \mathcal{O} \rangle, \quad \mathcal{R} \subseteq \mathcal{E}, \quad \mathcal{M} \subseteq \mathcal{E}, \quad \mathcal{O} \subset \mathcal{E} \times \mathcal{E} Every element $`e \in \mathcal{E}`$ is an immutable tuple: e = \langle \text{id}_e, \text{name}_e, \text{owner}_e, \mathcal{C}_e, \mathcal{A}_e, \Delta_e, \text{span}_e \rangle where $``\text{id}_e \in \mathcal{V}_{\text{arena}}``$, $``\text{name}_e \in \mathcal{S}_{\text{intern}} \cup \{ \bot \}``$, $``\text{owner}_e \in \mathcal{E} \cup \{ \bot \}``$, $``\mathcal{C}_e \subseteq \mathcal{E}``$, $``\mathcal{A}_e \subseteq \mathcal{M}``$, $``\Delta_e = \text{UUIDv5}(\text{OID}_{\text{DEAP}}, \text{FQN}(e))``$, and $``\text{span}_e``$ is lexical provenance. Relationship endpoint invariants: \begin{aligned} \text{directed}(r) &\implies (\text{source}(r) \neq \emptyset) \wedge (\text{target}(r) \neq \emptyset) \wedge (\text{source}(r) \cap \text{target}(r) = \emptyset) \\ \forall u &\in (\text{source}(r) \cup \text{target}(r)), \quad \text{IsAllocated}(\text{id}(u)) \equiv \text{true} \end{aligned} Ownership forest and acyclicity invariants: \forall v \in \mathcal{E}, \quad |\{ u \in \mathcal{E} \mid (u, v) \in \mathcal{O} \}| \le 1 \quad \wedge \quad (v, v) \notin \mathcal{O}^+ \forall u, v \in \mathcal{E}, \quad (u, v) \in \mathcal{O} \iff v \in \mathcal{C}_u \iff \text{owner}(v) = u Annotation non-interference: \forall e \in \mathcal{E}, \; \forall \alpha \in \mathcal{M}, \quad ⟦ e \oplus \alpha ⟧ \equiv ⟦ e ⟧ Diagnostic trigger mappings per REQ-0191: \begin{aligned} \text{source}(r) = \emptyset \vee \text{target}(r) = \emptyset \vee (\text{source}(r) \cap \text{target}(r) \neq \emptyset) &\implies \text{Diagnostic}(r, \text{E0200}) \in \mathcal{D}_{\text{sink}} \\ \exists u \in (\text{source}(r) \cup \text{target}(r)), \, \neg\text{IsAllocated}(\text{id}(u)) &\implies \text{Diagnostic}(r, \text{E0200}) \in \mathcal{D}_{\text{sink}} \\ |\{ u \in \mathcal{E} \mid (u, v) \in \mathcal{O} \}| \gt 1 &\implies \text{Diagnostic}(v, \text{E0200}) \in \mathcal{D}_{\text{sink}} \\ (e, e) \in \mathcal{O}^+ &\implies \text{Diagnostic}(\mathcal{P}_{\text{cycle}}, \text{E0203}) \in \mathcal{D}_{\text{sink}} \\ |\mathcal{D}_{\text{sink}}| \ge C_{\text{max\_errors}} &\implies \text{DiagnosticCode::E0199} \in \mathcal{D}_{\text{sink}} \end{aligned} --- */
        part def _2_Formal_Invariant {
        }
        doc /* KerML root abstract syntax lowering, relationship endpoint validation, and containment cycle checking execute strictly within Complexity Class $`\mathbf{P}`$. Contiguous AST memory slot allocation and handle dereferencing execute in deterministic $`O(1)`$ constant time with zero pointer indirection. Endpoint validation for bounded endpoints ($``K_{\text{src}}, K_{\text{tgt}} \le 16``$) requires $`O(1)`$ per relationship, yielding $`O(|\mathcal{R}|)`$ total endpoint validation time. Single ownership verification requires $`O(1)`$ time per element, bounding model checks to $`O(|\mathcal{E}|)`$. Tarjan strongly connected components (SCC) cycle detection on containment forest $``G_{\text{own}} = (\mathcal{E}, \mathcal{O})``$ evaluates in deterministic linear time $`O(|\mathcal{E}| + |\mathcal{O}|) \subseteq O(|\mathcal{E}|)`$ since $`|\mathcal{O}| \le |\mathcal{E}|`$. Annotation attachment and lookup execute in $`O(1)`$ amortized and $``O(|\mathcal{A}_e|)``$ linear time. Parallel lowering over $``N_{\text{max\_workers}}``$ threads scales as $``O((|\mathcal{E}| + |\mathcal{R}| + |\mathcal{M}|) / N_{\text{max\_workers}} + \log N_{\text{max\_workers}})``$. Arena memory footprint is bounded by $`O(|\mathcal{E}| + |\mathcal{R}| + |\mathcal{M}|)`$, with stack depth bounded by $``O(D_{\max}) \le 64``$ frames. NP Frontier Reference: Decoupled from NP-hard combinatorial frontiers (NP-1 through NP-8); all root structural graph checks evaluate deterministically in linear time $`O(V + E)`$ without backtracking. --- */
        part def _3_Computational_Complexity_Algorithmic_Bounds {
        }
        part def _4_Verification_Conformance_Criteria {
        }
    }
    doc /* 7D Physical Metrology & Abstract Flow Conservation Networks */
    package Subsystem_5_7D_Physical_Metrology_Flow_Networks {
        doc /* UUIDv5: a9dfc9c8-4af1-54e7-bdb7-b57797292b0f | Complexity: Class P (O(1) vector ops, O(N) lowering) | Standard: IEEE 29148-2018 / RFC 2119 / ISO 80000 | Diagnostics: E0199, E0300 */
        requirement def REQ_0098_Formal_mathbb_7_Rational_Vector_Space_over_SI_Base_Dimensions {
            id = "REQ-0098";
            text = "The metrology engine SHALL model physical dimensions as vector space (\mathbb{Q}^7,+,\cdot) over \mathbb{Q}. Canonical basis B_{SI} = \{e_M, \dots, e_J\} maps bijectively to the 7 SI base quantities (M, L, T, I, \Theta, N, J).";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: 83cab42d-eb92-56bf-91cd-0f4bc1c7a675 | Complexity: Class P (O(1) coordinate check, O(N) lowering) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / ISO 80000-1 | Diagnostics: E0199, E0300, E0301 (per REQ-0191) */
        requirement def REQ_0099_Base_Dimension_Tuple_Representation {
            id = "REQ-0099";
            text = "The engine SHALL represent dimensions as irreducible rational 7-tuples over \mathbb{Q}^7 spanning ISQ base dimensions (M, L, T, I, \Theta, N, J).";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: 607d243a-c844-554f-ab38-c90e43262629 | Complexity: Class P (O(K + V + E)) | Standard: IEEE 29148-2018 / RFC 2119 / Tellegen | Diagnostics: E0199, E0300, E0301 (per REQ-0191) */
        requirement def REQ_0100_Exact_Rational_Exponent_Arithmetic {
            id = "REQ-0100";
            text = "The compiler SHALL execute dimensional algebra over \mathbb{Q} without floating-point arithmetic, synthesizing flow continuity (\sum f = 0) and loop conservation (\sum \Delta e = 0).";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: 28881e44-527b-53f2-a928-fa9ff7b76349 | Complexity: Class P (O(1) vector checks, O(N) lowering) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / ISO 80000-1 | Diagnostics: E0199, E0300 */
        requirement def REQ_0101_Static_Dimensional_Homogeneity_Validation_for_Additive_Expressions {
            id = "REQ-0101";
            text = "The compiler SHALL validate dimensional homogeneity on additive (A\pm B), relational (A\sim B), and extremum (\min,\max) expressions in \mathbb{Q}^7.";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: 87075115-ccc2-5dc4-a270-f69dd24927aa | Complexity: Class P (O(1) arithmetic, O(N) AST lowering) | Standard: IEEE 29148-2018 / RFC 2119 / ISO 80000-1 | Diagnostics: E0199, E0300 (per REQ-0191) */
        requirement def REQ_0102_Multiplicative_Dimensional_Exponent_Addition {
            id = "REQ-0102";
            text = "The metrology engine SHALL compute and validate dimension vectors for multiplication (A \cdot B), division (A / B), and reciprocal (1 / B) via vector addition, subtraction, and negation in \mathbb{Q}^7.";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: 997a9b42-a403-53ea-b33b-a688089e8f42 | Complexity: Class P (O(1) coordinate check, O(V) AST traversal) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / ISO 80000-1 §3.8 | Diagnostics: E0199, E0300 */
        requirement def REQ_0103_Dimensionless_Constraint_Enforcement_for_Transcendental_Arguments {
            id = "REQ-0103";
            text = "The metrology engine and type checker of Subsystem 5 SHALL enforce that all arguments to transcendental and trigonometric functions evaluate strictly to the dimensionless null vector 0 \in \mathbb{Q}^7 over the seven ISQ base dimensions. Evaluated results MUST likewise yield d_{result} = 0 \in";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: 6b419bc3-0e70-538d-a5b7-afddf4582acd | Complexity: Class P (O(1) rational scalar multiplication, O(V) AST lowering) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / ISO 80000-1 §3.8 | Diagnostics: E0199, E0300 (per REQ-0191) */
        requirement def REQ_0104_Rational_Power_Evaluation_for_Fractional_Exponents {
            id = "REQ-0104";
            text = "The engine SHALL compute and validate 7D dimension vectors and scale factors for rational power expressions (A^k, \operatorname{pow}(A, k), \operatorname{sqrt}(A), \operatorname{cbrt}(A), \operatorname{root}(A, n)) with base dimension d_A \in \mathbb{Q}^7 and rational exponent k = p/q \in";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: 99116ca2-c69c-5b91-a748-9bdab8866e75 | Complexity: Class NP-complete} (LCP) / Class P (O(V^3+\kappa_{pivot} m^2)) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 | Diagnostics: E0199, E0300, E0301, E0399 */
        requirement def REQ_0105_Switched {
            id = "REQ-0105";
            text = "The compiler SHALL partition flow networks into continuous linear subgraphs solved via sparse LU and hybrid switched junctions formulated as a Linear Complementarity Problem (LCP), solved via Lemke pivoting bounded by iteration cutoff \kappa_{pivot}.";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: 7de336d6-2dbc-5cb3-9032-ddbc1e39e163 | Complexity: Class P (O(N_F) classification, O(N_V + N_F) routing) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 §7.15 | Diagnostics: E0199, E0201, E0300 */
        requirement def REQ_0106_Conservative_vs_Non_Conservative_Flow_Network_Classification {
            id = "REQ-0106";
            text = "The flow solver SHALL classify all connections f \in F_{flow} into Conservative (F_{cons}) or Non-Conservative (F_{noncons}) flows.";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: 9f4cf573-ed75-56fd-8516-8c0c1af2168d | Complexity: Class P (O(1) vector checks, O(N) lowering) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / ISO 80000-1 | Diagnostics: E0199, E0300, E0301 */
        requirement def REQ_0107_Generalized_Conjugate_Variable_Pair_Modeling {
            id = "REQ-0107";
            text = "The metrology engine SHALL validate conservative interfaces using dual conjugate variable pairs (e, f) whose dimensional product evaluates to universal Power d_{Power} = (1, 2, -3, 0, 0, 0, 0) \in \mathbb{Q}^7.";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: b7988cc3-7042-57c9-a715-c5ff85506ec7 | Complexity: Class P (O(V + E) lowering, O(E) balance) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Tellegen | Diagnostics: E0199, E0220, E0300, E0301 */
        requirement def REQ_0108_Generalized_Kirchhoff_Flow_Law_0_at_Conservative_Junctions {
            id = "REQ-0108";
            text = "The network solver SHALL synthesize generalized Kirchhoff Flow Law (KFL) continuity equations at conservative junctions.";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: c52acd62-a862-5c28-b9f9-638216863745 | Complexity: Class P (O(V + E) forest, O(E) balance) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Tellegen | Diagnostics: E0199, E0300, E0301 */
        requirement def REQ_0109_Generalized_Kirchhoff_Potential_Law_0_across_Closed_Loops {
            id = "REQ-0109";
            text = "The network solver SHALL synthesize generalized Kirchhoff Potential Law (KPL) equations across conservative loops.";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: 87e23bc6-38c1-58df-b69a-59c2f68b8116 | Complexity: Class P (O(V+E) incidence, O(V\cdot E) cut-set/cycle matrices) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Tellegen | Diagnostics: E0199, E0203, E0220, E0300, E0301 */
        requirement def REQ_0110_Flow_Conservation_Network_Incidence_Matrix_Construction {
            id = "REQ-0110";
            text = "The network solver SHALL construct incidence matrix A\in\{-1,0,1\}^{n\times b} for network G_{flow}=(V_{junc},E_{flow}), verify topological rank, and synthesize cut-set and cycle matrices.";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: 6f09c51c-508b-5e90-8b5a-d142d4fe60eb | Complexity: Class P (O(m + S + R) balance, O(N) lowering) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Tellegen | Diagnostics: E0199, E0300, E0301 */
        requirement def REQ_0111_Abstract_Power_Product_Balance_sum_P_frac {
            id = "REQ-0111";
            text = "The network solver SHALL verify power product balance across closed conservative boundaries \Omega.";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: 71ffa782-aca0-5839-aa8d-259e9c4ee546 | Complexity: Class P (O(1) interval check, O(N) lowering) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / ISO 80000-1 | Diagnostics: E0199, E0300, E0301 */
        requirement def REQ_0112_Parametric_Operational_Envelopes {
            id = "REQ-0112";
            text = "The metrology engine SHALL validate parameters and signals against declared operational envelopes [v_{\min}, v_{\max}] \subset \overline{\mathbb{R}}.";
            satisfy by MetrologyFlowEngine;
        }
        doc /* UUIDv5: 0aca7409-8a38-5c36-9245-98f5fdceef5c | Complexity: Class P (O(k) linear bounding, O(N \cdot K) AST evaluation) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 | Diagnostics: E0199, E0300, E0301 */
        requirement def REQ_0113_Static_Boundary_Value_Analysis {
            id = "REQ-0113";
            text = "The metrology engine SHALL perform static boundary value analysis (BVA), verifying tolerance envelopes satisfy safety bounds.";
            satisfy by MetrologyFlowEngine;
        }
        doc /* Primary execution engine for 7D Physical Metrology & Abstract Flow Conservation Networks */
        part def MetrologyFlowEngine {
            port in ast_in : ASTGraphPort;
            port out metrology_out : MetrologyPort;
        }
        doc /* - **Given:** Operands `Term_1` and `Term_2` of dimension $(1,1,-2,0,0,0,0)\in\mathbb{Q}^7$. - **When:** Lowering `Term_1 + Term_2` or `Term_1 - Term_2`. - **Then:** Validation inherits operand dimension $(1,1,-2,0,0,0,0)$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Additive_Homogeneity_and_Dimension_Inheritance {
        }
        doc /* - **Given:** Compiler loading `Package_0`. - **When:** Bootstrapping basis $``\mathcal{B}_{\text{SI}}``$ and dimensionless constants. - **Then:** 7 base dimensions map to $``\mathbf{e}_1 \dots \mathbf{e}_7 \in \mathbb{Q}^7``$ and scalars map to $\mathbf{0}$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Basis_Initialization {
        }
        doc /* - **Given:** Port `Port_Alpha` with `Effort_Var` ($(1,2,-3,-1,0,0,0)$) and `Flow_Var` ($(0,0,0,1,0,0,0)$). - **When:** Lowering checks dimensional product. - **Then:** Sum evaluates to $``\mathbf{d}_{\text{Power}}``$ with empty diagnostic sink. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Power_Invariant_Conjugate_Lowering {
        }
        doc /* - **Given:** Rational coordinates $(2/4,6/2,-9/3,0/1,0/1,0/1,0/1)$ and dimensionless scalar. - **When:** Lowering dimension AST nodes. - **Then:** Engine reduces coordinates to $((1,2),(3,1),(-3,1),(0,1),(0,1),(0,1),(0,1))$ and maps scalar to $\mathbf{0}$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Rational_Reduction_Zero_Identity {
        }
        doc /* - **Given:** Acausal ports `Port_1` and `Port_2` linked by `Flow_A` with $``\mathbf{d}_e = (1,-1,-2,0,0,0,0)``$ and $``\mathbf{d}_f = (0,3,-1,0,0,0,0)``$. - **When:** Lowering validates conjugate dimensions. - **Then:** $``\mathbf{d}_e + \mathbf{d}_f \equiv \mathbf{d}_{\text{power}}``$ holds and `Flow_A` enters $``\mathcal{F}_{\text{cons}}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Conservative_Flow_Classification {
        }
        doc /* - **Given:** Network `FlowNetwork_Alpha` in `Package_0` with 12 junctions, 18 branches, and grounded `Junction_1`. - **When:** Sparse LU solves continuous branches. - **Then:** System $``\mathbf{K}_{\text{red}}\mathbf{e}=\mathbf{f}_{\text{ext}}``$ solves with residual $``\|\mathbf{K}_{\text{red}}\mathbf{e}-\mathbf{f}_{\text{ext}}\|_2\lt 10^{-12}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Continuous_Linear_Subgraph_Sparse_LU_Factorization {
        }
        doc /* - **Given:** Network `Network_Alpha` with 5 junctions (`Junction_0`--`Junction_4`) and 7 branches (`FlowBranch_0`--`FlowBranch_6`). - **When:** Extracting spanning forest and cycle constraints. - **Then:** Partitions 3 chords ($``N_C = 3``$), builds $\mathbf{B}$, emitting $``\sum B_{k, e} \Delta e_e = 0``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Cycle_Basis_Extraction_KPL_Synthesis {
        }
        doc /* - **Given:** Expressions invoking $\sin, \cos, \exp, \ln$ with dimensionless arguments ($\mathbf{d} = \mathbf{0}$). - **When:** Metrology type-checking executes. - **Then:** Invocations pass verification with $\mathbf{d} = \mathbf{0}$ and empty diagnostic sink. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Dimensionless_Transcendental_Evaluation {
        }
        doc /* - **Given:** Parameter `Param_X : Real` with envelope `Envelope_Alpha` ($[10.0, 50.0]$) and $``v_{\text{nom}} = 25.0``$. - **When:** Lowering validates bounds and containment. - **Then:** Passes with $10.0 \le 25.0 \le 50.0$ and empty sink. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Envelope_Lowering_Nominal_Containment {
        }
        doc /* - **Given:** Expressions $``Q_1 : \text{Mass}^{1/2}``$ and $``Q_2 : \text{Mass}^{1/3}``$ in `Package_0`. - **When:** Lowering computes $``Q_1 \cdot Q_2``$ and $``(Q_1)^{2/3}``$. - **Then:** Exponents in $\mathbb{Q}^7$ evaluate to $5/6$ and $1/3$ without drift. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Exact_Rational_Exponent_Arithmetic_Scaling {
        }
        doc /* - **Given:** Linear $``y = 2 x_1 + 3 x_2``$ with $``x_1 \in [1.0, 3.0]``$, $``x_2 \in [2.0, 4.0]``$, target $[5.0, 20.0]$. - **When:** Lowering evaluates extrema. - **Then:** Computes $``[y_{\min}, y_{\max}] = [8.0, 18.0] \subseteq [5.0, 20.0]``$ with $``\mu_{\text{lower}} = 3.0``$, $``\mu_{\text{upper}} = 2.0``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Linear_Affine_Tolerance_Containment {
        }
        doc /* - **Given:** Junction `Junction_Alpha` with incoming `Flow_Edge_1`, `Flow_Edge_2`, `Flow_Edge_3` and outgoing `Flow_Edge_4`, `Flow_Edge_5`. - **When:** Lowering Kirchhoff flow continuity. - **Then:** Emits $``f_1 + f_2 + f_3 - f_4 - f_5 = 0``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Multi_Branch_Ideal_Junction_Flow_Balance {
        }
        doc /* - **Given:** Assembly `Assembly_Alpha` with inputs `Port_1` ($60\text{ W}$), `Port_2` ($40\text{ W}$) and output `Port_3` ($-100\text{ W}$). - **When:** Lowering power balance equations. - **Then:** Evaluates $``P_{\text{in}} = P_{\text{out}} = 100\text{ W}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Multi_Port_Power_Balance {
        }
        doc /* - **Given:** Quantities `Quantity_Alpha` (dimension $``\mathbf{e}_M + \mathbf{e}_L - 2\mathbf{e}_T``$, scale $``c_1``$) and `Quantity_Beta` (dimension $``\mathbf{e}_L``$, scale $``c_2``$). - **When:** Lowering multiplication `Expr_Alpha = Quantity_Alpha * Quantity_Beta`. - **Then:** Dimension evaluates to $``\mathbf{e}_M + 2\mathbf{e}_L - 2\mathbf{e}_T``$ with scale $``c_1 \cdot c_2``$, offset $o = 0$, and empty diagnostic sink. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Multiplicative_Exponent_Addition_Scale_Composition {
        }
        doc /* - **Given:** Base `Base_Alpha` ($(0, 2, 0, 0, 0, 0, 0)$) and scale $c = 4$. - **When:** Lowering `Base_Alpha ^ (3/2)` and `sqrt(Base_Alpha)`. - **Then:** Dimensions evaluate to $(0, 3, 0, 0, 0, 0, 0)$ with scale $8$ and $(0, 1, 0, 0, 0, 0, 0)$ with scale $2$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Rational_Exponent_Multiplication_Radical_Lowering {
        }
        doc /* - **Given:** Network `Network_Alpha` with `Junction_Alpha`, `Junction_Beta`, and `FlowBranch_1`. - **When:** Lowering constructs matrix $\mathbf{A}$. - **Then:** Emits $\mathbf{A}=[+1;-1]$ with column sum 0 and $\text{rank}(\mathbf{A})=1$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Two_Junction_Branch_Incidence_and_Column_Sum {
        }
        doc /* - **Given:** Invocation $``\operatorname{atan2}(E_y, E_x)``$ with length arguments ($``\mathbf{d}(E_y) = \mathbf{d}(E_x) = [L]``$) and $``\sin(\text{param\_theta})``$ with unit `rad`. - **When:** Commensurability checking and angle conversion execute. - **Then:** Commensurability holds, angle converts to radians, result yields $\mathbf{d} = \mathbf{0}$, and sink remains empty. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Commensurable_Multi_Argument_Resolution {
        }
        doc /* - **Given:** Operands `Term_1` and `Term_2` of dimension $(0,1,0,0,0,0,0)$ in `Unit_Alpha` ($c=1$) and `Unit_Beta` ($c=1/1000$). - **When:** Lowering `Term_1 + Term_2`. - **Then:** Compiler synthesizes node scaling `Term_2` by $1/1000\in\mathbb{Q}^+$ in unit `Unit_Alpha`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Commensurable_Unit_Conversion_Synthesis {
        }
        doc /* - **Given:** Dynamic junction `Junction_Beta` ($``S_i:[M]^1``$), incoming `Flow_Edge_1` (g/s, $``c_1=1/1000``$), outgoing `Flow_Edge_2` (kg/s, $``c_2=1``$). - **When:** Lowering dynamic flow continuity. - **Then:** Synthesizes $``(1/1000) f_1 - f_2 = \frac{d(\text{param\_s})}{dt}``$ in $[M]^1 [T]^{-1}$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Commensurable_Unit_Conversion_and_Dynamic_Accumulation {
        }
        doc /* - **Given:** Triangle network with 3 junctions, 3 branches, and admittances $``y_j\gt 0``$. - **When:** Lowering spanning tree, cut-set $\mathbf{Q}$, and cycle $\mathbf{B}$. - **Then:** Partitions 2 tree branches, 1 chord, yielding $``\mathbf{B}_T=-\mathbf{Q}_C^T``$, $\mathbf{A}\mathbf{B}^T=\mathbf{0}$, and $``\mathbf{Y}_{\text{node}}\succ 0``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Connected_Triangular_Loop_Spanning_Tree_and_Duality {
        }
        doc /* - **Given:** Interface `Interface_Gamma` with Across `Across_Var` and Through `Through_Var`. - **When:** Validating conjugate pairs. - **Then:** Dimensional sum evaluates to $``\mathbf{d}_{\text{Power}} = (1,2,-3,0,0,0,0)``$ with valid flag set true. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Conservative_Conjugate_Power_Pair_Conformance {
        }
        doc /* - **Given:** Ports `Port_Alpha` and `Port_Beta` sharing identical effort and flow dimensions. - **When:** Interconnect validation and continuity synthesis execute. - **Then:** Dimensions match, $``f_{\text{Port\_Alpha}} + f_{\text{Port\_Beta}} = 0``$ holds, and sink remains empty. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Conservative_Interconnect_Compatibility {
        }
        doc /* - **Given:** Quantities `Factor_1` (dimension $``\mathbf{e}_L``$, scale $1000$) and `Factor_2` (dimension $``\mathbf{e}_L``$, scale $1$). - **When:** Lowering division `Expr_Alpha = Factor_1 / Factor_2`. - **Then:** Dimension evaluates to identity $\mathbf{0}$ with scale $1000$ and empty diagnostic sink. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Division_Exponent_Subtraction_Dimensional_Cancellation {
        }
        doc /* - **Given:** Assembly `Assembly_Beta` with input `Port_1` ($2\text{ kW}$, $``c_1=1000``$), output `Port_2` ($1500\text{ W}$), dissipation $200\text{ W}$, storage rate $300\text{ W}$. - **When:** Lowering dynamic balance constraints. - **Then:** Evaluates $(1000 \cdot 2) - 1500 = 300 + 200$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Dynamic_Storage_and_Scaling {
        }
        doc /* - **Given:** Quantities `Quantity_1` ($(1,1,-2,0,0,0,0)$) and `Quantity_2` ($(0,1,0,0,0,0,0)$) with $k = 1/2$. - **When:** Lowering `Quantity_1 * Quantity_2`, `Quantity_1 / Quantity_2`, and `Quantity_2^(1/2)`. - **Then:** Dimensions evaluate to $``\mathbf{d}_1 + \mathbf{d}_2``$, $``\mathbf{d}_1 - \mathbf{d}_2``$, and $``k \cdot \mathbf{d}_2``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Exact_Vector_Arithmetic_and_Exponentiation {
        }
        doc /* - **Given:** Network `FlowNetwork_Alpha` with 4 switched branches, matrix $\mathbf{M}\succeq 0$, and cutoff $``\kappa_{\text{pivot}}=64``$. - **When:** Lemke algorithm solves canonical $\operatorname{LCP}(\mathbf{M},\mathbf{q})$. - **Then:** Solver terminates with $``z_0=0``$ in $``N_{\text{pivot}}\le\kappa_{\text{pivot}}``$, with $\mathbf{w}\ge\mathbf{0},\mathbf{z}\ge\mathbf{0}$ and $\mathbf{w}^T\mathbf{z}=0$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Hybrid_Switched_Junction_Complementarity_Lemke_Pivot_Convergence {
        }
        doc /* - **Given:** Output `Port_1` driving inputs `Port_2`, `Port_3`, `Port_4` with scalar `param_x : Real`. - **When:** Lowering builds signal routing. - **Then:** Connections enter $``\mathcal{F}_{\text{noncons}}``$ with unattenuated broadcast. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Non_Conservative_Signal_Flow {
        }
        doc /* - **Given:** Network `Network_Alpha` ($``e(\text{Junction\_0}) = 0``$), $``\mathbf{\Delta e} = \mathbf{A}_{\text{red}}^T \mathbf{e}_{\text{node}}``$, and cycle $``\mathcal{L}_{\text{comb}} = \mathcal{L}_1 \oplus \mathcal{L}_2``$. - **When:** Evaluating potential closure on $``\mathcal{L}_{\text{comb}}``$. - **Then:** Yields $\mathbf{B} \mathbf{\Delta e} = \mathbf{0}$ and $\oint \Delta e = 0$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Potential_Field_Arbitrary_Loop_Closure {
        }
        doc /* - **Given:** Nominal $1.0\text{ m}$ with tolerance $50.0\text{ mm}$ and bound $[0.95, 1.05]\text{ m}$. - **When:** Normalizing units and boundaries. - **Then:** Scales via $``c_u = 1/1000 \in \mathbb{Q}^+``$ to $[0.95, 1.05]\text{ m}$ with zero margin violation. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Unit_Conversion_and_Boundary_Clearance {
        }
        doc /* - **Given:** Parameter `Param_Y` with tiers $``\mathcal{E}_{\text{normal}} = [20.0\text{ mm}, 80.0\text{ mm}]``$, $``\mathcal{E}_{\text{safety}} = [0.01\text{ m}, 0.10\text{ m}]``$. - **When:** Lowering normalizes units ($c = 1/1000$) and checks monotonicity. - **Then:** Validates $[0.02, 0.08] \subseteq [0.01, 0.10]$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Unit_Scaling_Monotonic_Inclusion {
        }
        doc /* - **Given:** Exponent $3/0$ or junction with mismatched flow dimensions. - **When:** Dimensional checking executes. - **Then:** Engine halts, assigns sentinel $``\bot_{\text{dim}}``$, emitting `E0300`. - **Diagnostic:** `E0300`. */
        part def AC_02_Zero_Denominator_Incommensurable_Dimensions {
        }
        doc /* - **Given:** Quantity `Quantity_Alpha` ($(1, 1, -2, 0, 0, 0, 0)$) and parameter `param_x : Real` ($\mathbf{0}$). - **When:** Lowering `Quantity_Alpha ^ 0` and `param_x ^ (5/3)`. - **Then:** Both evaluate to null vector $\mathbf{0} \in \mathbb{Q}^7$ with scale $1$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Zero_Exponent_Identity_Dimensionless_Invariance {
        }
        doc /* - **Given:** Expression `Base_Alpha ^ 2` with affine unit ($o = 273.15$) and `Quantity_Alpha ^ param_y`. - **When:** Metrology type checking executes. - **Then:** Rejection emits `E0300` and assigns sentinel $``\bot_{\text{dim}}``$. - **Diagnostic:** `E0300`. */
        part def AC_03_Affine_Unit_Non_Rational_Exponent_Rejection {
        }
        doc /* - **Given:** Expression `Expr_Alpha = param_x * param_y` where `param_x` has affine unit `Unit_Alpha` ($o = 273.15$). - **When:** Lowering and metrology type checking execute. - **Then:** Expression is rejected with diagnostic `E0300` and assigns sentinel $``\bot_{\text{dim}}``$. - **Diagnostic:** `E0300` (Affine unit in multiplicative expression). */
        part def AC_03_Affine_Unit_Rejection {
        }
        doc /* - **Given:** Interface `Interface_Gamma` with Across $(1,1,-2,0,0,0,0)$ and Through $(0,0,1,0,0,0,0)$. - **When:** Evaluating power invariant ($``\mathbf{d}_e + \mathbf{d}_f \ne \mathbf{d}_{\text{Power}}``$). - **Then:** Lowering rejects definition with `E0301` and assigns sentinel $``\bot_{\text{pair}}``$. - **Diagnostic:** `E0301`. */
        part def AC_03_Conjugate_Power_Product_Violation_Rejection {
        }
        doc /* - **Given:** Operands `Term_1` (Force) and `Term_2` (Energy) with mismatched dimensions. - **When:** Lowering `Term_1 + Term_2` or `Term_1 < Term_2`. - **Then:** Rejection emits `E0300`, isolating mismatched length coordinate, and assigns sentinel $``\bot_{\text{dim}}``$. - **Diagnostic:** `E0300`. */
        part def AC_03_Incommensurable_Dimensional_Mismatch_Rejection {
        }
        doc /* - **Given:** Direct flow between conservative and non-conservative ports, and flow with $``\mathbf{d}_e+\mathbf{d}_f = (1,1,-2,0,0,0,0) \not\equiv \mathbf{d}_{\text{power}}``$. - **When:** Lowering checks flow compatibility. - **Then:** Rejection emits `E0300` and binds sentinel $``\bot_{\text{class}}``$. - **Diagnostic:** `E0300`. */
        part def AC_03_Incompatible_Hybrid_Connection_Rejection {
        }
        doc /* - **Given:** Envelope `Envelope_Beta` ($[100.0, 50.0]$) and parameter `Param_Z` with bounds $[L]^1$ vs $[T]^1$. - **When:** Lowering checks bound ordering and dimensions. - **Then:** Rejects declarations, emits `E0300`, binds $``\bot_{\text{env}}``$. - **Diagnostic:** `E0300` (InvalidOperationalEnvelopeBounds). */
        part def AC_03_Inverted_Bounds_Dimensional_Rejection {
        }
        doc /* - **Given:** Assembly `Assembly_Gamma` with passive dissipation $``P_{\text{dissipated}} = -50\text{ W}``$. - **When:** Static dissipation validation executes. - **Then:** Rejects assembly, binds sentinel $``\bot_{\text{power}}``$, emitting `E0301`. - **Diagnostic:** `E0301` (KirchhoffConservationViolation). */
        part def AC_03_Negative_Dissipation_Rejection {
        }
        doc /* - **Given:** Expression `sin(Quantity_Alpha)` where $``\mathbf{d}(\text{Quantity\_Alpha}) = [L]``$. - **When:** Metrology dimensional type checker evaluates argument dimension. - **Then:** Compiler detects $\mathbf{d} \ne \mathbf{0}$, halts lowering, binds sentinel $``\bot_{\text{dim}}``$, and emits `E0300`. - **Diagnostic:** `E0300`. */
        part def AC_03_Non_Dimensionless_Argument_Rejection {
        }
        doc /* - **Given:** Response $[2.0, 12.0]$ against envelope $[0.0, 10.0]$. - **When:** Containment checking executes. - **Then:** Upper breach ($12.0 \gt 10.0$) emits `E0301`. - **Diagnostic:** `E0301` (ToleranceEnvelopeViolation). */
        part def AC_03_Safety_Envelope_Breach_Rejection {
        }
        doc /* - **Given:** Branch with $``u_1=v_1``$ and isolated junction `Junction_Alpha` ($\text{deg}=0$). - **When:** Auditing incidence and degree invariants. - **Then:** Rejection emits `E0203` for self-loop and `E0220` for isolated junction. - **Diagnostic:** `E0203`, `E0220`. */
        part def AC_03_Self_Loop_and_Floating_Interface_Rejection {
        }
        doc /* - **Given:** Network `FlowNetwork_Alpha` with ungrounded junctions yielding $``\text{rank}(\mathbf{K}_{\text{red}})\lt n-1``$. - **When:** Conductance matrix factorization executes. - **Then:** Lowering halts, assigns sentinel $``\bot_{\text{flow}}``$, and emits `E0301`. - **Diagnostic:** `E0301`. */
        part def AC_03_Singular_Conductance_Matrix_Rejection {
        }
        doc /* - **Given:** Network `Network_Alpha` with 4 junctions and 5 branches in `Package_0`. - **When:** Constraint synthesis lowers topology. - **Then:** Matrix $\mathbf{A}$ lowers and $``\mathbf{A} \mathbf{f} = \mathbf{0}``$ synthesizes. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_03_Sparse_Incidence_Matrix_Continuity_Synthesis {
        }
        doc /* - **Given:** Expression `param_x : Real [DimVector_Alpha] + param_y : Real [DimVector_Beta]` with $``\mathbf{d}_{\alpha} \ne \mathbf{d}_{\beta}``$. - **When:** Dimensional type checking executes. - **Then:** Lowering halts evaluation, assigns sentinel $``\bot_{\text{dim}}``$, and emits `E0300`. - **Diagnostic:** `E0300` (DimensionalMismatch). */
        part def AC_03_Static_Incommensurability_Rejection {
        }
        doc /* - **Given:** Sum `Term_1 + Term_2` of interval quantities ($``o_1=o_2=5463/20``$) before valid statement. - **When:** Semantic validation and delimiter recovery execute. - **Then:** Rejection emits `E0300`, recovers on delimiter, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Affine_Interval_Addition_Rejection_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Invalid division `Expr_Fault = Factor_1 / 0.0` followed by `;` and valid `Expr_Beta = Factor_1 * Factor_2`. - **When:** Delimiter error recovery executes. - **Then:** Lowering emits `E0300`, binds sentinel $``\bot_{\text{dim}}``$, recovers on `;`, parses `Expr_Beta`, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Compile_Time_Division_by_Zero_Delimiter_Recovery {
        }
        doc /* - **Given:** Constant `Param_Const = 75.0` with envelope $[10.0, 50.0]$ before `;`, and disjoint ports $[10.0, 30.0]$, $[50.0, 80.0]$. - **When:** Containment and interconnect intersection validate. - **Then:** Emits `E0301`, recovers on `;`, emits `E0199` at $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0301`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Containment_Violation_Delimiter_Recovery {
        }
        doc /* - **Given:** Mismatched $[L]^1$ vs $[T]^1$ before `;`, followed by valid `Tolerance_Beta`. - **When:** Type checking and recovery execute. - **Then:** Emits `E0300`, binds $``\bot_{\text{dim}}``$, recovers on `;`, parses `Tolerance_Beta`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Dimension_Mismatch_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Assembly `Assembly_Delta` with mismatched port dimensions before delimiter `;` and valid `Assembly_Epsilon`. - **When:** Dimension checking and delimiter recovery execute. - **Then:** Emits `E0300`, binds $``\bot_{\text{dim}}``$, recovers on `;`, parsing `Assembly_Epsilon`, emitting `E0199` at $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Dimensional_Mismatch_and_Recovery {
        }
        doc /* - **Given:** Expression `Base_Alpha ^ (1 / 0)` before valid `Quantity_Beta = Base_Alpha ^ 2;`. - **When:** Validation and delimiter recovery execute. - **Then:** Rejection emits `E0300`, assigns sentinel $``\bot_{\text{dim}}``$, recovers on `;`, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Domain_Singularity_Delimiter_Recovery {
        }
        doc /* - **Given:** Malformed $``\operatorname{atan2}(E_y, E_x)``$ ($``\mathbf{d}(E_y) = [L], \mathbf{d}(E_x) = [T]``$) preceding valid `param_x : Real = cos(0.0);`. - **When:** Semantic validation and delimiter recovery execute. - **Then:** Compiler emits `E0300`, recovers on delimiter (`;`), verifies valid `cos` expression, and emits `E0199` at $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Incommensurable_Operands_Delimiter_Recovery {
        }
        doc /* - **Given:** Malformed `DimVector_Alpha` ($``q_i = 0``$) preceding valid `DimVector_Beta`. - **When:** Delimiter recovery executes. - **Then:** Ingestion emits `E0300`, recovers on delimiter, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Invalid_Denominator_Rejection_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Two non-conservative outputs directly driving one input without arbitration. - **When:** Lowering audits causal dependencies in $``\mathcal{G}_{\text{causal}}``$. - **Then:** Rejection emits `E0201` for multiple drivers on the receiver port. - **Diagnostic:** `E0201`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Multiple_Driver_Conflict_Rejection {
        }
        doc /* - **Given:** Cyclic network `FlowNetwork_Alpha` with cutoff $``\kappa_{\text{pivot}}=2``$ requiring 6 pivots, preceding `;` and valid `Classifier_Beta`. - **When:** Lemke solving exceeds cutoff ($``N_{\text{pivot}}\gt\kappa_{\text{pivot}}``$). - **Then:** Compiler records `E0399`, assigns $``\bot_{\text{lcp}}``$, recovers on `;`, parses `Classifier_Beta`, emitting `E0199` at $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0399`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Pivot_Iteration_Limit_Exceeded_Delimiter_Recovery {
        }
        doc /* - **Given:** Connection with mismatched effort dimensions before delimiter (`;`) and valid `Port_Gamma`. - **When:** Semantic validation and delimiter recovery execute. - **Then:** Rejection emits `E0300`, recovers on delimiter, parses `Port_Gamma`, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Port_Dimensional_Mismatch_Delimiter_Recovery {
        }
        doc /* - **Given:** Defective network ($\text{rank}(\mathbf{A})\lt n-p$) before delimiter (`;`) and valid `Network_Beta`. - **When:** Verifying solvability and executing recovery. - **Then:** Emits `E0301`, resynchronizes on `;`, parses `Network_Beta`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0301`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Rank_Deficiency_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Unbalanced static flow preceding delimiter (`;`) and valid flow. - **When:** Semantic evaluation executes with error recovery. - **Then:** Engine emits `E0301`, resynchronizes on delimiter, emitting `E0199` at $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0301`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Static_Conservation_Violation_Recovery {
        }
        doc /* - **Given:** Junction `Junction_Alpha` with flow imbalance (in: $10$, out: $8$) before delimiter `;` and valid `Junction_Beta`. - **When:** Balance checking and delimiter recovery execute. - **Then:** Emits `E0301`, resynchronizes on `;`, parsing `Junction_Beta`, emitting `E0199` at $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0301`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Static_Flow_Balance_Violation_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Denominator $q = 0$ or mismatched addition `param_x + param_y`. - **When:** Parsing and validation execute. - **Then:** Compiler emits `E0300`, assigns sentinel $``\bot_{\text{dim}}``$, recovers on delimiter (`;`), and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Static_Homogeneity_Delimiter_Recovery {
        }
        doc /* - **Given:** Loop `Loop_Beta` with static imbalance $\sum \Delta e = 1.0 \ne 0$ before `;` and valid `Loop_Gamma`. - **When:** Balance checking and delimiter recovery execute. - **Then:** Emits `E0301`, resynchronizes on `;`, parses `Loop_Gamma`, emitting `E0199` at $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0301`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Static_Imbalance_Delimiter_Recovery {
        }
        doc /* The metrology engine SHALL model physical dimensions as vector space $(\mathbb{Q}^7,+,\cdot)$ over $\mathbb{Q}$. Canonical basis $``\mathcal{B}_{\text{SI}} = \{\mathbf{e}_M, \dots, \mathbf{e}_J\}``$ maps bijectively to the 7 SI base quantities ($M, L, T, I, \Theta, N, J$). Metamodel lowering MUST enforce: 1. **Irreducible Coordinates**: Every dimension $\mathbf{d} \in \mathbb{Q}^7$ is a tuple $(\alpha,\beta,\gamma,\delta,\epsilon,\zeta,\eta)$ with $``d_i = \frac{p_i}{q_i}``$ ($``\gcd(|p_i|,q_i)=1, q_i \in \mathbb{Z}^+``$). Zero vector $\mathbf{0}$ models dimensionless scalars. 2. **Homomorphisms**: $``\mathbf{d}(Q_1 \cdot Q_2) = \mathbf{d}(Q_1) + \mathbf{d}(Q_2)``$, $``\mathbf{d}(Q_1 / Q_2) = \mathbf{d}(Q_1) - \mathbf{d}(Q_2)``$, $\mathbf{d}(Q^k) = k \cdot \mathbf{d}(Q)$ ($k \in \mathbb{Q}$). 3. **Exact Arithmetic**: Operations use checked 64-bit rationals. Divisors $q = 0$ or overflow emit `E0300`. 4. **Homogeneity**: Operations ($A \pm B$, $A == B$, $A \bowtie B$) require $\mathbf{d}(A) = \mathbf{d}(B)$; mismatches emit `E0300`. --- */
        part def _1_Normative_Statement {
        }
        doc /* Canonical basis, vector homomorphisms, homogeneity predicates, and diagnostic emission rules: \begin{aligned} \mathcal{B}_{\text{SI}} &= \{\mathbf{e}_M, \dots, \mathbf{e}_J\} \subset \mathbb{Q}^7,\; \mathbf{d} = \sum_{i=1}^7 d_i \mathbf{e}_i,\; d_i = \frac{p_i}{q_i},\; \gcd(|p_i|, q_i) = 1 \\ \mathbf{d}(Q_1 \cdot Q_2) &= \mathbf{d}(Q_1) + \mathbf{d}(Q_2),\; \mathbf{d}(Q_1 / Q_2) = \mathbf{d}(Q_1) - \mathbf{d}(Q_2),\; \mathbf{d}(Q^k) = k \cdot \mathbf{d}(Q) \\ \Phi_{\text{homogenous}} &\iff \mathbf{d}(A) = \mathbf{d}(B),\; \neg \Phi \wedge (A \pm B \vee A \bowtie B) \implies \text{Diagnostic}(n, \text{E0300}) \\ q_i \le 0 &\implies \text{Diagnostic}(D, \text{E0300}),\; |\mathcal{D}_{\text{sink}}| \ge C_{\text{max\_errors}} \implies \text{Diagnostic}(D_{\text{term}}, \text{E0199}) \\ \Delta_D &= \text{UUIDv5}(\text{NS}_{\text{DEAP}}, \text{FQN}(D)) \end{aligned} --- */
        part def _2_Formal_Invariant {
            attribute mathcal_mathbf : String = "Canonical SI basis and coordinate vector in $\mathbb{Q}^7$";
            attribute d_i_frac : String = "Irreducible rational coordinate with $``\gcd(";
            attribute Phi : String = "Predicate asserting equality $\mathbf{d}(A) = \mathbf{d}(B)$";
            attribute Delta_D_mathcal : String = "Deterministic UUIDv5 and diagnostic sink buffer";
        }
        doc /* - **Complexity Class:** $\mathbf{P}$ (Deterministic Polynomial) - **Asymptotic Bound:** $O(1)$ vector arithmetic; aggregate lowering is $O(N + D)$. - **Tractable Subclass & Frontier:** Tractable vector space $(\mathbb{Q}^7, +, \cdot)$ checks equality in $O(1)$ (NP-3). Work-stealing scales as $``O((N + D) / N_{\text{max\_workers}} + \log N_{\text{max\_workers}})``$. --- */
        part def _3_Computational_Complexity_Algorithmic_Bounds {
        }
        part def _4_Verification_Conformance_Criteria {
        }
    }
    doc /* Spatio-Temporal Dynamics & Discrete State Machine Solvers */
    package Subsystem_6_Spatio_Temporal_State_Solvers {
        doc /* UUIDv5: 3543c7aa-6407-54f2-a3e2-c415220715bb | Complexity: Class P (O(1) check, O(N) lowering) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 | Diagnostics: E0199, E0400, E0401 */
        requirement def REQ_0114_Spatio_Temporal_Occurrence_Lifecycles {
            id = "REQ-0114";
            text = "The dynamics solver SHALL assign interval bounds [t_{start}, t_{end}] \subset \mathbb{R} \cup \{-\infty, +\infty\} to lifecycles, actions, and states referenced to epoch t_{epoch} = 0.";
            satisfy by StateMachineSolverEngine;
        }
        doc /* UUIDv5: 641d5da6-0911-5d4f-a90f-dd1f1f93d23e | Complexity: Class P (O(1) per relation check, O(N^2) pairwise) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 | Diagnostics: E0199, E0400, E0401 */
        requirement def REQ_0115_Allen_s_13_Qualitative_Interval_Relations_Axiomatic_Algebraic_Solver {
            id = "REQ-0115";
            text = "The dynamics solver SHALL implement an axiomatic solver for Allen's 13 qualitative interval relations over occurrences, actions, and states.";
            satisfy by StateMachineSolverEngine;
        }
        doc /* UUIDv5: 00edf301-60ee-5d3d-85d3-6b21e495fc65 | Complexity: Class P (O(1) table lookup, O(N^3) path consistency) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Allen Interval Algebra | Diagnostics: E0199, E0400, E0401 */
        requirement def REQ_0116_Temporal_Relation_Composition_Table {
            id = "REQ-0116";
            text = "The dynamics solver SHALL perform path consistency constraint propagation using Allen's 13 \times 13 composition table, verifying qualitative temporal constraints.";
            satisfy by StateMachineSolverEngine;
        }
        doc /* UUIDv5: a5f8e352-0833-5200-a575-76a65a0c02d1 | Complexity: Class NP-complete} / Class P (O(N^3) for H_{ORD}) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Nebel & Bürckert (1995) | Diagnostics: E0199, E0400, E0406 */
        requirement def REQ_0117_Allen_s_Interval_Algebra_Temporal_Consistency {
            id = "REQ-0117";
            text = "The temporal solver SHALL enforce consistency over lifecycles and interval constraints.";
            satisfy by StateMachineSolverEngine;
        }
        doc /* UUIDv5: 0cf37885-69d7-51ea-9ff9-3ab9b0c9ea3d | Complexity: Class P (O(V + E) topological sort / Tarjan SCC) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 / KerML | Diagnostics: E0199, E0400, E0403 */
        requirement def REQ_0118_Directed_Causal_Precedence_DAG_Construction {
            id = "REQ-0118";
            text = "The dynamics solver SHALL construct directed causal precedence graph G_{prec} = (V, E) across action executions, behavioral steps, and state transitions, asserting acyclicity to guarantee deadlock-free execution.";
            satisfy by StateMachineSolverEngine;
        }
        doc /* UUIDv5: 9967ca70-d75e-53ca-aae1-e07ec6023403 | Complexity: Class P (O(V + E) DAG execution lowering) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 | Diagnostics: E0199, E0400, E0404 */
        requirement def REQ_0119_Action_Step_Sequence_Execution_Semantics {
            id = "REQ-0119";
            text = "The dynamics engine SHALL lower action sequences, fork nodes, and join nodes into execution DAGs, verifying precedence, barrier synchronization, and data-race freedom.";
            satisfy by StateMachineSolverEngine;
        }
        doc /* UUIDv5: cb960479-dda3-5a5b-9b29-485b9097cc10 | Complexity: Class P (O(D) state hierarchy traversal, O(M) orthogonal region check) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 / KerML | Diagnostics: E0199, E0402, E0405 */
        requirement def REQ_0120_Hierarchical_State_Machine_Containment {
            id = "REQ-0120";
            text = "The state machine solver SHALL validate and lower hierarchical statecharts and orthogonal regions into active configurations.";
            satisfy by StateMachineSolverEngine;
        }
        doc /* UUIDv5: 04751a64-acaa-5a57-b311-f1ceb3c9881d | Complexity: Class P (O(1) event dequeue, O(T) RTC step lowering) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 / KerML | Diagnostics: E0199, E0400, E0402 */
        requirement def REQ_0121_State_Transition_Trigger_Event_Dispatching {
            id = "REQ-0121";
            text = "The state machine solver SHALL validate and lower discrete event dispatching under Run-to-Completion (RTC) semantics with a bounded FIFO event queue.";
            satisfy by StateMachineSolverEngine;
        }
        doc /* UUIDv5: 4aac8fa3-b145-5d59-a81f-55b7b01eb9ea | Complexity: Class NP-complete} (SMT) / Tractable Fragment Class P (Syntactic) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 / KerML | Diagnostics: E0199, E0400, E0402 */
        requirement def REQ_0122_Deterministic_Transition_Guard_Disjointness_Verification {
            id = "REQ-0122";
            text = "The compiler SHALL verify that outgoing transitions from any state on identical events have mutually disjoint guards (G_1 \wedge G_2 \equiv false), ensuring determinism.";
            satisfy by StateMachineSolverEngine;
        }
        doc /* UUIDv5: 4754f095-d084-5a08-bf16-5232a31b1f90 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 | Diagnostics: E0199, E0400, E0403 */
        requirement def REQ_0123_Complete_State_Machine_Reachability_Analysis {
            id = "REQ-0123";
            text = "The solver SHALL analyze state machine reachability, diagnosing dead states, unreachable transitions, and trap states.";
            satisfy by StateMachineSolverEngine;
        }
        doc /* UUIDv5: d67ee888-8533-5926-877a-16ee4a93743c | Complexity: Class PSPACE-complete} / NP-complete} (BMC depth k) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 | Diagnostics: E0199, E0400, E0406 */
        requirement def REQ_0124_Discrete_State_Machine_Reachability_Deadlock {
            id = "REQ-0124";
            text = "The solver SHALL verify reachability, deadlock freedom, and livelock absence across K \ge 2 orthogonal regions via Bounded Model Checking (BMC).";
            satisfy by StateMachineSolverEngine;
        }
        doc /* UUIDv5: 3a899b03-86b6-5a93-a5fd-061331fe2a91 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 / KerML | Diagnostics: E0199, E0400, E0410 */
        requirement def REQ_0125_Failsafe_Fallback_Transitions {
            id = "REQ-0125";
            text = "The state machine solver SHALL validate failsafe fallback transitions, priority preemptive evacuation, and absorbing safe states across discrete statecharts.";
            satisfy by StateMachineSolverEngine;
        }
        doc /* UUIDv5: 4816be6a-f42d-5f14-8b49-6a7ed290c5a6 | Complexity: Class P (O(D) tree configuration snapshot and restoration) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 / KerML | Diagnostics: E0199, E0400, E0411 */
        requirement def REQ_0126_State_History_Pseudostates_Shallow {
            id = "REQ-0126";
            text = "The state machine solver SHALL validate and execute Shallow History ([H]) and Deep History ([H*]) restoration semantics.";
            satisfy by StateMachineSolverEngine;
        }
        doc /* UUIDv5: 86365281-8ea9-5024-994b-72134612c093 | Complexity: Class P (O(m \cdot D) trace step generation) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 | Diagnostics: E0199, E0400, E0402 */
        requirement def REQ_0127_State_Machine_Simulation_Stepper {
            id = "REQ-0127";
            text = "The dynamics engine SHALL provide a deterministic stepper (SimulationStepper_Alpha) and trace logger (TraceLog_1) stepping statecharts against event traces.";
            satisfy by StateMachineSolverEngine;
        }
        doc /* Primary execution engine for Spatio-Temporal Dynamics & Discrete State Machine Solvers */
        part def StateMachineSolverEngine {
            port in ast_in : ASTGraphPort;
            port out state_out : StateSolverPort;
        }
        doc /* - **Given:** `Interval_Alpha` $= [10.0, 20.0]$, `Interval_Beta` $= [20.0, 30.0]$. - **When:** Evaluating endpoint ordering ($``x_e = y_s``$). - **Then:** Classifies atomic `meets` ($\mathbf{m}$), lowering difference inequalities. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Atomic_Relation_Classification {
        }
        doc /* - **Given:** `CompositeState_Alpha` with 2 regions (3 states each), target reachable at $k = 3$ ($``k_{\text{max}} = 10``$). - **When:** Unrolling transitions into $``\Phi_k``$ and solving SAT. - **Then:** Returns SAT at $k = 3$, extracting witness $``\langle s_0, s_1, s_2, s_3 \rangle``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_BMC_Unrolling_Reachability_Witness {
        }
        doc /* - **Given:** `StateMachine_Alpha` with initial `State_0` reaching `State_1`, `State_2` cyclically. - **When:** Reachability executes fixed-point BFS traversal. - **Then:** Computes $``\mathcal{R} = \{\text{State\_0}, \text{State\_1}, \text{State\_2}\}``$, with $``\mathcal{D}_{\text{dead}} = \emptyset``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Reachability_Convergence {
        }
        doc /* - **Given:** `Package_0` declaring `SimulationStepper_Alpha` stepping `State_Alpha` $\to$ `State_Beta` $\to$ `State_Gamma`. - **When:** Stepper processes event sequence $``\vec{e} = \langle \text{Event\_0}, \text{Event\_1} \rangle``$. - **Then:** Completes 2 macro-steps, emitting `TraceLog_1` with exact configurations and `Status::Success`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Stepping_Trace_Generation {
        }
        doc /* - **Given:** Asserted $``X_1 \mathbf{b} X_2``$ (`before`) and $``X_2 \mathbf{b} X_3``$ in `TemporalNetwork_Alpha`. - **When:** Path consistency executes. - **Then:** Refines $``\mathbf{M}[X_1, X_3]``$ from $\mathbf{U} = 0\text{x}1\text{FFF}$ to $\{ \mathbf{b} \} = 0\text{x}0001$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Direct_Transitive_Deduction {
        }
        doc /* - **Given:** `State_Nominal_Alpha` in `State_Super_0`, `State_Safe_Omega`, and fallback `Transition_Failsafe_1` from `State_Super_0` ($\pi = 100, g \equiv \text{true}$). - **When:** Validating fallback coverage and transition priorities. - **Then:** Certifies inherited coverage, preempting nominal transitions ($\pi = 10 \lt 100$). - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Direct_and_Hierarchical_Fallback_Evacuation {
        }
        doc /* - **Given:** `State_Alpha` with `Transition_Alpha` (`param_x < 0.0`) and `Transition_Beta` (`param_x >= 0.0`) on `Event_0`. - **When:** Lowering verifies guard disjointness. - **Then:** Disjointness is certified via interval checks. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Disjoint_Guard_Verification_Happy_Path {
        }
        doc /* - **Given:** `EventQueue_1` with $``\langle\text{Event\_Signal1},\text{Event\_Call1}\rangle``$ in `State_Alpha`. - **When:** Dequeuing `Event_Signal1` fires `Transition_1` to `State_Beta`. - **Then:** Actions terminate; $``C'=\{\text{State\_Beta}\}``$ settles before next dequeue. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_FIFO_Dequeue_RTC_Transition_Firing {
        }
        doc /* - **Given:** `CompositeState_1` with children `State_Alpha`, `State_Beta`, activating `State_Alpha`. - **When:** Lowering validates tree hierarchy and active states. - **Then:** Verifies ancestor closure and XOR singularity ($|C \cap \mathcal{C}| = 1$). - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Hierarchical_Tree_Active_Configuration {
        }
        doc /* - **Given:** Model `Package_0` with 15 occurrences constrained by $``\mathcal{H}_{\text{ORD}}``$ relations. - **When:** Path consistency propagation executes. - **Then:** Computes fixed point in $O(N^3)$ operations. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Pure_ORD_Horn_Consistent_Network_Propagation {
        }
        doc /* - **Given:** Steps `Step_Alpha`, `Step_Beta` with $``t_{\text{end}} = t_{\text{start}} = 10.0``$. - **When:** Lowering constructs DAG $``G_{\text{exec}}``$ and verifies precedence. - **Then:** Validates $``t_{\text{end}} \le t_{\text{start}}``$ without diagnostic errors. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Sequential_Precedence_Lowering {
        }
        doc /* - **Given:** `CompositeState_Alpha` with `State_Sub_0`, `State_Sub_1`, and `History_Shallow` defaulting to `State_Sub_0`. - **When:** `State_Sub_1` active, `CompositeState_Alpha` exits and re-enters on `History_Shallow`. - **Then:** Restores `State_Sub_1` without evaluating `State_Sub_0`. - **Diagnostic:** Diagnostic sink empty. */
        part def AC_01_Shallow_History_Restoration {
        }
        doc /* - **Given:** Valid `Package_0` declaring sequential actions `Action_1`, `Action_2`, `Action_3` with intervals $[0.0, 10.0]$, $[10.0, 20.0]$, $[20.0, 30.0]$. - **When:** Lowering constructs $``G_{\text{prec}}``$, verifies acyclicity via Tarjan SCC, and synthesizes topological order $\mathcal{L}$. - **Then:** Verifies strict acyclicity, emitting schedule $``\langle \text{Action\_1}, \text{Action\_2}, \text{Action\_3} \rangle``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Valid_Acyclic_Pipeline_Precedence_and_Linearization {
        }
        doc /* - **Given:** `Occurrence_Alpha` ($[0.0, 10.0]$) and event `Event_0` ($[5.0, 5.0]$) in `Package_0`. - **When:** Lowering assigns interval bounds. - **Then:** Assigns durations $10.0 \gt 0$ and $0.0$; diagnostic sink remains empty. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Valid_Occurrence_Lifecycle_and_Interval_Lowering {
        }
        doc /* - **Given:** Relations $``R_1 = \{ \mathbf{b}, \mathbf{m} \}``$, $``R_2 = \{ \mathbf{m}, \mathbf{o} \}``$ on `(Interval_X, Interval_Y)`. - **When:** Evaluating bitmask operations. - **Then:** Computes $``R_1 \cap R_2 = \{ \mathbf{m} \}``$ (`0x0004`), $``(R_1)^\smile = \{ \mathbf{bi}, \mathbf{mi} \}``$ (`0x000A`). - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Bitmask_Algebraic_Inversion_and_Conjunction {
        }
        doc /* - **Given:** `State_Composite_1` with initial `State_Sub_0` chained through 1,024 states. - **When:** Reachability marks the bitset and traverses composite containment. - **Then:** All 1,024 states are marked reachable; zero dead states reported. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Bitset_Marking_Hierarchical_Propagation {
        }
        doc /* - **Given:** `CompositeState_Alpha` requiring 60 steps ($``k_{\text{max}} = 50``$), with `Region_1` active and `Region_2` stuttering. - **When:** Unrolling reaches horizon $``k_{\text{max}}``$. - **Then:** Halts at depth 50, asserting $``\mathbf{x}_2^{(t+1)} = \mathbf{x}_2^{(t)}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Bounded_Horizon_Cutoff_Stuttering {
        }
        doc /* - **Given:** Consistent network of $N = 10$ intervals converged to $\mathbf{M}^*$. - **When:** Verifying symmetry and re-executing propagation on $\mathbf{M}^*$. - **Then:** All $\mathbf{M}^*[j, i] \equiv (\mathbf{M}^*[i, j])^\smile$, queue $|Q| = 0$, with zero mutations. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Converse_Symmetry_and_Fixed_Point_Idempotency {
        }
        doc /* - **Given:** `CompositeState_Alpha` with child `CompositeState_Beta`, active leaf `State_Leaf_A2`, and `History_Deep`. - **When:** `CompositeState_Alpha` exits and re-enters on `History_Deep`. - **Then:** Restores `CompositeState_Beta` and `State_Leaf_A2` in $O(D)$ time without initial transitions. - **Diagnostic:** Diagnostic sink empty. */
        part def AC_02_Deep_History_Subtree_Restoration {
        }
        doc /* - **Given:** Diamond DAG `PrecedenceGraph_Alpha` where `Action_1` precedes `Action_2` and `Action_3`, both preceding `Action_4`. - **When:** Kahn topological linearization dequeues candidate ready vertices. - **Then:** Dequeues `Action_2` before `Action_3` via FQN byte order, yielding reproducible schedules across permuted runs. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Deterministic_Lexicographical_Ready_Queue_Tie_Breaking {
        }
        doc /* - **Given:** Fork `ForkNode_1` ($k = 3$) with paths `Path_Alpha`, `Path_Beta`, `Path_Gamma` (durations $10.0, 25.0, 15.0$) meeting at `JoinNode_1`. - **When:** Evaluating barrier synchronization and token conservation. - **Then:** Computes $``t_{\text{start}}(\text{JoinNode\_1}) = 25.0``$ and $``\Delta\text{Tokens}_{\text{net}} = 0``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Fork_Join_Concurrency_and_Barrier_Timing {
        }
        doc /* - **Given:** Composite `State_Comp_0` with `State_Child_0`, stepping from `State_Alpha` to `State_Gamma`. - **When:** Stepping transitions across composite boundaries. - **Then:** `TraceLog_1` logs top-down entry and bottom-up exit, maintaining ancestor closure. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Hierarchical_LCA_Exit_Entry_Action_Ordering {
        }
        doc /* - **Given:** `Occurrence_1` ($[15.0, 10.0]$) and `Occurrence_2` ($[-5.0, 10.0]$). - **When:** Lowering checks interval bounds. - **Then:** Rejects coordinates, binding $``\bot_{\text{interval}}``$ and emitting `E0400`. - **Diagnostic:** `E0400` (TemporalIntervalInverted / NegativeEpochTime). */
        part def AC_02_Inverted_Bounds_and_Negative_Epoch_Rejection {
        }
        doc /* - **Given:** Sibling `Transition_Alpha` (`param_x >= 10.0`) and `Transition_Beta` (`param_x <= 20.0`) on `Event_0`. - **When:** SMT solver evaluates $``\overline{G}_1 \land \overline{G}_2``$. - **Then:** Conjunction is satisfiable (`param_x = 15.0`), emitting `E0400` with counterexample. - **Diagnostic:** `E0400` (NonDisjointTransitionGuards). */
        part def AC_02_Non_Disjoint_Transition_Guard_Rejection {
        }
        doc /* - **Given:** `ParallelState_Omega` with regions `Region_1`, `Region_2`, activating leaves in both. - **When:** Validating region multiplicity, disjointness, and concurrency. - **Then:** Confirms $m = 2 \ge 2$, disjoint sets, and $``|C \cap \text{Leaves}(R_i)| = 1``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Orthogonal_Concurrency_Region_Disjointness {
        }
        doc /* - **Given:** Occurrences `Occurrence_Alpha`, `Occurrence_Beta`, and `Occurrence_Gamma` with cyclic `before` relations. - **When:** Path consistency evaluates triangular compositions. - **Then:** Derives empty relation $R = \emptyset$, binds $``\bot_{\text{net}}``$, emitting `E0400`. - **Diagnostic:** `E0400`. */
        part def AC_02_Pure_ORD_Horn_Contradiction_Rejection {
        }
        doc /* - **Given:** Active RTC step in `StateMachine_Alpha` with full queue ($|Q|=65536$). - **When:** Event arrives during step, followed by overflow enqueue. - **Then:** Buffers event at tail without preemption; overflow emits `E0400`. - **Diagnostic:** `E0400` (EventQueueOverflow). */
        part def AC_02_RTC_Non_Interruptibility_Queue_Overflow {
        }
        doc /* - **Given:** Operational states `State_Operational_0`, `State_Operational_1` targeting `State_Safe_Omega`, with exit on `Event_Reset`. - **When:** Validating reachability and absorbing boundaries. - **Then:** Reverse BFS confirms reachability in $O(V + E)$ time; verifies no spontaneous ($\epsilon$) or nominal exits. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Safe_State_Reachability_and_Absorbing_Boundary {
        }
        doc /* - **Given:** Hierarchy cycle `State_Alpha` $\sqsubset$ `State_Beta` $\sqsubset$ `State_Alpha`, or active leaf without parent. - **When:** Checking containment acyclicity and ancestor closure. - **Then:** Rejects cycle or missing ancestor, emits `E0402`, and binds $``\bot_{\text{state}}``$. - **Diagnostic:** `E0402` (StateHierarchyContainmentViolation). */
        part def AC_03_Containment_Acyclicity_Ancestor_Closure_Rejection {
        }
        doc /* - **Given:** `StateMachine_Alpha` with reachable `State_0`, isolated `State_Dead_1`, and island `State_Dead_2` $\to$ `State_Dead_3`. - **When:** Reachability evaluates $``\mathcal{D}_{\text{dead}} = \mathcal{S} \setminus \mathcal{R}``$. - **Then:** Rejects compilation, diagnosing `State_Dead_1`, `State_Dead_2`, `State_Dead_3` as dead. - **Diagnostic:** `E0400` (DeadStateDetected). */
        part def AC_03_Dead_State_Island_Rejection {
        }
        doc /* - **Given:** Model where `Region_1` and `Region_2` enter deadlocks or non-progress cycles. - **When:** Evaluating $``\Phi_k``$ with safety violation $``\neg \text{Safe}(s_k)``$. - **Then:** Detects SAT at $``k \le k_{\text{max}}``$, emits `E0400`, binding trace to $``\bot_{\text{trace}}``$. - **Diagnostic:** `E0400` (OrthogonalStateDeadlockDetected). */
        part def AC_03_Deadlock_and_Livelock_Rejection {
        }
        doc /* - **Given:** `CompositeState_Alpha` with `History_Shallow` and uninitialized history ($\mathcal{H} = \emptyset$). - **When:** Transition targets `History_Shallow`. - **Then:** Fires $``T_{\text{default}}``$, activating `State_Sub_0` in zero time ($\Delta t = 0$). - **Diagnostic:** Diagnostic sink empty. */
        part def AC_03_Default_Transition_Execution {
        }
        doc /* - **Given:** `ForkNode_1` with out-degree 1, or cycle $``\text{Step\_Alpha} \to \text{Step\_Beta} \to \text{Step\_Alpha}``$. - **When:** Validating degrees and acyclicity via Kahn's sort. - **Then:** Rejects invalid degrees and cycles, emitting `E0400`. - **Diagnostic:** `E0400` (MalformedControlNode). */
        part def AC_03_Degree_Malformation_and_Cycle_Rejection {
        }
        doc /* - **Given:** Malformed model declaring mutual cycle `Action_1` $\prec$ `Action_2` and `Action_2` $\prec$ `Action_1`. - **When:** Tarjan SCC decomposition audits $``G_{\text{prec}}``$. - **Then:** Isolates component $|C| = 2$, reconstructs traceback $``\langle \text{Action\_1}, \text{Action\_2}, \text{Action\_1} \rangle``$, and emits `E0400`. - **Diagnostic:** `E0400` (CausalPrecedenceCycleDetected). */
        part def AC_03_Directed_Causal_Cycle_Rejection_and_Traceback {
        }
        doc /* - **Given:** `Action_Alpha` ($[0.0, 10.0]$, $``\delta_{\text{nom}} = 12.0``$) and `Action_Beta` ($[0.0, 8.0]$, envelope $[1.0, 5.0]$). - **When:** Verifying duration consistency. - **Then:** Nominal error and envelope breach emit `E0400`. - **Diagnostic:** `E0400` (DurationBoundsInconsistency / DurationEnvelopeBreach). */
        part def AC_03_Duration_Parameter_Consistency_and_Envelope_Breach {
        }
        doc /* - **Given:** Network `Network_Beta` with non-ORD-Horn constraints ($``R \notin \mathcal{H}_{\text{ORD}}``$). - **When:** Compiling to QF_RDL and solving via SMT. - **Then:** Proves satisfiability within $``\kappa_{\text{temporal}}``$ steps. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_03_General_Temporal_Network_SMT_Satisfiability {
        }
        doc /* - **Given:** Invalid guard (`param_x / 0.0 > 1.0`) or cyclic $\epsilon$-transitions. - **When:** Evaluating candidate guards or completion micro-steps. - **Then:** Traps fault or limit $``\kappa_{\text{micro}} > \kappa_{\text{micro\_max}}``$, emitting `E0400` and binding $``\bot_{\text{step}}``$. - **Diagnostic:** `E0400` (SimulationGuardEvaluationFault). */
        part def AC_03_Guard_Evaluation_Fault_Micro_Step_Limit_Rejection {
        }
        doc /* - **Given:** `Interval_X` with $``x_s = 25.0 \gt x_e = 15.0``$, and assertion `equals` on $[0, 5]$ and $[10, 15]$. - **When:** Validating interval constraints. - **Then:** Inverted endpoints and relation conflict ($[0,5] \mathbf{b} [10,15] \ne \mathbf{eq}$) emit `E0400`. - **Diagnostic:** `E0400`. */
        part def AC_03_Inverted_Interval_and_Relation_Contradiction {
        }
        doc /* - **Given:** Circular triad $``X_1 \mathbf{b} X_2``$, $``X_2 \mathbf{b} X_3``$, and $``X_3 \mathbf{b} X_1``$. - **When:** Propagation intersects deduced $``X_1 \mathbf{b} X_3``$ with $``(X_3 \mathbf{b} X_1)^\smile = \mathbf{bi}``$. - **Then:** Intersection yields $\emptyset$, rejecting with `E0400`. - **Diagnostic:** `E0400` (PathConsistencyViolation). */
        part def AC_03_Latent_Conflict_Rejection {
        }
        doc /* - **Given:** `State_Operational_0` lacking fallback for `Event_Fault_Critical`, or `State_Safe_Omega` with spontaneous exit. - **When:** Auditing fallback completeness and absorbing boundaries. - **Then:** Rejects model, emits `E0400`, and binds sentinel $``\bot_{\text{failsafe}}``$. - **Diagnostic:** `E0400` (MissingFailsafeTransition or SpontaneousSafeStateExit). */
        part def AC_03_Missing_Fallback_and_Isolation_Rejection {
        }
        doc /* - **Given:** Guard conjunction requiring steps exceeding budget $``\kappa_{\text{smt}} = 100{,}000``$. - **When:** SMT solver executes. - **Then:** Halts deterministically without panicking, emitting `E0400`. - **Diagnostic:** `E0400` (GuardSolverStepLimitExceeded). */
        part def AC_03_Solver_Step_Limit_Bound_Enforcement {
        }
        doc /* - **Given:** Transition expecting `param_x : Real` with payload mismatch, or overlapping sibling guards. - **When:** Type checking and conflict analysis execute. - **Then:** Rejects payload mismatch or ambiguous guard overlap with `E0400`. - **Diagnostic:** `E0400` (MalformedTriggerOrConflict). */
        part def AC_03_Trigger_Payload_Mismatch_Ambiguous_Guards {
        }
        doc /* - **Given:** Branches `Path_Alpha` and `Path_Beta` mutating `param_x : Real` before `;`, followed by `Step_Gamma`. - **When:** Checking Bernstein conditions and recovery. - **Then:** Emits `E0404`, recovers on `;`, parses `Step_Gamma`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0404`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Bernstein_Race_Hazard_and_Delimiter_Recovery {
        }
        doc /* - **Given:** `StateMachine_Alpha` with false guard ($``g_\tau \equiv \text{false}``$) and trap `State_Trap_1` before `;`, followed by `StateMachine_Beta`. - **When:** Reachability and delimiter recovery execute. - **Then:** Emits `E0403`, binds $``\bot_{\text{trans}}``$, recovers on `;`, validating `StateMachine_Beta`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0403`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Dead_Transition_Trap_Delimiter_Recovery {
        }
        doc /* - **Given:** Degenerate parallel state ($m = 1$) before `;`, followed by an unsynchronized cross-region transition. - **When:** Semantic validation and delimiter recovery execute. - **Then:** Emits `E0405`, binds $``\bot_{\text{region}}``$, recovers on `;`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0405`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Degenerate_Region_Cross_Region_Recovery {
        }
        doc /* - **Given:** Conflicting assertions `Interval_A meets Interval_B` and `Interval_B before Interval_A`. - **When:** Checking intersection and error recovery. - **Then:** Detects $R \cap (R')^\smile = \emptyset$, emits `E0401`, binds $``\bot_{\text{rel}}``$, recovers on `;`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0401`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Disjoint_Relation_Conflict_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Parent $[10.0, 50.0]$ with child $[5.0, 60.0]$, and exclusive states overlapping on $[10.0, 12.0]$. - **When:** Containment and state continuity checks execute. - **Then:** Breaches emit `E0401`, binding sentinel $``\bot_{\text{occ}}``$. - **Diagnostic:** `E0401` (TemporalContainmentBreach / StateOccupancyOverlap). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Hierarchical_Containment_Breach_and_State_Overlap {
        }
        doc /* - **Given:** Transition violating containment before `;`, followed by a valid transition. - **When:** Containment checking and delimiter recovery execute. - **Then:** Emits `E0402`, binds $``\bot_{\text{trans}}``$, recovers on `;`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0402`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Hierarchy_Containment_Fault_Recovery {
        }
        doc /* - **Given:** Active configuration violating XOR singularity before `;`, followed by a valid step. - **When:** Validating configurations and performing delimiter recovery. - **Then:** Emits `E0402`, binds $``\bot_{\text{state}}``$, recovers on `;`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0402`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Hierarchy_Containment_Violation_Delimiter_Recovery {
        }
        doc /* - **Given:** Guard `param_x * param_y > 1.0` before `;`, then valid transition. - **When:** Admissibility checking and recovery execute. - **Then:** Emits `E0402`, binds $``\bot_{\text{guard}}``$, recovers on `;`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0402`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Non_Admissible_Theory_Delimiter_Recovery {
        }
        doc /* - **Given:** Failsafe transition with guard `param_x > 0.0` or priority $``\pi = 5 \le \pi_{\text{nominal}} = 10``$ before `;`, followed by a valid state. - **When:** Evaluating semantic rules and delimiter recovery. - **Then:** Emits `E0410`, binds sentinel $``\bot_{\text{trans}}``$, recovers on `;`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0410`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Priority_Inversion_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Invalid $``X_1 \mathbf{b} X_1``$ before `;`, then valid `TemporalNetwork_Beta`. - **When:** Lowering and constraint ingestion execute. - **Then:** Emits `E0401`, binds $``\bot_{\text{tcn}}``$, recovers at `;`, parsing `TemporalNetwork_Beta`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0401`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Reflexive_Contradiction_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Network exceeding budget $``\kappa_{\text{temporal}} = 50``$ before `;`, followed by `Occurrence_Delta`. - **When:** SMT solver hits step limit and recovers. - **Then:** Emits `E0406`, recovers on `;`, parses `Occurrence_Delta`, emitting `E0199` at $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0406`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_SMT_Step_Budget_Exceeded_Delimiter_Recovery {
        }
        doc /* - **Given:** Model exceeding budget $``\kappa_{\text{steps}} = 100``$ before delimiter (`;`), followed by `CompositeState_Beta`. - **When:** Step count exceeds budget ($``N_{\text{step}} \gt \kappa_{\text{steps}}``$). - **Then:** Emits `E0406`, binds $``\bot_{\text{state}}``$, recovers on `;`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0406`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Step_Budget_Cutoff_Recovery {
        }
        doc /* - **Given:** History at root $``s_{\text{root}}``$, duplicate history, and external target, delimited by `;`. - **When:** Validation passes execute. - **Then:** Rejects root/duplicate with `E0400`, rejects external target with `E0411`, recovering on `;` with `E0199`. - **Diagnostic:** `E0400`, `E0411`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Structural_Malformation_Rejection {
        }
        doc /* - **Given:** Invalid dependency `Action_1` $``\prec_{\text{seq}}``$ `Action_2` with intervals $[10.0, 20.0]$ and $[5.0, 15.0]$ before delimiter (`;`), followed by valid `PrecedenceGraph_Beta`. - **When:** Lowering checks interval ordering and triggers delimiter recovery. - **Then:** Emits `E0403`, binds $``\bot_{\text{prec}}``$, recovers on `;`, parses `PrecedenceGraph_Beta`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0403`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Temporal_Ordering_Inversion_and_Delimiter_Recovery {
        }
        doc /* The dynamics solver SHALL assign interval bounds $``[t_{\text{start}}, t_{\text{end}}] \subset \mathbb{R} \cup \{-\infty, +\infty\}``$ to lifecycles, actions, and states referenced to epoch $``t_{\text{epoch}} = 0``$. Lowering MUST enforce: 1. **Interval Bounds**: Intervals require $``t_{\text{start}} \le t_{\text{end}}``$ and $``t_{\text{start}} \ge 0``$. Inversions ($``t_{\text{start}} \gt t_{\text{end}}``$) or negative coordinates emit `E0400`. 2. **Lifecycle Dichotomy**: Events require $``t_{\text{start}} = t_{\text{end}}``$ ($\text{duration} = 0$). Durative occurrences require $``t_{\text{start}} \lt t_{\text{end}}``$ ($\text{duration} \gt 0$). Violations emit `E0400`. 3. **Duration Consistency**: Nominal $``\delta_{\text{nom}} \ge 0``$ requires $``|(t_{\text{end}} - t_{\text{start}}) - \delta_{\text{nom}}| \le \epsilon_{\text{tol}}``$ ($``\epsilon_{\text{tol}} = 10^{-9}``$). Envelopes require $``\delta_{\min} \le t_{\text{end}} - t_{\text{start}} \le \delta_{\max}``$. Breaches emit `E0400`. 4. **Hierarchical Containment**: Sub-occurrences ($``o_{\text{sub}} \subseteq_{\text{occ}} o_{\text{super}}``$) require $``[t_{\text{start}}(o_{\text{sub}}), t_{\text{end}}(o_{\text{sub}})] \subseteq [t_{\text{start}}(o_{\text{super}}), t_{\text{end}}(o_{\text{super}})]``$; breaches emit `E0401`. 5. **State Continuity**: Sequential states satisfy $``t_{\text{end}}(S_i) = t(\tau) = t_{\text{start}}(S_{i+1})``$. Exclusive state overlaps emit `E0401`. --- */
        part def _1_Normative_Statement {
        }
        doc /* Occurrence lifecycle intervals, duration consistency, hierarchical containment, and error mappings satisfy: \begin{aligned} I(o)=[t_{\text{start}}(o),t_{\text{end}}(o)],\quad 0\le t_{\text{start}}(o)\le t_{\text{end}}(o),\quad \text{duration}(I(o))=t_{\text{end}}(o)-t_{\text{start}}(o)\ge 0 \\ (o\in\mathcal{O}_{\text{event}}\implies t_{\text{start}}=t_{\text{end}})\land (o\in\mathcal{O}_{\text{durative}}\implies t_{\text{start}}\lt t_{\text{end}}) \\ \delta_{\min}\le\text{duration}(I(o))\le\delta_{\max},\quad |\text{duration}(I(o))-\delta_{\text{nom}}|\le\epsilon_{\text{tol}} \\ o_{\text{sub}}\subseteq_{\text{occ}} o_{\text{super}}\implies (t_{\text{start}}(o_{\text{super}})\le t_{\text{start}}(o_{\text{sub}})\le t_{\text{end}}(o_{\text{sub}})\le t_{\text{end}}(o_{\text{super}})) \\ S_i\xrightarrow{\tau} S_{i+1}\implies t_{\text{end}}(S_i)=t(\tau)=t_{\text{start}}(S_{i+1}),\quad I(S_i)\cap I(S_j)\subseteq\{t_{\text{boundary}}\} \\ (t_{\text{start}}\gt t_{\text{end}}\lor t_{\text{start}}\lt 0\lor \Delta t\lt 0)\implies\text{Diagnostic}(o,\text{E0400})\land I(o)\gets\bot_{\text{interval}} \\ (o_{\text{sub}}\not\subseteq_{\text{time}} o_{\text{super}}\lor I(S_i)\cap I(S_j)\not\subseteq\{t_{\text{boundary}}\})\implies\text{Diagnostic}(o,\text{E0401})\land o_{\text{sub}}\gets\bot_{\text{occ}} \\ \forall o\in\mathcal{O}_{\text{life}},\quad \Delta_o=\text{UUIDv5}(\text{NS}_{\text{DEAP}},\text{FQN}(o)) \end{aligned} --- */
        part def _2_Formal_Invariant {
            attribute mathcal_I : String = "Lifecycles and bounds $``[t_{\text{start}}, t_{\text{end}}]``$";
            attribute mathcal_mathcal : String = "Events ($\Delta t = 0$) and durative occurrences ($\Delta t \gt 0$)";
            attribute delta_delta : String = "Nominal duration and tolerance envelope";
            attribute o_subseteq_o : String = "Sub-occurrence containment relation";
            attribute S_i_tau : String = "State occupancy and transition event";
            attribute bot_bot_Delta_o : String = "Sentinels and deterministic UUIDv5 identifier";
        }
        doc /* - **Complexity Class:** Class $\mathbf{P}$ (Deterministic Polynomial Time) - **Asymptotic Bound:** $O(1)$ interval check; $O(N)$ lowering for $``N = |\mathcal{O}_{\text{life}}|``$ nodes; $O(N)$ containment traversal for $M \le N - 1$ edges. Work-stealing: $``O(N / N_{\text{max\_workers}} + \log N_{\text{max\_workers}})``$. - **Tractable Subclass & Frontier:** Deterministic polynomial; avoids NP-complete temporal reasoning (NP-1). --- */
        part def _3_Computational_Complexity_Algorithmic_Bounds {
        }
        part def _4_Verification_Conformance_Criteria {
        }
    }
    doc /* Formal Safety, Traceability & Regulatory Verification */
    package Subsystem_7_Formal_Safety_Traceability_Verification {
        doc /* UUIDv5: baeb1e4f-5b99-5168-853f-30537093be69 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 | Diagnostics: E0199, E0400, E0402 */
        requirement def REQ_0128__7_Tier_Bipartite_Traceability_DAG_Architecture {
            id = "REQ-0128";
            text = "The safety compiler SHALL build, validate, and query a deterministic 7-tier bipartite DAG (TraceabilityGraph_Alpha) G_{trace} = (V_{trace}, E_{trace}) linking requirements, design elements, interfaces, constraints, code, and witnesses.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: b26286ac-e3bf-5e54-9c55-ec9066844298 | Complexity: Class P (O(\vert V_{req}\vert + \vert E_{alloc}\vert) completeness check) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 | Diagnostics: E0199, E0400, E0404 */
        requirement def REQ_0129_Upward_Allocation_Completeness_Gate_exists_text {
            id = "REQ-0129";
            text = "The formal safety compiler SHALL enforce an upward allocation completeness gate (AllocationGate_Alpha) ensuring every system requirement allocates to architecture or safety invariants.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: 1d64393a-24ec-54b7-bb5d-546f37a05f72 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 | Diagnostics: E0199, E0400, E0405 */
        requirement def REQ_0130_Downward_Realization_Completeness_Gate_exists_text {
            id = "REQ-0130";
            text = "The safety compiler SHALL enforce downward realization completeness (RealizationGate_Alpha) across traceability DAG G_{trace}.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: 9ccb3e3c-c281-588c-8abf-4c442be6ce57 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / SysML v2 Verification Cases | Diagnostics: E0199, E0400, E0407 */
        requirement def REQ_0131_Verification_Witness_Completeness_Gate_exists_text {
            id = "REQ-0131";
            text = "The verification engine SHALL enforce a Verification Witness Completeness Gate (WitnessGate_Alpha) across the traceability graph, asserting that all requirements are witnessed.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: f3b428ab-71c2-5f12-81f8-551901cbdfe2 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / ISO 26262 / DO-178C | Diagnostics: E0199, E0400, E0408 */
        requirement def REQ_0132_Extraneous_Node_Detection {
            id = "REQ-0132";
            text = "The safety compiler SHALL eliminate extraneous AST nodes and unreachable behaviors lacking reachability to root requirements. The analyzer (DeadEliminator_1) MUST evaluate reachability over traceability DAG (SafetyGraph_Alpha) from roots R_{root}.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: 2336e9ee-9b05-5312-91f2-0329ca177e61 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / RFC 6962 | Diagnostics: E0199, E0400, E0409 */
        requirement def REQ_0133_Cryptographic_Merkle_Root_Attestation_for_End_to_End_Verification_Graphs {
            id = "REQ-0133";
            text = "The verification engine SHALL compute and verify Merkle root digest H_{root} \in \{0, 1\}^{256} over 7-tier traceability graph TraceGraph_Alpha, emitting manifest HashAttestation_0 (MerkleTree_1) to guarantee bitwise determinism.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: 753858e5-d482-51bb-b4d3-03c2b1736021 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / STPA Safety Engineering / KerML | Diagnostics: E0199, E0400, E0412 */
        requirement def REQ_0134_Hierarchical_Control_Structure_AST_Extraction {
            id = "REQ-0134";
            text = "The safety compiler SHALL extract and validate a Hierarchical Control Structure (HCS) topology from the AST, partitioning entities into disjoint sets: controllers (C), actuators (E), processes (P), and sensors (O).";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: c14212a7-8635-5dd9-a985-e710051af8d0 | Complexity: Class NP-hard} (NP-complete} decision) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / STPA Safety Verification | Diagnostics: E0199, E0400, E0413 */
        requirement def REQ_0135_STPA_Minimal_Hazard_Cut_Sets {
            id = "REQ-0135";
            text = "The safety compiler SHALL compute the minimal hitting set of constraints covering all declared hazards, ingesting hazards H and constraints C from the AST arena as an abstract hypergraph.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: 2e0c948d-ae2d-5e2b-96ea-3d4d074e7f6c | Complexity: Class P with parameter 4^k (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / STPA Safety Invariant | Diagnostics: E0199, E0400, E0414 */
        requirement def REQ_0136_STPA_Combinatorial_Unsafe_Control_Action_Tensor_Expansion {
            id = "REQ-0136";
            text = "The safety engine SHALL execute combinatorial tensor expansion and context pruning across control actions, universal STPA guide words, and operational context states.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: 85bf8271-6297-596e-95db-02060b000a44 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / STPA Safety Invariant | Diagnostics: E0199, E0400, E0406 */
        requirement def REQ_0137_Automated_Boolean_Safety_Invariant_Synthesis_from_Hazard_Scenarios {
            id = "REQ-0137";
            text = "The safety compiler SHALL synthesize Boolean safety invariants from hazard scenarios by generating the logical negation of hazardous state predicates over the state vector.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: 3cafd580-3a77-55aa-afd8-5c2f553d5fd3 | Complexity: Class P (Tseitin CNF) / NP-complete} (SAT check) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Formal Safety Invariant | Diagnostics: E0199, E0400 */
        requirement def REQ_0138_Structured_ConstraintExpr_AST_Invariant_Generation_with_De_Morgan_Normalization {
            id = "REQ-0138";
            text = "The safety compiler SHALL construct invariants as typed ConstraintExpr AST nodes and lower them to canonical CNF via De Morgan normalization and bounded Tseitin transformation.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: 098559d8-013e-5f41-b0e3-3ef7d4ab7d5a | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / SAE ARP4761 | Diagnostics: E0199, E0400 */
        requirement def REQ_0139_FMECA_Failure_Mode_Synthesis_across_4_Universal_Dimensions {
            id = "REQ-0139";
            text = "The safety compiler SHALL synthesize FMECA records across four universal failure dimensions (Interface, State, Action, Resource) for every architectural component in the system AST.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: 566300cf-7308-51ac-9a9b-bafcfd0b609a | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / FMEA Invariant | Diagnostics: E0199, E0400 */
        requirement def REQ_0140_Quantitative_Risk_Priority_Number_Integer_Scoring_Engine {
            id = "REQ-0140";
            text = "The safety compiler SHALL compute Risk Priority Numbers (RPN), evaluating integer scores and mitigation gates.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: 6452162e-a5d8-503c-a7f4-cd3e22a2e29d | Complexity: Class P (O(N_{sub})) | Standard: IEEE 29148-2018 / RFC 2119 / ASTM F3269-17 | Diagnostics: E0199, E0400, E0440 */
        requirement def REQ_0141_Run_Time_Assurance_Simplex_Duplex_Architecture_Pattern_Synthesis {
            id = "REQ-0141";
            text = "The safety compiler SHALL synthesize Run-Time Assurance (RTA) Simplex and Duplex patterns into verified control structures.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: 14356448-5860-5a10-b7aa-3ddb1b11e33a | Complexity: Class P (O(1)) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 | Diagnostics: E0199, E0400, E0440 */
        requirement def REQ_0142_Smooth_State_Transition_Blending {
            id = "REQ-0142";
            text = "The safety compiler SHALL synthesize smooth transition interpolation for Run-Time Assurance (RTA) switching logic, interpolating Signal_0 between Classifier_Alpha and Classifier_Beta via blender BlendFunction_Alpha across duration TransTime_1 (T_{switch}).";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: f9950fc1-ed6b-5ea9-957f-0615cea6a33e | Complexity: Class P (contract formulation) / Quadratic Programming (QP) solver integration O(n_{ctrl}^3) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Continuous Safety Invariant | Diagnostics: E0199, E0400, E0406, E0440 */
        requirement def REQ_0143_Control_Barrier_Function_Forward_Invariance_Contract_Formulation {
            id = "REQ-0143";
            text = "The safety compiler SHALL formulate Control Barrier Function (CBF) forward invariance contracts for critical state constraints, ensuring synthesized and filtered control laws maintain safe set forward invariance.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* UUIDv5: a935c567-a393-5727-961c-015cc725d722 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / Safety Verification | Diagnostics: E0199, E0400 */
        requirement def REQ_0144_Declarative_Pluggable_Regulatory_Safety_Profiles_Engine {
            id = "REQ-0144";
            text = "The compiler SHALL implement a declarative pluggable regulatory safety profiles engine defining severity scales, required attributes, checklists, and rules without mutating core AST schemas.";
            satisfy by SafetyAssuranceEngine;
        }
        doc /* Primary execution engine for Formal Safety, Traceability & Regulatory Verification */
        part def SafetyAssuranceEngine {
            port in state_in : StateSolverPort;
            port out safety_out : SafetyPort;
        }
        doc /* - **Given:** `Package_0` with component `Component_Alpha` having partitioned elements. - **When:** Lowering FMECA failure mode synthesis. - **Then:** Allocates Cartesian records in arena storage (`FMECA_Table_1`). - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_4_Dimension_FMECA_Synthesis {
        }
        doc /* - **Given:** `Package_0` with 7-tier chain from `Req_Mission_0` (`Tier_1`) to `Witness_0` (`Tier_7`). - **When:** Lowering `TraceabilityGraph_Alpha` and indexing adjacency. - **Then:** Validates 6 adjacent relations and indexes verification thread without diagnostics. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_7_Tier_Verification_Thread_Construction {
        }
        doc /* - **Given:** `Package_0` with `ConstraintExpr_Alpha` over `param_x : Real`. - **When:** Lowering elimination and De Morgan normalization. - **Then:** Emits canonical NNF AST with zero diagnostics. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_AST_De_Morgan_Normalization {
        }
        doc /* - **Given:** Model `Package_0` with `StateVector_1` (`param_x : Real`) and hazard `Hazard_Scenario_0` ($``H_0(\mathbf{x}) \equiv (\text{param\_x} \gt 80.0)``$). - **When:** Lowering hazard scenarios into synthesized invariants (`SafetyInvariant_Alpha`). - **Then:** Emits `AssertConstraintUsage` AST node with predicate $``\neg(\text{param\_x} \gt 80.0) \equiv (\text{param\_x} \le 80.0)``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Boolean_Invariant_Synthesis {
        }
        doc /* - **Given:** `Package_0` declaring $\dot{\mathbf{x}}=f(\mathbf{x})+g(\mathbf{x})\mathbf{u}$, barrier `BarrierFunction_Alpha` ($\gamma=1$), and `ControlLaw_1`. - **When:** Lowering CBF contract into filter `ControlFilter_0`. - **Then:** Synthesizes $``L_f h, L_g h``$ and QP system $``A_{\text{cbf}}\mathbf{u}\le\mathbf{b}_{\text{cbf}}``$ in arena. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_CBF_Lowering_QP_Filter_Formulation {
        }
        doc /* - **Given:** `Package_0` with `Controller_Alpha`, `Process_Beta`, `ControlAction_0`, and `FeedbackChannel_1`. - **When:** AST topology extraction executes. - **Then:** Lowers 8-tuple HCS with valid port directions and feedback loop. - **Diagnostic:** Diagnostic sink empty. */
        part def AC_01_Canonical_Closed_Loop_Extraction {
        }
        doc /* - **Given:** Model `Package_0` with hazards `Hazard_Alpha`, `Hazard_Beta` and candidate constraints. - **When:** `CutSetSolver_0` executes greedy minimization. - **Then:** Hitting set $``C_{\text{greedy}}``$ covers all hazards within $(1 + \ln |\mathcal{H}|)$ bound. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Greedy_Cut_Set_Minimization {
        }
        doc /* - **Given:** `Package_0` declaring `SafetyGraph_Alpha` grounded to `Req_Root_0`. - **When:** `DeadEliminator_1` executes reachability analysis. - **Then:** $``V_{\text{extraneous}} = \emptyset``$, $``G_{\text{active}} = G``$; diagnostic sink remains empty. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Grounded_Model_Reachability {
        }
        doc /* - **Given:** Graph `TraceGraph_Alpha` (`Req_Mission_0` to `Witness_0`). - **When:** Pass `MerkleTree_1` evaluates the graph. - **Then:** Emits root $``H_{\text{root}}``$ and manifest `HashAttestation_0`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Merkle_DAG_Root {
        }
        doc /* - **Given:** Profile `SafetyProfile_Alpha` with levels `Level_0` through `Level_3`. - **When:** The compiler ingests the profile and computes severity ranks. - **Then:** Order $``s_0 \prec_{\mathcal{S}} \dots \prec_{\mathcal{S}} s_3``$ is verified and ranks assigned. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Profile_Ingestion {
        }
        doc /* - **Given:** `Package_0` declaring `Requirement_0` and witness `Witness_1` (`Test`, verdict `Pass`). - **When:** Executing `WitnessGate_Alpha` on `(Requirement_0, Witness_1)`. - **Then:** Validates verification edge and marks `Requirement_0` certified. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Requirement_Witness_Binding_Certification {
        }
        doc /* - **Given:** `Package_0` declaring `RequirementNode_0`, `Component_1`, and `Invariant_Safe_0`. - **When:** `AllocationGate_Alpha` verifies allocation edges. - **Then:** Records edges in $``E_{\text{alloc}}``$, confirms $``\mu_{\text{alloc}} = 1.0``$, and succeeds. - **Diagnostic:** Diagnostic sink empty. */
        part def AC_01_Canonical_Requirement_to_Element_Allocation {
        }
        doc /* - **Given:** `Package_0` with `FailureMode_Alpha` ($S=5, O=4, D=3$) and `FailureMode_Beta` ($S=9, O=1, D=1$). - **When:** `RPN_Engine_0` evaluates scores and criticality. - **Then:** Yields $RPN=60$ ($\text{AP}=\text{Low}$) and $RPN=9$ ($\text{IsCritical}=\text{true}$, $\text{AP}=\text{High}$). - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Scoring_Criticality {
        }
        doc /* - **Given:** Package `Package_0` declaring `AdvancedController_0`, `RecoveryController_1`, `SafetyMonitor_Alpha`, and `SwitchingLogic_0`. - **When:** Synthesizing the RTA Simplex or Duplex pattern. - **Then:** Emits composite RTA block with arbitrated ports, fan-out flows, and zero diagnostics. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Simplex_Duplex_Pattern_Synthesis {
        }
        doc /* - **Given:** `Package_0` with 5 actions (`ControlAction_Alpha`), 4 guide words, and 10 states (`ContextTensor_0`). - **When:** Lowering tensor expansion and pruning (`Pruner_1`). - **Then:** Allocates $|U| = 200$ tuples and retains $``\mathcal{U}_{\text{pruned}}``$ records. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Tensor_Expansion_Pruning {
        }
        doc /* - **Given:** `Package_0` with `Element_0` and requirement `Requirement_0`. - **When:** Lowering processes `satisfy Requirement_0 by Element_0`. - **Then:** Registers $``(r_0, e_0) \in E_{\text{realize}}``$, validating completeness. - **Diagnostic:** Diagnostic sink empty. */
        part def AC_01_Direct_Downward_Realization {
        }
        doc /* - **Given:** `Package_0` declaring `BlendFunction_Alpha` with $``T_{\text{switch}} = 0.5\,\text{s}``$. - **When:** Transition blending synthesis executes. - **Then:** Synthesizes $\lambda(\tau) = 3\tau^2 - 2\tau^3$ matching endpoint derivatives with $C^1$-continuity. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Nominal_Blending_Synthesis_C_1_Continuity {
        }
        doc /* - **Given:** Blender with signals in $``[u_{\min}, u_{\max}]``$ and rate below limit $``\dot{\mathbf{u}}_{\max}``$. - **When:** Envelope and rate verification executes. - **Then:** Verifies $``\mathbf{u}_{\text{blend}}(\tau) \in [u_{\min}, u_{\max}]``$ and $``\sup \|\dot{\mathbf{u}}_{\text{blend}}\| \le \dot{\mathbf{u}}_{\max}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Actuator_Envelope_Slew_Rate_Conformance {
        }
        doc /* - **Given:** `Package_0` with safe set `SafeSet_0` where $``K_{\text{cbf}}(\mathbf{x})\cap\mathcal{U}_{\text{ctrl}}=\emptyset``$. - **When:** Checking constraint polytope feasibility on boundary $\partial\mathcal{C}$. - **Then:** Aborts filter lowering, binds sentinel $``\bot_{\text{cbf}}``$, and emits `E0440`. - **Diagnostic:** `E0440` (ActuatorSaturationConflict). */
        part def AC_02_Actuator_Saturation_Infeasibility_Rejection {
        }
        doc /* - **Given:** State $\mathbf{x}(t)$ with $``h_j(\mathbf{x}(t)) < \delta_{\text{margin}}``$ or Duplex discrepancy $``\|\mathbf{u}_A - \mathbf{u}_B\| > \epsilon_{\text{discrepancy}}``$. - **When:** `SafetyMonitor_Alpha` evaluates feedback state. - **Then:** Monitor asserts $\text{Unsafe}$ and `SwitchingLogic_0` transfers authority to `RecoveryController_1`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Boundary_Envelope_Protection_Margin_Trip {
        }
        doc /* - **Given:** `Package_0` with `FailureMode_Min` ($S=1, O=1, D=1$) and `FailureMode_Max` ($S=10, O=10, D=10$). - **When:** Evaluating boundary products and mitigations. - **Then:** Yields $RPN=1$ and $RPN=1000$ ($\text{IsCritical}=\text{true}$) without error. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Boundary_Limits_Mitigation {
        }
        doc /* - **Given:** Clauses in `Clause_0` with $``K_{\text{proj}} > K_{\text{dist\_max}} = 256``$. - **When:** Evaluating expansion threshold. - **Then:** Emits linear $``O(|N_{\text{expr}}|)``$ clauses via Tseitin transformation. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Bounded_Distribution_Tseitin_Fallback {
        }
        doc /* - **Given:** Model `Package_0` with hazard `Hazard_Scenario_1` guarded by $``C_1(\mathbf{x}) \equiv (\text{StateVector\_1}.\text{mode} == 1)``$. - **When:** Generating context-conditioned invariant AST nodes. - **Then:** Emits implication $``C_1(\mathbf{x}) \implies \neg H_1(\mathbf{x}) \equiv \neg C_1(\mathbf{x}) \lor \neg H_1(\mathbf{x})``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Context_Guarded_Conditional_Invariant_Synthesis {
        }
        doc /* - **Given:** `Package_0` with dimension $``d > d_{\max}``$ or tensor size $``|U| > K_{\max}``$. - **When:** Allocating candidate tensor. - **Then:** Emits `E0414` and binds $``\bot_{\text{tensor}}``$. - **Diagnostic:** `E0414` (ContextDimensionalityLimitBreach). */
        part def AC_02_Dimensionality_Limit_Tensor_Threshold {
        }
        doc /* - **Given:** `Package_0` with ungrounded `Node_Orphan` lacking path from $``R_{\text{root}}``$. - **When:** Compiling under `strict_safety_audit = true`. - **Then:** Halts lowering, rejects code emission, and emits `E0408`. - **Diagnostic:** `E0408` (ExtraneousNodeDetected). */
        part def AC_02_Extraneous_Node_Rejection_in_Strict_Safety_Audit_Mode {
        }
        doc /* - **Given:** Composite `Requirement_Parent` decomposed into leaves `Requirement_Leaf_0` and `Requirement_Leaf_1` allocated to `Component_1` and `Component_2`. - **When:** `AllocationGate_Alpha` verifies leaf completeness. - **Then:** Confirms complete leaf allocation, satisfying upward coverage. - **Diagnostic:** Diagnostic sink empty. */
        part def AC_02_Hierarchical_Decomposition_Leaf_Completeness {
        }
        doc /* - **Given:** Composite `Requirement_0` decomposed into leaves `Requirement_1` and `Requirement_2`, each bound to a `Pass` witness. - **When:** Evaluating leaf witness coverage and hierarchical conjunction rollup. - **Then:** Full leaf coverage is verified and certified status propagates to `Requirement_0`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Hierarchical_Decomposition_Witness_Rollup {
        }
        doc /* - **Given:** Composite `Element_0` with child `Element_Child_0`, where `Element_0` realizes `Requirement_0`. - **When:** Lowering executes containment traversal. - **Then:** `Element_Child_0` inherits realization ($``\text{Realizers}_{\text{inherited}} \ne \emptyset``$). - **Diagnostic:** Diagnostic sink empty. */
        part def AC_02_Hierarchical_Inheritance_Traversal {
        }
        doc /* - **Given:** Model `Package_0` with `Classifier_Alpha` at `Level_2` omitting `Attribute_0`. - **When:** Attribute completeness validation executes. - **Then:** Lowering of `Classifier_Alpha` halts with diagnostic `E0400`. - **Diagnostic:** `E0400` on missing required attribute. */
        part def AC_02_Monotonic_Attribute_Schema {
        }
        doc /* - **Given:** `Controller_Alpha` supervising `Controller_Beta`, commanding `Process_Beta`. - **When:** Supervisory level stratification executes. - **Then:** Assigns levels $\ell = 0, 1, 2$, verifying DAG acyclicity. - **Diagnostic:** Diagnostic sink empty. */
        part def AC_02_Multi_Level_Supervisory_Stratification {
        }
        doc /* - **Given:** `Package_0` mutating a byte in `Req_Mission_0` or edge target. - **When:** Verification checks recomputed Merkle root. - **Then:** Hash divergence alters $``H_{\text{root}}``$, rejecting compilation. - **Diagnostic:** `E0400` (MerkleAttestationMismatch). */
        part def AC_02_Mutation_Avalanche_Detection {
        }
        doc /* - **Given:** Model with skip-tier edge (`Req_Mission_0` to `Classifier_Alpha`) or backward edge (`Tier_6` to `Tier_3`). - **When:** Validating edge tier step $``\tau_V(v) - \tau_V(u) \ne 1``$. - **Then:** Rejects edge, binds sentinel $``\bot_{\text{edge}}``$, emitting `E0400`. - **Diagnostic:** `E0400` (InvalidTraceabilityEdgeTier). */
        part def AC_02_Non_Adjacent_Edge_Structural_Acyclicity_Rejection {
        }
        doc /* - **Given:** Exact cut-set model with threshold $``\kappa_{\text{cut}}``$. - **When:** Counter $``N_{\text{step}} \gt \kappa_{\text{cut}}``$. - **Then:** Search aborts with diagnostic `E0413`. - **Diagnostic:** `E0413` on step limit exceeded. */
        part def AC_02_Step_Limit_Enforcement {
        }
        doc /* - **Given:** `Component_Alpha` with 2 elements per dimension (8 total). - **When:** Lowering Cartesian expansion. - **Then:** Synthesizes 42 records (`FailureMode_0`) across 21 kinds. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Universal_Failure_Kinds_Completeness {
        }
        doc /* - **Given:** `Invariant_1` with contradictory clauses ($l \land \neg l$) or vacuous $\text{true}$. - **When:** Validating and simplifying invariant AST. - **Then:** Rejects formula, emits `E0400`, and binds $``\bot_{\text{expr}}``$. - **Diagnostic:** `E0400` (UnsatisfiableSafetyInvariant). */
        part def AC_03_Contradictory_Invariant_Rejection {
        }
        doc /* - **Given:** Model with grounded classifiers and orphan port `Port_Orphan`. - **When:** Compiling under `dce_pruning = true`. - **Then:** Prunes `Port_Orphan`, constructs induced $``G_{\text{active}}``$ without dangling edges, and writes `Manifest_Dead_0`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_03_Dead_Code_Elimination_Induced_Subgraph_Pruning {
        }
        doc /* - **Given:** Node declared in conflicting tiers (`Tier_3` and `Tier_7`), or lacking tier mapping. - **When:** Evaluating vertex tier assignment during ingestion. - **Then:** Rejects node, binds sentinel $``\bot_{\text{node}}``$, emitting `E0402`. - **Diagnostic:** `E0402` (ConflictingTierAssignment). */
        part def AC_03_Disjoint_Tier_Partitioning_Multi_Tier_Rejection {
        }
        doc /* - **Given:** `Package_0` with empty actions ($|A| = 0$) or $g \notin G$. - **When:** Validating action and guide word alphabets. - **Then:** Rejects input, emits `E0400`, and binds $``\bot_{\text{uca}}``$. - **Diagnostic:** `E0400` (MalformedGuideWord). */
        part def AC_03_Empty_Action_Set_Invalid_Guide_Word_Rejection {
        }
        doc /* - **Given:** Component with $|\text{Elements}(C)| = 0$ or invalid kind `FailureKind_Custom`. - **When:** Validating elements and failure kinds. - **Then:** Halts lowering, emits diagnostic `E0400`, and binds sentinel $``\bot_{\text{fmeca}}``$. - **Diagnostic:** `E0400` (EmptyComponentElements or InvalidFailureKind). */
        part def AC_03_Empty_Element_Invalid_Failure_Kind_Rejection {
        }
        doc /* - **Given:** Graph `TraceGraph_Alpha` and witness `Witness_0`. - **When:** Checking proof $``\Pi(\text{Witness\_0})``$ against forged sibling hashes. - **Then:** Valid proof verifies in $O(1)$; forged proof emits `E0409`. - **Diagnostic:** `E0409` (InvalidMerkleInclusionProof). */
        part def AC_03_Inclusion_Proof_Validation {
        }
        doc /* - **Given:** `Package_0` with invalid `FailureMode_Invalid` ($S=11$) and unmitigated `FailureMode_Unmitigated` ($S=10, O=5, D=5$). - **When:** Validating rating domains and mitigation sets. - **Then:** Rejects input, binds $``\bot_{\text{rpn}}``$, and emits `E0400`. - **Diagnostic:** `E0400` (RatingDomainViolation). */
        part def AC_03_Invalid_Rating_Unmitigated_Critical_Rejection {
        }
        doc /* - **Given:** Model `Package_0` with invalid duration ($``T_{\text{switch}} \le 0``$ or $``T_{\text{switch}} \gt T_{\text{max\_switch}}``$). - **When:** Timing validation executes. - **Then:** Lowering halts with diagnostic `E0400`. - **Diagnostic:** `E0400` on invalid duration. */
        part def AC_03_Invalid_Switching_Duration_Rejection {
        }
        doc /* - **Given:** RTA block missing recovery controller ($``C_{\text{rec}} = \bot``$) or output exceeding $``[u_{\min}, u_{\max}]``$. - **When:** Semantic envelope checks execute. - **Then:** Rejects block, binds $``\bot_{\text{rta}}``$, and emits diagnostic `E0400` or `E0440`. - **Diagnostic:** `E0400` (MissingRecoveryController) or `E0440` (RecoveryOutputEnvelopeViolation). */
        part def AC_03_Missing_Subcomponent_or_Output_Saturation_Rejection {
        }
        doc /* - **Given:** Model declaring `Requirement_0` with zero edges ($``\text{deg}_{E_{\text{witness}}}(\text{Requirement\_0}) = 0``$). - **When:** Auditing requirements against `WitnessGate_Alpha`. - **Then:** Rejects compilation, emits `E0407` for `Requirement_0`, and binds sentinel $``\bot_{\text{req}}``$. - **Diagnostic:** `E0407` (UnwitnessedRequirement). */
        part def AC_03_Missing_Verification_Witness_Rejection {
        }
        doc /* - **Given:** Model declaring unallocated `Element_1` lacking realization traces. - **When:** Completeness pass executes. - **Then:** Traps $``|\text{Realizers}(e_1)| = 0``$, halts lowering, emits `E0405`, and binds $``\bot_{\text{elem}}``$. - **Diagnostic:** `E0405` (DownwardRealizationIncomplete). */
        part def AC_03_Orphan_Element_Rejection {
        }
        doc /* - **Given:** `Package_0` with barrier $\gamma=2$ lacking auxiliary chain, or undecidable SMT dynamics. - **When:** Validating barrier relative degree and decidability. - **Then:** Rejects barrier, binds $``\bot_{\text{cbf}}``$, and emits `E0400` or `E0406`. - **Diagnostic:** `E0400` / `E0406`. */
        part def AC_03_Relative_Degree_Mismatch_Undecidable_Barrier_Rejection {
        }
        doc /* - **Given:** Unallocated `RequirementNode_0` ($|\text{Alloc}| = 0$) or allocation targeting `Package_1`. - **When:** `AllocationGate_Alpha` checks out-degrees and target tiers. - **Then:** Emits `E0400` rejecting the orphan requirement or invalid target. - **Diagnostic:** `E0400` (UnallocatedSystemRequirement). */
        part def AC_03_Unallocated_Requirement_Invalid_Target_Rejection {
        }
        doc /* - **Given:** Model `Package_0` declaring `Hazard_Alpha` with empty mitigation set. - **When:** Completeness validation executes. - **Then:** Lowering halts with diagnostic `E0400`. - **Diagnostic:** `E0400` on unmitigated hazard. */
        part def AC_03_Unmitigated_Hazard_Rejection {
        }
        doc /* - **Given:** `ControlAction_0` lacking feedback without `@open_loop`, or unbound controller. - **When:** Observability and process model checks execute. - **Then:** Emits `E0400` and binds sentinel $``\bot_{\text{ctrl}}``$. - **Diagnostic:** `E0400`. */
        part def AC_03_Unobservable_Loop_Rejection {
        }
        doc /* - **Given:** Model `Package_0` declaring universal hazard $``H_0 \equiv \text{true}``$ or unresolved variable $x \notin \mathbf{x}$. - **When:** Invariant satisfiability and scope validation execute. - **Then:** Rejects input, emits diagnostic `E0400`, and binds sentinel $``\bot_{\text{inv}}``$. - **Diagnostic:** `E0400` (UnsatisfiableSafetyInvariant). */
        part def AC_03_Unsatisfiable_Invariant_Undefined_Variable_Rejection {
        }
        doc /* - **Given:** Model `Package_0` with `Hazard_0` at `Level_3` lacking witness `Witness_0`. - **When:** Checklist gates and profile rules $``\mathcal{R}_{\text{rules}}``$ are evaluated. - **Then:** Lowering halts with diagnostic `E0400`. - **Diagnostic:** `E0400` on unsatisfied checklist gate. */
        part def AC_03_Verification_Checklist_Gate {
        }
        doc /* - **Given:** Blender with peak rate $``\sup \|\dot{\mathbf{u}}_{\text{blend}}\| \gt \dot{\mathbf{u}}_{\max}``$. - **When:** Slew-rate verification executes. - **Then:** Halts with diagnostic `E0440`. - **Diagnostic:** `E0440` on slew-rate violation. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Actuator_Slew_Rate_Violation {
        }
        doc /* - **Given:** Coverage deficit ($``\mu_{\text{alloc}} < 1.0``$) and malformed statement before `;`. - **When:** Validating upward coverage and parsing declarations. - **Then:** Emits `E0404`, binds $``\bot_{\text{alloc}}``$, recovers on `;`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0404`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Allocation_Coverage_Deficit_Delimiter_Recovery {
        }
        doc /* - **Given:** `Witness_1` referencing undefined `Requirement_Dangling` before `;`, followed by a valid pair. - **When:** Validating targets and executing delimiter recovery. - **Then:** Emits `E0400`, binds $``\bot_{\text{witness}}``$, recovers on `;`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0400`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Dangling_Witness_Target_Synchronization_Token_Recovery {
        }
        doc /* - **Given:** Malformed realization and ungrounded requirement before `;`, followed by `Element_0`. - **When:** Lowering parses declarations. - **Then:** Emits `E0400`, recovers on `;`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0400`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Error_Recovery {
        }
        doc /* - **Given:** Model declaring 5 invalid edges separated by delimiters (`;`, `}`). - **When:** Parsing malformed statements with delimiter recovery. - **Then:** Resynchronizes on delimiters, records `E0400` in $``\mathcal{D}_{\text{sink}}``$, halting with `E0199` at $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0400`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Recovery_Diagnostic_Capacity_Halt {
        }
        doc /* - **Given:** Contradictory context before `;`, followed by valid action. - **When:** Parser detects conflict and recovers on delimiter. - **Then:** Emits `E0400`, recovers on `;`, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0400`, `E0199`. */
        part def AC_04_Delimiter_Recovery_Error_Accumulation {
        }
        doc /* - **Given:** Malformed declarations ($S=4.5$, missing $D$) separated by delimiters (`;`). - **When:** Ingestion encounters syntax or domain errors. - **Then:** Emits `E0400`, recovers on `;`, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0400`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Recovery_Error_Saturation {
        }
        doc /* - **Given:** Malformed declarations separated by statement delimiters (`;`, `}`). - **When:** Ingestion encounters syntax or type faults. - **Then:** Records diagnostics in $``\mathcal{D}_{\text{sink}}``$, recovers on delimiters, and halts with `E0199` at $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0199` (ErrorSinkOverflow). --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Recovery_Error_Sink_Saturation {
        }
        doc /* - **Given:** Malformed barrier missing dynamics before `;`, followed by valid `BarrierFunction_Alpha`. - **When:** Parser encounters syntax fault and resynchronizes. - **Then:** Emits `E0400`, recovers on `;`, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0400`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Resynchronization_Error_Recovery {
        }
        doc /* - **Given:** Declaration violating $``\prec_{\text{canon}}``$ before `;`, followed by a valid node. - **When:** Sorting triggers delimiter recovery. - **Then:** Emits `E0400`, binds $``\bot_{\text{hash}}``$, recovers on `;`, halting at limit with `E0199`. - **Diagnostic:** `E0400`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Non_Canonical_Ordering_Recovery {
        }
        doc /* - **Given:** Inverted port directions or dangling interface handles delimited by `;`. - **When:** Directionality and interface binding passes execute. - **Then:** Emits `E0412`, resynchronizes on `;`, emitting `E0199` at $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0412`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Port_Inversion_Interface_Violations {
        }
        doc /* - **Given:** Hazard model exceeding step budget $``\kappa_{\text{safety}}``$ or syntax faults preceding delimiter (`;`, `}`). - **When:** Solver evaluates consistency and parser resynchronizes on delimiters. - **Then:** Emits `E0406` on step budget breach, accumulates errors in $``\mathcal{D}_{\text{sink}}``$, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0406`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Solver_Step_Limit_Enforcement_Delimiter_Recovery {
        }
        doc /* - **Given:** `Invariant_0` lacking path from $``R_{\text{root}}``$, followed by `;` and valid nodes. - **When:** Validating invariant grounding and recovery. - **Then:** Rejects silent pruning, emits `E0400`, recovers on `;`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0400`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Ungrounded_Safety_Invariant_Delimiter_Recovery {
        }
        doc /* - **Given:** $10^4$ tuples across $``N_{\text{max\_workers}}``$ threads. - **When:** Evaluating and sorting in Release mode (`--release`). - **Then:** Emits bitwise identical records; latency $< 25\text{ ms}$, RSS $< 100\text{ MB}$. - **Diagnostic:** Diagnostic sink remains empty. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_05_Bitwise_Determinism_Release_Performance {
        }
        doc /* The safety compiler SHALL build, validate, and query a deterministic 7-tier bipartite DAG (`TraceabilityGraph_Alpha`) $``G_{\text{trace}} = (V_{\text{trace}}, E_{\text{trace}})``$ linking requirements, design elements, interfaces, constraints, code, and witnesses. Validation MUST enforce: 1. **Disjoint Partitioning**: Vertices $``V_{\text{trace}}``$ partition into seven disjoint tiers: `Tier_1` ($``T_1``$, $``\mathcal{R}_{\text{mission}}``$), `Tier_2` ($``T_2``$, $``\mathcal{R}_{\text{system}}``$), `Tier_3` ($``T_3``$, $``\mathcal{C}_{\text{arch}}``$), `Tier_4` ($``T_4``$, $``\mathcal{P}_{\text{port}}``$), `Tier_5` ($``T_5``$, $``\mathcal{I}_{\text{safety}}``$), `Tier_6` ($``T_6``$, $``\mathcal{M}_{\text{code}}``$), and `Tier_7` ($``T_7``$, $``\mathcal{W}_{\text{verify}}``$). Unpartitioned or multi-tier entities emit `E0402`. 2. **Strict Adjacent Edges**: Edges $``(u, v) \in E_{\text{trace}}``$ MUST satisfy $``\tau_V(v) = \tau_V(u) + 1``$ within $``E_{\text{trace}} \subseteq \bigcup_{i=1}^6 (T_i \times T_{i+1})``$. Skip-tier, backward, and intra-tier edges emit `E0400`. 3. **Typing & Acyclicity**: Edges bind relations: `Refines`, `Allocates`, `Exposes`, `Guards`, `Enforces`, `Witnesses`. Monotonic tier steps guarantee acyclicity; cycles or conflicts emit `E0400`. 4. **Bidirectional Traversal**: Adjacency $\text{Adj}^+$ and transposed $\text{Adj}^-$ support forward $\text{Reach}^+$ and backward $\text{Reach}^-$ sweeps, indexing verification threads $``\langle v_1, \dots, v_7 \rangle``$. --- */
        part def _1_Normative_Statement {
        }
        doc /* Traceability graph partitioning, edge relations, and reachability satisfy: \begin{aligned} G_{\text{trace}}=\langle V_{\text{trace}},E_{\text{trace}},\mathcal{T}_{\text{tiers}},\tau_V,\tau_E,\Delta_V,\Delta_E,\mathcal{D}_{\text{sink}}\rangle,\quad V_{\text{trace}}=\biguplus_{i=1}^7 T_i \\ \mathcal{T}_{\text{tiers}}=\langle\mathcal{R}_{\text{mission}},\mathcal{R}_{\text{system}},\mathcal{C}_{\text{arch}},\mathcal{P}_{\text{port}},\mathcal{I}_{\text{safety}},\mathcal{M}_{\text{code}},\mathcal{W}_{\text{verify}}\rangle \\ E_{\text{trace}}\subseteq\bigcup_{i=1}^6(T_i\times T_{i+1})\iff\forall(u,v)\in E_{\text{trace}}:\tau_V(v)=\tau_V(u)+1 \\ \forall(u,v)\in E_{\text{trace}}:\tau_E(u,v)\in\{\text{Refines},\text{Allocates},\text{Exposes},\text{Guards},\text{Enforces},\text{Witnesses}\} \\ \forall u\in V_{\text{trace}}:\neg\exists\text{Path}(u,u),\quad\text{Reach}^+(u)=\{v\in V_{\text{trace}}\mid\exists\text{Path}(u,v)\} \\ \Delta_V(v)=\text{UUIDv5}(\text{NS}_{\text{DEAP}},\text{FQN}(v)),\quad\Delta_E(e)=\text{UUIDv5}(\text{NS}_{\text{DEAP}},\text{FQN}(u)\mathbin{\Vert}\text{"::"}\mathbin{\Vert}\text{FQN}(v)) \\ (\tau_V(u)\notin\{1,\dots,7\}\lor u\in T_i\cap T_j)\implies\text{Diagnostic}(u,\text{E0402})\land u\gets\bot_{\text{node}} \\ (\tau_V(v)\ne\tau_V(u)+1\lor\text{Conflict}(e_1,e_2))\implies\text{Diagnostic}(e,\text{E0400})\land e\gets\bot_{\text{edge}} \\ |\mathcal{D}_{\text{sink}}|\ge C_{\text{max\_errors}}\implies\text{Diagnostic}(\text{E0199}) \end{aligned} --- */
        part def _2_Formal_Invariant {
            attribute G_mathcal : String = "Traceability DAG and 7-tier sequence";
            attribute V_E : String = "Disjoint vertices and bipartite edges";
            attribute tau_V_tau_E : String = "Tier assignment and relation typing";
            attribute text_item : String = "Downward and upward reachability sets";
            attribute Delta_V_Delta_E : String = "RFC 4122 UUIDv5 anchor maps";
            attribute mathcal_bot : String = "Error sink and sentinels ($``\bot_{\text{node}}``$, $``\bot_{\text{edge}}``$)";
        }
        doc /* - **Complexity Class:** Class $\mathbf{P}$ (Deterministic Polynomial Time) - **Asymptotic Bound:** $O(|V| + |E|)$ for construction, validation, and traversal; work-stealing bounds to $``O((|V| + |E|) / N_{\text{max\_workers}} + \log N_{\text{max\_workers}})``$. - **Tractable Subclass & Frontier:** Avoids NP-4 (REQ-0135) explosion by validating concrete bipartite tiers without combinatorial search. --- */
        part def _3_Computational_Complexity_Algorithmic_Bounds {
        }
        part def _4_Verification_Conformance_Criteria {
        }
    }
    doc /* Level 1C Interface Control Documents & Interconnect Contracts */
    package Subsystem_8_Level_1C_ICD_Interconnect_Contracts {
        doc /* UUIDv5: 7e5d0447-d59a-530f-a569-3838a3ec3572 | Complexity: Class P (O(N^2 + | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 | Diagnostics: E0199, E0200, E0201 */
        requirement def REQ_0145_Automated_N_2_System_Interface_Matrix_Construction {
            id = "REQ-0145";
            text = "The ICD engine of Subsystem 8 SHALL construct the N^2 System Interface Matrix representing component interactions, placing internal identities on diagonal cells and directed contracts in off-diagonal cells.";
            satisfy by ICDEngine;
        }
        doc /* UUIDv5: 1a4cce94-34a3-5890-8c9d-472fd5a6ca27 | Complexity: Class P (O(N^2 \cdot | Standard: IEEE 29148-2018 / RFC 2119 / ICD & Interconnect Contracts | Diagnostics: E0199, E0200, E0202 */
        requirement def REQ_0146_N_2_Interface_Symmetry {
            id = "REQ-0146";
            text = "The compiler SHALL verify topological consistency across the N^2 System Interface Matrix M (InterfaceMatrix_Alpha), ensuring bidirectional channels exhibit symmetry and directed flows exhibit antisymmetry.";
            satisfy by ICDEngine;
        }
        doc /* UUIDv5: c351b282-3701-570d-b64d-d57c27f55865 | Complexity: NP-hard (ILP) / Class P (FFD heuristic) | Standard: IEEE 29148-2018 / RFC 2119 / ICD & Interconnect Contracts | Diagnostics: E0199, E0200, E0203 */
        requirement def REQ_0147_Structural_Allocation_Interconnect_Clustering {
            id = "REQ-0147";
            text = "The compiler SHALL allocate logical signal flows into shared interconnect channels, minimizing matrix cut bandwidth while enforcing multidimensional capacity bounds.";
            satisfy by ICDEngine;
        }
        doc /* UUIDv5: 6033ff9f-296e-5b42-beff-6d90c6565bd9 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / ISO/IEC 80000 | Diagnostics: E0199, E0200, E0204 */
        requirement def REQ_0148_Master_Signal_Flow_Dictionary {
            id = "REQ-0148";
            text = "The ICD engine of Subsystem 8 SHALL extract the canonical Master Signal Flow Dictionary FlowDictionary_0 from AST item flows without ungrounded tokens or fallbacks.";
            satisfy by ICDEngine;
        }
        doc /* UUIDv5: d741cf5e-525d-549a-96c6-7701841528ab | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / ICD Contracts | Diagnostics: E0199, E0200, E0205 */
        requirement def REQ_0149_Port_Definition_Rosters {
            id = "REQ-0149";
            text = "The compiler SHALL synthesize Port Definition Rosters and bind port types for Level 1C Interface Control Documents (ICD), indexing declarations across hierarchies.";
            satisfy by ICDEngine;
        }
        doc /* UUIDv5: d2245ba2-c8d2-5021-aad3-80629d9118d0 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / Level 1C ICD Contract | Diagnostics: E0199, E0200, E0206 */
        requirement def REQ_0150_Connection_Binding_Rosters_Serialization_Layout {
            id = "REQ-0150";
            text = "The ICD engine of Subsystem 8 SHALL synthesize Connection Binding Rosters mapping connections to endpoints, channels, and stream IDs, computing exact binary wire layouts.";
            satisfy by ICDEngine;
        }
        doc /* UUIDv5: e4a7fb79-cf9c-53b0-900c-d0ffc7fe0624 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Interconnect Contract | Diagnostics: E0199, E0200, E0220 */
        requirement def REQ_0151_Dangling_Port_Gate {
            id = "REQ-0151";
            text = "The compiler SHALL enforce compile-time dangling port gate DanglingGate_Alpha over boundary ports during Level 1C ICD generation.";
            satisfy by ICDEngine;
        }
        doc /* UUIDv5: 5ef3e7e4-d8d9-5f1e-a113-7dfa019e1ada | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Level 1C ICD Contract | Diagnostics: E0199, E0200, E0207 */
        requirement def REQ_0152_SI_Unit_Verification_in_mathbb_7_Rational_Metric_Space_across_Signal_Flows {
            id = "REQ-0152";
            text = "The compiler SHALL verify that engineering units of signal flows match connected port dimensions in \mathbb{Q}^7.";
            satisfy by ICDEngine;
        }
        doc /* UUIDv5: ebc694f1-114a-5c45-be58-2d5e23fd6924 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Interconnect Contract | Diagnostics: E0199, E0200, E0208 */
        requirement def REQ_0153_Failsafe_Default_Value_Domain_Validity {
            id = "REQ-0153";
            text = "The compiler SHALL enforce failsafe domain validity and boundary assertion gate FailsafeGate_Alpha across signals in the Master Signal Flow Dictionary.";
            satisfy by ICDEngine;
        }
        doc /* UUIDv5: f8eb3bc4-c1c9-5815-8292-426d3bf4efd7 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Interconnect Contract | Diagnostics: E0199, E0200, E0209 */
        requirement def REQ_0154_Logical_Channel_Bandwidth_Utilization {
            id = "REQ-0154";
            text = "The ICD engine of Subsystem 8 SHALL verify channel bandwidth budgets, asserting aggregate traffic remains within headroom limits.";
            satisfy by ICDEngine;
        }
        doc /* UUIDv5: 829686fa-ff8c-5ef3-99ae-b28d5937b966 | Complexity: Class P (O(n \log n) Liu & Layland, O(n^2) exact RTA) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Level 1C ICD Contract | Diagnostics: E0199, E0200, E0210 */
        requirement def REQ_0155_Rate_Monotonic_Scheduling_Schedulability_Bound_Verification {
            id = "REQ-0155";
            text = "The ICD engine of Subsystem 8 SHALL verify Rate Monotonic Scheduling (RMS) schedulability for periodic task sets on interconnect buses.";
            satisfy by ICDEngine;
        }
        doc /* UUIDv5: 227ee8dc-ac8f-5555-866e-b57c660e6609 | Complexity: Class P (O(n) dynamic utilization accumulation \sum C_i/T_i \le 1) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Interconnect Contract | Diagnostics: E0199, E0200, E0211 */
        requirement def REQ_0156_Earliest_Deadline_First_Dynamic_Schedulability_Verification {
            id = "REQ-0156";
            text = "The compiler SHALL verify dynamic schedulability for real-time tasks under scheduler EDF_Scheduler_0 during Level 1C ICD synthesis.";
            satisfy by ICDEngine;
        }
        doc /* UUIDv5: 72e6b1ae-0933-5ea5-98d0-40e519df605c | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / Interconnect Contract | Diagnostics: E0199, E0200, E0212 */
        requirement def REQ_0157_Protocol_Framing_Overhead_Calculation {
            id = "REQ-0157";
            text = "The ICD engine of Subsystem 8 SHALL calculate framing overheads and serialization penalties for all signal flows.";
            satisfy by ICDEngine;
        }
        doc /* UUIDv5: f990748f-d459-5a41-9fd9-a0f0131cb9d5 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Interconnect Contract | Diagnostics: E0199, E0200, E0213 */
        requirement def REQ_0158_Worst_Case_Execution_Time_Propagation_across_Interconnect_Latency_Paths {
            id = "REQ-0158";
            text = "The ICD engine of Subsystem 8 SHALL evaluate static timing and propagate Worst-Case Execution Times (WCET) across interconnect latency paths using analyzer WCET_Engine_0.";
            satisfy by ICDEngine;
        }
        doc /* Primary execution engine for Level 1C Interface Control Documents & Interconnect Contracts */
        part def ICDEngine {
            port in safety_in : SafetyPort;
            port out icd_out : ICDPort;
        }
        doc /* - **Given:** Model `Package_0` with flow `Signal_Alpha` connecting `Port_1` to `Port_2`. - **When:** Lowering constructs `FlowDictionary_0`. - **Then:** Record $\sigma$ is allocated with ten non-null columns. - **Diagnostic:** Diagnostic sink empty. */
        part def AC_01_10_Column_Record_Synthesis {
        }
        doc /* - **Given:** Connection `Connection_Alpha` between `Port_1` and `Port_2` on `Channel_0` with `Field_0` and `Field_1`. - **When:** Synthesizing binding rosters and wire layouts. - **Then:** Emits `Binding_0` and `WireLayout_1`; diagnostic sink is empty. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Binding_Wire_Layout {
        }
        doc /* - **Given:** `Package_0` declaring 10 flows (`Flow_Alpha`) and 3 channels (`LogicalChannel_0`). - **When:** Allocation executes under standard FFD mode. - **Then:** Flows are volume-sorted and packed without capacity violations. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_FFD_Multi_Resource_Flow_Allocation {
        }
        doc /* - **Given:** Model `Package_0` with `Interconnect_1` in $``M_{\alpha\beta}, M_{\beta\alpha}``$ and flow `Flow_0` in $``M_{\alpha\beta}``$. - **When:** Matrix symmetry validation executes. - **Then:** Symmetry and antisymmetry invariants hold. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Matrix_Symmetry_Antisymmetry {
        }
        doc /* - **Given:** `Package_0` with `Subsystem_Alpha`, `Subsystem_Beta`, and `Interconnect_1`. - **When:** Lowering interface matrix `InterfaceMatrix_0`. - **Then:** Generates $2 \times 2$ matrix with diagonal subsystems, $``M_{12}=\{\text{Interconnect\_1}\}``$, and $``M_{21}=\emptyset``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_N_2_Matrix_Construction {
        }
        doc /* - **Given:** Flow `Flow_0` (`Payload_1`, $L = 64$) with profile `ProtocolFrame_Alpha` ($``L_{\text{fixed}} = 88``$, $``R_{\text{bus}} = 10^6``$). - **When:** Computing wire framing and serialization metrics. - **Then:** Computes $``L_{\text{frame}} = 152``$, $``\eta_{\text{framing}} \approx 0.4211``$, $``\tau_{\text{occupancy}} = 152\ \mu\text{s}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Overhead_Efficiency {
        }
        doc /* - **Given:** Model `Package_0` with `PortDef_0` and `Port_Alpha`. - **When:** Roster generation executes. - **Then:** Ports are cataloged in `Roster_0` with resolved types and lexicographical ordering. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Roster_Synthesis_Type_Binding {
        }
        doc /* - **Given:** Port `Port_Mandatory` ($``m_{\min} = 1``$) connected via `Channel_0`. - **When:** Lowering model through gate `DanglingGate_Alpha`. - **Then:** Evaluates $\deg(p) = 1$ and passes. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Connected_Mandatory_Port {
        }
        doc /* - **Given:** Path `LatencyPath_Alpha` through `Node_0` ($150\,\mu\text{s}$), hop `InterconnectHop_1` ($200\,\mu\text{s}$), and `Node_1` ($200\,\mu\text{s}$). - **When:** Lowering chain through `WCET_Engine_0`. - **Then:** Confirms $``t_{\text{end\_to\_end}} = 550\,\mu\text{s} \le 600\,\mu\text{s}``$ and passes. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_End_to_End_Latency_Propagation {
        }
        doc /* - **Given:** Flow `Flow_Alpha` connecting `Port_1` to `Port_2` with dimension `UnitVector_0` and scale $1$. - **When:** Evaluating SI unit verification. - **Then:** Evaluates $``\mathbf{u}_{\text{flow}} = \mathbf{u}(p_1) = \mathbf{u}(p_2)``$ and passes. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Homogeneous_Dimensional_Triad_Conformance {
        }
        doc /* - **Given:** Task set `DynamicTaskSet_Alpha` on `Channel_0` ($``C_1=1, T_1=4; C_2=2, T_2=6; C_3=1, T_3=8``$). - **When:** Computing $U = 17/24 \le 1.0$. - **Then:** Confirms EDF schedulability. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Implicit_Deadline_Schedulability {
        }
        doc /* - **Given:** `TaskSet_Alpha` with `PeriodicFlow_0` ($C=1, T=4$) and `PeriodicFlow_1` ($C=2, T=10$). - **When:** Evaluating utilization against $``U_{\text{LL}}(2) \approx 0.8284``$. - **Then:** Confirms $``U = 0.45 \le U_{\text{LL}}(2)``$ and certifies schedulable. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Liu_Layland_Verification {
        }
        doc /* - **Given:** Channel `LogicalChannel_Alpha` ($``C_{\max} = 10^7\text{ bps}``$, $``\rho_{\text{limit}} = 0.70``$) with flows totaling $4.5 \times 10^6\text{ bps}$. - **When:** Lowering model and validating budget `BandwidthBudget_0`. - **Then:** Evaluates $U = 0.45 \le 0.70$ and passes. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Nominal_Aggregate_Bandwidth_Within_Budget {
        }
        doc /* - **Given:** Signal `Signal_Alpha` in `Package_0` routed to `Port_Tgt` (`Int32`), with failsafe `Failsafe_1` set to `0`. - **When:** Lowering through gate `FailsafeGate_Alpha`. - **Then:** Confirms $0 \in [-2^{31}, 2^{31}-1]$ and satisfies $``\mathcal{I}_{\text{safe}}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Valid_In_Domain_Failsafe_Value {
        }
        doc /* - **Given:** Flow with $L = 40$, $``L_{\text{payload\_min}} = 128``$, $\text{Align} = 32$, and $``\Sigma_{\text{stuffing}} = \text{BitStuffing}(5)``$. - **When:** Synthesizing padding and stuffing expansions. - **Then:** Yields $``\Delta_{\text{min\_pad}} = 88``$ and $``\Delta_{\text{stuffing}} = 49``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Alignment_Padding_Bit_Stuffing {
        }
        doc /* - **Given:** Signal `Signal_Alpha` (`param_x : Real`) targeting `Port_Tgt` with envelope $[0.0, 100.0]$ and failsafe `25.0`. - **When:** Evaluating boundary assertions. - **Then:** Confirms $0.0 \le 25.0 \le 100.0$ and admits declaration. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Boundary_Envelope_Conformance {
        }
        doc /* - **Given:** Channel `LogicalChannel_Alpha` ($``C_{\max} = 10^6\text{ bps}``$, $``\rho_{\text{limit}} = 0.70``$) with traffic $7 \times 10^5\text{ bps}$. - **When:** Computing utilization at headroom boundary. - **Then:** Confirms $U = 0.70 \le 0.70$ and passes. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Boundary_Saturation_at_Headroom_Limit {
        }
        doc /* - **Given:** Fields `Field_0` (width 24, align 8) and `Field_1` (width 32, align 32). - **When:** Computing field offsets and padding. - **Then:** Inserts $\text{PadBits} = 8$, placing `Field_1` at offset 32. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Deterministic_Byte_Alignment_Padding {
        }
        doc /* - **Given:** Model where ILP solver exceeds step budget $``\kappa_{\text{alloc}}=100``$. - **When:** Solver exceeds step cutoff $``\kappa_{\text{alloc}}``$. - **Then:** Search aborts, falls back to FFD packing, and emits `E0200`. - **Diagnostic:** `E0200` on step cutoff fallback. */
        part def AC_02_Exact_0_1_ILP_Step_Cutoff_Fallback {
        }
        doc /* - **Given:** Path `LatencyPath_Alpha` with $``t_{\text{end\_to\_end}} = T_{\text{deadline}} = 500\,\mu\text{s}``$. - **When:** Evaluating timing contract satisfaction. - **Then:** Confirms $``t_{\text{end\_to\_end}} \le T_{\text{deadline}}``$ holds and passes. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Exact_Deadline_Boundary_Conformance {
        }
        doc /* - **Given:** `TaskSet_Alpha` with `PeriodicFlow_0` ($C=2, T=5$) and `PeriodicFlow_1` ($C=3, T=7$) ($U \approx 0.8286$). - **When:** Executing iterative RTA for `PeriodicFlow_1`. - **Then:** Recurrence converges to fixed point $``R_1^* = 5 \le 7``$, certifying schedulable. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Exact_RTA_Convergence {
        }
        doc /* - **Given:** Task set on `Channel_0` ($``C_1=1, T_1=2; C_2=1, T_2=4; C_3=1, T_3=4``$). - **When:** Evaluating dynamic bound. - **Then:** Passes under EDF (RMS rejects). - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Exact_Saturation_Dynamic_Bound {
        }
        doc /* - **Given:** Port `Port_Mandatory` with $\deg(p) = 0$ marked `IsTerminated(p) == true`. - **When:** Evaluating connectivity and termination. - **Then:** Confirms $\deg(p) = 0$ and passes. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Explicitly_Terminated_Port {
        }
        doc /* - **Given:** Component `Classifier_1` declaring `Port_Parent` with child `Port_Child`. - **When:** Containment traversal executes. - **Then:** Mappings $``\text{owner}(\text{Port\_Child}) = \text{Port\_Parent}``$ and $``\text{owner}(\text{Port\_Parent}) = \text{Classifier\_1}``$ hold within depth $D$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Hierarchical_Nested_Port_Resolution {
        }
        doc /* - **Given:** Flow declaration with fewer than 10 columns or null sentinels ($\bot$). - **When:** Completeness validation checks $``\mathbf{K}_{10}``$. - **Then:** Compiler rejects the record and emits `E0200`. - **Diagnostic:** `E0200`. */
        part def AC_02_Incomplete_Field_Rejection {
        }
        doc /* - **Given:** Model `Package_0` with `Interconnect_1` in $``M_{\alpha\beta}``$ omitted from $``M_{\beta\alpha}``$. - **When:** Transpose symmetry validation executes. - **Then:** Rejects lowering and emits `E0200`. - **Diagnostic:** `E0200` on symmetry mismatch. */
        part def AC_02_Interconnect_Symmetry_Rejection {
        }
        doc /* - **Given:** `Subsystem_Gamma` and `Subsystem_Alpha` with flows `Flow_A` and `Flow_B`. - **When:** Subsystem sorting and coordinate assignment execute. - **Then:** Sorts $``\text{Index}(S_{\alpha})=1, \text{Index}(S_{\gamma})=2``$; maps `Flow_A` to $``M_{12}``$ and `Flow_B` to $``M_{21}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Lexicographical_Indexing_Directional_Placement {
        }
        doc /* - **Given:** Ports sharing `UnitVector_0` with scale disparity ($10^{-3}$ vs $1$) and adapter `Adapter_Alpha`. - **When:** Evaluating scale compatibility. - **Then:** Validates $``s_{\text{ratio}} = 10^{-3}``$ against `Adapter_Alpha` and passes. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Unit_Scale_Factor_Adaptation {
        }
        doc /* - **Given:** Channel `LogicalChannel_Alpha` ($``C_{\max} = 10^6\text{ bps}``$, $``\rho_{\text{limit}} = 0.70``$) with flows totaling $700{,}001\text{ bps}$. - **When:** Lowering model through budgeting verifier. - **Then:** Emits `E0209` and binds $``\bot_{\text{bw}}``$. - **Diagnostic:** `E0209` (ChannelCapacityOverflow). */
        part def AC_03_Bandwidth_Capacity_Overflow_Rejection {
        }
        doc /* - **Given:** Field `Field_0` (width 5) at offset 5 in word $W = 8$ without split permission. - **When:** Enforcing bitfield word containment. - **Then:** Rejects layout, binds $``\bot_{\text{layout}}``$, and emits `E0206`. - **Diagnostic:** `E0206` on boundary violation. */
        part def AC_03_Bitfield_Storage_Word_Boundary_Violation {
        }
        doc /* - **Given:** Port `PortDef_Alpha` (`In`) instantiated as `Port_Beta : ~PortDef_Alpha`. - **When:** Conjugation lowering evaluates ${\sim}$. - **Then:** Direction evaluates to `Out` with invariant type $``\tau(\text{Port\_Beta}) \cong \tau(\text{PortDef\_Alpha})``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_03_Conjugation_Direction_Inversion {
        }
        doc /* - **Given:** Flow `Signal_Beta` with reversed port directions, type mismatch, or $``f_{\text{rate}} \le 0``$. - **When:** Interface verification validates endpoints. - **Then:** Compiler rejects the declaration and emits `E0204`. - **Diagnostic:** `E0204`. */
        part def AC_03_Contract_and_Typing_Validation {
        }
        doc /* - **Given:** Port `Port_Mandatory` with $\deg(p) = 0 \land \neg\text{IsTerminated}(p)$. - **When:** Evaluating dangling port gate. - **Then:** Fails closed, emits `E0220`, and binds $``\bot_{\text{port}}``$. - **Diagnostic:** `E0220` (DanglingBoundaryPortViolation). */
        part def AC_03_Dangling_Port_Rejection {
        }
        doc /* - **Given:** Flow `Flow_Beta` connecting `Port_1` (`UnitVector_0`) to `Port_2` (`UnitVector_1`). - **When:** Comparing endpoint vectors in $\mathbb{Q}^7$. - **Then:** Detects mismatch, fails closed, binds $``\bot_{\text{dim}}``$, emitting `E0207`. - **Diagnostic:** `E0207` (DimensionalMismatchViolation). */
        part def AC_03_Dimensional_Mismatch_Rejection {
        }
        doc /* - **Given:** Tasks on `Channel_0` with $U = 1.10 \gt 1.0$. - **When:** Evaluating schedulability gate. - **Then:** Fails closed, binds $``\bot_{\text{sched}}``$, emits `E0211`. - **Diagnostic:** `E0211` (DynamicSchedulabilityViolation). */
        part def AC_03_Dynamic_Overload_Rejection {
        }
        doc /* - **Given:** Model `Package_0` with duplicate `Flow_0` in $``M_{\alpha\beta}, M_{\beta\alpha}``$. - **When:** Flow antisymmetry validation executes. - **Then:** Rejects lowering and emits `E0202`. - **Diagnostic:** `E0202` on antisymmetry breach. */
        part def AC_03_Flow_Antisymmetry_Rejection {
        }
        doc /* - **Given:** Chain `Chain_Alpha` with latency $550\,\mu\text{s}$ exceeding deadline $500\,\mu\text{s}$. - **When:** Verifying response chain deadlines. - **Then:** Fails closed, emits `E0213`, and binds sentinel $``\bot_{\text{latency}}``$. - **Diagnostic:** `E0213` (LatencyDeadlineViolation). */
        part def AC_03_Latency_Deadline_Violation_Rejection {
        }
        doc /* - **Given:** Flow `Flow_0` with $L = 1024$, $``L_{\text{mtu}} = 512``$, and $``\Pi_{\text{fragment}} = \text{false}``$. - **When:** Validating MTU and framing limits. - **Then:** Fails closed, emits `E0212`, and binds $``\bot_{\text{framing}}``$. - **Diagnostic:** `E0212` (FramingMTUExceeded). */
        part def AC_03_MTU_Overflow_Rejection {
        }
        doc /* - **Given:** `Package_0` with `Flow_Alpha` exceeding all channel capacities. - **When:** Channel capacity validation executes. - **Then:** Allocation halts, binds sentinel $``\bot_{\text{alloc}}``$, and emits `E0200`. - **Diagnostic:** `E0200` on capacity violation. */
        part def AC_03_Multi_Resource_Capacity_Infeasibility_Rejection {
        }
        doc /* - **Given:** Signal `Signal_Alpha` targeting `Port_Tgt` (`Int8`) with failsafe value `256`. - **When:** Verifying destination port domain. - **Then:** Fails closed, emits `E0208`, and binds sentinel $``\bot_{\text{failsafe}}``$. - **Diagnostic:** `E0208` (FailsafeValueDomainViolation). */
        part def AC_03_Out_of_Domain_Failsafe_Rejection {
        }
        doc /* - **Given:** `TaskSet_Alpha` with $U \gt 1.0$ or response time $``R_i^* \gt D_i``$. - **When:** Validating schedulability and deadlines. - **Then:** Rejects task set, binds sentinel $``\bot_{\text{sched}}``$, and emits `E0210`. - **Diagnostic:** `E0210` (SchedulabilityDeadlineViolation). */
        part def AC_03_Schedulability_Violation_Rejection {
        }
        doc /* - **Given:** `Interconnect_1` referencing unmapped endpoint, or conflicting coordinates. - **When:** Validating coordinates and endpoints. - **Then:** Halts lowering, binds sentinel $``\bot_{\text{icd}}``$, and emits `E0200`. - **Diagnostic:** `E0200` on unmapped endpoint or collision. */
        part def AC_03_Unmapped_Subsystem_Endpoint_Collision_Rejection {
        }
        doc /* - **Given:** Ports with $\deg(p) \ge 1 \land \text{IsTerminated}(p)$ and missing `Endpoint_0`, separated by `;`. - **When:** Delimiter recovery on syntax and semantic faults. - **Then:** Emits `E0220` and `E0200`, resynchronizes, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0220`, `E0200`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Conflicting_Termination_Recovery {
        }
        doc /* - **Given:** Model `Package_0` with `Interconnect_1` in diagonal cell $``M_{ii}``$ before `;`. - **When:** Compiler encounters breach and resynchronizes. - **Then:** Recovers on `;`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0200`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Diagonal_Exclusion_Delimiter_Recovery {
        }
        doc /* - **Given:** Signals `Signal_Alpha` (divisor failsafe `0`) and `Signal_Beta` (missing `Port_Src`), separated by `;`. - **When:** Validating with delimiter error recovery. - **Then:** Emits `E0208` and `E0200`, resynchronizes, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0208`, `E0200`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Divisor_Hazard_Error_Recovery {
        }
        doc /* - **Given:** Flow referencing unmapped `Port_1`, separated by `;`. - **When:** Ingesting model and recovering across delimiters. - **Then:** Emits `E0200`, resynchronizes, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0200`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Endpoint_Fault_Delimiter_Recovery {
        }
        doc /* - **Given:** Circular routing between `Multiplexer_1` and `Multiplexer_2` before `;`. - **When:** Cycle detection and delimiter recovery execute. - **Then:** Emits `E0203`, recovers on `;`, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0203`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Multiplexing_Routing_Cycle_Delimiter_Recovery {
        }
        doc /* - **Given:** Model with an unresolvable type, direction conflict, and cyclic containment. - **When:** Port roster validation executes. - **Then:** Rejection emits `E0200` and `E0205`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0200`, `E0205`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Negative_Diagnostic_Rejection_Error_Recovery {
        }
        doc /* - **Given:** `Interconnect_1` connecting incompatible directions (`in` to `in`). - **When:** Validating port directionality. - **Then:** Halts lowering, binds sentinel $``\bot_{\text{icd}}``$, and emits `E0201`. - **Diagnostic:** `E0201` on port directionality violation. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Port_Directionality_Mismatch_Rejection {
        }
        doc /* - **Given:** Flow `Flow_0` referencing undeclared `Profile_Alpha`, separated by `;`. - **When:** Recovering across delimiter boundaries. - **Then:** Emits `E0200`, resynchronizes, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0200`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Profile_Resolution_Delimiter_Recovery {
        }
        doc /* - **Given:** Malformed flow followed by `;` and valid `Signal_Gamma`. - **When:** Parser encounters the syntax fault. - **Then:** Compiler emits `E0200`, resynchronizes at `;`, parses `Signal_Gamma`, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0200`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Resynchronization_Saturation_Recovery {
        }
        doc /* - **Given:** Connection `Connection_Alpha` referencing unmapped `Port_1` with delimiters (`;`, `}`). - **When:** Validating endpoint resolution and error recovery. - **Then:** Records `E0200` in $``\mathcal{D}_{\text{sink}}``$, recovers, and emits `E0199` at $``C_{\text{max\_errors}}``$. - **Diagnostic:** `E0200` on unmapped endpoint; `E0199` on error saturation. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Unmapped_Endpoint_Delimiter_Recovery {
        }
        doc /* - **Given:** Flow referencing missing `Port_Unknown` and flow with dimensional mismatch, separated by `;`. - **When:** Delimiter recovery on syntax and semantic faults. - **Then:** Emits `E0200` and `E0207`, resynchronizes on `;`, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0200`, `E0207`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Unresolved_Endpoint_Error_Recovery {
        }
        doc /* The ICD engine of Subsystem 8 SHALL construct the $N^2$ System Interface Matrix representing component interactions, placing internal identities on diagonal cells and directed contracts in off-diagonal cells. --- */
        part def _1_Normative_Statement {
        }
        doc /* Let $``\mathcal{V}_{\text{AST}}``$ denote AST entities and $``\mathcal{S}_{\text{intern}}``$ denote interned symbols. Interface matrix $``\mathbf{M}_{N^2}``$ satisfies: \begin{aligned} \mathbf{M}_{N^2}=\langle\mathcal{S},\text{Index},\mathbf{M},\mathcal{C},\Delta_{\mathbf{M}}\rangle,\;\mathcal{S}=\{S_1,\dots,S_N\}\subset\mathcal{V}_{\text{AST}} \\ \forall a\ne b,\;S_a\cap S_b=\emptyset,\;S_a\prec_{\text{lex}}S_b\iff\text{Index}(S_a)\lt\text{Index}(S_b) \\ M_{ii}=S_i,\;M_{ij}=\{c\in\mathcal{C}\mid\text{source}(c)\in S_i\land\text{target}(c)\in S_j\}\;(i\ne j) \\ \forall c\in M_{ij},\;p_{\text{src}}(c)\in\text{Ports}(S_i)\land p_{\text{tgt}}(c)\in\text{Ports}(S_j)\land\text{DirMatch}(p_{\text{src}},p_{\text{tgt}}) \\ (\text{source}(c)\notin\mathcal{S}\lor\text{target}(c)\notin\mathcal{S})\implies\text{Diagnostic}(c,\text{E0200})\land c\gets\bot_{\text{icd}} \\ \neg\text{DirMatch}(p_{\text{src}}(c),p_{\text{tgt}}(c))\implies\text{Diagnostic}(c,\text{E0201})\land c\gets\bot_{\text{icd}} \\ (a\ne b\land\text{Index}(S_a)=\text{Index}(S_b))\implies\text{Diagnostic}(\mathbf{M}_{N^2},\text{E0200}) \\ |\mathcal{D}_{\text{sink}}|\ge C_{\text{max\_errors}}\implies\text{Diagnostic}_{\text{term}}(\text{E0199})\in\mathcal{D}_{\text{sink}},\;\forall x,\Delta_x=\text{UUIDv5}(\text{OID}_{\text{DEAP}},\text{FQN}(x)) \end{aligned} --- */
        part def _2_Formal_Invariant {
            attribute mathbf_mathbf : String = "Interface matrix tuple and cell grid";
            attribute mathcal_text : String = "Subsystem roster and bijective index mapping";
            attribute M_mathcal : String = "Matrix cell and connection handles";
            attribute text_item : String = "Reciprocal port directionality predicate";
            attribute bot_mathcal : String = "Error sentinel and diagnostic sink";
            attribute Delta_x : String = "RFC 4122 UUIDv5 topological anchor";
        }
        doc /* - **Complexity Class:** Class $\mathbf{P}$ (Deterministic Polynomial Time). - **Asymptotic Bound:** $O(N^2 + |\mathcal{C}|)$ for $N=|\mathcal{S}|$ subsystems and $|\mathcal{C}|$ connections. Sparse indexing requires $O(N\log N + |\mathcal{C}|)$; dense export requires $O(N^2 + |\mathcal{C}|)$. Work-stealing executes in $``O((N^2 + |\mathcal{C}|)/N_{\text{max\_workers}} + \log N_{\text{max\_workers}})``$. Space is $O(N^2 + |\mathcal{C}|)$. - **Tractable Subclass & Frontier:** N/A (Deterministic P). Operates in polynomial time, avoiding NP-2 (REQ-0147) and NP-8 (REQ-0197) via relational indexing. --- */
        part def _3_Computational_Complexity_Algorithmic_Bounds {
        }
        part def _4_Verification_Conformance_Criteria {
        }
    }
    doc /* Downstream Specification Projections */
    package Subsystem_9_Downstream_Specification_Projections {
        doc /* UUIDv5: 7098189e-c5b3-5f42-91ba-3f9071e53e88 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / RFC 4122 | Diagnostics: E0199, E0300, E0301 */
        requirement def REQ_0159_Deterministic_RFC_4122_UUIDv5_Document_Anchors_for_Specification_Artifacts {
            id = "REQ-0159";
            text = "The projection engine UUIDv5_Engine_0 of Subsystem 9 SHALL inject deterministic RFC 4122 UUIDv5 anchors into frontmatter headers of emitted specification artifacts (Artifact_Alpha).";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: ee29aa4c-1bd3-5422-a59c-c7c02690d164 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / DAG Scheduling Specification | Diagnostics: E0199, E0300, E0302 */
        requirement def REQ_0160_Bottom_Up_Feature_First_Dependency_Ordering_and_DAG_Scheduling {
            id = "REQ-0160";
            text = "The downstream projection engine of Subsystem 9 SHALL schedule features in strict bottom-up topological order via Scheduler_1 over dependency DAG DependencyDAG_0 (G_{dep} = (F, E_{dep})), synthesizing leaf features before dependent composite features to eliminate forward reference gaps.";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: 62138c24-7491-5944-9c0b-c5775216cd2d | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Downstream Projection Contract | Diagnostics: E0199, E0300, E0303 */
        requirement def REQ_0161_Epics_Projection {
            id = "REQ-0161";
            text = "The projection engine of Subsystem 9 SHALL synthesize Epic specifications by partitioning models along top-level subsystem boundaries and projecting capability allocations.";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: 8fcd0f74-3160-5527-a581-e38bbfcdc2b9 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Downstream Projection Contract | Diagnostics: E0199, E0300, E0304 */
        requirement def REQ_0162_Epics_Projection {
            id = "REQ-0162";
            text = "The downstream engine of Subsystem 9 SHALL synthesize UML class and component architecture diagrams within Epic specifications using synthesizer Diagram_Alpha, streaming artifacts directly through ArtifactSink_0.";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: e4967cb4-af4b-58bb-bad9-ba3824ba3ee7 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 / KerML | Diagnostics: E0199, E0300, E0305 */
        requirement def REQ_0163_Epics_Projection {
            id = "REQ-0163";
            text = "Subsystem 9 projection engine SHALL synthesize macro statecharts and operational scenarios within Epic specifications.";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: 30be0357-f32d-5b49-a99b-ca931dc76215 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Downstream Projection Mandate | Diagnostics: E0199, E0300, E0306 */
        requirement def REQ_0164_Feature_Projection {
            id = "REQ-0164";
            text = "The projection engine of Subsystem 9 SHALL synthesize Feature specifications from the AST and enforce the 3-Layer Definition of Done (3-Layer DoD) via DoD_Validator_0.";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: de528a7b-8df8-5c7a-98c9-b6b4b21a5c7e | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 / KerML | Diagnostics: E0199, E0300, E0307 */
        requirement def REQ_0165_Feature_Layer_1 {
            id = "REQ-0165";
            text = "The projection engine of Subsystem 9 SHALL project Feature Layer 1 domain state and primitive structural typing specifications.";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: 868d7f06-19bf-52f1-91d4-2a1955f441f6 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / SysML v2 | Diagnostics: E0199, E0300, E0308 */
        requirement def REQ_0166_Feature_Layer_2 {
            id = "REQ-0166";
            text = "Subsystem 9 SHALL project Feature Layer 2 specifications for every classifier Feature_0.";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: 8dbd183f-84d4-51e9-913a-96ce1cba10ad | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / SysML v2 | Diagnostics: E0199, E0300, E0309 */
        requirement def REQ_0167_Feature_Layer_3 {
            id = "REQ-0167";
            text = "Subsystem 9 SHALL project Feature Layer 3 physical dynamics, Kirchhoff network laws, and conservative equations for every classifier Feature_0.";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: fc4a4f89-c48e-5b16-be29-9e6e0da32924 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Agile MBSE Projection | Diagnostics: E0199, E0300, E0310 */
        requirement def REQ_0168_User_Story_Projection {
            id = "REQ-0168";
            text = "Subsystem 9 SHALL project User Story specifications for feature Feature_0.";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: d4062e22-8bf8-5089-a292-0b299e469502 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / OMG SysML v2 / KerML | Diagnostics: E0199, E0300, E0311 */
        requirement def REQ_0169_Use_Case_Projection {
            id = "REQ-0169";
            text = "The downstream projection engine of Subsystem 9 SHALL project formal Use Case specifications from the compilation unit abstract syntax tree.";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: 53086ebc-88e9-53e3-8f0a-7cb244837862 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / MIL-STD-881E | Diagnostics: E0199, E0300, E0312 */
        requirement def REQ_0170_Engineering_Tasks_Projection {
            id = "REQ-0170";
            text = "Subsystem 9 SHALL project Engineering Tasks from AST definitions into a Work Breakdown Structure (WBS) rooted at WBS_0.";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: 2e7a3f47-ec5a-52f1-aa95-fc71295b9d79 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / SysML v2 | Diagnostics: E0199, E0300, E0313 */
        requirement def REQ_0171_Downstream_Synchronization_Engine {
            id = "REQ-0171";
            text = "Subsystem 9 SHALL perform bidirectional incremental AST patching and synchronization via SyncEngine_Alpha across upstream AST models and downstream projections against base AST T_{base}.";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: bf107d67-ba84-5f40-8b1b-fb07469a4c51 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / SysML v2 | Diagnostics: E0199, E0300, E0314 */
        requirement def REQ_0172_Bidirectional_Traceability_Link_Invalidation {
            id = "REQ-0172";
            text = "Subsystem 9 SHALL maintain bidirectional traceability across AST entities and projected artifacts, executing cascade Cascade_1 over TraceGraph_Alpha (G_{trace} = (V, E_{trace})) upon AST mutation.";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: 5610bc93-aa9a-5813-88b1-38379aee5188 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Downstream Projection Mandate | Diagnostics: E0199, E0300, E0315 */
        requirement def REQ_0173_Automated_Conflict_Resolution_Policies_for_Upstream_Downstream_Divergence {
            id = "REQ-0173";
            text = "The projection engine of Subsystem 9 SHALL reconcile divergence between upstream AST models and downstream projections via ConflictResolver_Alpha.";
            satisfy by AgileProjectionEngine;
        }
        doc /* UUIDv5: a375490a-a035-519d-a417-212d22faeb53 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Cryptographic Manifest Ledger | Diagnostics: E0199, E0300, E0316 */
        requirement def REQ_0174_Specification_Manifest_Generation {
            id = "REQ-0174";
            text = "The downstream projection engine of Subsystem 9 SHALL synthesize a specification manifest (Manifest_Alpha) and verification ledger (HashLedger_0) covering all emitted artifacts (A).";
            satisfy by AgileProjectionEngine;
        }
        doc /* Primary execution engine for Downstream Specification Projections */
        part def AgileProjectionEngine {
            port in icd_in : ICDPort;
            port out specs_out : BacklogPort;
        }
        doc /* - **Given:** Base $``T_{\text{base}}``$ with upstream addition of `Classifier_Alpha` in `Package_0` and downstream update of `param_x : Real` on `Port_1`. - **When:** `SyncEngine_Alpha` computes diff `ASTDiff_0` and applies patch `Patch_1`. - **Then:** Reconciles edits into $``T_{\text{merged}}``$ preserving all modifications. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_3_Way_AST_Diff_and_Non_Conflicting_Patch_Application {
        }
        doc /* - **Given:** Model `Package_0` declaring subsystem `Classifier_Alpha` with parts `Node_0` and `Node_1`. - **When:** Synthesizing architecture diagrams via `Diagram_Alpha`. - **Then:** Emits valid UML class and component Mermaid diagrams. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Architecture_Diagram_Synthesis {
        }
        doc /* - **Given:** DAG with leaves `Feature_Leaf_A`, `Feature_Leaf_B` and composite `Feature_Composite_C`. - **When:** Scheduling via `Scheduler_1`. - **Then:** Confirms $``\text{Order}(\text{Feature\_Leaf\_A}) < \text{Order}(\text{Feature\_Composite\_C})``$ and $``\text{Order}(\text{Feature\_Leaf\_B}) < \text{Order}(\text{Feature\_Composite\_C})``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Bottom_Up_Feature_Ordering {
        }
        doc /* - **Given:** `Package_0` with `Property_1 : PrimitiveType_0` ($[0, 100]$, default $25$, unit $\mathbf{0}$, `Configurable`) and `Property_2 : Real` ($[0.0, 50.0]$, default $10.0$, unit $\text{m/s}$, `ReadOnly`). - **When:** Lowering Feature Layer 1. - **Then:** Projects attributes into Layer 1 with valid types and envelopes. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Domain_State_and_Structural_Typing {
        }
        doc /* - **Given:** Graph `TraceGraph_Alpha` with `Classifier_Alpha` (`DirtyNode_0`) linked to `Artifact_Alpha`. - **When:** Mutating `DirtyNode_0` and triggering `Cascade_1`. - **Then:** Traverses edges via BFS, marking `Classifier_Alpha` and `Artifact_Alpha` dirty. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Forward_and_Backward_Dirty_Cascade {
        }
        doc /* - **Given:** AST with package `Package_0` and entity `Classifier_Alpha` (`Node_0`). - **When:** Lowering `Artifact_Alpha` via `UUIDv5_Engine_0`. - **Then:** Emitted frontmatter `id` matches RFC 4122 UUIDv5 with $\text{Version} = 5$ and $\text{Variant} = 2$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Frontmatter_UUIDv5_Injection {
        }
        doc /* - **Given:** Feature `Feature_0` with network `KirchhoffNetwork_Alpha`, junctions `Junction_0`, `Junction_1`, and balanced flows `Flow_1`, `Flow_2`. - **When:** Lowering Feature Layer 3 projections. - **Then:** Lowers network graph into arena storage with balanced equations. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Kirchhoff_Network_Lowering {
        }
        doc /* - **Given:** State machine in `Package_0` with states `State_0`, `State_1`. - **When:** Synthesizing macro statechart `MacroStatechart_Alpha`. - **Then:** Collapses micro-steps, projects transitions, and emits Mermaid `stateDiagram-v2`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Macro_Statechart_Projection {
        }
        doc /* - **Given:** Model with specification artifacts (`Artifact_Alpha`) in `Package_0`. - **When:** Lowering `Manifest_Alpha` and `HashLedger_0`. - **Then:** Emits relative paths, sizes, digests (`Digest_1`), root hash $``H_{\text{root}}``$, and UUIDv5 anchors. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Manifest_and_Cryptographic_Ledger_Generation {
        }
        doc /* - **Given:** `Package_0` declaring `UseCase_Alpha` with actor `Actor_0`, precondition `Precondition_1`, primary scenario `Scenario_0` with steps $``\langle \text{Step}_0, \text{Step}_1 \rangle``$, and postcondition `Postcondition_1`. - **When:** Projecting use case specifications. - **Then:** Projects `UseCase_Alpha` with verified step order and actor associations. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Use_Case_and_Primary_Success_Path_Projection {
        }
        doc /* - **Given:** Feature `Feature_0` with `UserStory_Alpha` (`Persona_0`, `Action_0`, value $100.0$, `MustHave`). - **When:** Lowering User Story specifications. - **Then:** Formalizes narrative, assigns MoSCoW rank 1, and passes. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_User_Story_Lowering {
        }
        doc /* - **Given:** Feature `Feature_0` task `Task_0` containing leaves `Task_Alpha` ($h = 8.0$) and `Task_Beta` ($h = 16.0$) with `DoD_Criteria_0`. - **When:** Lowering tasks and synthesizing WBS hierarchy. - **Then:** Projects `WBS_0` with effort $``h_{\text{Task\_0}} = 24.0``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_WBS_Task_Hierarchy_and_Effort_Projection {
        }
        doc /* - **Given:** Base $B$ in `Package_0`, edit $U$ on `Element_0`, and edit $D$ on disjoint `Element_1` under `Policy_1`. - **When:** Lowering through `ConflictResolver_Alpha`. - **Then:** Reconciles mutations into $``M_{\text{resolved}}``$, preserving both edits. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Disjoint_Non_Conflicting_3_Way_Divergence_Resolution {
        }
        doc /* - **Given:** Feature `Feature_Alpha` in `Package_0` declaring valid `Layer_1`, `Layer_2`, and `Layer_3`. - **When:** Lowering feature through `DoD_Validator_0`. - **Then:** Confirms $``\text{DoD}(\text{Feature\_Alpha}) \equiv \text{true}``$ and emits artifact. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Full_3_Layer_Feature_Conformance {
        }
        doc /* - **Given:** Feature `Feature_0` with operation `Operation_Alpha` and machine `StateMachine_0`. - **When:** Lowering Feature Layer 2 specifications. - **Then:** Formalizes signature $op$ and transition $t$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Operation_Signature_and_Statechart_Lowering {
        }
        doc /* - **Given:** Subsystem `Subsystem_0` with `Part_0`, `Port_0` ($D = 3$), and `Capability_0`. - **When:** Lowering Epic `Epic_Alpha`. - **Then:** Emits `Epic_Alpha` with structural tree, capability table, and UUIDv5 anchors. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Structural_Decomposition_and_Capability_Projection {
        }
        doc /* - **Given:** Use case `UseCase_Alpha` declaring alternate extension `Extension_0` branching from `Step_0` under guard $``g_{\text{alt}}``$ and resuming at `Step_1`. - **When:** Validating scenario branching topology and step anchors. - **Then:** Confirms anchor `Step_0` and resumption step `Step_1` reside in `Scenario_0`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Alternate_Extension_Branching_and_Resumption_Boundary {
        }
        doc /* - **Given:** Artifact `Artifact_0` of $16\text{ MB}$ within $10^4$ artifacts. - **When:** Computing digests and aggregating ledger entries. - **Then:** Processes artifacts within $O(|\mathcal{A}| \cdot \text{size})$ bounds without memory exhaustion. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Boundary_Artifact_Size_and_Large_Manifest_Scaling {
        }
        doc /* - **Given:** Minimal feature `Feature_Beta` with single attribute, transition, and interface binding. - **When:** Evaluating layer non-emptiness. - **Then:** Confirms $``\text{IsEmpty}(\text{Layer}_\ell) \equiv \text{false}``$ for $\ell \in \{1, 2, 3\}$ and passes. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Boundary_Layer_Completeness {
        }
        doc /* - **Given:** Leaf `Task_Alpha` with minimum effort $h = 0.5$ and criterion `DoD_Criteria_0`. - **When:** Validating effort boundaries and DoD completeness. - **Then:** Confirms $h \gt 0$, validates DoD satisfaction, and lowers task. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Boundary_Leaf_Task_Allocation_and_Minimum_Effort {
        }
        doc /* - **Given:** AST node with canonical path length $L = 4096$ bytes. - **When:** Computing SHA-1 compression and bitwise masks. - **Then:** Processes 65 blocks, emitting canonical 36-character hyphenated UUIDv5. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Boundary_Path_Length_Conformance {
        }
        doc /* - **Given:** Base $B$ attribute `param_x : Real` on `Element_0`, with identical edits in $U$ and $D$. - **When:** Evaluating convergent divergence under `Policy_1`. - **Then:** Confirms $U(e) = D(e)$ and merges mutation into $``M_{\text{resolved}}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Convergent_Concurrent_Mutation_Boundary {
        }
        doc /* - **Given:** Ready queue with leaves `Feature_Beta`, `Feature_Alpha`, `Feature_Gamma` ($\text{deg}^{-} = 0$). - **When:** Scheduling across repeated runs. - **Then:** Extracts candidates in ascending lexicographical order (`Feature_Alpha`, `Feature_Beta`, `Feature_Gamma`) with 0-byte diff churn. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Deterministic_Lexicographical_Tie_Breaking {
        }
        doc /* - **Given:** Stories across `MustHave`, `ShouldHave`, `CouldHave`, `WontHave` in arbitrary order. - **When:** Sorting catalog sequence $``\prec_{\text{proj}}``$. - **Then:** Orders stories by MoSCoW rank with value tie-breaking. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Deterministic_MoSCoW_Ordering {
        }
        doc /* - **Given:** Loop $C$ in `KirchhoffNetwork_Alpha` with three flows whose potential drops sum to zero. - **When:** Validating cycle potential balance. - **Then:** Confirms potential conservation across cycle $C$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Fundamental_Cycle_Potential_Balance_Boundary {
        }
        doc /* - **Given:** Synchronized tree $``T_{\text{merged}}``$ with base $``T_{\text{base}} = T_{\text{merged}}``$. - **When:** `SyncEngine_Alpha` computes diff across identical trees. - **Then:** Generates empty diff $\Delta = \emptyset$ with 0-byte state churn. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Idempotent_Patch_Re_Application_Boundary {
        }
        doc /* - **Given:** Artifact `Artifact_Gamma` with edges from mutated `DirtyNode_0` and clean `Classifier_Beta`. - **When:** Executing cascade invalidation across multiple passes. - **Then:** Marks `Artifact_Gamma` dirty on initial visit, skipping redundant passes with zero diff churn. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Multi_Parent_Convergence_and_Idempotent_Traversal {
        }
        doc /* - **Given:** Feature `Feature_Alpha` attribute `Property_Alpha` with envelope $[0.0, 100.0]$ and default $``v_{\text{default}} = 100.0``$. - **When:** Validating range containment. - **Then:** Confirms $``v_{\min} \le v_{\text{default}} \le v_{\max}``$ holds at boundary. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Operational_Range_Boundary_Conformance {
        }
        doc /* - **Given:** Path from `State_0` to `State_1` on `Event_0` with guard `Guard_0`. - **When:** Synthesizing operational scenario `Scenario_0`. - **Then:** Validates step sequence and verifies disjoint guards. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Operational_Scenario_Step_Verification {
        }
        doc /* - **Given:** Model with 5 subsystems and 50 capabilities (10 per subsystem). - **When:** Partitioning capabilities across Epics. - **Then:** Confirms $``\bigcup_{k=0}^4 E_k = \mathcal{M}_{\text{capabilities}}``$ and $``\forall i \ne j, E_i \cap E_j = \emptyset``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Partition_Completeness_and_Disjointness {
        }
        doc /* - **Given:** Machine `StateMachine_0` with initial state `State_Init` and transition $``t_{\text{init}}``$ ($\epsilon$). - **When:** Validating initial state topology. - **Then:** Confirms single outgoing transition from `State_Init` and lowers $``t_{\text{init}}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Pseudostate_and_Spontaneous_Transition_Boundary {
        }
        doc /* - **Given:** Epic specification with artifact size $|A| \ge 10\text{ MB}$. - **When:** Streaming chunks through `ArtifactSink_0` with threshold $``B_{\text{max\_chunk\_size}} = 64\text{ KB}``$. - **Then:** Confirms resident memory satisfies $``M_{\text{sink}} \le 64\text{ KB} \in O(1)``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Streaming_Artifact_Sink_Memory_Invariant {
        }
        doc /* - **Given:** Capability `Capability_Alpha` unallocated or mapped to `Subsystem_0` and `Subsystem_1`. - **When:** Validating allocation partitions. - **Then:** Rejects model, emits `E0303`, and binds sentinel $``\bot_{\text{epic}}``$. - **Diagnostic:** `E0303` (CapabilityAllocationViolation). */
        part def AC_03_Allocation_Violation_Rejection {
        }
        doc /* - **Given:** Forward edge $``(u, v) \in E_{\text{fwd}}``$ lacking reciprocal edge $``(v, u) \in E_{\text{bwd}}``$. - **When:** Verifying link symmetry during cascade initialization. - **Then:** Rejects asymmetric link, binds sentinel $``\bot_{\text{link}}``$, and emits `E0314`. - **Diagnostic:** `E0314` (TraceabilityLinkInvalidationViolation). */
        part def AC_03_Asymmetric_Traceability_Link_Rejection {
        }
        doc /* - **Given:** Base node `Classifier_Alpha` where upstream sets `param_x = 10.0` and downstream sets `param_x = 20.0`. - **When:** `SyncEngine_Alpha` evaluates 3-way merge rules. - **Then:** Fails closed, emits `E0313`, and binds sentinel $``\bot_{\text{patch}}``$. - **Diagnostic:** `E0313` (SynchronizationConflictViolation). */
        part def AC_03_Concurrent_Conflicting_Modification_Rejection {
        }
        doc /* - **Given:** Conflicting edits to `param_x` on `Element_0` across $U$ and $D$ under `Policy_Alpha`. - **When:** Resolving conflicting divergence. - **Then:** Fails closed, emits diagnostic `E0315`, and binds sentinel $``\bot_{\text{resolve}}``$. - **Diagnostic:** `E0315` (DivergenceConflictViolation). */
        part def AC_03_Contradictory_Divergence_Rejection_and_Sentinel_Binding {
        }
        doc /* - **Given:** Dependency cycle between `Feature_Alpha` and `Feature_Beta`. - **When:** Evaluating cycle detection. - **Then:** Rejects cyclic nodes, emits `E0302` with cycle path, and binds sentinel $``\bot_{\text{sched}}``$. - **Diagnostic:** `E0302` (CyclicFeatureDependency). */
        part def AC_03_Cyclic_Dependency_Detection_and_Rejection {
        }
        doc /* - **Given:** `UseCase_Alpha` where `Extension_0` specifies unresolvable anchor `Step_Missing` or null precondition $``P_{\text{pre}} = \bot``$. - **When:** Validating step connectivity and branch invariants. - **Then:** Rejects flow, binds sentinel $``\bot_{\text{uc}}``$, and emits diagnostic `E0311`. - **Diagnostic:** `E0311` (AlternateExtensionViolation). */
        part def AC_03_Dangling_Extension_Anchor_and_Flow_Rejection {
        }
        doc /* - **Given:** Task `Task_Alpha` with empty DoD or placeholder `"TODO"`. - **When:** Validating Definition of Done completeness. - **Then:** Fails closed, emits `E0312`, and binds sentinel $``\bot_{\text{task}}``$. - **Diagnostic:** `E0312` (TaskDefinitionOfDoneViolation). */
        part def AC_03_Definition_of_Done_Violation_and_Placeholder_Rejection {
        }
        doc /* - **Given:** Feature `Feature_Gamma` lacking `Layer_3`. - **When:** Evaluating structural completeness. - **Then:** Fails closed, emits `E0300`, and binds sentinel $``\bot_{\text{layer}}``$. - **Diagnostic:** `E0300` (Feature Definition of Done violation). */
        part def AC_03_Empty_Layer_Rejection {
        }
        doc /* - **Given:** Story `UserStory_Beta` with invalid priority `MaybeHave` or negative metric $-5.0$. - **When:** Validating priority and business value. - **Then:** Fails closed, binds sentinel $``\bot_{\text{story}}``$, emitting `E0310`. - **Diagnostic:** `E0310` (PriorityClassificationViolation). */
        part def AC_03_Invalid_Priority_Rejection {
        }
        doc /* - **Given:** Network `KirchhoffNetwork_Alpha` with junction `Junction_0` having flow imbalance ($``f_{\text{in}} \ne f_{\text{out}}``$). - **When:** Validating Kirchhoff flow conservation. - **Then:** Rejects junction, emits `E0309`, and binds sentinel $``\bot_{\text{junction}}``$. - **Diagnostic:** `E0309` (KirchhoffFlowConservationViolation). */
        part def AC_03_Non_Zero_Junction_Divergence_Rejection {
        }
        doc /* - **Given:** Diagram referencing an edge to dangling endpoint `Node_1` lacking AST backing. - **When:** Enforcing diagram soundness. - **Then:** Fails closed, emits `E0300`, and binds sentinel $``\bot_{\text{diag}}``$. - **Diagnostic:** `E0300` (PhantomDiagramEdgeViolation). */
        part def AC_03_Phantom_Diagram_Edge_and_Dangling_Endpoint_Rejection {
        }
        doc /* - **Given:** Feature `Feature_0` attribute `Property_1` with inverted range $[100, 50]$ or default $150 \notin [0, 100]$. - **When:** Validating interval containment. - **Then:** Rejects attribute, binds sentinel $``\bot_{\text{attr}}``$, emitting `E0307`. - **Diagnostic:** `E0307` (RangeConstraintViolation). */
        part def AC_03_Range_Envelope_and_Default_Value_Violation_Rejection {
        }
        doc /* - **Given:** Macro transition asserted without a realizing AST path. - **When:** Verifying reachability and bisimulation. - **Then:** Fails closed, emits diagnostic `E0300`, and binds sentinel $``\bot_{\text{macro}}``$. - **Diagnostic:** `E0300` (MacroReachabilityBisimulationViolation). */
        part def AC_03_Reachability_and_Bisimulation_Violation_Rejection {
        }
        doc /* - **Given:** Node with host-absolute path or pseudo-random `UUIDv4`. - **When:** Validating frontmatter anchors. - **Then:** Fails closed, emits `E0300` or `E0301`, and binds $``\bot_{\text{anchor}}``$. - **Diagnostic:** `E0300`, `E0301`. */
        part def AC_03_Rejection_of_Malformed_Paths_and_Banned_UUIDs {
        }
        doc /* - **Given:** Ledger `HashLedger_0` where `Artifact_Alpha` is modified by 1 byte. - **When:** Validating manifest integrity. - **Then:** Fails closed, emits `E0316` (`HashVerificationMismatch`), and binds sentinel $``\bot_{\text{ledger}}``$. - **Diagnostic:** `E0316`. */
        part def AC_03_Tamper_Detection_and_Hash_Mismatch_Rejection {
        }
        doc /* - **Given:** Transition $``t_1``$ with guard typing to `Real`, or parameter type error. - **When:** Type checking transition guards and signatures. - **Then:** Fails closed, emits `E0308`, and binds sentinel $``\bot_{\text{trans}}``$ or $``\bot_{\text{op}}``$. - **Diagnostic:** `E0308` (TypeMismatchViolation). */
        part def AC_03_Type_Mismatch_and_Non_Boolean_Guard_Rejection {
        }
        doc /* - **Given:** Malformed link referencing `Node_Missing`, delimiter `;`, and valid `Link_0`. - **When:** Delimiter error recovery processes tokens. - **Then:** Emits `E0300`, recovers across `;`, parses `Link_0`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Dangling_Endpoint_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Subsystem `Subsystem_0` with cyclic nesting ($> D$) and undeclared targets, separated by `;`. - **When:** Delimiter recovery processes faults. - **Then:** Emits `E0300` and `E0303`, recovers on `;`, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0303`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Decomposition_Cycle_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Malformed model with invalid statements separated by `;` and `|`. - **When:** Recovering across delimiter boundaries. - **Then:** Emits `E0300` and `E0301`, resynchronizing until $``C_{\text{max\_errors}}``$ emits `E0199`. - **Diagnostic:** `E0300`, `E0301`, `E0199`. */
        part def AC_04_Delimiter_Synchronization_Token_Error_Recovery {
        }
        doc /* - **Given:** Composite `Task_0` with effort mismatch ($h = 30.0 \ne 24.0$), child referencing `Task_Missing`, delimiter `;`, and valid `Task_Beta`. - **When:** Recovering across delimiters on invalid tasks. - **Then:** Emits `E0300` and `E0312`, binds sentinels $``\bot_{\text{task}}``$, recovers across `;`, parses `Task_Beta`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0312`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Hierarchy_Disconnect_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Scenario referencing ungrounded `State_Undefined`, delimited by `;`. - **When:** Executing delimiter recovery. - **Then:** Emits `E0305`, resynchronizes, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0305`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Inconsistent_Scenario_Trace_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Artifact with absolute path `"/opt/spec.md"`, delimiter `|`, and `Artifact_Beta`. - **When:** Recovering across delimiter boundaries. - **Then:** Emits `E0300`, recovers on `|`, parses `Artifact_Beta`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Malformed_Relative_Path_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Record `Divergence_0` violating typing, delimiter `;`, and valid `Divergence_1`. - **When:** Executing delimiter recovery across `;`. - **Then:** Emits `E0300`, binds $``\bot_{\text{resolve}}``$, resynchronizes across `;`, parses `Divergence_1`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. */
        part def AC_04_Malformed_Schema_Record_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Story missing persona, delimiter `;`, and valid `UserStory_Beta`. - **When:** Delimiter recovery resynchronizes across tokens. - **Then:** Emits `E0300`, binds $``\bot_{\text{story}}``$, parses `UserStory_Beta`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Missing_Persona_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Reference to missing `Feature_Missing` followed by `;` and `Feature_Alpha`. - **When:** Delimiter error recovery processes tokens. - **Then:** Emits `E0300`, recovers on `;`, parses `Feature_Alpha`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Missing_Prerequisite_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Feature declaring `Property_1` with unit vector $\mathbf{u} \notin \mathbb{Q}^7$, delimiter `;`, and valid `Property_2`. - **When:** Encountering dimensional incompatibility. - **Then:** Emits `E0300`, binds $``\bot_{\text{dim}}``$, recovers across `;`, parses `Property_2`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Physical_Dimension_Mismatch_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Write fault on `ArtifactSink_0` and syntax faults separated by `;`. - **When:** Delimiter error recovery processes faults. - **Then:** Emits `E0304`, binds $``\bot_{\text{sink}}``$, halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0304`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Streaming_Sink_Write_Failure_and_Error_Recovery {
        }
        doc /* - **Given:** Patch with cycle in `Package_0`, delimiter `;`, and valid `Port_1`. - **When:** Structural validation detects cycle and recovers across `;`. - **Then:** Emits `E0300`, binds sentinel $``\bot_{\text{patch}}``$, resumes on `Port_1`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Structural_Cycle_Violation_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Feature `Feature_Delta` with placeholder `TODO` in `Layer_2`, delimiter `;`, and valid `Feature_Epsilon`. - **When:** Delimiter recovery processes `Feature_Delta`. - **Then:** Emits `E0306`, recovers on `;`, validates `Feature_Epsilon`, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0306`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Unbound_Placeholder_Rejection_and_Error_Recovery {
        }
        doc /* - **Given:** Flow `Flow_1` referencing undefined `Junction_Missing`, delimiter `;`, and valid `Flow_2`. - **When:** Recovering across statement delimiters. - **Then:** Emits `E0300`, binds $``\bot_{\text{flow}}``$, lowers `Flow_2`, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Unmapped_Junction_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Transition $``t_2``$ referencing `State_Missing`, then `;` and `Operation_Alpha`. - **When:** Delimiter recovery resynchronizes across statement tokens. - **Then:** Emits `E0300`, binds $``\bot_{\text{trans}}``$, lowers `Operation_Alpha`, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. */
        part def AC_04_Unmapped_State_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Use case referencing undeclared actor `Actor_Missing`, followed by delimiter `;` and valid `UseCase_Beta`. - **When:** Lowering use case actors with delimiter recovery enabled. - **Then:** Emits `E0300`, binds $``\bot_{\text{uc}}``$, recovers across `;`, projects `UseCase_Beta`, and halts at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Unresolved_Actor_Reference_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Model with $10^4$ artifacts across $``N_{\text{max\_workers}}``$ threads. - **When:** Compiling repeatedly under Release mode (`--release`). - **Then:** Emits 0-byte diff churn; latency $< 25\text{ ms}$, RSS $< 100\text{ MB}$. - **Diagnostic:** Diagnostic sink remains empty. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_05_Bitwise_Determinism_Release_Performance {
        }
        doc /* - **Given:** Model with $``|C_{\text{diff}}| = 10^4``$ diff elements evaluated across $``N_{\text{max\_workers}}``$ threads. - **When:** Benchmarking in Release mode (`--release`). - **Then:** Emits identical UUIDv5 anchors; latency $< 25\text{ ms}$, peak RSS $< 100\text{ MB}$. - **Diagnostic:** Diagnostic sink remains empty. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_05_Deterministic_UUIDv5_Anchors_and_Release_Performance_Bounds {
        }
        doc /* - **Given:** $10^4$ elements across $``N_{\text{max\_workers}}``$ threads. - **When:** Lowering Layer 2 projections in Release mode (`--release`). - **Then:** Generates identical UUIDv5 anchors; latency $< 25\text{ ms}$, RSS $< 100\text{ MB}$. - **Diagnostic:** Diagnostic sink remains empty. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_05_UUIDv5_Determinism_and_Release_Performance_Bounds {
        }
        doc /* The projection engine `UUIDv5_Engine_0` of Subsystem 9 SHALL inject deterministic RFC 4122 UUIDv5 anchors into frontmatter headers of emitted specification artifacts (`Artifact_Alpha`). The pipeline MUST enforce: 1. **Canonical Topological Path**: For node $v$ (`Node_0`), the engine SHALL construct canonical path $``\mathcal{N}_{\text{topological}}(v) = p_0 \mathbin{::} \dots \mathbin{::} \text{Name}(v)``$ in `Package_0`. Paths MUST be environmental-invariant, omitting host paths and timestamps. Malformed paths emit `E0300`, bind sentinel $``\bot_{\text{anchor}}``$, and halt. 2. **RFC 4122 Hashing and Masking**: The engine SHALL compute SHA-1 over namespace `Namespace_1` ($``\text{NS}_{\text{DEAP}}``$) and UTF-8 path bytes, masking digest bytes to enforce Version 5 ($``u_6 \operatorname{AND} 0\text{x0F} \mathbin{|} 0\text{x50}``$) and Variant ($``u_8 \operatorname{AND} 0\text{x3F} \mathbin{|} 0\text{x80}``$). 3. **Frontmatter Schema**: Artifacts SHALL declare fields `id` (36-character hyphenated UUIDv5), `fqn`, `artifact_type`, `ast_handle`, and `digest`. Time-based (v1/v6/v7) and pseudo-random (v4) UUIDs are strictly prohibited; non-deterministic UUIDs emit `E0301`. 4. **Bijective Invariance**: Canonical path to UUIDv5 mapping MUST be bijective, ensuring 0-byte diff churn across regenerations. 5. **Directives**: UUIDv5 anchors (Directive 1); work-stealing ceiling $``N_{\text{max\_workers}}``$ (Directive 2); symbol interning for tokens and frontmatter keys (`id`, `fqn`, `digest`) (Directive 3); recovery on `;` and `|` halting at $``C_{\text{max\_errors}}``$ with `E0199` (Directive 4); Release budget ($< 25\text{ ms}$ for $10^4$ artifacts, $< 100\text{ MB}$) (Directive 5). Placeholders (`Package_0`, `Classifier_Alpha`, `UUIDv5_Engine_0`, `Namespace_1`, `Artifact_Alpha`, `Node_0`, `param_x : Real`) used. --- */
        part def _1_Normative_Statement {
        }
        doc /* The canonical path structure, SHA-1 digest masking, and diagnostic triggers satisfy: \begin{aligned} \mathcal{N}_{\text{topological}}(v)&=p_0\mathbin{::}p_1\mathbin{::}\dots\mathbin{::}\text{Name}(v) \\ H(v)&=\text{SHA1}(\text{NS}_{\text{DEAP}}\mathbin{\Vert}\text{Bytes}(\mathcal{N}_{\text{topological}}(v)))=(h_0,\dots,h_{19}) \\ u_i&=h_i\;(\forall i\notin\{6,8\}),\quad u_6=(h_6\operatorname{AND}0\text{x0F})\mathbin{|}0\text{x50},\quad u_8=(h_8\operatorname{AND}0\text{x3F})\mathbin{|}0\text{x80} \\ U(v)&=(u_0,\dots,u_{15})\in(\mathbb{Z}_{256})^{16},\quad\text{Version}(U(v))=5,\quad\text{Variant}(U(v))=2 \\ \mathcal{N}_{\text{topological}}(v_1)=\mathcal{N}_{\text{topological}}(v_2)&\iff U(v_1)=U(v_2) \\ \neg\text{IsValidPath}(\mathcal{N}_{\text{topological}}(v))&\implies\text{Diagnostic}(v,\text{E0300})\in\mathcal{D}_{\text{sink}}\land\text{Anchor}(v)\gets\bot_{\text{anchor}} \\ (\text{Version}(U(v))\ne 5\lor\text{IsNonDeterministic}(U(v)))&\implies\text{Diagnostic}(v,\text{E0301})\in\mathcal{D}_{\text{sink}}\land\text{Anchor}(v)\gets\bot_{\text{anchor}} \\ |\mathcal{D}_{\text{sink}}| \ge C_{\text{max\_errors}}&\implies\text{Diagnostic}(\text{E0199})\in\mathcal{D}_{\text{sink}} \end{aligned} --- */
        part def _2_Formal_Invariant {
            attribute mathcal : String = "Canonical topological path string of AST node $v$";
            attribute text_H : String = "Namespace UUID constant and 160-bit SHA-1 digest";
            attribute U_text_text : String = "128-bit UUIDv5 octets, Version 5, and Variant 2 fields";
            attribute bot_mathcal_C : String = "Anchor sentinel, diagnostic sink, and error limit";
        }
        doc /* - **Complexity Class:** Class $\mathbf{P}$ (Deterministic Polynomial Time). - **Asymptotic Bound:** $O(|V|)$ SHA-1 UUIDv5 generation over AST nodes $V$. Single-artifact hashing evaluates in $O(L)$ time for path length $L$. Work-stealing across $``N_{\text{max\_workers}}``$ threads scales as $``O((|V| + L_{\text{total}}) / N_{\text{max\_workers}} + \log N_{\text{max\_workers}})``$. Arena memory is $O(|V|)$. - **Tractable Subclass & Frontier:** N/A (Deterministic P). Closed-form UUIDv5 hashing bypasses NP-1 temporal networks (REQ-0117), NP-2 bin packing (REQ-0147), and NP-8 SMT solving (REQ-0197). --- */
        part def _3_Computational_Complexity_Algorithmic_Bounds {
        }
        part def _4_Verification_Conformance_Criteria {
        }
    }
    doc /* Multi-Target Code Generation, Simulation & Transport Bindings */
    package Subsystem_10_Multi_Target_CodeGen_Simulation_Bindings {
        doc /* UUIDv5: 9baa4e7e-60b7-59a0-884d-fac25daeeb27 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / SSA CFG Specification | Diagnostics: E0199, E0300, E0501 */
        requirement def REQ_0175_LUMI_Intermediate_Representation {
            id = "REQ-0175";
            text = "The backend of Subsystem 10 SHALL lower actions, statecharts, and constraints into SSA representation LumiIR_Alpha.";
            satisfy by CodeGenEngine;
        }
        doc /* UUIDv5: 542e1b16-3772-5fed-9db9-307fe84b96e2 | Complexity: Class P (O( | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / LUMI Spec | Diagnostics: E0199, E0300, E0502 */
        requirement def REQ_0176_LUMI_IR_Memory_Semantics {
            id = "REQ-0176";
            text = "Subsystem 10 SHALL enforce value semantics, typed slots, immutable SSA bindings, and state transformers for MemoryModel_Alpha.";
            satisfy by CodeGenEngine;
        }
        doc /* UUIDv5: a2e0a9c0-8fa3-5c75-9f53-d4e627171d97 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0199, E0300, E0503 */
        requirement def REQ_0177_Streaming_Artifact_Sink_Interface {
            id = "REQ-0177";
            text = "The emission engine of Subsystem 10 SHALL stream code artifacts (A) through writer sinks (WriterSink_Alpha) via StreamEmitter_1. Monolithic file accumulation is strictly prohibited.";
            satisfy by CodeGenEngine;
        }
        doc /* UUIDv5: 8d1c29ff-a23a-5634-9d97-191858a85bfa | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0199, E0300, E0504 */
        requirement def REQ_0178_Manifest_Driven_File_Persistence_with_XXH3_Content_Fingerprinting {
            id = "REQ-0178";
            text = "The persistence engine of Subsystem 10 SHALL persist artifacts (A) through manifest CodegenManifest_Alpha via fingerprint ArtifactFingerprint_0 using XXH3 hashing.";
            satisfy by CodeGenEngine;
        }
        doc /* UUIDv5: f8d9d6f7-1f07-5aa2-ab56-93e201d50e63 | Complexity: Class P (O(n) state update per timestep) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Continuous-Time Solvers | Diagnostics: E0199, E0300, E0505 */
        requirement def REQ_0179_Continuous_Time_Numerical_Solvers {
            id = "REQ-0179";
            text = "The simulation engine of Subsystem 10 SHALL synthesize discrete fixed-step Forward Euler blocks (EulerSolver_Alpha) for continuous dynamical models (Package_0::Classifier_Alpha).";
            satisfy by CodeGenEngine;
        }
        doc /* UUIDv5: 6dff0df6-5f33-5e14-ae03-0c52044797d4 | Complexity: NP-Hard (NP-7 Register Allocation & DAG Scheduling) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / Chaitin-Briggs Coloring / Critical-Path Scheduling | Diagnostics: E0199, E0300, E0506 */
        requirement def REQ_0180_Register_Allocation {
            id = "REQ-0180";
            text = "Subsystem 10 SHALL execute register allocation and instruction scheduling over LUMI IR basic blocks (Block_0).";
            satisfy by CodeGenEngine;
        }
        doc /* UUIDv5: 224d57ed-4322-5a65-9d21-c3009c71e11a | Complexity: Class P (O(n^2) state-space, O(n) RK4) | Standard: IEEE 29148-2018 / RFC 2119 / SysML v2 | Diagnostics: E0199, E0300, E0507 */
        requirement def REQ_0181_Linear_State_Space_Matrix_Evaluation {
            id = "REQ-0181";
            text = "Subsystem 10 SHALL evaluate state-space models and synthesize RK4 solvers via StateSpaceEngine_Alpha.";
            satisfy by CodeGenEngine;
        }
        doc /* UUIDv5: d70e71b2-dcaf-5cef-8f22-87e04cef2552 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / ROS2 Middleware Transport Binding | Diagnostics: E0199, E0300, E0508 */
        requirement def REQ_0182_ROS2_Node_Architecture_Emission {
            id = "REQ-0182";
            text = "Subsystem 10 SHALL synthesize idiomatic, zero-allocation ROS2 node architectures (RosNode_Alpha) from AST components (Classifier_Alpha).";
            satisfy by CodeGenEngine;
        }
        doc /* UUIDv5: 3a8e345c-fc56-5805-93be-2ca124e8aa19 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / OMG IDL 4.2 / OMG CDR | Diagnostics: E0199, E0300, E0509 */
        requirement def REQ_0183_OMG_DDS_IDL_Schema_Generation {
            id = "REQ-0183";
            text = "Subsystem 10 SHALL synthesize OMG DDS IDL schemas (IDL_0) and CDR codecs (CDR_Codec_1) from AST structures (Struct_Alpha) via DdsGenerator_Alpha.";
            satisfy by CodeGenEngine;
        }
        doc /* UUIDv5: 92e4c4a6-15f6-5a43-acb1-05438e04a52b | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / ISO/IEC 14882:2020 C++20 | Diagnostics: E0199, E0300, E0510 */
        requirement def REQ_0184_Freestanding_Zero_Allocation_C_20_Header_Source_Code_Emission {
            id = "REQ-0184";
            text = "Subsystem 10 SHALL emit freestanding, zero-allocation C++20 header (.hpp) and source (.cpp) translation units (TranslationUnit_0) from classifiers (Classifier_Alpha) via CppEmitter_Alpha.";
            satisfy by CodeGenEngine;
        }
        doc /* UUIDv5: 0c0edf5f-c3fd-5073-af3e-05380258cdc9 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / MISRA C:2012 / ISO/IEC 9899:1999 | Diagnostics: E0199, E0300, E0511 */
        requirement def REQ_0185_High_Integrity_Embedded_MISRA_C99_Source_Code_Generation_with_Static_Memory_Layout {
            id = "REQ-0185";
            text = "Subsystem 10 SHALL synthesize MISRA C99 source (.c) and header (.h) files via MisraEmitter_Alpha from AST classifiers (Classifier_Alpha).";
            satisfy by CodeGenEngine;
        }
        doc /* UUIDv5: 0c14814e-2187-5417-afad-881f7ed9ebe0 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / ISO/IEC 9899:1999 §4 / ISO/IEC 14882:2020 §4.1 | Diagnostics: E0199, E0300, E0512 */
        requirement def REQ_0186_Freestanding_RTOS_Memory_Mapped_Register_Header_Generation {
            id = "REQ-0186";
            text = "Subsystem 10 SHALL synthesize freestanding, zero-allocation C99 and C++20 MMIO register headers (.h, .hpp) from peripheral blocks (RegBlock_0) via RegisterHeaderGen_Alpha.";
            satisfy by CodeGenEngine;
        }
        doc /* UUIDv5: b7eded58-e981-5c8f-9696-08fcf819e19a | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / Formal Verification Script Synthesis | Diagnostics: E0199, E0300, E0513 */
        requirement def REQ_0187_Formal_Verification_Script_Emission {
            id = "REQ-0187";
            text = "Subsystem 10 SHALL synthesize formal verification scripts (.m) targeting verification engines (MATLAB / SLDV) from AST classifiers (Classifier_Alpha) via ProofSynthesizer_Alpha.";
            satisfy by CodeGenEngine;
        }
        doc /* UUIDv5: 695cd246-2eaa-5128-b08a-15ab3032f58c | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / SMT-LIB Standard v2.6 | Diagnostics: E0199, E0300, E0514 */
        requirement def REQ_0188_SMT_LIB2_Z3_First_Order_Constraint_Encoding {
            id = "REQ-0188";
            text = "Subsystem 10 SHALL synthesize SMT-LIB2 (.smt2) scripts targeting first-order SMT solvers via SMTEncoder_Alpha.";
            satisfy by CodeGenEngine;
        }
        doc /* UUIDv5: a39d6415-ec6c-5929-a005-bf11334ac055 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / POSIX.1-2017 Filesystem Semantics | Diagnostics: E0199, E0300, E0515 */
        requirement def REQ_0189_Atomic_In_Place_File_Overwrite {
            id = "REQ-0189";
            text = "Subsystem 10 SHALL persist artifacts via FilePersistence_Alpha.";
            satisfy by CodeGenEngine;
        }
        doc /* Primary execution engine for Multi-Target Code Generation, Simulation & Transport Bindings */
        part def CodeGenEngine {
            port in specs_in : BacklogPort;
            port out code_out : CodeArtifactPort;
        }
        doc /* - **Given:** Block `Block_0` in `Package_0` with budget $K = 16$. - **When:** Lowering via `RegisterAllocator_Alpha` and `Scheduler_1`. - **Then:** Assigns colors ($c(u) \ne c(v)$ for $(u, v) \in E$) with zero stalls. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Allocation_and_Scheduling {
        }
        doc /* - **Given:** Model in `Package_0` declaring `Classifier_Alpha::Function_0` with branching. - **When:** Lowering AST into `LumiIR_Alpha`. - **Then:** Emits valid CFG with entry `BasicBlock_0`, linear instructions, and terminators. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_CFG_Construction {
        }
        doc /* - **Given:** `Package_0` synthesizing `Classifier_Alpha` for `Path_0`. - **When:** Lowering into `CodegenManifest_Alpha` with bytes $B$. - **Then:** Computes `ArtifactFingerprint_0` via XXH3 (seed 0), binds UUIDv5 $``\Delta_a``$, and records entry. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Manifest_and_Fingerprint_Emission {
        }
        doc /* - **Given:** `Package_0` with `Classifier_Alpha` emitting `Artifact_0` via `WriterSink_Alpha`. - **When:** `StreamEmitter_1` emits tokens into `ChunkBuffer_0`. - **Then:** Emits without monolithic buffering, flushing at $``B_{\text{max\_chunk\_size}} = 64\text{ KB}``$ with $O(1)$ memory. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Streaming_Code_Emission {
        }
        doc /* - **Given:** Model `MemoryModel_Alpha` in `Package_0` declaring `Slot_0` and `ValueRegister_0`. - **When:** Lowering allocations and verifying SSA bindings. - **Then:** Allocates `Slot_0` with UUIDv5 anchor, confirms $``\text{Aliases}(\text{ValueRegister\_0}) = \emptyset``$, and threads tokens. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Canonical_Typed_Slot_Allocation {
        }
        doc /* - **Given:** Model in `Package_0` with $\dot{x}=-2.0x$, $``x_0=1.0``$, `TimeStep_1` ($\Delta t=0.01$). - **When:** Executing Forward Euler step. - **Then:** Evaluates to $``x_1=0.98``$ within tolerance $\epsilon=10^{-12}$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Discrete_Forward_Euler_Recurrence_Execution {
        }
        doc /* - **Given:** `Classifier_Alpha` declaring `param_x : Real`. - **When:** Lowering `TranslationUnit_0` via `CppEmitter_Alpha`. - **Then:** Emits `.hpp` and `.cpp` with freestanding headers, `noexcept`, and UUIDv5 anchors. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Freestanding_Translation_Unit_Synthesis {
        }
        doc /* - **Given:** `Struct_Alpha` with `Field_0` and key `Field_1`. - **When:** Lowering `IDL_0` via `DdsGenerator_Alpha`. - **Then:** Emits IDL v4.2 syntax with `@key` and UUIDv5 anchors. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_IDL_Schema_Generation_and_Key_Annotation {
        }
        doc /* - **Given:** File `Artifact_0` at `Path_0` with inode `Inode_0` and buffer $B$. - **When:** `FilePersistence_Alpha` persists updated artifact. - **Then:** Writes in place via truncation flags, preserving inode ($``\text{inode}_{t+1} == \text{inode}_t``$) and directory metadata. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_In_Place_Overwrite_and_Inode_Preservation {
        }
        doc /* - **Given:** `RegBlock_0` with 32-bit register `Register_0`. - **When:** Lowering `RegisterHeaderGen_Alpha` to C99 and C++20 headers. - **Then:** Emits include guards, `extern "C"` blocks, `volatile` accessors, and atomic helpers. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_MMIO_Header_Synthesis {
        }
        doc /* - **Given:** Component `Classifier_Alpha` declaring ports `Port_0` and `Port_1`. - **When:** Lowering `RosNode_Alpha` and endpoints. - **Then:** Emits `Publisher_0`, `Subscriber_1`, and UUIDv5 anchors. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Node_and_Endpoint_Synthesis {
        }
        doc /* - **Given:** `Classifier_Alpha` with invariant `Invariant_0` expression `(a + b * c) <= d`. - **When:** Synthesizing script `verify_Classifier_Alpha.m`. - **Then:** Emits `sldv.assert` with parenthesized `((a) + ((b) * (c))) <= (d)`, preserving precedence. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Obligation_Synthesis_and_Precedence_Preservation {
        }
        doc /* - **Given:** Model `Classifier_Alpha` with linear constraints `Constraint_0` and invariant `Invariant_0`. - **When:** `SMTEncoder_Alpha` generates code targeting logic `QF_LRA`. - **Then:** Emits `.smt2` script asserting `(assert (not Invariant_0))` with `(check-sat)` and `(get-model)`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Standard_SMT_LIB2_Benchmark_and_Invariant_Synthesis {
        }
        doc /* - **Given:** Model `StateSpaceEngine_Alpha` with `Matrix_A0` ($n = 2$), `Matrix_B0`, and `Vector_X1`. - **When:** `RK4Solver_0` integrates across steps $``h_1 = 0.1``$ and $``h_2 = 0.05``$. - **Then:** Trajectory converges with local error $O(h^5)$ and global error $O(h^4)$ within 2% tolerance. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_State_Space_Evaluation_and_RK4_Convergence {
        }
        doc /* - **Given:** `Classifier_Alpha` declaring `StaticState_0`. - **When:** Lowering C99 via `MisraEmitter_Alpha`. - **Then:** Emits static struct, zero dynamic allocations, zero VLAs. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Static_Memory_Footprint {
        }
        doc /* - **Given:** `RegBlock_0` with registers of widths 1, 2, 4, 8 bytes at aligned offsets. - **When:** Validating alignment and typing. - **Then:** Confirms $``\text{RegAddress}(R) \equiv 0 \pmod{\text{sizeof}(R)}``$ and emits `<stdint.h>` types. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Alignment_and_Typing {
        }
        doc /* - **Given:** Slot `Slot_0` with 8 scalars and index 7. - **When:** Validating envelope $[0, 7]$ and alignment. - **Then:** Confirms bounds, checks alignment, and emits transition. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Boundary_Slot_Alignment_and_Envelope {
        }
        doc /* - **Given:** Model `Matrix_A` with pole $\lambda=-10.0$ and critical timestep $``\Delta t_{\text{crit}}=0.2``$. - **When:** Evaluating stable $\Delta t=0.18$ versus unstable $\Delta t=0.22$. - **Then:** Decays if stable; emits `E0505` on $|1+\lambda\Delta t|>1$. - **Diagnostic:** `E0505`. */
        part def AC_02_Boundary_Stability_Condition_Verification {
        }
        doc /* - **Given:** Backend generating code of size $|A| \ge 100\text{ MB}$ for `Classifier_Alpha`. - **When:** Streaming chunks through `WriterSink_Alpha` under memory tracking. - **Then:** Buffer memory never exceeds $``B_{\text{max\_chunk\_size}} = 64\text{ KB}``$, ensuring constant memory. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Bounded_Resident_Memory_Ceiling {
        }
        doc /* - **Given:** `Struct_Alpha` with 8-bit `Field_0` and 64-bit `Field_1`. - **When:** `CDR_Codec_1` serializes payload into wire buffer. - **Then:** Satisfies $``\text{Offset}(\phi_i) \equiv 0 \pmod{A_i}``$, inserting 7 zero bytes (`0x00`). - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_CDR_Natural_Alignment_and_Zero_Padding_Boundary {
        }
        doc /* - **Given:** Cycle in `CallGraph_1`. - **When:** Evaluating call graph acyclicity. - **Then:** Fails closed, emits `E0511`, binds $``\bot_{\text{c99}}``$, and records cycle. - **Diagnostic:** `E0511`. */
        part def AC_02_Call_Graph_Cycle_Rejection {
        }
        doc /* - **Given:** Artifact `Artifact_1` at non-existent `Path_1`. - **When:** `FilePersistence_Alpha` evaluates file existence. - **Then:** Directly creates file with flags `O_WRONLY | O_CREAT | O_EXCL`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Direct_Atomic_File_Creation_Boundary {
        }
        doc /* - **Given:** Construct attempting dynamic allocation (`operator new`) or exceptions (`throw`). - **When:** Validating zero-allocation and freestanding invariants. - **Then:** Fails closed, binds sentinel $``\bot_{\text{unit}}``$, emitting `E0510`. - **Diagnostic:** `E0510`. */
        part def AC_02_Dynamic_Allocation_and_Exception_Rejection {
        }
        doc /* - **Given:** Join block `BasicBlock_Join` with predecessors `BasicBlock_0` and `BasicBlock_1`. - **When:** Lowering variables into `SSA_1`. - **Then:** Inserts $\phi$-node bijectively matching predecessors with uniform types. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Join_Block_phi_Node_Resolution {
        }
        doc /* - **Given:** Model with `Matrix_A0` dimensions $2 \times 3$ for $n = 2$. - **When:** `StateSpaceEngine_Alpha` verifies matrix dimensions. - **Then:** Halts lowering, binds sentinel $``\bot_{\text{ss}}``$, emitting `E0300`. - **Diagnostic:** `E0300`. */
        part def AC_02_Matrix_Dimension_Boundary_Verification {
        }
        doc /* - **Given:** `Classifier_Alpha` with envelope $[0.0, 100.0]$ on `param_x : Real`. - **When:** Synthesizing assumption `Obligation_0`. - **Then:** Emits `sldv.assume` bounds `((param_x >= 0.0) and (param_x <= 100.0))`. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Operational_Envelope_Boundary_Verification {
        }
        doc /* - **Given:** `Port_0` with QoS `KeepLast` and depth $``d_{\text{depth}} = 10``$. - **When:** Validating QoS boundaries. - **Then:** Confirms $``d_{\text{depth}} \ge 1``$ and lowers profile. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_QoS_Depth_Boundary_Validation {
        }
        doc /* - **Given:** File at `Path_0` matching cached `CodegenManifest_Alpha`. - **When:** Re-compiling with unchanged AST inputs. - **Then:** Evaluates $``\text{WriteSkipped}(\text{Path\_0}, B) = \text{true}``$, bypasses writes, preserves $mtime$, yielding $``\Delta_{\text{writes}} = 0``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Redundant_Write_Bypass_and_Idempotency {
        }
        doc /* - **Given:** Graph `InterferenceGraph_0` with degree exceeding budget $K$. - **When:** Lowering via Kempe simplification with spilling. - **Then:** Selects candidate $``v_{\text{spill}}``$ minimizing cost ratio and assigns stack slots. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Register_Pressure_and_Optimistic_Spilling {
        }
        doc /* - **Given:** Model with states `State_0`, `State_1` and transition `Transition_1`. - **When:** `SMTEncoder_Alpha` synthesizes inductive step $``\Phi_{\text{step}}``$. - **Then:** Emits sort `(declare-sort State_Sort 0)` with distinctness, primed variables, and transition assertions. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Sort_Mapping_and_Inductive_Consecution_Generation {
        }
        doc /* - **Given:** Unbounded sequence in freestanding profile, or buffer $``C_{\text{buf}} < |\mathbf{W}|``$. - **When:** Validating layout or serializing payload. - **Then:** Fails closed, binds sentinel $``\bot_{\text{cdr}}``$, emitting `E0509`. - **Diagnostic:** `E0509`. */
        part def AC_03_Buffer_Overflow_and_Unbounded_Type_Rejection {
        }
        doc /* - **Given:** Block `Block_0` with cyclic instruction dependencies ($u \to v \to u$). - **When:** Lowering DAG `DAG_Alpha`. - **Then:** Emits `E0300`, binds sentinel $``\bot_{\text{dag}}``$, and fails closed. - **Diagnostic:** `E0300`. */
        part def AC_03_Dependency_Cycle_Rejection {
        }
        doc /* - **Given:** `Classifier_Alpha` with sequence $N = 16$ and mismatched dimensions. - **When:** Lowering storage and evaluating `constexpr` dimensional expressions. - **Then:** Detects dimensional violation, binds sentinel $``\bot_{\text{unit}}``$, emitting `E0300`. - **Diagnostic:** `E0300`. */
        part def AC_03_Fixed_Bounds_and_Dimensional_Evaluation {
        }
        doc /* - **Given:** `Classifier_Alpha` with inverted envelope $[100.0, 0.0]$ ($``v_{\min} > v_{\max}``$). - **When:** Validating envelope interval bounds. - **Then:** Halts emission, binds $``\bot_{\text{proof}}``$, and records `E0513`. - **Diagnostic:** `E0513`. */
        part def AC_03_Inverted_Envelope_Bound_Rejection {
        }
        doc /* - **Given:** `RegBlock_0` with misaligned offset `0x03` or overflowing `BitField_1`. - **When:** Validating geometry. - **Then:** Fails closed, emits `E0512`, and binds sentinel $``\bot_{\text{reg}}``$. - **Diagnostic:** `E0512`. */
        part def AC_03_Misalignment_Rejection {
        }
        doc /* - **Given:** Constraint `Constraint_0` with non-linear product `param_x * param_y` or alternating quantifiers. - **When:** `SMTEncoder_Alpha` checks theory admissibility before emission. - **Then:** Halts lowering, binds sentinel $``\bot_{\text{smt}}``$, and emits `E0514`. - **Diagnostic:** `E0514`. */
        part def AC_03_Non_Linear_Arithmetic_and_Quantifier_Rejection {
        }
        doc /* - **Given:** Model with $|R(\lambda h)| > 1$ or $\text{NaN}$ in derivative $``\mathbf{k}_1``$. - **When:** `RK4Solver_0` evaluates stability and numeric validity. - **Then:** Halts simulation, binds sentinel $``\bot_{\text{ss}}``$, emitting `E0507`. - **Diagnostic:** `E0507`. */
        part def AC_03_Numerical_Instability_and_Non_Finite_Interception {
        }
        doc /* - **Given:** Path `Path_Escaping = "../Package_0/Out.out"`. - **When:** `FilePersistence_Alpha` validates root confinement. - **Then:** Fails closed, binds $``\bot_{\text{io}}``$, emitting `E0300`. - **Diagnostic:** `E0300`. */
        part def AC_03_Path_Traversal_Security_Rejection {
        }
        doc /* - **Given:** Artifact at `Path_0` where write fails or hash diverges. - **When:** Committing bytes to disk sink `DiskSink_1`. - **Then:** Fails closed, emits `E0504`, and binds sentinel $``\bot_{\text{write}}``$. - **Diagnostic:** `E0504` (PersistenceFailure). */
        part def AC_03_Persistence_Failure_and_Hash_Mismatch_Rejection {
        }
        doc /* - **Given:** Connector linking `Publisher_0` (`BestEffort`) to `Subscriber_1` (`Reliable`). - **When:** Evaluating RxO compatibility. - **Then:** Fails closed, emits `E0508`, and binds sentinel $``\bot_{\text{endpoint}}``$. - **Diagnostic:** `E0508`. */
        part def AC_03_RxO_Incompatibility_Rejection {
        }
        doc /* - **Given:** Malformed IR defining `SSA_1` multiple times or violating dominance. - **When:** Validating SSA invariants. - **Then:** Fails closed, emits `E0501`, and binds sentinel $``\bot_{\text{ssa}}``$. - **Diagnostic:** `E0501`. */
        part def AC_03_SSA_Multiple_Definition_Rejection {
        }
        doc /* - **Given:** Target stream sink encountering hardware write exhaustion. - **When:** `WriterSink_Alpha` executes write or flush on `ChunkBuffer_0`. - **Then:** Fails closed, unlinks partial files, binds sentinel $``\bot_{\text{sink}}``$, and records `E0503`. - **Diagnostic:** `E0503` (SinkEmissionFault). */
        part def AC_03_Sink_Write_Fault_and_Overflow_Rejection {
        }
        doc /* - **Given:** Model `EulerSolver_Alpha` with timestep $\Delta t\le 0$ or mismatch $\dim(\mathbf{x})\ne\dim(f)$. - **When:** Validating parameters during ingestion. - **Then:** Fails closed, binds sentinel $``\bot_{\text{solver}}``$, and emits `E0300`. - **Diagnostic:** `E0300`. */
        part def AC_03_Timestep_Positivity_and_Dimension_Mismatch_Rejection {
        }
        doc /* - **Given:** Loop exceeding $``N_{\text{max\_loop}}``$ or lacking bound. - **When:** Evaluating loop termination. - **Then:** Halts lowering, binds $``\bot_{\text{c99}}``$, and emits `E0511`. - **Diagnostic:** `E0511`. */
        part def AC_03_Unbounded_Loop_Interception {
        }
        doc /* - **Given:** Slot `Slot_1` with unsized allocation and register `ValueRegister_1` with $|\text{Def}(r)| \gt 1$. - **When:** Verifying memory invariants. - **Then:** Fails closed, emits `E0300` and `E0502`, binding sentinels $``\bot_{\text{slot}}``$ and $``\bot_{\text{reg}}``$. - **Diagnostic:** `E0300`, `E0502`. */
        part def AC_03_Variable_Length_Allocation_Rejection {
        }
        doc /* - **Given:** Conflict in `Block_0`, delimiter `;`, and `Block_1`. - **When:** Lowering across block boundaries. - **Then:** Emits `E0506`, recovers at `;`, parses `Block_1`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0506`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Allocation_Conflict_and_Recovery {
        }
        doc /* - **Given:** Invalid type, delimiter `;`, and `Classifier_Beta`. - **When:** Recovering across delimiters. - **Then:** Emits `E0300`, binds $``\bot_{\text{c99}}``$, recovers across `;`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Error_Recovery {
        }
        doc /* - **Given:** Malformed matrix syntax followed by delimiter `;` and `Classifier_Alpha`. - **When:** Parser detects fault, records `E0300` in $``\mathcal{D}_{\text{sink}}``$, recovering across `;`. - **Then:** Parses `Classifier_Alpha`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Recovery_and_Error_Containment {
        }
        doc /* - **Given:** Syntax error followed by delimiter `;` and `Classifier_Beta`. - **When:** Detecting fault, recording `E0510` in $``\mathcal{D}_{\text{sink}}``$, recovering across `;`. - **Then:** Emits `Classifier_Beta`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0510`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Recovery_and_Saturation_Halting {
        }
        doc /* - **Given:** Field `interface` colliding with keyword, delimiter `;`, and `Field_1`. - **When:** Lowering fields across delimiters. - **Then:** Emits `E0300`, recovers at `;`, parses `Field_1`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_IDL_Keyword_Collision_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Path with traversal (`../target`), delimiter `;`, and `Artifact_Beta`. - **When:** Recovering across delimiter boundaries. - **Then:** Emits `E0300`, binds $``\bot_{\text{sink}}``$, resynchronizes across `;`, emits `Artifact_Beta`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Invalid_Destination_Path_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Block `Block_0` with hazard on `Slot_0`, delimiter `;`, and valid store. - **When:** Recovering across delimiters during validation. - **Then:** Emits `E0502`, recovers on `;`, parses instructions, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0502`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Memory_Hazard_Recovery {
        }
        doc /* - **Given:** Equations with states ($``|x_i|>10^{300}``$, NaN) and syntax faults separated by `;`. - **When:** Trapping divergence and recovering across delimiters. - **Then:** Traps `E0505`; recovers on `;`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0199`, `E0505`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Numerical_Divergence_Trapping_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Artifact with escaping path (`../target`), delimiter `\n`, and `Artifact_Beta`. - **When:** Validating destination path bounds within the output root. - **Then:** Emits `E0300`, binds $``\bot_{\text{path}}``$, recovers across `\n`, persists `Artifact_Beta`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Path_Traversal_Interception_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Malformed sort declaration followed by delimiter `;` and valid `Constraint_1`. - **When:** Pipeline encounters sort fault. - **Then:** Emits `E0300`, binds $``\bot_{\text{smt}}``$, recovers across `;`, encodes `Constraint_1`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Sort_Mismatch_and_Delimiter_Error_Recovery {
        }
        doc /* - **Given:** Malformed token `1_Bad_Reg`, delimiter `;`, and `Register_1`. - **When:** Recovering across delimiters. - **Then:** Emits `E0300`, binds sentinel $``\bot_{\text{reg}}``$, recovers across `;`, parses `Register_1`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Syntax_Delimiter_Recovery {
        }
        doc /* - **Given:** Block `BasicBlock_0` missing a terminator, delimiter `;`, and `BasicBlock_1`. - **When:** Recovering across `;`. - **Then:** Emits `E0300`, binds $``\bot_{\text{cfg}}``$, parses `BasicBlock_1`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Terminator_Delimiter_Recovery {
        }
        doc /* - **Given:** `Classifier_Alpha` with invalid topic `"1_Bad//Topic"`, delimiter `;`, and `Port_1`. - **When:** Recovering across delimiters. - **Then:** Emits `E0300`, binds sentinel $``\bot_{\text{endpoint}}``$, recovers across `;`, parses `Port_1`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Topic_Syntax_Delimiter_Recovery {
        }
        doc /* - **Given:** `Classifier_Alpha` with type mismatch in `Predicate_1`, delimiter `;`, and `Invariant_2`. - **When:** Detecting type mismatch and resynchronizing across `;`. - **Then:** Emits `E0300`, binds $``\bot_{\text{proof}}``$, parses `Invariant_2`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Type_Mismatch_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Failing `Path_0` with delimiter `;` and valid `Path_1`. - **When:** `FilePersistence_Alpha` encounters write failure. - **Then:** Emits `E0515`, binds $``\bot_{\text{io}}``$, recovers across `;`, persists `Path_1`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0515`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Write_Fault_and_Delimiter_Error_Recovery {
        }
        doc /* The backend of Subsystem 10 SHALL lower actions, statecharts, and constraints into SSA representation `LumiIR_Alpha`. --- */
        part def _1_Normative_Statement {
        }
        doc /* CFG $``\mathcal{G}_{\text{cfg}}``$, SSA bindings, and diagnostic triggers satisfy: \begin{aligned} \mathcal{G}_{\text{cfg}}=(\mathcal{B},\mathcal{E}_{\text{cfg}}),&\quad\text{pred}(B_{\text{entry}})=\emptyset\land\forall B\in\mathcal{B},\text{Paths}(B_{\text{entry}},B)\ne\emptyset \\ \forall v\in\mathcal{V}_{\text{ssa}},&\quad|\text{Def}(v)|=1\land\forall u\in\text{Uses}(v),\text{Def}(v)\ \mathbf{dom}\ u \\ \forall B\in\mathcal{B},&\quad|\text{pred}(B)|\le 1\implies\mathbf{\Phi}_B=\emptyset \\ \phi=\left(v_{\phi}\leftarrow\phi(\langle v_1,B_1\rangle,\dots,\langle v_k,B_k\rangle)\right)&\implies\{B_1,\dots,B_k\}=\text{pred}(B)\land\tau(v_i)\equiv\tau(v_{\phi}) \\ \text{DF}(B)&=\left\{Y\in\mathcal{B}\mid\exists P\in\text{pred}(Y):B\ \mathbf{dom}\ P\land\neg(B\ \mathbf{sdom}\ Y)\right\} \\ |\text{Def}(v)|\ne 1\lor\exists u\in\text{Uses}(v):\neg(\text{Def}(v)\ \mathbf{dom}\ u)&\implies\text{Diagnostic}(v,\text{E0501})\in\mathcal{D}_{\text{sink}}\land v\gets\bot_{\text{ssa}} \\ T_B=\bot\lor\exists B'\in\text{targets}(T_B):B'\notin\mathcal{B}&\implies\text{Diagnostic}(B,\text{E0300})\in\mathcal{D}_{\text{sink}}\land B\gets\bot_{\text{cfg}} \\ |\mathcal{D}_{\text{sink}}|\ge C_{\text{max\_errors}}&\implies\text{Diagnostic}(\text{E0199})\in\mathcal{D}_{\text{sink}},\quad\Delta_e=\text{UUIDv5}(\text{OID}_{\text{DEAP}},\text{FQN}(e)) \end{aligned} --- */
        part def _2_Formal_Invariant {
            attribute mathcal_mathcal_mathcal_B : String = "CFG graph, block set, edge set, and entry block";
            attribute mathcal_mathbf_B_text_text : String = "SSA registers, $\phi$-nodes, definition, and use set";
            attribute mathbf_mathbf_text : String = "Dominance, strict dominance, and dominance frontier";
            attribute bot_bot_mathcal_Delta_e : String = "SSA sentinel, CFG sentinel, diagnostic sink, and UUIDv5 anchor";
        }
        doc /* - **Complexity Class:** Class $\mathbf{P}$ (Deterministic Polynomial Time). - **Asymptotic Bound:** $``O(|B| + |E_{\text{cfg}}|)``$ CFG and dominance traversal ($``|B| = |\mathcal{B}|, |E_{\text{cfg}}| = |\mathcal{E}_{\text{cfg}}|``$). Lowering runs in $``O(|B| + |E_{\text{cfg}}| + |I|)``$ for $|I|$ instructions. Dominator trees take $``O(|B| + |E_{\text{cfg}}|)``$; SSA checks take $O(1)$ per use. Work-stealing scales as $``O((|B| + |E_{\text{cfg}}|)/N_{\text{max\_workers}} + \log N_{\text{max\_workers}})``$. Arena memory is $``O(|B| + |E_{\text{cfg}}| + |I|)``$. - **Tractable Subclass and Frontier:** N/A (Deterministic P). SSA lowering avoids NP-7 coloring (REQ-0180), NP-5 reachability (REQ-0124), and NP-8 solving (REQ-0197). --- */
        part def _3_Computational_Complexity_Algorithmic_Bounds {
        }
        part def _4_Verification_Conformance_Criteria {
        }
    }
    doc /* Standardized Compiler Diagnostic Error Catalog */
    package Subsystem_11_Standardized_Diagnostic_Error_Catalog {
        doc /* UUIDv5: 8e81b526-6467-55d0-ada4-53c971fdb272 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0100, E0190, E0199 */
        requirement def REQ_0190_Rich_Source_Mapped_Diagnostic_Reporting_with_Byte_Spans_Synchronization_Tokens {
            id = "REQ-0190";
            text = "Subsystem 11 SHALL emit structured diagnostic records via DiagnosticEngine_Alpha.";
            satisfy by DiagnosticErrorCatalogEngine;
        }
        doc /* UUIDv5: 12d9701a-3a6a-5023-885f-4279e0c18de7 | Complexity: Class P (O(1) taxonomy range classification) | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0199, E0200, E0300, E0400, E0500 */
        requirement def REQ_0191_Standardized_Compiler_Diagnostic_Taxonomy_Source_Mapping {
            id = "REQ-0191";
            text = "TaxonomyEngine_Alpha SHALL partition diagnostics into five disjoint taxonomy ranges: Ingestion/Lexer (E0100--E0199), Metamodel/Typing (E0200--E0299), Metrology/Conservation (E0300--E0399), Spatio-Temporal/Safety (E0400--E0499), and Backend/Emission (E0500--E0599). Unclassified codes MUST NOT be";
            satisfy by DiagnosticErrorCatalogEngine;
        }
        doc /* UUIDv5: 07d1b185-07f0-5939-a19b-5376f745050a | Complexity: Class P (O(\vert E_{doc} \vert + \vert N_{AST} \vert) reconciliation) | Standard: IEEE 29148-2018 / RFC 2119 / Bidirectional Model Reconciliation | Diagnostics: E0199, E0300, E0502 */
        requirement def REQ_0192_Bidirectional_Reverse_Sync_Prose_Gate {
            id = "REQ-0192";
            text = "Subsystem 11 SHALL execute reverse synchronization via ProseGate_Alpha and Reconciler_0.";
            satisfy by DiagnosticErrorCatalogEngine;
        }
        doc /* UUIDv5: 847ea3fe-07eb-5488-b50f-ec490803397f | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / CommonMark Specification | Diagnostics: E0199, E0300, E0500 */
        requirement def REQ_0193_Non_Destructive_Markdown_Parser {
            id = "REQ-0193";
            text = "Subsystem 11 SHALL parse and mutate CommonMark documents non-destructively via MarkdownParser_Alpha and MutationEngine_0.";
            satisfy by DiagnosticErrorCatalogEngine;
        }
        doc /* UUIDv5: 57d13fd9-ec1b-5870-ae71-3d0f019101cb | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 / KerML | Diagnostics: E0199, E0300, E0500 */
        requirement def REQ_0194_Artifact_Drift_Detection {
            id = "REQ-0194";
            text = "Subsystem 11 SHALL detect drift and enforce zero-divergence bijective synchronization between schemas and artifacts via DriftDetector_Alpha and ModelSync_0.";
            satisfy by DiagnosticErrorCatalogEngine;
        }
        doc /* Primary execution engine for Standardized Compiler Diagnostic Error Catalog */
        part def DiagnosticErrorCatalogEngine {
            port in diag_in : DiagnosticStreamPort;
            port out diag_out : DiagnosticReportPort;
        }
        doc /* - **Given:** Buffer `SourceFile_0` with $``L_{\text{starts}}``$ and span `ByteSpan_0` = $``[b_{\text{start}}, b_{\text{end}})``$. - **When:** Constructing diagnostic `ErrorRecord_0`. - **Then:** Resolves coordinates, rendering margin bars (`|`), carets (`^`), squiggles (`~~~`). - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Diagnostic_Construction_and_Coordinate_Resolution {
        }
        doc /* - **Given:** Entity `Entity_0` in $\mathcal{A}$ and document `Doc_0` with matching ID and name. - **When:** `ProseGate_Alpha` evaluates reconciliation. - **Then:** Classifies as `ExactMatch`, preserving node without mutation. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_ExactMatch_Classification_and_Invariant_Preservation {
        }
        doc /* - **Given:** Malformed input in `Package_0` exceeding $``C_{\text{max\_errors}} = 100``$. - **When:** `TaxonomyEngine_Alpha` executes delimiter synchronization. - **Then:** Recovers across delimiters, accumulating 100 diagnostics before emitting sentinel `E0199`. - **Diagnostic:** `E0199`. */
        part def AC_01_Ingestion_Delimiter_Recovery_and_Sink_Saturation {
        }
        doc /* - **Given:** Document `Doc_0` with `Block_0` containing `Classifier_Alpha`. - **When:** `MutationEngine_0` applies delta $``\Delta_{\text{AST}}``$ renaming to `Classifier_Beta`. - **Then:** Mutates attributes in place, preserving layout, partition, and UUIDv5 anchors. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Schema_Block_In_Place_Mutation {
        }
        doc /* - **Given:** Model `Package_0` with `Classifier_Alpha`, `Port_1`, and artifact `Artifact_0`. - **When:** `DriftDetector_Alpha` executes bijective synchronization via `ModelSync_0`. - **Then:** Verifies `Bijection_1` ($\text{Drift} == 0$) with identical topology and attributes. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Zero_Divergence_Bijective_Isomorphism_Baseline {
        }
        doc /* - **Given:** Buffer `SourceFile_0` with point fault ($``b_{\text{start}} = b_{\text{end}} - 1``$) at $|S| - 1$. - **When:** Formatting ASCII snippet. - **Then:** Resolves column without overread, emitting caret (`^`). - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Boundary_Byte_Span_and_Single_Token_Mapping {
        }
        doc /* - **Given:** Document `Doc_0` with schema blocks and unmapped prose `Block_1`. - **When:** `MutationEngine_0` reconciles AST updates. - **Then:** 100% of prose blocks preserve byte slices and hashes ($``\text{SHA256}(B'_i) \equiv \text{SHA256}(B_i)``$). - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Byte_for_Byte_Prose_Preservation {
        }
        doc /* - **Given:** Circular inheritance between `Classifier_Alpha` and `Classifier_Beta`. - **When:** `TaxonomyEngine_Alpha` evaluates metamodel typing. - **Then:** Classifies error into `Partition_1` (`E0200`--`E0299`), emitting `E0200` with patch guidance. - **Diagnostic:** `E0200`. */
        part def AC_02_Metamodel_and_Typing_Taxonomy_Partitioning {
        }
        doc /* - **Given:** Entity `Entity_0` renamed to `Classifier_Beta` in document `Doc_0`. - **When:** `Reconciler_0` validates syntax and scope. - **Then:** Classifies as `Renamed`, updating identifier in-place. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Renamed_Entity_Validation_and_Identifier_Mutation {
        }
        doc /* - **Given:** `Artifact_0` with divergent `param_x : Real = 43.0` (schema: `42.0`) or missing edge. - **When:** `DriftDetector_Alpha` checks isomorphism against `Package_0`. - **Then:** Emits `E0500`, binds $``\bot_{\text{drift}}``$, and isolates coordinates without persisting. - **Diagnostic:** `E0500`. */
        part def AC_02_Structural_Relational_and_Property_Drift_Detection {
        }
        doc /* - **Given:** Inverted span ($``b_{\text{start}} > b_{\text{end}}``$) or offset ($``b_{\text{end}} > |S|``$). - **When:** Validating span invariants. - **Then:** Rejects coordinates, binds $``\bot_{\text{diag}}``$, emitting `E0190`. - **Diagnostic:** `E0190`. */
        part def AC_03_Malformed_Byte_Span_Rejection {
        }
        doc /* - **Given:** File at `Path_0` matching $``D_{\text{updated}}``$ byte-for-byte. - **When:** `MarkdownParser_Alpha` evaluates $``\text{ShouldWrite}(P, D_{\text{updated}})``$. - **Then:** Evaluates false, bypassing write while preserving inode and timestamp. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_03_Memory_Mapped_Diff_Bypass {
        }
        doc /* - **Given:** Incompatible physical quantity addition on `Port_1`. - **When:** `TaxonomyEngine_Alpha` executes dimensional homogeneity validation. - **Then:** Classifies fault into `Partition_2` (`E0300`--`E0399`), emitting `E0300` with highlight spans. - **Diagnostic:** `E0300`. */
        part def AC_03_Metrology_and_Conservation_Taxonomy_Partitioning {
        }
        doc /* - **Given:** Document `Doc_0` declaring ungrounded `ProseEntity_1` without anchor ID in $\mathcal{A}$. - **When:** `ProseGate_Alpha` evaluates classification. - **Then:** Rejects entity as `NewProseEntity`, halting injection, emitting `E0502`. - **Diagnostic:** `E0502`. */
        part def AC_03_Unauthorized_Prose_Entity_Detection_and_Rejection {
        }
        doc /* - **Given:** Artifact referencing escaping path `../Artifact_Escaping` or ungrounded anchor. - **When:** `ModelSync_0` validates path confinement and anchor validity. - **Then:** Fails closed, binds $``\bot_{\text{drift}}``$, and registers `E0300` in $``\mathcal{D}_{\text{sink}}``$. - **Diagnostic:** `E0300`. */
        part def AC_03_Workspace_Path_Validation_and_Anchor_Rejection {
        }
        doc /* - **Given:** Malformed `Token_1` separated by `;`, and sink limit $``K_{\text{max\_errors}} = 100``$. - **When:** Parser encounters syntax errors across statements. - **Then:** Emits `E0100`, recovers across `;`, and halts at limit with `E0199`. - **Diagnostic:** `E0100`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Recovery_and_Error_Saturation {
        }
        doc /* - **Given:** Malformed artifact with delimiter `;` and valid `Classifier_Beta`. - **When:** `DriftDetector_Alpha` parses stream, accumulating diagnostics in $``\mathcal{D}_{\text{sink}}``$. - **Then:** Recovers across `;`, parses `Classifier_Beta`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0500`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Resynchronization_and_Error_Saturation_Limit {
        }
        doc /* - **Given:** Document `Doc_0` with malformed `|` followed by `## Block_1`. - **When:** `MarkdownParser_Alpha` parses document streams. - **Then:** Emits `E0300`, binds $``\bot_{\text{block}}``$, resynchronizes on `##`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Syntax_Error_Recovery {
        }
        doc /* - **Given:** Malformed rename followed by delimiter `###` and valid `Entity_0`. - **When:** `Reconciler_0` scans tokens. - **Then:** Emits `E0300`, binds $``\bot_{\text{reconcile}}``$, recovers on `###`, parses `Entity_0`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0300`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Malformed_Rename_Identifier_and_Delimiter_Recovery {
        }
        doc /* - **Given:** Conflicting temporal relations in `State_0`. - **When:** `TaxonomyEngine_Alpha` verifies interval constraints. - **Then:** Classifies conflict into `Partition_3` (`E0400`--`E0499`), emitting `E0400` without panicking. - **Diagnostic:** `E0400`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Spatio_Temporal_and_Safety_Taxonomy_Partitioning {
        }
        doc /* Subsystem 11 SHALL emit structured diagnostic records via `DiagnosticEngine_Alpha`. --- */
        part def _1_Normative_Statement {
        }
        doc /* Diagnostic records and filtering satisfy: \begin{aligned} D&=\langle c,s,p,[b_{\text{start}},b_{\text{end}}),\lambda,\mu,\sigma,\Delta_{\text{diag}}\rangle \\ \lambda&=\langle\ell(b_{\text{start}}),c(b_{\text{start}}),\ell(b_{\text{end}}),c(b_{\text{end}})\rangle \\ \ell(b)&=\max\{i\in\{1,\dots,M\}\mid l_i\le b\},\quad c(b)=(b-l_{\ell(b)})+1 \\ \mathcal{D}_{k+1}&=\begin{cases} \mathcal{D}_k\cup\{D_{k+1}\},&\text{if }|\mathcal{D}_k|<K_{\text{max\_errors}} \\ \mathcal{D}_k,&\text{otherwise} \end{cases} \\ \text{Emit}(j,\tau_{\text{last}})&=\begin{cases} \text{Suppress},&\text{if }j-\tau_{\text{last}}\le\delta \\ \text{Record},&\text{if }j-\tau_{\text{last}}>\delta \end{cases} \\ (b_{\text{start}}>b_{\text{end}}\lor b_{\text{end}}>|S|)&\implies\text{Diagnostic}(\text{E0190})\in\mathcal{D}_{\text{sink}}\land D\gets\bot_{\text{diag}} \\ \text{ParseError}(\text{Token}_1)&\implies\text{Diagnostic}(\text{Token}_1,\text{E0100})\in\mathcal{D}_{\text{sink}} \\ |\mathcal{D}_{\text{sink}}|\ge K_{\text{max\_errors}}&\implies\text{Diagnostic}(\text{E0199})\in\mathcal{D}_{\text{sink}} \\ \Delta_{\text{diag}}&=\text{UUIDv5}(\text{OID}_{\text{DEAP}},p\mathbin{\Vert}\text{"::"}\mathbin{\Vert}\text{str}(c)\mathbin{\Vert}\text{"::"}\mathbin{\Vert}\text{str}(b_{\text{start}})\mathbin{\Vert}\text{"::"}\mathbin{\Vert}\text{str}(b_{\text{end}})) \end{aligned} --- */
        part def _2_Formal_Invariant {
            attribute D_b_lambda : String = "Diagnostic tuple, byte span, coordinates";
            attribute c_s_p_mu_sigma : String = "Code, severity, path, remediation, token";
            attribute ell_c_L : String = "Coordinate mappings, line-start table";
            attribute mathcal_k_mathcal_K : String = "Accumulation state, sink, limit";
            attribute tau_delta_bot : String = "Recovery position, window, fault sentinel";
            attribute Delta_text : String = "UUIDv5 anchor, namespace OID";
        }
        doc /* - **Complexity Class:** Class $\mathbf{P}$ (Deterministic Polynomial Time). - **Asymptotic Bound:** Indexing takes $O(|S|)$. Coordinate lookup takes $O(\log M)$. Accumulation takes $O(1)$ amortized time, bounding collection to $O(|\mathcal{D}|)$ ($``|\mathcal{D}| \le K_{\text{max\_errors}}``$). Sorting takes $O(|\mathcal{D}| \log |\mathcal{D}|)$. Work-stealing across $``N_{\text{max\_workers}}``$ threads scales as $``O(|S| / N_{\text{max\_workers}} + |\mathcal{D}| \log |\mathcal{D}|)``$. Memory is $``O(M + K_{\text{max\_errors}})``$. - **Tractable Subclass and Frontier:** N/A (Deterministic P). Avoids NP-1 (REQ-0117), NP-2 (REQ-0147), NP-8 (REQ-0197). --- */
        part def _3_Computational_Complexity_Algorithmic_Bounds {
        }
        part def _4_Verification_Conformance_Criteria {
        }
    }
    doc /* Compiler Performance, CLI, Assurance & Regression Inoculation */
    package Subsystem_12_Compiler_Performance_CLI_Assurance {
        doc /* UUIDv5: 9015e8e6-c6b1-54f5-b4de-82b06320a18f | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / Unified Headless CLI Mandate | Diagnostics: E0199, E0300, E0500 */
        requirement def REQ_0195_Unified_Headless_CLI_Architecture {
            id = "REQ-0195";
            text = "Subsystem 12 SHALL provide a headless CLI and deterministic subcommand interface via CliEngine_Alpha.";
            satisfy by CompilerAssuranceEngine;
        }
        doc /* UUIDv5: 2c190faa-66f3-5d69-93a6-7fa86984f68f | Complexity: Class P (O(1) metric assertion) | Standard: IEEE 29148-2018 / RFC 2119 / Performance Assurance Mandate | Diagnostics: E0196, E0199, E0300 */
        requirement def REQ_0196_Performance_Assurance_Gates {
            id = "REQ-0196";
            text = "Subsystem 12 SHALL enforce dual performance gates bounding latency and RSS via AssuranceGate_Alpha, LatencyMonitor_0, and RssTracker_1.";
            satisfy by CompilerAssuranceEngine;
        }
        doc /* UUIDv5: 71c9e201-e6f5-582b-b222-fa1714c79d91 | Complexity: NP-complete (Decidable QF Fragments) / Undecidable (General First-Order Logic) | Standard: IEEE 29148-2018 §8.4 / RFC 2119 / DPLL(T) / Nelson-Oppen | Diagnostics: E0199, E0300, E0406 */
        requirement def REQ_0197_NP_8 {
            id = "REQ-0197";
            text = "Subsystem 12 SHALL discharge formal proof obligations (ProofObligation_Alpha) from contracts via SmtSolver_0.";
            satisfy by CompilerAssuranceEngine;
        }
        doc /* UUIDv5: a1dedb3d-e92f-54ba-8476-7017bfef1458 | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 / OMG SysML v2 / KerML | Diagnostics: E0198, E0199, E0300 */
        requirement def REQ_0198_Property_Based_Fuzzing {
            id = "REQ-0198";
            text = "Subsystem 12 SHALL verify panic-free execution and AST invariant preservation via FuzzerEngine_Alpha and InvariantChecker_1.";
            satisfy by CompilerAssuranceEngine;
        }
        doc /* UUIDv5: b43c48cc-c04f-5787-ac49-c489c5a4704a | Complexity: Class P (O( | Standard: IEEE 29148-2018 / RFC 2119 | Diagnostics: E0199, E0300, E0500, E0502 */
        requirement def REQ_0199__4_Pass_Semantic_Parity_Verification_Framework {
            id = "REQ-0199";
            text = "Subsystem 12 SHALL execute 4-pass semantic parity verification via ParityVerifier_Alpha.";
            satisfy by CompilerAssuranceEngine;
        }
        doc /* Primary execution engine for Compiler Performance, CLI, Assurance & Regression Inoculation */
        part def CompilerAssuranceEngine {
            port in cli_in : CLIPort;
            port out metrics_out : PerformanceMetricsPort;
        }
        doc /* - **Given:** `Package_0` with invariant $``\text{param\_x} \le 100.0``$ given $``\text{param\_x} \le 50.0``$. - **When:** `SmtSolver_0` verifies `ProofObligation_Alpha`. - **Then:** Discharges as $\text{UNSAT}$, certifying satisfaction with witness $``\mathcal{W}_{\text{proof}}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Decidable_Fragment_Satisfaction {
        }
        doc /* - **Given:** Documents `Doc_A`, `Doc_B` with identical frontmatter, graphs of `Package_0`, and tables. - **When:** `ParityVerifier_Alpha` evaluates verification. - **Then:** Predicate $``\Phi(\text{Doc}_A, \text{Doc}_B)``$ evaluates $\text{true}$ across all facets. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Full_4_Pass_Semantic_Parity_Conformance {
        }
        doc /* - **Given:** Model `Package_0` with `Classifier_Alpha` and `Port_1`. - **When:** `CliEngine_Alpha` dispatches `Subcommand_0` in headless mode. - **Then:** Executes with code `0`, emitting payload to `stdout` without TTY escapes. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Headless_Subcommand_Dispatch_Baseline {
        }
        doc /* - **Given:** Model `Package_0` with `Classifier_Alpha` and `Port_1`. - **When:** `AssuranceGate_Alpha` runs $M \ge 1{,}000$ iterations in Release mode (`--release`). - **Then:** Asserts $``p_{99} \lt 25.0\text{ ms}``$ and $``\text{RSS}_{\text{peak}} \lt 100.0\text{ MB}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Release_Latency_and_Memory_Compliance {
        }
        doc /* - **Given:** Model `Package_0` with `Classifier_Alpha`, `Port_1`, and `param_x : Real`. - **When:** `FuzzerEngine_Alpha` lowers AST and `InvariantChecker_1` asserts integrity. - **Then:** Validates node handles, acyclicity, and typing with zero panics. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_01_Valid_Model_Generation_and_Invariant_Preservation_Baseline {
        }
        doc /* - **Given:** Pairs $``v_A = 1.0000000``$, $``v_B = 1.0000005``$ (error $5 \times 10^{-7} < 10^{-6}$), and $10^{-13}$, $2 \times 10^{-13}$ (difference $10^{-13} < 10^{-9}$). - **When:** `NumericPass_3` evaluates tolerance relations. - **Then:** Both pairs satisfy $\text{TolEq}$, yielding $``\Phi_{\text{Numeric}} = \text{true}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Boundary_Numerical_Tolerance_Threshold_and_Absolute_Floor {
        }
        doc /* - **Given:** Model `Package_0` mutated via operator `Mutation_0`. - **When:** `FuzzerEngine_Alpha` processes mutated AST across compiler phases. - **Then:** Detects malformed structure, records `E0300`, and binds fault sentinel $``\bot_{\text{fuzz}}``$. - **Diagnostic:** `E0300`. */
        part def AC_02_Generative_Metamodel_Mutation_and_Fault_Isolation {
        }
        doc /* - **Given:** Model `Package_0` with $N = 10{,}000$, $E = 40{,}000$. - **When:** Lowering pipeline executes under isolated harnesses. - **Then:** Latency $``p_{99} \le 24.5\text{ ms}``$; memory $``\text{RSS}_{\text{peak}} \le 39.8\text{ MB}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Maximal_Node_Boundary_Evaluation {
        }
        doc /* - **Given:** Contract declaring term $``\text{param\_x} \cdot \text{param\_y}``$ or quantifier $\forall x \exists y$. - **When:** Admissibility is evaluated. - **Then:** Emits `E0406`, binds sentinel $``\bot_{\text{proof}}``$, and halts dispatch. - **Diagnostic:** `E0406`. */
        part def AC_02_Non_Linear_and_Quantifier_Rejection {
        }
        doc /* - **Given:** `Args_1` specifying `--format=json` for `Subcommand_0`. - **When:** `CliEngine_Alpha` serializes output streams. - **Then:** Emits JSON on `stdout` binding $``\Delta_{\text{exec}}``$ from $``\text{OID}_{\text{DEAP}}``$. - **Diagnostic:** Diagnostic sink remains empty. */
        part def AC_02_Structured_JSON_Telemetry_and_UUIDv5_Anchor {
        }
        doc /* - **Given:** Model `Package_0` inducing invalid handle in `Classifier_Beta`. - **When:** `InvariantChecker_1` inspects the lowered AST. - **Then:** Detects invariant violation, registers `E0198` in $``\mathcal{D}_{\text{sink}}``$, and fails closed. - **Diagnostic:** `E0198`. */
        part def AC_03_AST_Invariant_Violation_Detection_and_Reporting {
        }
        doc /* - **Given:** Invariant violation or cutoff $``\kappa_{\text{smt}} = 20``$. - **When:** `SmtSolver_0` evaluates refutation formula. - **Then:** On $\text{SAT}$, extracts counterexample $``\mathcal{M}_{\text{counter}}``$ and emits `E0406`; on timeout, emits `E0406`. - **Diagnostic:** `E0406`. */
        part def AC_03_Counterexample_and_Step_Timeout {
        }
        doc /* - **Given:** Arguments referencing escaping `../Package_0` or invalid flag. - **When:** `CliEngine_Alpha` validates arguments and paths. - **Then:** Fails closed with exit code `2`, binds $``\bot_{\text{cli}}``$, registering `E0300`. - **Diagnostic:** `E0300`. */
        part def AC_03_Path_Confinement_and_Syntax_Rejection {
        }
        doc /* - **Given:** Model exceeding statutory latency or memory limits. - **When:** `AssuranceGate_Alpha` validates metrics against statutory gates. - **Then:** Halts execution with exit code 1, emitting `E0196`. - **Diagnostic:** `E0196`. */
        part def AC_03_Performance_Gate_Breach_Rejection {
        }
        doc /* - **Given:** `Doc_B` with reversed edge `Classifier_Alpha --> Port_1` or incompatible $\mathbb{Q}^7$ dimensions. - **When:** `TopologyPass_1` and `NumericPass_3` validate invariants. - **Then:** Halts lowering, binds $``\bot_{\text{parity}}``$, emitting `E0500` or `E0300`. - **Diagnostic:** `E0500`, `E0300`. */
        part def AC_03_Rejection_of_Graph_Topology_Divergence_and_Dimension_Mismatch {
        }
        doc /* - **Given:** 150 discrepancies across delimiter `|` and fence `---`. - **When:** `ParityVerifier_Alpha` ingests and resynchronizes. - **Then:** Accumulates up to $``C_{\text{max\_errors}} = 100``$, emitting terminal `E0199`, halting compilation. - **Diagnostic:** `E0502`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Error_Recovery_and_Diagnostic_Saturation_Limit {
        }
        doc /* - **Given:** Model with delimiter errors or sampling fault. - **When:** Parser resynchronizes or `RssTracker_1` queries memory counters. - **Then:** Halts at $``C_{\text{max\_errors}}``$ with `E0199`; sampling faults emit `E0300`. - **Diagnostic:** `E0199`, `E0300`. */
        part def AC_04_Delimiter_Recovery_and_Sampling_Fault {
        }
        doc /* - **Given:** Model `Package_0` with corrupted delimiters (`;`, `}`) exceeding $``C_{\text{max\_errors}} = 100``$. - **When:** `FuzzerEngine_Alpha` parses stream, accumulating diagnostics in $``\mathcal{D}_{\text{sink}}``$. - **Then:** Recovers across delimiters, accumulates 100 diagnostics, halting at limit with `E0199`. - **Diagnostic:** `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Resynchronization_and_Error_Saturation_Limit {
        }
        doc /* - **Given:** Malformed contract with delimiter `;` and valid `ProofObligation_Beta`. - **When:** Parser processes stream into $``\mathcal{D}_{\text{sink}}``$. - **Then:** Recovers across `;`, parses `ProofObligation_Beta`, halting at $``C_{\text{max\_errors}}``$ with `E0199`. - **Diagnostic:** `E0406`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Delimiter_Resynchronization_and_Recovery {
        }
        doc /* - **Given:** Model generating `E0500` and 120 errors with $``C_{\text{max\_errors}} = 100``$. - **When:** `CliEngine_Alpha` recovers across `;`, accumulating diagnostics in $``\mathcal{D}_{\text{sink}}``$. - **Then:** Exits with code `1`, binds $``\bot_{\text{cli}}``$, halting at limit with `E0199`. - **Diagnostic:** `E0500`, `E0199`. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_04_Drift_Detection_and_Saturation_Recovery {
        }
        doc /* - **Given:** Benchmark suite on $``N_{\text{max\_workers}}``$ threads. - **When:** Run in Release mode (`--release`) versus debug mode. - **Then:** Debug bypasses gates; Release satisfies $``p_{99} \lt 25.0\text{ ms}``$, $\text{RSS} \lt 100.0\text{ MB}$. - **Diagnostic:** Diagnostic sink remains empty. --- *Traceability: Elaborated under IEEE 29148-2018 and the DEAP Compiler Streamlined Charter.* */
        part def AC_05_Harness_Isolation_and_Scalability {
        }
        doc /* Subsystem 12 SHALL provide a headless CLI and deterministic subcommand interface via `CliEngine_Alpha`. --- */
        part def _1_Normative_Statement {
        }
        doc /* Headless CLI dispatch, stream partitioning, and diagnostic triggers satisfy: \begin{aligned} \text{CLI}:\mathcal{A}_{\text{args}}\times\mathcal{E}_{\text{env}}&\longrightarrow\langle\text{ExitCode},\text{Stdout},\text{Stderr}\rangle \\ \text{ExitCode}(A,E)=0&\iff\text{ValidSyntax}(A)\land|\mathcal{D}_{\text{fatal}}|=0\land|\mathcal{D}_{\text{error}}|=0 \\ \text{ExitCode}(A,E)=1&\iff\text{ValidSyntax}(A)\land|\mathcal{D}_{\text{fatal}}|+|\mathcal{D}_{\text{error}}|\gt 0 \\ \text{ExitCode}(A,E)=2&\iff\neg\text{ValidSyntax}(A)\lor\neg\text{ValidPath}(A) \\ \Delta_{\text{exec}}&=\text{UUIDv5}(\text{OID}_{\text{DEAP}},\text{Subcommand}\mathbin{\Vert}\text{"::CLI::"}\mathbin{\Vert}\text{Digest}(E)) \\ \forall\sigma,\quad\text{Stdout}(A,E\mid\text{IsTTY}(\sigma))&\equiv\text{Stdout}(A,E\mid\neg\text{IsTTY}(\sigma)) \\ \neg\text{ValidPath}(p)&\implies\text{Diagnostic}(p,\text{E0300})\in\mathcal{D}_{\text{sink}}\land p\gets\bot_{\text{cli}} \\ \text{Drift}(\mathcal{A}_{\text{schema}}, \mathcal{A}_{\text{artifact}})\gt 0&\implies\text{Diagnostic}(v,\text{E0500})\in\mathcal{D}_{\text{sink}}\land v\gets\bot_{\text{cli}} \\ |\mathcal{D}_{\text{sink}}|\ge C_{\text{max\_errors}}&\implies\text{Diagnostic}(\text{E0199})\in\mathcal{D}_{\text{sink}} \end{aligned} --- */
        part def _2_Formal_Invariant {
            attribute mathcal_mathcal : String = "Argument token space, isolated execution environment";
            attribute text_text_text : String = "Termination status code, partitioned stream payloads";
            attribute mathcal_mathcal_mathcal : String = "Diagnostic sink, severity partitions";
            attribute Delta_text : String = "UUIDv5 session anchor, namespace OID";
            attribute text_bot : String = "Terminal predicate, CLI fault sentinel";
            attribute text_C : String = "Drift metric, diagnostic saturation limit";
        }
        doc /* - **Complexity Class:** Class $\mathbf{P}$ (Deterministic Polynomial Time). - **Asymptotic Bound:** $O(|A|)$ dispatch for tokens $|A|$, and $O(|S|)$ serialization for bytes $|S|$. Token lookup takes $O(1)$ time. Work-stealing incurs $``O(|U| / N_{\text{max\_workers}} + \log N_{\text{max\_workers}})``$ for $|U|$ units. Arena memory is $O(|A| + |S|)$. - **Tractable Subclass and Frontier:** N/A (Deterministic P). CLI dispatch and serialization execute in linear time, bypassing NP-1 intervals (REQ-0117) and NP-8 SMT solving (REQ-0197). --- */
        part def _3_Computational_Complexity_Algorithmic_Bounds {
        }
        part def _4_Verification_Conformance_Criteria {
        }
    }
}