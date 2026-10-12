# Implementation Plan -- Synthesize 10-Pillar STPA Safety Assurance Suite for `uav-012`

**Objective**: Synthesize, verify, and deliver the complete 10-pillar STPA Safety Assurance Matrix and FMECA suite for `uav-012` (`/Users/perkunas/jail/uav-012`) derived from its authoritative SysML v2 AST model (`schema/model.sysml`), verify that Check 17 and all baseline quality gates pass cleanly, achieve 100% green GitLab CI on Merge Request !5, and push to remote.

---

## 1. Context & Completed Work Packages

- **Target Workspace**: `/Users/perkunas/jail/uav-012` (GitLab: `https://gitlab.com/gintatkinson/uav-012.git`, branch `Phase-1-baseline`).
- **Initial Delivery**:
  - Fixed syntax error in `uav-012/schema/model.sysml` at line 2401.
  - Installed release toolchain in `uav-012/target/release/`.
  - Transpiled complete 10-deliverable STPA suite under `uav-012/docs/safety/`.
  - Check 17 verified passing.
  - Committed with neutral citation `feat(safety): synthesize 10-pillar STPA safety assurance suite (refs #9)` and pushed to `feat/stpa-safety-assurance-suite`.
  - GitLab Merge Request !5 opened: https://gitlab.com/gintatkinson/uav-012/-/merge_requests/5.
- **GitLab CI Diagnostic Findings**:
  - GitLab CI pipeline #2937728442 failed on `lint:downstream-baseline` due to Check 13B (Mermaid syntax & ergonomics) in the generated safety deliverables:
    1. `docs/safety/01_LOSSES_HAZARDS_TOPOLOGY.md`:
       - Subgraph `Hierarchical Safety Control Structure` missing explicit `direction TB`.
       - Node labels exceed 35 characters without `<br/>` wrapping (e.g. `ASTK_A5_V2_5_IAU (Supervisory Controller)`).
       - Commas inside quoted edge labels (`"supervisory dispatch: trigger_lowering, invoke_codegen"`, `"artifact synthesis: lower_ast, write_binaries"`, `"sensor feedback: diagnostic_errors, verification_metrics"`), which GitLab's GLFM parser rejects.
    2. `docs/safety/07_RTA_ARCHITECTURE.md`:
       - Subgraph `Run-Time Assurance Architecture` missing explicit `direction TB`.
       - Node labels exceed 35 characters without `<br/>` wrapping (e.g. `High Assurance Channel (CompilerAssuranceEngine)`).

---

## 2. Work Packages Decomposition

### Work Package 1: Syntax Cleanliness in `uav-012/schema/model.sysml` [COMPLETED]
- Fixed line 2401 of `/Users/perkunas/jail/uav-012/schema/model.sysml` by stripping literal escape characters.

### Work Package 2: Toolchain Setup in `uav-012` [COMPLETED]
- Installed release binaries (`compile-sysml`, `verify-baseline`, `reconcile-backlog`) in `uav-012/target/release/`.

### Work Package 3: STPA Transpilation & Safety Artifact Generation [COMPLETED]
- Transpiled 10 safety deliverables in `uav-012/docs/safety/`.

### Work Package 4: Quality Gate & Baseline Verification [COMPLETED]
- Verified Check 17 passes cleanly.

### Work Package 5: Remote Push & GitLab MR Creation [COMPLETED]
- Pushed branch `feat/stpa-safety-assurance-suite` and opened GitLab MR !5.

### Work Package 6: STPA Generator GLFM & Mermaid Ergonomics Overhaul (`dumpiler-01`)
- In `crates/compile-sysml/src/stpa/safety_suite.rs`:
  - Add explicit `direction TB` inside `Hierarchical Safety Control Structure` and `Run-Time Assurance Architecture` subgraphs.
  - Wrap node labels with `<br/>` so that no label line exceeds 35 characters:
    - `ASTK_A5_V2_5_IAU<br/>(Supervisory Controller)`
    - `UniversalIngestionEngine<br/>(Actuator Engine)`
    - `DownstreamApplicationHost<br/>(Execution Environment)`
    - `CompilerAssuranceEngine<br/>(Diagnostic Sensors)`
    - `High Assurance Channel<br/>(CompilerAssuranceEngine)`
    - `Safety Monitor Switch<br/>(StateMachineSolverEngine)`
    - `Recovery Channel<br/>(SafetyAssuranceEngine)`
    - `System Under Assurance<br/>(DEAPCompilerSystem)`
  - Replace commas in edge labels with dashes (` - `) to eliminate GLFM parser rejections:
    - `"supervisory dispatch: trigger_lowering - invoke_codegen"`
    - `"artifact synthesis: lower_ast - write_binaries"`
    - `"sensor feedback: diagnostic_errors - verification_metrics"`
  - Update unit test assertions in `safety_suite.rs` to reflect the updated diagram strings.
- Rebuild workspace release binaries:
  ```bash
  cargo build --release --workspace
  ```
- Regenerate `dumpiler-01/docs/safety/` and assert baseline passes:
  ```bash
  ./target/release/compile-sysml --schema schema/model.sysml --stpa-transpile --out-dir docs/safety
  ./target/release/verify-baseline . --no-domain
  ```

### Work Package 7: Re-transpile & Push in `uav-012` to Clear GitLab CI
- Copy updated `target/release/compile-sysml` to `/Users/perkunas/jail/uav-012/target/release/compile-sysml`.
- In `/Users/perkunas/jail/uav-012`:
  - Re-run `./target/release/compile-sysml --schema schema/model.sysml --stpa-transpile --out-dir docs/safety`.
  - Verify that Check 13B and Check 17 both pass cleanly.
  - Commit changes under neutral citation: `feat(safety): format STPA Mermaid diagrams for GLFM compliance (refs #9)` (strictly zero em dashes, zero auto-closing keywords).
  - Push to `origin feat/stpa-safety-assurance-suite`.
  - Monitor and verify GitLab CI pipeline on MR !5 until green.

---

## 3. Acceptance Criteria

- [x] `schema/model.sysml` in `uav-012` parses with zero syntax errors.
- [x] Initial 10-pillar STPA suite generated under `uav-012/docs/safety/`.
- [x] Check 17 verified passing.
- [x] GitLab Merge Request !5 opened.
- [ ] `crates/compile-sysml/src/stpa/safety_suite.rs` updated with `direction TB`, `<br/>` line wrapping ($\le 35$ chars), and zero commas in edge labels.
- [ ] Workspace builds cleanly with `cargo check --workspace` and `cargo test --workspace`.
- [ ] `dumpiler-01` and `uav-012` safety documents regenerated and pass all Mermaid / GLFM lint gates.
- [ ] Updated commit pushed to `feat/stpa-safety-assurance-suite` on GitLab.
- [ ] GitLab CI pipeline on MR !5 passes.

---

## 4. Human Authorization Gate

Per `AGENTS.md` § **Strict Planning Gate**:
To authorize execution of Work Packages 6 and 7, please reply with **PROCEED**.
