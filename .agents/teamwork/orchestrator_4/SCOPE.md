# Scope: Mermaid Diagram Visual Verification & Report Dossier

## Architecture
- Toolchain: GitHub CLI (`gh`), Headless Chrome (`/Applications/Google Chrome.app/Contents/MacOS/Google Chrome --headless --screenshot`) or headless browser harness, local HTML test fixture using Mermaid JS (or mmdc/headless chrome), Rust verification engine (`./target/release/verify-baseline`).
- Artifact Targets:
  - Screenshots: `docs/reports/mermaid_proofs/issue_<NUMBER>_mermaid_<INDEX>.png`
  - Report Dossier: `docs/reports/MERMAID_RENDERING_VERIFICATION.md`

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | Non-Requirement Issue Discovery | Query GitHub via `gh issue list` and exclude requirement issues (`Feature *`, `Epic *`, `User Story *`, `Use Case *`, `REQ-*`) | M1 | R1 |
| 2 | Mermaid Diagram Extraction | Extract every ` ```mermaid ` block from non-requirement issues | M1 | R1 |
| 3 | Visual Headless Rendering & Screenshot Capture | Render each diagram in headless browser session without syntax/parser errors | M2 | R2 |
| 4 | Screenshot Artifact Storage | Save PNG screenshots to `docs/reports/mermaid_proofs/issue_<NUMBER>_mermaid_<INDEX>.png` | M2 | R3 |
| 5 | Verification Report Synthesis | Author `docs/reports/MERMAID_RENDERING_VERIFICATION.md` with summary table and visual gallery | M3 | R4 |
| 6 | Governance & Baseline Gates | Check 32 baseline verification, zero em dashes, git commit with neutral citations (`refs #<id>`), push to origin/main | M3 | R5 |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| 1 | M1: Discovery & Diagram Extraction | Query GitHub issues, filter non-requirement issues, catalog and extract all Mermaid diagrams | none | DONE |
| 2 | M2: Headless Rendering & Screenshot Capture | Render each diagram via Chrome Headless, verify 0 syntax/clipping errors, save PNGs in `docs/reports/mermaid_proofs/` | M1 | DONE |
| 3 | M3: Dossier Authoring & Baseline Conformance | Create `MERMAID_RENDERING_VERIFICATION.md`, verify 32 baseline gates, commit and push to `origin/main` | M2 | DONE |

## Interface Contracts
- M1 -> M2: Catalog of non-requirement Mermaid diagrams with issue numbers, titles, indices, diagram types, and exact raw diagram text.
- M2 -> M3: Set of verified PNG files in `docs/reports/mermaid_proofs/issue_<N>_mermaid_<M>.png` and render status log.
- M3 -> Done: Full report `docs/reports/MERMAID_RENDERING_VERIFICATION.md`, clean baseline exit code 0, clean git push.
