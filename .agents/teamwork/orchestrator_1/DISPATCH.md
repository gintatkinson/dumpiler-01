## 2026-10-11T07:37:28Z
Execute the total metadata integrity and taxonomy standardization plan in gintatkinson/dumpiler-01:

### 1. Unified Metadata Contract (Eliminate YAML Frontmatter)
In `crates/compile-sysml/src/sync/forward.rs`:
- Remove raw YAML frontmatter (--- ... ---) from all specification generation templates (Epics, Features, User Stories, Use Cases).
- Emit the native CommonMark 2-column table directly at lines 1-10 with exact header:
  | Attribute | Specification Detail |
  | :--- | :--- |
- Include all mandatory attributes per rules/specification-metadata-integrity.md:
  - Epics: Issue ID, Title, Type, Package, Subsystem, Generation Mode, Specification Source (e.g. [schema/model.sysml](../../schema/model.sysml)).
  - Features: Issue ID, Title, Type, Parent Epic link, Interface Type, Schema Containers, Generation Mode, Specification Source.
  - User Stories: Issue ID, Title, Type, Parent Epic link, SysML Interaction, SysML Test Case, Generation Mode, Specification Source.
  - Use Cases: Issue ID, Title, Type, Primary Actor, Scope, Level, Generation Mode, Specification Source.
In `.pipeline/constitution.md`:
- Update line 94 to mandate unique issue_id in the CommonMark metadata table instead of YAML frontmatter.
In `crates/verify-baseline/src/spec_audit/`:
- Ensure metadata validator verifies CommonMark table at lines 1-10 and flags raw YAML frontmatter in specs as a finding.

### 2. Taxonomy Standardization (Purge "Worker" & Fractional Phases)
- In `skills/spec-orchestrator/SKILL.md`: Purge all occurrences of "Worker" and fractional phases (Phase 0.5, Phase 0.75). Standardize on Phase (Macro Milestone), Step (Procedural Step), and Subagent Role.
- In `skills/feature-driven-implementation/SKILL.md`: Standardize all agent references to context-isolated Subagents with explicit Roles.
- In `.pipeline/constitution.md`: Purge legacy references to "workers".
- Recompile `.pipeline/ACTIVE_RULES_BUNDLE.md`.

### 3. Closed-Loop Toolchain Execution & Remote Sync
- Run `cargo build --release --workspace`.
- Run `./target/release/compile-sysml --forward-sync --force` to regenerate all 94 specification files in `docs/` with the compliant CommonMark table at lines 1-10.
- Run `./target/release/verify-baseline . --spec-only` (assert 0 findings).
- Run `./target/release/verify-baseline . --no-domain` (assert all 31 checks pass).
- Commit with neutral citation: `feat(spec-core): enforce native metadata tables and clean taxonomy (refs #115)`.
- Push to `origin/main` and verify `git diff origin/main` is empty.

Invariants:
- Zero Em Dash Invariant: Unicode em dashes (\u2014) are strictly forbidden. Use ASCII -- exclusively.
- Commit Message Non-Closure Invariant: Auto-closing keywords are forbidden. Use neutral citations: (refs #115).

PROCEED
