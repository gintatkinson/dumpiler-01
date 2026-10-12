# Handoff Report: Defect Repair for Issue #121

## 1. Observation
- **Target Files & Locations**:
  - `schema/REQ-0161.md:24-45`
  - `schema/subsystems/downstream_agile_projections/requirements.sysml:48-67`
  - `.pipeline/schema.sysml:1959-1979`
  - `.pipeline/schema-digest.json:1-10, 850-858`
- **Verbatim Defect Statements (Before Repair)**:
  - Normative statement (`schema/REQ-0161.md:24`): `"The projection engine of Subsystem 9 SHALL synthesize Epic specifications by partitioning models along top-level subsystem boundaries and projecting capability allocations."`
  - Mathematical invariant (`schema/REQ-0161.md:34-38`):
    $$E_k=\{c\in\mathcal{M}_{\text{capabilities}}\mid\text{Alloc}(c)=S_k\},\quad \bigcup_{k=1}^m E_k=\mathcal{M}_{\text{capabilities}}\land(\forall i\ne j,\,E_i\cap E_j=\emptyset)$$
    $$(\exists c:\text{Alloc}(c)=\bot\lor\text{Alloc}(c)\notin\mathcal{S}\lor\exists i\ne j:c\in E_i\cap E_j)\implies\text{Diagnostic}(c,\text{E0303})\in\mathcal{D}_{\text{sink}}$$
  - Acceptance Criterion AC-03 (`schema/REQ-0161.md:77-82`): `"Given: Capability Capability_Alpha unallocated or mapped to Subsystem_0 and Subsystem_1. When: Validating allocation partitions. Then: Rejects model, emits E0303, and binds sentinel \bot_{epic}."`
- **Tool Commands & Verbatim Outputs**:
  - `cargo check --workspace` -> Exit code 0 (`Finished dev profile [unoptimized + debuginfo] target(s) in 0.16s`).
  - `cargo build --release --workspace` -> Exit code 0 (`Finished release profile [optimized] target(s) in 0.06s`).
  - `./target/release/compile-sysml --compile` -> Exit code 0 (`Successfully compiled SysML schema 'schema' to '.pipeline/schema.sysml'`).
  - `./target/release/verify-baseline . --no-domain` -> Exit code 0 (All 32 quality gates verified with 0 findings).
  - `./target/release/verify-baseline . --spec-only` -> Exit code 0 (`Spec audit completed in 269 ms (93 files audited, 0 findings, passed: true)`).
  - `git commit` -> Commit `92ead0e`: `"fix(schema): eliminate artificial 1:1 epic partitioning in REQ-0161 in favor of M:N allocation (refs #121)"`.
  - `gh issue comment 121` -> https://github.com/gintatkinson/dumpiler-01/issues/121#issuecomment-6109916914.
  - `gh issue edit 121 --add-label "status:fixed-resolved"` -> State: `OPEN`, Labels: `["bug", "status:fixed-resolved"]`.

## 2. Logic Chain
1. *Observation*: Under OMG SysML v2 / KerML, INCOSE SE Handbook v5.0 (§3.4.4 & §4.2), ISO/IEC/IEEE 15288:2023, and SAFe 6.0, functional capabilities (`CapabilityDef`) cross-cut physical system components (`PartDef`). Allocation is inherently Many-to-Many (M:N).
2. *Observation*: REQ-0161 previously mandated disjoint partitions ($E_i \cap E_j = \emptyset$) and emitted `E0303` whenever a capability was allocated to more than one subsystem.
3. *Inference*: Repairing REQ-0161 requires replacing the 1:1 disjoint set partition with an M:N allocation model $\mathcal{A} \subseteq \mathcal{M}_{\text{capabilities}} \times \mathcal{S}$ where $|\text{AllocatedSubsystems}(c)| \ge 1$, emitting `E0303` only for unallocated or dangling/non-existent subsystem references.
4. *Inference*: Updating the normative statement, formal mathematical invariant, and acceptance criteria (AC-02 Multi-Subsystem Capability Allocation and AC-03 Dangling Capability Allocation Rejection) across both CommonMark (`schema/REQ-0161.md`) and SysML v2 model definitions (`schema/subsystems/downstream_agile_projections/requirements.sysml` and `.pipeline/schema.sysml`) restores complete alignment with OMG SysML v2 and INCOSE SE Handbook v5.0.
5. *Verification*: Recompiling the schema and running `./target/release/verify-baseline . --no-domain` and `--spec-only` verified all 32 quality gates pass with zero findings.

## 3. Caveats
- No caveats. The schema model and requirement contracts have been updated cleanly, and baseline parity has been verified. Compiler synchronization engine updates for downstream Epics projection belong to separate work packages in the implementation plan.

## 4. Conclusion
Defect Issue #121 is fixed and verified. The artificial 1:1 Epic-to-subsystem disjoint partitioning in REQ-0161 has been replaced by the normative M:N allocation model pursuant to OMG SysML v2 and INCOSE SE Handbook v5.0. All 32 quality gates pass cleanly with exit code 0. Commit `92ead0e` has been committed with neutral citation `(refs #121)`. Issue #121 has been updated with resolution evidence and transitioned to `status:fixed-resolved` while remaining Open for Product Owner review.

## 5. Verification Method
To independently verify:
```bash
cargo check --workspace
cargo build --release --workspace
./target/release/verify-baseline . --no-domain
./target/release/verify-baseline . --spec-only
git log -1 --stat
gh issue view 121 --json state,labels
```
Invalidation conditions:
- Any quality gate failing in `./target/release/verify-baseline . --no-domain` or `--spec-only`.
- Existence of disjoint set partition restrictions in `schema/REQ-0161.md` or `requirements.sysml`.
- Any auto-closing keywords in git commit message.
