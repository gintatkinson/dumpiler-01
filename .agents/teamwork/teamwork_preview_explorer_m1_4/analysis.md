# Technical Analysis: Mermaid Diagram Extraction and Headless Rendering Audit

## Executive Summary

A comprehensive discovery and syntax audit was executed against all 125 issues in the GitHub repository `gintatkinson/dumpiler-01`.
Following strict governance requirements, all 105 requirement issues (`Feature *`, `Epic *`, `User Story *`, `Use Case *`, `REQ-*`) were filtered out.
The remaining 20 non-requirement issues were inspected, parsed, and tested for Mermaid diagram blocks.
Every single non-requirement issue (20 of 20) contains exactly one Mermaid diagram (all of type `sequenceDiagram`).

When evaluated against Mermaid parser grammar and rendered in a local headless Chrome session (`/Applications/Google Chrome.app/Contents/MacOS/Google Chrome` v155.0.8059.39) using Mermaid JS v10.9.1:
- **18 diagrams PASS** rendering cleanly without syntax or parser errors.
- **2 diagrams FAIL** rendering with Mermaid parse errors:
  - **Issue #121**: Parse error on line 18 due to an unescaped semicolon `;` in a `Note` statement (`Capabilities cross-cut subsystems; Subsystems realize multiple Epics`).
  - **Issue #123**: Parse error on line 8 and line 12 due to unescaped semicolons `;` in `Note` statements (`Discards AST ports and attributes; injects...` and `Validates classes exist in part_names; skips...`).
  - **Zero Unicode Em Dashes**: 0 Unicode em dashes (`\u2014`) found across all 20 diagrams (100% compliant with ASCII `--`).

---

## 1. Issue Corpus Classification and Filtering

### 1.1 Discovery Query
Issues were queried via GitHub CLI:
```bash
gh issue list --repo gintatkinson/dumpiler-01 --state all --limit 300 --json number,title,body
```
Total issues returned: **125**.

### 1.2 Filtering Rule
All issues matching requirement prefixes (`Feature `, `Epic `, `User Story `, `Use Case `, `REQ-`) were excluded:
- `Feature *`: 65 issues
- `Epic *`: 28 issues
- `User Story *`: 6 issues
- `Use Case *`: 6 issues
- **Total Requirement Issues Excluded**: 105 issues
- **Total Non-Requirement Issues Retained**: 20 issues

---

## 2. Catalog of Non-Requirement Mermaid Diagrams

Every non-requirement issue contains exactly 1 Mermaid diagram block (Index 1).

| Issue | Title | Type | Status | Semicolons | Em Dashes | Lines | Size (W x H) |
|:-----:|:------|:----:|:------:|:----------:|:---------:|:-----:|:------------:|
| #1 | [AUDIT] [markdown.rs]: Acceptance criteria detached as orphan part defs... | `sequenceDiagram` | **PASS** | 0 | 0 | 18 | 1554 x 556 |
| #2 | feat(schema): formalize invariant constraints lowering... | `sequenceDiagram` | **PASS** | 0 | 0 | 17 | 1500 x 515 |
| #3 | fix(schema): encapsulate formal invariant constraints directly... | `sequenceDiagram` | **PASS** | 0 | 0 | 15 | 1480 x 454 |
| #4 | [AUDIT] [main.rs]: Shallow Directory Ingestion in find_sysml_in_dir... | `sequenceDiagram` | **PASS** | 0 | 0 | 22 | 1450 x 685 |
| #5 | [AUDIT] [scanner.rs]: Nested Block Comment Truncation... | `sequenceDiagram` | **PASS** | 0 | 0 | 17 | 1420 x 528 |
| #6 | [AUDIT] [grammar.rs]: Parser rejects connect keyword in connection... | `sequenceDiagram` | **PASS** | 0 | 0 | 19 | 1510 x 735 |
| #7 | [AUDIT] [parity_gates.rs]: discover_sysml_model_text swallows I/O errors... | `sequenceDiagram` | **PASS** | 0 | 0 | 24 | 1580 x 765 |
| #8 | [AUDIT] [sysmlv2_ast.py]: Unbounded Port Regex Misclassifies Import... | `sequenceDiagram` | **PASS** | 0 | 0 | 19 | 1490 x 673 |
| #9 | [AUDIT] [forward.rs]: Hardcoded Fallback Domain Concepts... | `sequenceDiagram` | **PASS** | 0 | 0 | 22 | 1540 x 669 |
| #115 | [AUDIT] [architecture.sysml]: Non-structural document part defs... | `sequenceDiagram` | **PASS** | 0 | 0 | 19 | 1470 x 344 |
| #116 | [AUDIT] [activities.sysml]: Monolithic Level 0 Operational Activities... | `sequenceDiagram` | **PASS** | 0 | 0 | 17 | 1460 x 398 |
| #117 | [AUDIT] [behavior.sysml]: Empty subsystem package traps execution flows... | `sequenceDiagram` | **PASS** | 0 | 0 | 17 | 1480 x 704 |
| #118 | [AUDIT] [forward.rs]: Hardcoded Mock Test Data Shape and Canned Compiler... | `sequenceDiagram` | **PASS** | 0 | 0 | 21 | 1520 x 563 |
| #119 | [AUDIT] [forward.rs]: Cross-wired and phantom Realization Matrices... | `sequenceDiagram` | **PASS** | 0 | 0 | 14 | 1430 x 476 |
| #120 | [AUDIT] [model.sysml]: Dangling Subsystem Ports and Broken Pipeline... | `sequenceDiagram` | **PASS** | 0 | 0 | 18 | 1560 x 392 |
| #121 | Defect: Artificial 1:1 Epic-to-Subsystem Partitioning in REQ-0161... | `sequenceDiagram` | **FAIL** | 1 | 0 | 21 | 0 x 0 (error) |
| #122 | [AUDIT] Architecture: Eliminate brittle shell scripts (>50 lines)... | `sequenceDiagram` | **PASS** | 0 | 0 | 32 | 1620 x 1035 |
| #123 | [AUDIT] [forward.rs]: Synthetic Class Diagram Stub Gaming... | `sequenceDiagram` | **FAIL** | 2 | 0 | 19 | 0 x 0 (error) |
| #124 | [AUDIT] [SKILL.md]: Step D Check 7 Offline Syntax Gate Fails... | `sequenceDiagram` | **PASS** | 0 | 0 | 12 | 1200 x 648 |
| #125 | [AUDIT] [SKILL.md]: Step C.9 and Step D.12 Impose Phantom Test Runner... | `sequenceDiagram` | **PASS** | 0 | 0 | 13 | 1250 x 526 |

---

## 3. Deep-Dive Syntax and Defect Analysis

### 3.1 Failure Root Cause in Issue #121
- **File / Source**: Issue #121 body line 56-74
- **Defective Line**:
  ```mermaid
  Note over Engine,Epics: Capabilities cross-cut subsystems; Subsystems realize multiple Epics
  ```
- **Parser Mechanism**: In Mermaid sequence diagram grammar, `;` functions as a statement terminator. When `;` is parsed within `Note over Engine,Epics: ...`, the parser treats `Subsystems realize multiple Epics` as the start of a subsequent participant-message statement. Because `Subsystems` is followed by words rather than arrow tokens (`->>`, `-->>`), the parser throws:
  `Parse error on line 18: Expecting 'SOLID_OPEN_ARROW', 'DOTTED_OPEN_ARROW', ... got 'NEWLINE'`
- **Remediation**:
  Replace `;` with ASCII `--`:
  ```mermaid
  Note over Engine,Epics: Capabilities cross-cut subsystems -- Subsystems realize multiple Epics
  ```
- **Verification**: Verified via test harness. With `--`, Issue #121 renders completely without errors into a 68 KB PNG.

### 3.2 Failure Root Cause in Issue #123
- **File / Source**: Issue #123 body line 62-78
- **Defective Lines**:
  - Line 8:
    ```mermaid
    Note over Compiler: Discards AST ports and attributes; injects synthetic 3-line stub (lines 751-765)
    ```
  - Line 12:
    ```mermaid
    Note over Validator: Validates classes exist in part_names; skips empty member checks (lines 372-438)
    ```
- **Parser Mechanism**: Identical to Issue #121, both semicolons break the `Note` statement and cause subsequent text to be parsed as malformed messages.
- **Remediation**:
  Replace `;` with ASCII `--` on both lines:
  ```mermaid
  Note over Compiler: Discards AST ports and attributes -- injects synthetic 3-line stub (lines 751-765)
  ...
  Note over Validator: Validates classes exist in part_names -- skips empty member checks (lines 372-438)
  ```
- **Verification**: Verified via test harness. With `--`, Issue #123 renders completely without errors into a 63 KB PNG.

### 3.3 Confirmation with Issue #124 Governance Finding
Issue #124 was filed specifically as an adversarial audit finding titled:
`[AUDIT] [SKILL.md]: Step D Check 7 Offline Syntax Gate Fails to Enforce Semicolon and Curly Brace Invariants`
Section 1.5 of that issue explicitly states:
`"Most importantly here: no semicolons in Note statements or message text, and no curly braces in class member lines."`
The rendering failures observed in Issues #121 and #123 directly confirm the defect identified in Issue #124.

---

## 4. Headless Browser Toolchain Evaluation

Empirical inspection was performed on the host environment:
1. **Google Chrome Binary**:
   - Location: `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`
   - Version: `Google Chrome 155.0.8059.39`
   - Execution Mode: Functional with `--headless` and `--screenshot`.
2. **Node Runtime**:
   - Node: `/opt/homebrew/bin/node` (v26.0.0)
   - NPM: `/opt/homebrew/bin/npm` (11.12.1)
   - Note: `mmdc` (mermaid-cli) is not installed globally.
3. **Mermaid Engine**:
   - Library: `mermaid.min.js` (v10.9.1, 3.2 MB) downloaded and tested locally.
   - Initializer Configuration:
     ```javascript
     mermaid.initialize({
       startOnLoad: true,
       theme: 'default',
       securityLevel: 'loose',
       sequence: { useMaxWidth: false }
     });
     ```
4. **Headless Execution Invocation**:
   Chrome Headless requires `--virtual-time-budget=2000` or higher to ensure the asynchronous Mermaid DOM layout engine finishes rendering the SVG before the screenshot is captured:
   ```bash
   "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
     --headless \
     --virtual-time-budget=2000 \
     --screenshot="docs/reports/mermaid_proofs/issue_<N>_mermaid_<M>.png" \
     --window-size=1600,1000 \
     --default-background-color=00000000 \
     "file://<ABSOLUTE_PATH>/fixture.html"
   ```

---

## 5. Architectural Recommendations for Milestone M2 & M3

1. **GitHub Issue Tracker Alignment**:
   In Milestone M2, either:
   - Capture visual proof of the raw state on GitHub (recording #121 and #123 as `FAIL` with screenshot evidence of the error), OR
   - Propose/execute an issue body update (`gh issue edit 121 --body ...` and `gh issue edit 123 --body ...`) replacing `;` with `--`, allowing 100% (20/20) PASS rate.
2. **Artifact Directory Structure**:
   Ensure `docs/reports/mermaid_proofs/` is created prior to Milestone M2 execution.
3. **Verification Dossier Formulation**:
   Format `docs/reports/MERMAID_RENDERING_VERIFICATION.md` in Milestone M3 following Requirement R4, embedding both the executive summary table and visual screenshot gallery.
