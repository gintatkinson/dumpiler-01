# Implementation Plan -- Eradicate All Regex, Purge Python Debris, and Arm Baseline Quality Gates (Checks 33 & 34)

**Objective**: Permanently purge all Python script debris from the workspace, eliminate all 181 regular expression call sites across all 6 Rust compiler crates (`assemble-conops`, `reconcile-backlog`, `verify-baseline`, `ingest-sysml`, `compile-sysml`, `deap-core`), completely evict the `regex` crate dependency from all crate manifests and the workspace dependency tree, and arm `./target/release/verify-baseline` with Check 33 (Zero Python Scripts Invariant) and Check 34 (Zero Regex Invariant) backed by empirical negative falsification proofs and adversarial mutation testing.

---

## 1. Root Cause & Defect Inventory

### A. Python Script Debris (12 files previously under `.agents/teamwork/`)
Subagents previously took ad-hoc shortcuts by writing Python utility scripts to parse markdown and issues, concealed from `git status` via `.gitignore`:
- `.agents/teamwork/teamwork_preview_worker_p2_diff/analyze_specs.py`
- `.agents/teamwork/victory_auditor_3/verify_step_d.py`
- `.agents/teamwork/teamwork_preview_explorer_m1_4/audit_summary.py`
- `.agents/teamwork/teamwork_preview_explorer_m1_4/verify_all_diagrams.py`
- `.agents/teamwork/teamwork_preview_explorer_m1_4/verify_filter.py`
- `.agents/teamwork/teamwork_preview_explorer_m1_4/parse_issues.py`
- `.agents/teamwork/teamwork_preview_explorer_m1_4/extract_diagrams.py`
- `.agents/teamwork/teamwork_preview_explorer_m1_4/generate_fixtures.py`
- `.agents/teamwork/teamwork_preview_explorer_m1_4/test_render.py`
- `.agents/teamwork/teamwork_preview_explorer_m1_4/check_starts.py`
- `.agents/teamwork/teamwork_preview_worker_m1_4/render_all_proofs.py`
- `.agents/teamwork/teamwork_preview_worker_m1_4/generate_report.py`

*Status*: Completely purged in WP1 (`test $(find . -name "*.py" -not -path "./target/*" | wc -l) -eq 0`).

### B. Comprehensive Regex Inventory (181 active sites across 19 files and 6 member crates)
Empirical workspace audit (`git grep -n "Regex::" crates/` and `git grep -n "use regex::" crates/`) uncovered that regular expressions are not confined to 43 sites across 4 crates as initially assumed, but span **181 call sites across 19 source files (20 total files referencing regex) in all 6 workspace crates**:

#### 1. `crates/assemble-conops` (53 sites in 3 files, manifest dependency `regex = "1.10"`)
- `src/toc.rs` (0 sites remaining): Previously contained 1 site (`toc.rs:27`), successfully refactored in WP2 with `pulldown_cmark::Parser` AST events.
- `src/assembler.rs` (6 sites, 1 import at line 6, 1 `Captures` binding at line 91):
  - Line 87: `Regex::new(r"\[(?P<label>(?:\\\]|[^\]])+)\]\((?P<target>[^)\n]+)\)")` -- Markdown link extraction.
  - Line 88: `Regex::new(r"^[a-zA-Z][a-zA-Z0-9+.-]*://")` -- Absolute URI scheme detection.
  - Line 202: `Regex::new(RAW_TOKEN_FINDER)` -- Scans for unresolved `{{...}}` parameter tokens.
  - Line 434: `Regex::new(r"(?i)\|\s*\*\*Title\*\*\s*\|\s*([^|]+)\|")` -- Metadata table Title extractor.
  - Line 435: `Regex::new(r"(?i)\|\s*\*\*Version\*\*\s*\|\s*([^|]+)\|")` -- Metadata table Version extractor.
  - Line 436: `Regex::new(r"(?i)\|\s*\*\*Date\*\*\s*\|\s*([^|]+)\|")` -- Metadata table Date extractor.
- `src/params.rs` (23 sites, 1 import at line 8, 1 `Captures` binding at line 1106):
  - Line 355: `Regex::new(r"\bpackage\s+([A-Za-z0-9_]+)")` -- SysML package identifier extraction.
  - Line 369: `Regex::new(r"\bpart\s+def\s+([A-Za-z0-9_]+)")` -- SysML part definition extractor.
  - Line 379: `Regex::new(r"\battribute\s+([A-Za-z0-9_]+)...")` -- SysML attribute and default literal extractor.
  - Line 403: `Regex::new(r"^#\s+(.+)$")` -- H1 heading extractor for system name inference.
  - Lines 464, 573: `Regex::new(r"[-+]?\d*\.?\d+")` -- Numeric substring and MTOW float extractor.
  - Line 1100: `Regex::new(r"\{\{([A-Za-z0-9_]+)(?::([^\}]*))?\}\}")` -- Template placeholder parser.
  - Lines 1143-1175 (14 sites): Domain-specific terminology sanitization regexes (medical, rail, marine, space).
  - Lines 1182-1187 (3 sites): Civilian safety and ROE identifier replacements.
- `src/sanitize.rs` (24 sites, 1 import at line 3):
  - Lines 16-25 (4 sites): CRC-16 polynomial equations and text patterns.
  - Lines 29-35 (3 sites): Serial baud rate pattern stripping.
  - Lines 39-51 (5 sites): Hardware opcode hexadecimal/decimal reference stripping.
  - Lines 55-58 (2 sites): Level 2 Use Case reference stripping `(UC-##)`.
  - Lines 62-83 (8 sites): Punctuation and whitespace normalization passes.
  - Lines 96-97 (2 sites): Line break splitting and HTML tag detection for Mermaid label wrapping.

#### 2. `crates/reconcile-backlog` (3 sites in 1 file, manifest dependency `regex = "1.10"`)
- `src/checklist.rs` (3 sites, 1 import at line 5):
  - Line 27: `Regex::new(r"(?i)\*?\s*To be populated after Phase 3\s*\*?")` -- Placeholder replacement.
  - Line 34: `Regex::new(r"^(\s*-\s*\[([ xX])\])\s*(?:#(\d+)\s*[-:]?\s*)?(.*)$")` -- Checklist task item parser.
  - Line 63: `Regex::new(r"^(\s*-\s*\[)([ xX])(\]\s*(?:#(\d+)\s*[-:]?\s*)?)(.*)$")` -- Checkbox reconciliation formatter.

#### 3. `crates/verify-baseline` (38 sites in 4 files, manifest dependency `regex = "1.10"`)
- `src/checks/parity_gates.rs` (2 sites, 1 import at line 6):
  - Line 86: `Regex::new(r"(?i)^(?:flowchart|graph|classDiagram|stateDiagram(?:-v2)?|sequenceDiagram)\b")` -- Diagram header validation.
  - Line 87: `Regex::new(r"^\s*[+\-#~]\w+\s*\(.*\)\s*:\s*\w+")` -- Mermaid class return-type syntax detector.
- `src/checks/safety_stpa.rs` (28 sites, 1 import at line 5):
  - Line 47: `Regex::new(r"(?i)failure\s+mode|fmeca")` -- FMECA table header detection.
  - Lines 177-180 (4 sites): 4 Universal Failure Dimensions (Interface, State, Action, Resource) guide-word matching.
  - Lines 239-261 (5 sites): UCA failure categories (Not providing, Providing, Too early/late, Stopped too soon).
  - Lines 375-441 (16 sites): 8-Pillar STPA integrity checks (Losses, Hazards, Control Structure, UCA, Loss Scenarios, Safety Constraints, FMECA, RPN).
  - Lines 483-489 (3 sites): Pillar 8 regulatory objectives and commercial toolchain integration hooks.
- `src/checks/structural.rs` (7 sites, 1 import at line 13):
  - Lines 64-69 (6 sites): Domain cleanliness checks forbidding hardcoded blueprint names and concrete `.sysml` files in templates.
  - Line 137: `Regex::new(r#"^(?:GROUND_TRUTH|EXPECTED_SPECS|...)\s*="#)` -- Forbids hardcoded test parameter assignments.
- `src/checks/wbs_integrity.rs` (1 site, 1 import at line 3):
  - Line 99: `Regex::new(r"\[([^\]]+)\]\(([^)]+)\)")` -- WBS deliverables internal hyperlink extractor.

#### 4. `crates/ingest-sysml` (52 sites in 7 files, manifest dependency `regex = "1.10"`)
- `src/detectors.rs` (2 sites, 1 import at line 24):
  - Line 58: Markdown schema table header keywords.
  - Line 62: Markdown table delimiter syntax detector.
- `src/digest.rs` (2 sites, 1 import at line 26):
  - Line 211: Markdown heading section extractor.
  - Line 212: YANG node definition header extractor.
- `src/lib.rs` (1 site, 1 import at line 35):
  - Line 160: Non-alphanumeric sanitization for SysML constraint identifiers.
- `src/table.rs` (17 sites, 1 import at line 43):
  - Lines 159-176 (4 sites): Header unit stripping, formatting character removal, and identifier normalization.
  - Lines 224-225 (2 sites): Parenthesized/bracketed physical unit token extraction.
  - Lines 253-256 (2 sites): Snake_case column key normalization.
  - Lines 283-291 (3 sites): Link stripping, `<br>` tag replacement, and HTML tag removal.
  - Lines 326-339 (3 sites): Hex scalar literal and float/unit numeric parsing.
  - Lines 371-374 (2 sites): Interval boundary bracket cleaning and range delimiter splitting.
  - Line 562: Table alignment delimiter row detector.
- `src/translators/idl.rs` (6 sites, 1 import at line 22):
  - Lines 55-161 (6 sites): OMG IDL module, struct, field, interface, operation, and typedef extractors.
- `src/translators/markdown.rs` (23 sites, 1 import at line 39):
  - Lines 284-290 (3 sites): Hyperlink, LaTeX font command, and whitespace normalization in normative text.
  - Lines 342-344 (2 sites): Metadata value formatting and whitespace stripping.
  - Lines 396-403 (3 sites): Acceptance criteria link, LaTeX, and whitespace cleaning.
  - Line 422: Acceptance criteria header parser `AC-###: <Title>`.
  - Lines 524-544 (4 sites): Math expression stripping and comment whitespace formatting.
  - Line 748: Requirement dependency references `REQ-####`.
  - Lines 1416-1422 (7 sites): Table delimiter, heading H1..H4, package keyword, component prefix, and slug generator.
  - Lines 1685-1686 (2 sites): Table separator lines and component column mark strippers.
- `src/translators/openapi.rs` (1 site, 1 import at line 31):
  - Line 72: OpenAPI YAML title extractor fallback.

#### 5. `crates/compile-sysml` (8 sites in 3 files, manifest dependency `regex = "1.10"`)
- `src/semantic/validator.rs` (2 sites, 1 import at line 5):
  - Line 248: `@SafetyRealises(HazardId)` annotation extractor.
  - Line 253: `@TriggersHazard(HazardId)` annotation extractor.
- `src/stpa/safety_suite.rs` (4 sites, inline `regex::Regex::new`, 1 `Captures` binding at line 342):
  - Line 332: Constraint expression token extractor (variable, operator, value).
  - Line 341: Template parameter resolver `%%PARAM%%`.
  - Line 875: UCA Markdown table row parser.
  - Line 900: FMECA Markdown table row parser.
- `src/sync/reverse.rs` (2 sites, inline `regex::Regex::new`):
  - Line 293: Reverse-sync operation/action signatures in Markdown lists `- +Action() : ReturnType`.
  - Line 354: STPA safety constraint matrix rows `| SC-### | Statement | Invariant |`.

#### 6. `crates/deap-core` (27 sites in 2 files, manifest dependency `regex = "1.10"`)
- `src/markdown.rs` (5 sites, 1 import at line 3):
  - Lines 219-220 (2 sites): `\begin{aligned}` and `\end{aligned}` environment counter and parity check.
  - Line 230: Forbidden `\begin{align}` top-level environment detector.
  - Line 231: LaTeX environment matching and unescaped ampersand validation.
  - Line 292: UML stereotype tag stripping `<<stereotype>>` before Mermaid bracket escaping.
- `src/sysml_ast.rs` (22 sites, 1 import at line 3):
  - Line 694: SysML v2 attribute definition parser.
  - Line 718: SysML v2 port definition parser.
  - Lines 752-761 (3 sites): SysML v2 action definition and in/out parameter parser.
  - Line 829: SysML v2 constraint definition and assertion parser.
  - Lines 868-878 (7 sites): SysML v2 requirement definition blocks and relationship statements (`assume`, `require`, `derived from`, `verify by`, `satisfy by`).
  - Lines 942-946 (2 sites): SysML v2 connection/flow definition blocks and endpoint statements.
  - Lines 997-1003 (4 sites): SysML v2 state definition blocks and `entry`/`do`/`exit` actions.
  - Line 1105: SysML v2 part definition parser.
  - Line 1164: SysML v2 package definition parser.

### C. Gatekeeper Blind Spot
- `verify-baseline` Check 32 only enforces the Zero Shell Scripts Invariant (`.sh`), leaving `.py` unchecked.
- `verify-baseline` previously lacked an automated check against regular expressions because `verify-baseline` itself contained 38 `Regex::new` invocations.

---

## 2. Work Packages Decomposition (WP1 through WP10)

### Work Package 1: Workspace Hygiene & Python Purge (COMPLETED)
- **Status**: COMPLETED.
- **Actions Executed**:
  - Recursively purged all 12 leftover `.py` scripts under `.agents/teamwork/`.
  - Verified working tree and untracked tree contain zero `.py` files.
- **Verification Evidence**:
  - `test $(find . -name "*.py" -not -path "./target/*" | wc -l) -eq 0` returns 0.

### Work Package 2: Refactor Slice 1 -- `crates/assemble-conops/src/toc.rs` (COMPLETED)
- **Status**: COMPLETED.
- **Actions Executed**:
  - Replaced line-by-line regex compilation in `extract_headings` with zero-copy `pulldown_cmark::Parser` AST events (`Tag::Heading`, `HeadingLevel`, `Event::Text`, `Event::Code`).
  - Implemented zero-copy heading level extraction and anchor slug generation in pure Rust.
- **Verification Evidence**:
  - `crates/assemble-conops/src/toc.rs` contains 0 regex call sites.

### Work Package 3: Refactor Slice 2 -- `crates/reconcile-backlog` (checklist.rs: 3 sites) & evict regex
- **Target**: `crates/reconcile-backlog/src/checklist.rs` (3 sites: lines 27, 34, 63).
- **Refactoring Strategy**:
  - Line 27 placeholder check: Replace case-insensitive regex with ASCII case-insensitive substring search:
    ```rust
    let lower = line.to_ascii_lowercase();
    if lower.contains("to be populated after phase 3") { ... }
    ```
  - Lines 34 and 63 task item parsing: Replace complex capturing regex with zero-allocation string slicing:
    - Trim leading whitespace and check for `- [ ]` or `- [x]` / `- [X]`.
    - Check for optional `#<digits>` issue number citation using char iterators.
    - Extract task title directly by string slicing without allocations.
  - Target: `crates/reconcile-backlog/Cargo.toml`: Remove `regex = "1.10"` dependency.
  - Remove `use regex::Regex;` from `crates/reconcile-backlog/src/checklist.rs`.
- **Verification**:
  - `cargo check -p reconcile-backlog` passes with zero errors.
  - `test $(git grep "Regex::" crates/reconcile-backlog | wc -l) -eq 0`.

### Work Package 4: Refactor Slice 3 -- `crates/verify-baseline` (38 sites across 4 files) & evict regex
- **Targets**:
  - `src/checks/safety_stpa.rs` (28 sites):
    - Replace FMECA table header detection with string search `contains("failure mode") || contains("fmeca")`.
    - Replace 4 Universal Failure Dimensions guide-word regexes (Interface, State, Action, Resource) with static token sets and word boundary checks.
    - Replace UCA failure categories (Not providing, Providing, Too early/late, Stopped too soon) with case-insensitive token phrase matching.
    - Replace 8-Pillar section presence checks and identifier format checks (`L-#`, `H-#`, `UCA-#`, `LS-#`, `SC-#`, `RPN`, `Pillar 8`) with deterministic substring matching and prefix number parsing.
    - Replace commercial toolchain keyword detector with token search (`matlab`, `simulink`, `stateflow`, `embedded coder`, `sldv`).
  - `src/checks/structural.rs` (7 sites):
    - Replace domain cleanliness regexes (`flight_systems`, `uas_infrastructure`, etc.) with case-insensitive substring checks.
    - Replace concrete `.sysml` file detector with `ends_with(".sysml")`.
    - Replace `GROUND_TRUTH=`, `EXPECTED_SPECS=` static assignment check with line prefix scanning.
  - `src/checks/parity_gates.rs` (2 sites):
    - Replace diagram header validation with `line.trim().starts_with(...)` matching valid Mermaid diagram type prefixes.
    - Replace Mermaid class return-type syntax detector with token scan checking for visibility prefixes and colon return-type syntax.
  - `src/checks/wbs_integrity.rs` (1 site):
    - Replace hyperlink extractor with delimiter scanning for `[` and `](...)`.
  - `crates/verify-baseline/Cargo.toml`: Remove `regex = "1.10"` dependency.
  - Remove all `use regex::Regex;` import statements.
- **Verification**:
  - `cargo check -p verify-baseline` passes cleanly.
  - `test $(git grep "Regex::" crates/verify-baseline | wc -l) -eq 0`.

### Work Package 5: Refactor Slice 4 -- `crates/ingest-sysml` (52 sites across 7 files) & evict regex
- **Targets**:
  - `src/detectors.rs` (2 sites): Replace schema table header and delimiter regexes with string searching and pipe character inspection.
  - `src/digest.rs` (2 sites): Replace heading extractor and YANG node header regexes with `starts_with('#')` and keyword prefix matching.
  - `src/lib.rs` (1 site): Replace sanitization regex with `c.is_ascii_alphanumeric() || c == '_'`.
  - `src/table.rs` (17 sites):
    - Replace header unit stripping, bracket extraction, and column key normalization with char filter loops and delimiter slicing.
    - Replace Markdown link stripping, `<br>` tag replacement, and HTML tag stripping with linear character scanners.
    - Replace hex literal and float numeric parsers with `u64::from_str_radix` and `f64::from_str`.
    - Replace range delimiter splitting with `split(|c| c == ',' || c == ':' || c == '.')`.
    - Replace table alignment cell detector with `cell.chars().all(|c| c == '-' || c == ':')`.
  - `src/translators/idl.rs` (6 sites):
    - Replace IDL module, struct, field, interface, operation, and typedef regexes with lexical token scanning in pure Rust.
  - `src/translators/markdown.rs` (23 sites):
    - Replace Markdown table extraction, AC-### header parsing, LaTeX stripping, and heading extraction with `pulldown_cmark` AST events and token scanners.
    - Replace requirement dependency scanner (`REQ-####`) with prefix and 4-digit check.
  - `src/translators/openapi.rs` (1 site):
    - Replace OpenAPI YAML title regex with line-by-line `trim().strip_prefix("title:")` scanning.
  - `crates/ingest-sysml/Cargo.toml`: Remove `regex = "1.10"` dependency.
  - Remove all `use regex::Regex;` import statements.
- **Verification**:
  - `cargo check -p ingest-sysml` passes cleanly.
  - `test $(git grep "Regex::" crates/ingest-sysml | wc -l) -eq 0`.

### Work Package 6: Refactor Slice 5 -- `crates/assemble-conops` Remaining (53 sites across 3 files) & evict regex
- **Targets**:
  - `src/assembler.rs` (6 sites):
    - Replace Markdown link extraction regex with bracket/parenthesis slice scanner.
    - Replace URI scheme detector with `url::Url::parse` or scheme prefix check (`starts_with("http://")`, `starts_with("https://")`).
    - Replace `RAW_TOKEN_FINDER` regex with delimiter scan for `{{` and `}}`.
    - Replace metadata table Title, Version, Date extractors with pipe-delimited table row scanner.
  - `src/params.rs` (23 sites):
    - Replace SysML package, part def, and attribute extraction regexes with word token scanners.
    - Replace H1 heading extractor with `strip_prefix("# ")`.
    - Replace numeric substring extractors with float parsing iterators.
    - Replace template placeholder regex `\{\{([A-Za-z0-9_]+)...\}\}` with `{{` delimiter scanner.
    - Replace domain-specific word sanitization regexes (parachute, altitude, ASTM standards, ROE identifiers) with string replacement passes (`replace`, `replace_all`).
  - `src/sanitize.rs` (24 sites):
    - Replace CRC-16 polynomial, baud rate, opcode, Use Case citation `(UC-##)`, punctuation, and HTML tag regexes with pure Rust substring searches, token replacements, and character scanners.
  - `crates/assemble-conops/Cargo.toml`: Remove `regex = "1.10"` dependency.
  - Remove all `use regex::Regex;` import statements and `Captures` type bindings.
- **Verification**:
  - `cargo check -p assemble-conops` passes cleanly.
  - `test $(git grep "Regex::" crates/assemble-conops | wc -l) -eq 0`.

### Work Package 7: Refactor Slice 6 -- `crates/compile-sysml` (8 sites) and `crates/deap-core` (27 sites) & evict regex
- **Targets for `crates/compile-sysml` (8 sites across 3 files)**:
  - `src/semantic/validator.rs` (2 sites): Replace `@SafetyRealises` and `@TriggersHazard` regexes with prefix scanning `line.find("@SafetyRealises")` and identifier extraction.
  - `src/stpa/safety_suite.rs` (4 sites):
    - Replace constraint expression token extractor with operator splitting (`<=`, `>=`, `<`, `>`, `=`).
    - Replace `%%PARAM%%` scanner with delimiter scan for `%%`.
    - Replace UCA and FMECA Markdown table row parsers with pipe-separated column splitting `row.split('|')`.
  - `src/sync/reverse.rs` (2 sites):
    - Replace operation signature parser `- +Action() : ReturnType` with token prefix and colon splitting.
    - Replace STPA safety constraint row parser `| SC-### | Statement | Invariant |` with pipe column extraction.
  - `crates/compile-sysml/Cargo.toml`: Remove `regex = "1.10"` dependency.
- **Targets for `crates/deap-core` (27 sites across 2 files)**:
  - `src/markdown.rs` (5 sites):
    - Replace `\begin{aligned}` and `\end{aligned}` counters with `content.matches(r"\begin{aligned}").count()`.
    - Replace forbidden `\begin{align}` check with `content.contains(r"\begin{align}")`.
    - Replace LaTeX environment token and ampersand validator with linear LaTeX token parser.
    - Replace UML stereotype tag stripper `<<...>>` with delimiter scanner.
  - `src/sysml_ast.rs` (22 sites):
    - Replace SysML v2 attribute, port, action, constraint, requirement, connection, state, part, and package definition regexes with deterministic lexical token parsers and AST block scanners.
  - `crates/deap-core/Cargo.toml`: Remove `regex = "1.10"` dependency.
  - Remove all `use regex::Regex;` import statements.
- **Verification**:
  - `cargo check -p compile-sysml` and `cargo check -p deap-core` pass cleanly.
  - `test $(git grep "Regex::" crates/compile-sysml crates/deap-core | wc -l) -eq 0`.

### Work Package 8: Workspace Manifest Eviction & Lockfile Regeneration
- **Actions**:
  - Audit all `Cargo.toml` manifests across the entire repository to confirm `regex` is removed from:
    - `crates/assemble-conops/Cargo.toml`
    - `crates/compile-sysml/Cargo.toml`
    - `crates/deap-core/Cargo.toml`
    - `crates/ingest-sysml/Cargo.toml`
    - `crates/reconcile-backlog/Cargo.toml`
    - `crates/verify-baseline/Cargo.toml`
    - Root `Cargo.toml` (if present).
  - Execute `cargo check --workspace` to regenerate `Cargo.lock`.
- **Verification**:
  - `! cargo tree -i regex` exits non-zero, confirming complete eviction from the workspace dependency graph.

### Work Package 9: Arm Baseline Toolchain (Checks 33 & 34) & Build Release Binary
- **Target**: `crates/verify-baseline/src/checks/hygiene.rs` & `crates/verify-baseline/src/runner.rs`.
- **Implement Check 33 (`check_zero_python_scripts_invariant`)**:
  - Recursively walks repository filesystem from root (including dotfiles/ignored dirs, skipping only `target/` and `.git/`).
  - Fails immediately with error details if any file ending in `.py` is detected.
- **Implement Check 34 (`check_zero_regex_invariant`)**:
  - Recursively scans all `.rs` and `Cargo.toml` files in `crates/` and workspace root.
  - Fails immediately if `Regex::`, `use regex::`, or `regex =` is found.
- **Register Checks**: Add Check 33 and Check 34 to the active baseline suite in `crates/verify-baseline/src/runner.rs`.
- **Build Release Binary**: `cargo build --release -p verify-baseline`.
- **Verification**:
  - `./target/release/verify-baseline . --no-domain` runs and passes all 34 checks with exit code 0.

### Work Package 10: Adversarial Auditor Mutation Testing & Remote PR Synchronization
- **Adversarial Mutation Testing**:
  - Gate 33 Negative Stimulus: Create temporary `test_probe.py` -> verify `./target/release/verify-baseline . --no-domain` FAILS Check 33 with exit code 1. Remove `test_probe.py` -> verify Check 33 passes.
  - Gate 34 Negative Stimulus: Inject temporary `let _ = Regex::new("");` into a `.rs` file -> verify `./target/release/verify-baseline . --no-domain` FAILS Check 34 with exit code 1. Revert change -> verify Check 34 passes.
- **Negative Falsification Proofs**:
  - `test $(git grep "Regex::" crates/ | wc -l) -eq 0`
  - `test $(git grep "use regex::" crates/ | wc -l) -eq 0`
  - `test $(find . -name "*.py" -not -path "./target/*" | wc -l) -eq 0`
  - `! cargo tree -i regex`
- **Remote Synchronization**:
  - Commit all changes with neutral citations: `(refs #115)`. Strictly zero em dashes.
  - Synchronize remote PR branches:
    - `gintatkinson/dumpiler-01#128`
    - `gintatkinson/DEAP01-spec-core#433`
    - `gintatkinson/DEAP01-spec-core#434`
  - Verify `git diff origin/main` is empty.

---

## 3. Un-falsifiable Acceptance Criteria & Mechanical Gates

Completion will NOT be accepted via text assertion or exit code 0 alone. All of the following empirical proofs must pass:

1. **Python Script Invariant**:
   ```bash
   test $(find . -name "*.py" -not -path "./target/*" | wc -l) -eq 0
   ```
2. **Regex Code Invariant**:
   ```bash
   test $(git grep "Regex::" crates/ | wc -l) -eq 0
   test $(git grep "use regex::" crates/ | wc -l) -eq 0
   ```
3. **Dependency Eviction Invariant**:
   ```bash
   # cargo tree -i regex must fail because regex does not exist in the dependency graph
   ! cargo tree -i regex
   ```
4. **Active Baseline Gate Invariant**:
   ```bash
   ./target/release/verify-baseline . --no-domain
   # Must explicitly log:
   # Success: Check 33 verified (Zero Python Scripts Invariant passed -- zero .py files exist on disk).
   # Success: Check 34 verified (Zero Regex Invariant passed -- zero Regex:: references and dependency evicted).
   ```
5. **Adversarial Mutation Invariant**:
   ```bash
   # Mutation tests for Checks 33 and 34 must prove gates fail loudly on negative stimulus.
   ```
6. **Remote Synchronization Invariant**:
   ```bash
   git diff origin/main
   # Must be empty on default branch; PR branches synchronized with origin.
   ```
