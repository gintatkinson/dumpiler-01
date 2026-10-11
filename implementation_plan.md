# Implementation Plan -- Mermaid Diagram Visual Verification & Screenshot Proof

**Objective**: Verify and prove that every single non-requirement issue on GitHub (`gintatkinson/dumpiler-01`) containing Mermaid diagrams renders correctly without syntax or parser errors, by capturing visual screenshot proofs using headless browser testing tools and compiling a definitive verification report.

---

## 1. Problem Statement & Scope

The user requested empirical, visual proof that every non-requirement issue on GitHub renders its Mermaid diagram(s) correctly:
- **Target Repository**: `gintatkinson/dumpiler-01`
- **Scope Filter**: All issues in the repository, strictly **excluding** requirements (i.e. excluding `Feature *`, `Epic *`, `User Story *`, `Use Case *`, `REQ-*`).
- **Target Selection**: Every non-requirement issue containing ```` ```mermaid ```` code blocks.
- **Verification Standard**: Visual rendering via headless browser testing tools (Google Chrome Headless), capturing full-resolution screenshots of each rendered diagram.

---

## 2. Proposed Deliverables

### Deliverable 1: Visual Screenshot Proofs (`docs/reports/mermaid_proofs/`)
- Directory dedicated to storing rendered PNG screenshots for each verified issue.
- Naming convention: `issue_<NUMBER>_mermaid_<INDEX>.png` (e.g., `issue_1_mermaid_1.png`, `issue_124_mermaid_1.png`).

### Deliverable 2: Visual Verification Dossier (`docs/reports/MERMAID_RENDERING_VERIFICATION.md`)
A comprehensive, publication-grade markdown report including:
1. **Executive Summary Table**:
   - Issue Number & Title
   - Diagram Type (`sequenceDiagram`, `classDiagram`, `stateDiagram-v2`, `flowchart`, etc.)
   - Render Status (`PASS` / `FAIL`)
   - Relative link to the captured PNG screenshot
2. **Per-Issue Verification Gallery**:
   - Issue URL and metadata
   - Raw Mermaid diagram source code
   - Embedded screenshot proof (`![Issue #N Mermaid Proof](mermaid_proofs/issue_N_mermaid_1.png)`)
   - Syntax validation notes (conformance to semicolon, bracket, and brace invariants from `rules/platform-independence.md`)

---

## 3. Subagent Execution Strategy

Per repository rules (`AGENTS.md` § *Strict Coordinator Tool Locking*, *Mandatory Teamwork Preview Gate*, and Teamwork Delegation Protocol):
- The coordinator does not perform task implementation or authoring directly.
- Upon human approval of this preview, the coordinator will dispatch the teamwork multi-agent system:
  * **Role**: `Mermaid Visual Verification Team`
  * **TypeName**: `teamwork_preview`
  * **Workspace**: `inherit`
  * **Prompt Payload**: Verbatim task prompt preserved without modification.
- **Subagent Execution Steps**:
  1. **Step 1 (Ingest Governance)**: Subagent reads `.pipeline/constitution.md` and `.pipeline/ACTIVE_RULES_BUNDLE.md`.
  2. **Step 2 (Issue Discovery & Extraction)**: Query GitHub via `gh issue list --repo gintatkinson/dumpiler-01 --state all --limit 300 --json number,title,body`, filter out requirement titles, extract all non-requirement issues containing Mermaid diagrams, and save the raw diagram blocks.
  3. **Step 3 (Offline Headless Rendering & Screenshot Harness)**:
     - Utilize a local HTML harness embedding Mermaid.js and the extracted diagram.
     - Invoke `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome --headless --screenshot=... --window-size=1280,800` to capture visual PNG screenshots.
     - Inspect the browser console / DOM output to confirm zero SVG rendering errors or syntax error markers.
  4. **Step 4 (Report Synthesis)**: Author `docs/reports/MERMAID_RENDERING_VERIFICATION.md` and commit screenshots under `docs/reports/mermaid_proofs/`.
  5. **Step 5 (Quality Gate Verification)**:
     - Run `./target/release/verify-baseline . --no-domain` to ensure 32/32 repository quality gates pass.
     - Verify zero Unicode em dashes across all created files.
  6. **Step 6 (Commit & Remote Sync)**:
     - Commit changes with neutral citation: `docs(reports): add visual mermaid screenshot verification dossier (refs #124, refs #125)`.
     - Push to `origin/main` and verify `git diff origin/main` is empty.

---

## 4. Acceptance Criteria

- [ ] All non-requirement issues on `gintatkinson/dumpiler-01` are identified and cataloged.
- [ ] Every Mermaid diagram from every non-requirement issue is extracted and rendered.
- [ ] PNG screenshot captured for each diagram and saved to `docs/reports/mermaid_proofs/`.
- [ ] Zero rendering or syntax failures across all diagrams.
- [ ] `docs/reports/MERMAID_RENDERING_VERIFICATION.md` generated with full table, embedded screenshots, and issue links.
- [ ] `./target/release/verify-baseline . --no-domain` passes all 32 checks with 0 findings.
- [ ] Zero Unicode em dashes in newly created files.
- [ ] Committed with neutral issue citations and pushed cleanly to `origin/main`.

---

## 5. Human Approval Gate

Per `AGENTS.md` § Strict Planning Gate:
The coordinator is halted and awaiting your explicit approval.
To authorize execution of this plan and dispatch the verification subagent, reply with **PROCEED**.
