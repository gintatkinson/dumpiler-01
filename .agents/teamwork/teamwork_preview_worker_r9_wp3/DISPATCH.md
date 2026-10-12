# Dispatch for Worker R9-WP3

Working directory: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_r9_wp3

Task: Work Package 3 -- Arm `verify-baseline` with Semantic Quality Gates (`crates/verify-baseline`)
Requirements:
1. Add Anti-Stutter Gate: Mechanically fail if a specification title or filename contains stuttering prefixes (e.g. `Use Case 01: UC 01` or `UC-01-UC_01_`).
2. Add Anti-Boilerplate Gate: Mechanically fail if Use Cases contain canned fallback strings (`"initiates workflow execution"`, `"processes structural elements and validates semantic constraints"`), if Main Success Scenario has fewer than 5 steps, or if Alternate and Exception Flows have fewer than 3 exception cases.
3. Add Use Case Diagram Compliance Gate: Mechanically fail if Use Case diagrams lack a system boundary subgraph, use directed arrows to actors, use non-stadium nodes, or consist of trivial 2-node flows.
4. Add Epic Statechart Heterogeneity Gate: Mechanically fail if Epics share identical canned statecharts.
5. Add Parent Epic Alignment Gate: Mechanically fail if User Stories link to a mismatching parent Epic.
Verify with `cargo check --workspace` and `cargo test -p verify-baseline`.

## 2026-10-11T20:32:28Z
Execute Work Package 3:
### R3. Arm `verify-baseline` with Semantic Quality Gates (`crates/verify-baseline`)
In `crates/verify-baseline` (e.g. `src/spec_audit/`, `src/spec_audit/sections.rs`, `src/spec_audit/metadata.rs`, `src/spec_audit/uml_validator.rs`, `src/spec_audit/diagram_ast.rs`, and/or `src/runner.rs`):
1. **Anti-Stutter Gate**: Mechanically fail if a specification title or filename contains stuttering prefixes (e.g. `Use Case 01: UC 01` or `UC-01-UC_01_` or `UC_XX_`).
2. **Anti-Boilerplate Gate**: Mechanically fail if Use Cases contain canned fallback strings (`"initiates workflow execution"`, `"processes structural elements and validates semantic constraints"`), if Main Success Scenario has fewer than 5 steps, or if Alternate and Exception Flows have fewer than 3 exception cases (e.g. `5a`, `5b`, `5c`).
3. **Use Case Diagram Compliance Gate**: Mechanically fail if Use Case diagrams lack a system boundary subgraph, use directed arrows (`-->`) to actors, use non-stadium nodes (`["..."]` instead of `(["..."])`), or consist of trivial 2-node flows.
4. **Epic Statechart Heterogeneity Gate**: Mechanically fail if Epics share identical canned statecharts (e.g., if multiple epics share the exact same `Bootstrapping -> Ingesting -> Compiling -> Verifying` transitions without subsystem-specific states).
5. **Parent Epic Alignment Gate**: Mechanically fail if User Stories link to a mismatching parent Epic (e.g. non-conops story declaring `Parent Epic: EPIC-02-ConOps` when its package/subsystem is different).

Zero Unicode em dashes (`\u2014`) allowed. Use ASCII -- exclusively.

VERIFICATION REQUIREMENTS:
1. Run `cargo check --workspace` to ensure clean compilation.
2. Run `cargo test -p verify-baseline` to verify unit and regression tests pass.
3. Write your handoff report to `/Users/perkunas/jail/dumpiler-01/.agents/teamwork/teamwork_preview_worker_r9_wp3/handoff.md`.
4. Send a completion message back to parent using `send_message`.
