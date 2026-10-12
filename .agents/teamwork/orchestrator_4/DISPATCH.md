## 2026-10-11T11:37:26Z

You are the Project Orchestrator (teamwork_preview_orchestrator).
Your working directory is: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/orchestrator_4
Authoritative user request is recorded in: /Users/perkunas/jail/dumpiler-01/.agents/teamwork/ORIGINAL_REQUEST.md

Verbatim User Directive:
Verify that every single non-requirement issue on GitHub in repository gintatkinson/dumpiler-01 containing Mermaid diagrams renders correctly without syntax or parser errors, capture visual screenshot proofs using headless browser testing tools, and compile a comprehensive verification report.

Working directory: /Users/perkunas/jail/dumpiler-01
Integrity mode: development

## Requirements

### R1. Non-Requirement Issue Discovery & Diagram Extraction
Query all issues from GitHub repository `gintatkinson/dumpiler-01` via `gh issue list --repo gintatkinson/dumpiler-01 --state all --limit 300 --json number,title,body`. Strictly exclude all requirement issues (those titled `Feature *`, `Epic *`, `User Story *`, `Use Case *`, or `REQ-*`). Extract every Mermaid diagram code block (```mermaid) from the remaining non-requirement issues.

### R2. Visual Headless Rendering & Screenshot Capture
For every extracted Mermaid diagram, render it in a local headless browser session using Chrome Headless (`/Applications/Google Chrome.app/Contents/MacOS/Google Chrome --headless --screenshot`) or an equivalent headless browser harness. Capture a full visual PNG screenshot verifying that the diagram rendered successfully without syntax errors, missing elements, or layout failures.

### R3. Screenshot Artifact Storage
Save each captured PNG screenshot directly into the repository under `docs/reports/mermaid_proofs/` using the naming format `issue_<NUMBER>_mermaid_<INDEX>.png` (e.g. `issue_1_mermaid_1.png`, `issue_124_mermaid_1.png`).

### R4. Verification Report Synthesis
Author a comprehensive verification report in `docs/reports/MERMAID_RENDERING_VERIFICATION.md` featuring:
1. An executive summary table detailing each issue number, title, diagram type, render status (`PASS`/`FAIL`), and screenshot link.
2. A visual gallery section embedding each captured PNG screenshot alongside its issue URL and raw diagram source code.

### R5. Governance & Repository Baseline Gates
Verify that all 32 checks of `./target/release/verify-baseline . --no-domain` pass cleanly. Strictly observe the Zero Em Dash Invariant (ASCII `--` exclusively). Commit the report and screenshot artifacts with neutral issue citations (`docs(reports): add mermaid visual rendering verification dossier (refs #124, refs #125)`), push to `origin/main`, and verify `git diff origin/main` is empty.

## Acceptance Criteria

### Discovery & Extraction
- [ ] All issues in `gintatkinson/dumpiler-01` queried and filtered
- [ ] 100% of non-requirement issues containing Mermaid diagrams identified and cataloged

### Rendering & Screenshot Proofs
- [ ] Every non-requirement Mermaid diagram rendered via headless browser
- [ ] Individual PNG screenshots captured and saved to `docs/reports/mermaid_proofs/`
- [ ] Zero syntax, SVG clipping, or parser errors across all rendered diagrams

### Documentation & Baseline Conformance
- [ ] `docs/reports/MERMAID_RENDERING_VERIFICATION.md` created with summary table and embedded screenshots
- [ ] `./target/release/verify-baseline . --no-domain` passes all 32 quality gates with 0 findings
- [ ] Zero Unicode em dashes across all created files
- [ ] Changes committed with neutral citations and pushed cleanly to `origin/main`

PROCEED
