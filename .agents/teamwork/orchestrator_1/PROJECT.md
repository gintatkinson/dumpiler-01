# Project: Total Metadata Integrity and Taxonomy Standardization

## Architecture
- `crates/compile-sysml`: Spec compiler and forward-sync generator. Generates markdown specs in `docs/` from SysML models.
- `crates/verify-baseline`: Semantic acceptance test and specification linter. Audits spec metadata, traceability, and structure.
- `.pipeline/`: Governance constitution, active rules bundle, and pipeline templates.
- `skills/`: Autonomous agent skills (`spec-orchestrator`, `feature-driven-implementation`).

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | Forward sync CommonMark metadata table | Replace YAML frontmatter with CommonMark 2-column table at lines 1-10 in forward.rs | M1 | User Request §1 |
| 2 | Constitution issue_id mandate | Update constitution line 94 to mandate issue_id in CommonMark table | M1 | User Request §1 |
| 3 | Spec audit metadata validator | Verify CommonMark table at lines 1-10 and flag raw YAML frontmatter | M1 | User Request §1 |
| 4 | Spec orchestrator taxonomy purge | Purge 'Worker' and fractional phases in spec-orchestrator/SKILL.md | M2 | User Request §2 |
| 5 | Feature driven implementation taxonomy purge | Standardize subagent references in feature-driven-implementation/SKILL.md | M2 | User Request §2 |
| 6 | Constitution taxonomy purge | Purge legacy references to 'workers' in constitution.md | M2 | User Request §2 |
| 7 | Recompile ACTIVE_RULES_BUNDLE.md | Recompile bundle from updated rules/constitution | M2 | User Request §2 |
| 8 | Workspace release build | Compile all release binaries cleanly | M3 | User Request §3 |
| 9 | Spec forward sync regeneration | Regenerate all 94 spec files with compliant tables | M3 | User Request §3 |
| 10 | Baseline verification | Run verify-baseline spec-only and no-domain | M3 | User Request §3 |
| 11 | Remote git sync | Commit with neutral citation (refs #115) and push | M3 | User Request §3 |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Unified Metadata Contract | `crates/compile-sysml/src/sync/forward.rs`, `.pipeline/constitution.md` (line 94), `crates/verify-baseline/src/spec_audit/` | none | DONE |
| M2 | Taxonomy Standardization | `skills/spec-orchestrator/SKILL.md`, `skills/feature-driven-implementation/SKILL.md`, `.pipeline/constitution.md`, `.pipeline/ACTIVE_RULES_BUNDLE.md` | M1 | DONE |
| M3 | Closed-Loop Execution & Sync | Build, forward-sync 94 specs, verify-baseline, git commit & push | M1, M2 | DONE |

## Interface Contracts
### `compile-sysml` ↔ `verify-baseline`
- CommonMark Table Format at lines 1-10:
```markdown
| Attribute | Specification Detail |
| :--- | :--- |
```
- Exactly lines 1-10, no leading blank lines, no raw YAML frontmatter `---`.
- Attributes:
  - Epics: Issue ID, Title, Type, Package, Subsystem, Generation Mode, Specification Source
  - Features: Issue ID, Title, Type, Parent Epic link, Interface Type, Schema Containers, Generation Mode, Specification Source
  - User Stories: Issue ID, Title, Type, Parent Epic link, SysML Interaction, SysML Test Case, Generation Mode, Specification Source
  - Use Cases: Issue ID, Title, Type, Primary Actor, Scope, Level, Generation Mode, Specification Source

## Code Layout
- `crates/compile-sysml/src/sync/forward.rs`: spec generation templates
- `crates/verify-baseline/src/spec_audit/`: metadata verification logic
- `.pipeline/constitution.md`: governance constitution
- `skills/spec-orchestrator/SKILL.md`: spec orchestrator skill definition
- `skills/feature-driven-implementation/SKILL.md`: feature driven implementation skill definition
- `.pipeline/ACTIVE_RULES_BUNDLE.md`: consolidated rules bundle
