# Scope: Check 7 Hollow Gate Regression Audit & Filing

## Architecture
- Target Skill: `skills/adversarial-code-auditor/SKILL.md:186-207` (Check 7)
- Associated Toolchain Code: `crates/deap-core/src/markdown.rs:326-415`, `crates/deap-core/src/rules.rs:23`
- Normative Rule: `rules/platform-independence.md:21`
- Invariant Violations: REQ-0015 (Zero-Regex Monotonic Scanning) & Test Integrity Pillar
- Target Dossier Output: `.pipeline/defects/dossier_check7_hollow_gate_regression.md`
- Target Remote Issue: GitHub issue filed via `gh issue create` (Issue #126)

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | Forensic Investigation | Trace Check 7 gutting in commit f3fbfdd, issues #121/#123 parse failures, markdown.rs gap, and rules.rs defect exclusion | M1 | ORIGINAL_REQUEST.md |
| 2 | Dossier Generation | Author canonical 7-section defect dossier in `.pipeline/defects/dossier_check7_hollow_gate_regression.md` matching Section 2 skeleton character-for-character | M1 | skills/adversarial-code-auditor/SKILL.md |
| 3 | Mermaid Diagram Verification | Section 4 sequenceDiagram illustrating Check 7 hollow verification gate failure, strictly zero semicolons in Note lines and text | M1 | rules/platform-independence.md |
| 4 | Step D Offline Verification | Execute all 12 checks of Step D verification on the generated dossier body file | M1 | skills/adversarial-code-auditor/SKILL.md |
| 5 | Issue Filing | File verified defect issue via `gh issue create` with label `bug` | M1 | skills/adversarial-code-auditor/SKILL.md |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| 1 | M1: Adversarial Audit & Issue Filing | Investigate Check 7 regression, draft 7-section dossier, verify Section 4 diagram (zero semicolons), pass Step D checks, file via gh issue create | none | DONE |

## Interface Contracts
- Input: `skills/adversarial-code-auditor/SKILL.md`, `crates/deap-core/src/markdown.rs`, `crates/deap-core/src/rules.rs`, `rules/platform-independence.md`
- Output: `.pipeline/defects/dossier_check7_hollow_gate_regression.md`
- Issue Tracker: GitHub Issue #126 (https://github.com/gintatkinson/dumpiler-01/issues/126) with label `bug`.
