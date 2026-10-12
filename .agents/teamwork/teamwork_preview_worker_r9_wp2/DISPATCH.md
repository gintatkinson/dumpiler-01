## 2026-10-11T20:08:42Z
You are a context-isolated subagent with Role: Micro-Task Implementer.
Your working directory is: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_r9_wp2
Your parent is conversation ID: 76edfb08-05a5-45ad-a5e4-751d08836b76 (orchestrator_9).

MANDATORY FIRST STEPS:
1. Autonomously execute `view_file` on `/Users/perkunas/jail/dumpiler-01/.pipeline/constitution.md` and `/Users/perkunas/jail/dumpiler-01/.pipeline/ACTIVE_RULES_BUNDLE.md`.
2. Read the verbatim user request at `/Users/perkunas/jail/dumpiler-01/.agents/teamwork/ORIGINAL_REQUEST.md`.
3. Check `target/reference/3dgs-039/docs/use-cases/` for canonical reference Use Cases and UML diagrams.

EXCLUSIVE FILE OWNERSHIP:
You own `crates/compile-sysml/src/sync/forward.rs` (and `crates/compile-sysml/src/sync/mod.rs` if needed).

INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_preview_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

TASK OBJECTIVE:
Execute Work Package 2:
### R2. Compiler Generator Overhaul for Full Model Fidelity (`crates/compile-sysml/src/sync/forward.rs`)
- **Use Case Clean Naming & Paths**: Strip redundant `UC_XX_`, `UC-XX-`, or `UCXX_` prefixes. Generate clean titles (`Use Case 01: System Vision and Foundational Invariants`) and clean filenames (`use-cases/UC-01-System_Vision_and_Foundational_Invariants.md`). Update Epic checklist links in `forward.rs` and update `resolve_issue_id` to maintain existing issue IDs (#95--#106) across renames.
- **Rich Use Case Lowering**: Lower all 6+ numbered main scenario steps and `5a`..`5j` exception flows directly from the parsed doc block (`parsed_doc` or `uc.doc`).
- **Valid UML Use Case Diagrams**: Replace the dummy 2-node flowchart (`Actor --> Target`) with a compliant UML Use Case diagram conforming to `rules/uml-model-integrity.md`: system boundary subgraph, external actors outside the boundary, stadium-shaped use case nodes `(["..."])`, and undirected associations `---`.
- **Dynamic Specification Sources**: Bind `Specification Source` to `[schema/subsystems/{subsys_dir}/behavior.sysml]` instead of hardcoded `activities.sysml`.
- **Epic Model Parity**: Lower genuine subsystem `state def` from `behavior.sysml` (e.g. `StateSolverExecutionStatechart`) into Epic statecharts instead of the canned `Bootstrapping -> Ingesting -> Compiling -> Verifying`. Expand Epic class diagrams to include all constituent `part def`, `port def`, and attributes from `architecture.sysml`.
- **User Story Model Parity**: Lower genuine `interaction def` lifelines and messages from `behavior.sysml` into sequence diagrams. Bind `Parent Epic` to the declaring subsystem Epic instead of hardcoded `[EPIC-02-ConOps]`.

Zero Unicode em dashes (`\u2014`) allowed. Use ASCII `--` exclusively.

VERIFICATION REQUIREMENTS:
1. Run `cargo check --workspace` to ensure clean build.
2. Run `cargo test -p compile-sysml` to verify unit tests pass.
3. Write your handoff report to `/Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_r9_wp2/handoff.md`.
4. Send a completion message back to parent using `send_message`.

PROCEED
