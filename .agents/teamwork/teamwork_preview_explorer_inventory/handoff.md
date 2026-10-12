# Handoff Report: Complete Workspace Regex Inventory Scan

## 1. Observation

Direct empirical scan of the entire workspace was performed to audit all regular expression call sites, declarations, and package dependencies across all Rust crates.

### 1.1 Empirical Command Executions and Raw Outputs

#### Command 1: `git grep -n "use regex::" crates/`
```text
crates/assemble-conops/src/assembler.rs:6:use regex::Regex;
crates/assemble-conops/src/params.rs:8:use regex::Regex;
crates/assemble-conops/src/sanitize.rs:3:use regex::Regex;
crates/compile-sysml/src/semantic/validator.rs:5:use regex::Regex;
crates/deap-core/src/markdown.rs:3:use regex::Regex;
crates/deap-core/src/sysml_ast.rs:3:use regex::Regex;
crates/ingest-sysml/src/detectors.rs:24:use regex::Regex;
crates/ingest-sysml/src/digest.rs:26:use regex::Regex;
crates/ingest-sysml/src/lib.rs:35:use regex::Regex;
crates/ingest-sysml/src/table.rs:43:use regex::Regex;
crates/ingest-sysml/src/translators/idl.rs:22:use regex::Regex;
crates/ingest-sysml/src/translators/markdown.rs:39:use regex::Regex;
crates/ingest-sysml/src/translators/openapi.rs:31:use regex::Regex;
crates/reconcile-backlog/src/checklist.rs:5:use regex::Regex;
crates/verify-baseline/src/checks/parity_gates.rs:6:use regex::Regex;
crates/verify-baseline/src/checks/safety_stpa.rs:5:use regex::Regex;
crates/verify-baseline/src/checks/structural.rs:13:use regex::Regex;
crates/verify-baseline/src/checks/wbs_integrity.rs:3:use regex::Regex;
```
Total matching lines: **18** lines across **18** source files.

#### Command 2: `git grep -n "regex" Cargo.toml crates/*/Cargo.toml`
```text
crates/assemble-conops/Cargo.toml:11:regex = "1.10"
crates/compile-sysml/Cargo.toml:10:regex = "1.10"
crates/deap-core/Cargo.toml:7:regex = "1.10"
crates/ingest-sysml/Cargo.toml:11:regex = "1.10"
crates/reconcile-backlog/Cargo.toml:10:regex = "1.10"
crates/verify-baseline/Cargo.toml:9:regex = "1.10"
```
Total manifests declaring `regex`: **6 crates** (100% of workspace member crates). Root `Cargo.toml` declares no dependencies.

#### Command 3: `cargo tree -i regex`
```text
regex v1.13.1
├── assemble-conops v0.1.0 (/Users/perkunas/jail/dumpiler-01/crates/assemble-conops)
├── compile-sysml v0.1.0 (/Users/perkunas/jail/dumpiler-01/crates/compile-sysml)
│   └── ingest-sysml v0.1.0 (/Users/perkunas/jail/dumpiler-01/crates/ingest-sysml)
├── deap-core v0.1.0 (/Users/perkunas/jail/dumpiler-01/crates/deap-core)
│   ├── assemble-conops v0.1.0 (/Users/perkunas/jail/dumpiler-01/crates/assemble-conops)
│   ├── compile-sysml v0.1.0 (/Users/perkunas/jail/dumpiler-01/crates/compile-sysml) (*)
│   ├── ingest-sysml v0.1.0 (/Users/perkunas/jail/dumpiler-01/crates/ingest-sysml)
│   ├── reconcile-backlog v0.1.0 (/Users/perkunas/jail/dumpiler-01/crates/reconcile-backlog)
│   └── verify-baseline v0.1.0 (/Users/perkunas/jail/dumpiler-01/crates/verify-baseline)
├── ingest-sysml v0.1.0 (/Users/perkunas/jail/dumpiler-01/crates/ingest-sysml)
├── reconcile-backlog v0.1.0 (/Users/perkunas/jail/dumpiler-01/crates/reconcile-backlog)
└── verify-baseline v0.1.0 (/Users/perkunas/jail/dumpiler-01/crates/verify-baseline)
```
Observation: No external third-party crate pulls in `regex`. Eviction from the 6 internal crates completely purges `regex` from the dependency tree.

#### Command 4: `git grep -n "Regex::" crates/ | wc -l`
```text
181
```
Total active `Regex::new` constructor sites across the workspace: **181 sites** across **19 files**.

---

### 1.2 Comprehensive Inventory Grouped by Crate & File

#### Crate 1: `crates/assemble-conops` (53 sites in 3 files)
**Manifest**: `crates/assemble-conops/Cargo.toml:11: regex = "1.10"`

##### 1. `crates/assemble-conops/src/assembler.rs` (6 sites, 1 import at line 6)
- **Line 87**: `Regex::new(r"\[(?P<label>(?:\\\]|[^\]])+)\]\((?P<target>[^)\n]+)\)")` -- Purpose: Extracts Markdown hyperlinks `[label](target)` for relative URL re-anchoring.
- **Line 88**: `Regex::new(r"^[a-zA-Z][a-zA-Z0-9+.-]*://")` -- Purpose: Detects absolute URI schemes (http, https) to skip relativizing external URLs.
- **Line 202**: `Regex::new(RAW_TOKEN_FINDER)` -- Purpose: Scans for unresolved `{{...}}` parameter tokens during unit integrity validation.
- **Line 434**: `Regex::new(r"(?i)\|\s*\*\*Title\*\*\s*\|\s*([^|]+)\|")` -- Purpose: Extracts metadata table Title value from Markdown unit headers.
- **Line 435**: `Regex::new(r"(?i)\|\s*\*\*Version\*\*\s*\|\s*([^|]+)\|")` -- Purpose: Extracts metadata table Version value from Markdown unit headers.
- **Line 436**: `Regex::new(r"(?i)\|\s*\*\*Date\*\*\s*\|\s*([^|]+)\|")` -- Purpose: Extracts metadata table Date value from Markdown unit headers.
- *(Note: Line 91 carries `|caps: &regex::Captures|` closure type binding).*

##### 2. `crates/assemble-conops/src/params.rs` (23 sites, 1 import at line 8)
- **Line 355**: `Regex::new(r"\bpackage\s+([A-Za-z0-9_]+)")` -- Purpose: Extracts top-level SysML package identifier.
- **Line 369**: `Regex::new(r"\bpart\s+def\s+([A-Za-z0-9_]+)")` -- Purpose: Extracts SysML part definition names.
- **Line 379**: `Regex::new(r"\battribute\s+([A-Za-z0-9_]+)(?:\s*:\s*[A-Za-z0-9_]+)?\s*=\s*([^;]+);")` -- Purpose: Extracts SysML attribute keys and default literal values.
- **Line 403**: `Regex::new(r"^#\s+(.+)$")` -- Purpose: Extracts H1 title from Markdown documents for system name inference.
- **Line 464**: `Regex::new(r"[-+]?\d*\.?\d+")` -- Purpose: Extracts numeric substring from attribute value during semantic alias mapping.
- **Line 573**: `Regex::new(r"[-+]?\d*\.?\d+")` -- Purpose: Extracts numeric mass float from MTOW parameter bindings.
- **Line 1100**: `Regex::new(r"\{\{([A-Za-z0-9_]+)(?::([^\}]*))?\}\}")` -- Purpose: Parses template placeholders `{{KEY}}` or `{{KEY:default}}` for variable substitution.
- **Line 1143**: `Regex::new(r"(?i)\bparachute\b")` -- Purpose: Sanitizes "parachute" to "failsafe joint brake" in medical domain.
- **Line 1146**: `Regex::new(r"(?i)\b(?:altitude\s+AGL|m\s+AGL)\b")` -- Purpose: Replaces aviation altitude units with "mm" in medical domain.
- **Line 1148**: `Regex::new(r"ASTM\s+F3411(?:-22a)?")` -- Purpose: Replaces ASTM drone standard with "IEC 62304 / ISO 14971" in medical domain.
- **Line 1151**: `Regex::new(r"(?i)\bparachute\b")` -- Purpose: Replaces "parachute" with "pneumatic emergency brake" in rail domain.
- **Line 1154**: `Regex::new(r"(?i)\b(?:altitude\s+AGL|m\s+AGL)\b")` -- Purpose: Replaces altitude unit with "m" in rail domain.
- **Line 1156**: `Regex::new(r"ASTM\s+F3411(?:-22a)?")` -- Purpose: Replaces ASTM drone standard with "EN 50128 SIL 4" in rail domain.
- **Line 1159**: `Regex::new(r"(?i)\bparachute\b")` -- Purpose: Replaces "parachute" with "positive buoyancy drop-weight" in marine domain.
- **Line 1162**: `Regex::new(r"(?i)\b(?:altitude\s+AGL|m\s+AGL)\b")` -- Purpose: Replaces altitude unit with "m Depth" in marine domain.
- **Line 1164**: `Regex::new(r"ASTM\s+F3411(?:-22a)?")` -- Purpose: Replaces ASTM standard with "DNV-GL-ST-E403" in marine domain.
- **Line 1167**: `Regex::new(r"(?i)\bparachute\b")` -- Purpose: Replaces "parachute" with "autonomous de-orbit propulsion" in space domain.
- **Line 1170**: `Regex::new(r"(?i)\b(?:altitude\s+AGL|m\s+AGL)\b")` -- Purpose: Replaces altitude unit with "km" in space domain.
- **Line 1172**: `Regex::new(r"ASTM\s+F3411(?:-22a)?")` -- Purpose: Replaces ASTM standard with "ECSS-E-ST-40C" in space domain.
- **Line 1175**: `Regex::new(r"(?i)\bparachute\b")` -- Purpose: Replaces "parachute" with "recovery system" in generic non-aircraft domains.
- **Line 1182**: `Regex::new(&format!(r"\bROE-0{idx}\b"))` -- Purpose: Replaces military ROE identifiers with SAF safety identifiers in civilian mode.
- **Line 1185**: `Regex::new(r"(?i)rules of engagement(?:\s*\(ROE\))?`)` -- Purpose: Sanitizes "rules of engagement" to "operational safety interlocks" in civilian mode.
- **Line 1187**: `Regex::new(r"(?i)\bweapons release\b")` -- Purpose: Sanitizes "weapons release" to "high-consequence actuation" in civilian mode.
- *(Note: Line 1106 carries `|caps: &regex::Captures|` closure type binding).*

##### 3. `crates/assemble-conops/src/sanitize.rs` (24 sites, 1 import at line 3)
- **Line 16**: `Regex::new(r"(?i)x\^16\s*\+\s*x\^12\s*\+\s*x\^5\s*\+\s*1")` -- Purpose: Strips CRC-16 polynomial equations.
- **Line 19**: `Regex::new(r"(?i)_?0x1021\b")` -- Purpose: Strips CRC-16 hex polynomial literal.
- **Line 22**: `Regex::new(r"(?i)\bCRC-?16(?:-[A-Za-z0-9_]+)?(?:\s+polynomial(?:\s+(?:equation|formula))?)?\b")` -- Purpose: Replaces CRC-16 polynomial text with "Frame Integrity Check".
- **Line 25**: `Regex::new(r"(?i)\bpolynomial\s+equation\b")` -- Purpose: Replaces "polynomial equation" with "integrity validation".
- **Line 29**: `Regex::new(r"(?i)\b(?:at\s+)?\d+(?:\.\d+)?\s*(?:k|M|G)?baud\b")` -- Purpose: Strips baud rate specifications.
- **Line 32**: `Regex::new(r"(?i)\b(?:at\s+)?(?:9600|19200|38400|57600|115200|230400|460800|921600)\s*(?:bps|baud)\b")` -- Purpose: Strips standard serial baud rates.
- **Line 35**: `Regex::new(r"_(?:9600|19200|38400|57600|115200|230400|460800|921600)\b")` -- Purpose: Strips underscored baud rate suffixes.
- **Line 39**: `Regex::new(r"\b(?:[Oo]pcode|[Oo]pcodes)\s+0x[0-9a-fA-F]+\b")` -- Purpose: Strips hex opcode specifications.
- **Line 42**: `Regex::new(r"\b(?:OPCODE|OPCODES)\s+0x[0-9a-fA-F]+\b")` -- Purpose: Strips uppercase OPCODE hex strings.
- **Line 45**: `Regex::new(r"\b(?:[Oo]pcode|[Oo]pcodes)\s+[0-9]+\b")` -- Purpose: Strips decimal opcode references.
- **Line 48**: `Regex::new(r"_?0x[0-9a-fA-F]+")` -- Purpose: Strips bare hex literals.
- **Line 51**: `Regex::new(r"\b(?:Opcode|opcode|OPCODE)\b")` -- Purpose: Strips bare "opcode" words.
- **Line 55**: `Regex::new(r"\(\s*(?:UC|uc)-\d+(?:\s*(?:and|&|,)\s*(?:UC|uc)-\d+)*\s*\)")` -- Purpose: Strips parenthesized Level 2 Use Case citations (e.g., `(UC-01)`).
- **Line 58**: `Regex::new(r"\b(?:UC|uc)-\d+\b")` -- Purpose: Strips bare Use Case citations.
- **Line 62**: `Regex::new(r"\(\s*\)")` -- Purpose: Cleans empty parentheses `()`.
- **Line 65**: `Regex::new(r"\[\s*\]")` -- Purpose: Cleans empty brackets `[]`.
- **Line 68**: `Regex::new(r"\(\s*,+\s*")` -- Purpose: Removes leading comma inside parentheses `(,`.
- **Line 71**: `Regex::new(r",+\s*\)")` -- Purpose: Removes trailing comma inside parentheses `,)`.
- **Line 74**: `Regex::new(r",\s*,+")` -- Purpose: Collapses duplicate commas `,,`.
- **Line 77**: `Regex::new(r"[ \t]+,\s*")` -- Purpose: Normalizes space before comma `" ,"`.
- **Line 80**: `Regex::new(r",\s*\.")` -- Purpose: Eliminates comma-period punctuation anomalies `,.`.
- **Line 83**: `Regex::new(r"[ \t]{2,}")` -- Purpose: Collapses multiple consecutive spaces to a single space.
- **Line 96**: `Regex::new(r"(?i)(<br\s*/?>|\r?\n)")` -- Purpose: Splits text by linebreaks/HTML breaks for Mermaid label wrapping.
- **Line 97**: `Regex::new(r"</?[a-zA-Z0-9_-]+\s*/?>")` -- Purpose: Detects and skips HTML tags during character-count wrapping.

---

#### Crate 2: `crates/reconcile-backlog` (3 sites in 1 file)
**Manifest**: `crates/reconcile-backlog/Cargo.toml:10: regex = "1.10"`

##### 1. `crates/reconcile-backlog/src/checklist.rs` (3 sites, 1 import at line 5)
- **Line 27**: `Regex::new(r"(?i)\*?\s*To be populated after Phase 3\s*\*?")` -- Purpose: Matches and replaces unpopulated phase 3 placeholders.
- **Line 34**: `Regex::new(r"^(\s*-\s*\[([ xX])\])\s*(?:#(\d+)\s*[-:]?\s*)?(.*)$")` -- Purpose: Parses Markdown task checklist items with optional issue number `#123`.
- **Line 63**: `Regex::new(r"^(\s*-\s*\[)([ xX])(\]\s*(?:#(\d+)\s*[-:]?\s*)?)(.*)$")` -- Purpose: Reconciles checkbox markers `[ ]` vs `[x]` while preserving formatting.

---

#### Crate 3: `crates/verify-baseline` (38 sites in 4 files)
**Manifest**: `crates/verify-baseline/Cargo.toml:9: regex = "1.10"`

##### 1. `crates/verify-baseline/src/checks/parity_gates.rs` (2 sites, 1 import at line 6)
- **Line 86**: `Regex::new(r"(?i)^(?:flowchart|graph|classDiagram|stateDiagram(?:-v2)?|sequenceDiagram)\b")` -- Purpose: Validates Mermaid diagram type declaration headers.
- **Line 87**: `Regex::new(r"^\s*[+\-#~]\w+\s*\(.*\)\s*:\s*\w+")` -- Purpose: Detects forbidden Mermaid class diagram colon return-type syntax (e.g. `+func(): void`).

##### 2. `crates/verify-baseline/src/checks/safety_stpa.rs` (28 sites, 1 import at line 5)
- **Line 47**: `Regex::new(r"(?i)failure\s+mode|fmeca")` -- Purpose: Detects FMECA Markdown table header row.
- **Line 177**: `Regex::new(r"(?i)\b(?:Interface|Port|Bus|Signal|Protocol|Packet|Message|Frame|Channel|Link|CRC|Timeout|IO|Input|Output|Data|Transceiver|Receiver|Uplink|Downlink|Telemetry|Transients?|Γ|\\Gamma)\b")` -- Purpose: Checks FMECA coverage of Interface dimension ($\Gamma$).
- **Line 178**: `Regex::new(r"(?i)\b(?:State|Mode|Transition|Deadlock|Latch|Phase|Statechart|FSM|Sync|Synchronization|Desync|Drift|Stuck|Uninitialized|Freeze|Lockup|Trip|Abort|Corruption|Disagreement|Φ|\\Phi)\b")` -- Purpose: Checks FMECA coverage of State dimension ($\Phi$).
- **Line 179**: `Regex::new(r"(?i)\b(?:Action|Command|Execution|Operation|Control|Timing|Deadline|Compute|Calculation|Process|Logic|Omission|Commission|Latency|Jitter|Delay|Rate|Clamping|Limiter|Saturation|Step|Overshoot|Schedule|Task|Authority|Miss|Ω|\\Omega)\b")` -- Purpose: Checks FMECA coverage of Action dimension ($\Omega$).
- **Line 180**: `Regex::new(r"(?i)\b(?:Resource|Memory|CPU|Buffer|Power|Energy|Battery|Thermal|Heat|Overheat|Overload|Bandwidth|Storage|Capacity|Stack|Heap|Overflow|Underflow|Brownout|Voltage|Current|Load|Fault|Short|Sag|Circuit|Crowbar|Degradation|Flash|RAM|Supply|Undervoltage|Overvoltage|Seizure|Windings?|Wiper|Hardware|Bearing|Dielectric|Squib|Fuse|Fusing|Ψ|\\Psi)\b")` -- Purpose: Checks FMECA coverage of Resource dimension ($\Psi$).
- **Line 239**: `Regex::new(r"(?i)\b(?:not\s+provid(?:ing|ed)|omission)\b")` -- Purpose: Validates UCA Category 1 (Not providing causes hazard).
- **Line 245**: `Regex::new(r"(?i)\b(?:providing\s+(?:causes|incorrectly)|commission)\b")` -- Purpose: Validates UCA Category 2 explicit commission phrasing.
- **Line 246**: `Regex::new(r"(?i)\bproviding\b")` -- Purpose: Validates UCA Category 2 generic providing phrasing.
- **Line 247**: `Regex::new(r"(?i)\bproviding\s+too\b")` -- Purpose: Filters out Category 3 ("providing too early") from Category 2.
- **Line 255**: `Regex::new(r"(?i)\b(?:too\s+early|too\s+late|out\s+of\s+order|timing|early/late)\b")` -- Purpose: Validates UCA Category 3 (Timing / sequence).
- **Line 261**: `Regex::new(r"(?i)\b(?:stopped\s+too\s+soon|applied\s+too\s+long|duration|stopped\s+early)\b")` -- Purpose: Validates UCA Category 4 (Duration / stopped too soon).
- **Line 375**: `Regex::new(r"(?i)loss(?:es)?")` -- Purpose: Validates Pillar 1 System Losses presence.
- **Line 376**: `Regex::new(r"(?i)\bL-\d+\b|\$L-\d+")` -- Purpose: Validates Pillar 1 Loss identifier format `L-1..N`.
- **Line 382**: `Regex::new(r"(?i)hazard(?:s)?")` -- Purpose: Validates Pillar 2 System Hazards presence.
- **Line 383**: `Regex::new(r"(?i)\bH-\d+\b|\$H-\d+")` -- Purpose: Validates Pillar 2 Hazard identifier format `H-1..N`.
- **Line 389**: `Regex::new(r"(?i)control\s+structure")` -- Purpose: Validates Pillar 3 Hierarchical Control Structure presence.
- **Line 390**: `Regex::new(r"(?i)controller")` -- Purpose: Validates Pillar 3 controller element.
- **Line 391**: `Regex::new(r"(?i)actuator")` -- Purpose: Validates Pillar 3 actuator element.
- **Line 399**: `Regex::new(r"(?i)unsafe\s+control\s+actions?|\bUCA-\d+\b")` -- Purpose: Validates Pillar 4 Unsafe Control Actions format.
- **Line 412**: `Regex::new(r"(?i)loss\s+scenarios?|causal\s+scenarios?")` -- Purpose: Validates Pillar 5 Loss Scenarios presence.
- **Line 413**: `Regex::new(r"(?i)\bLS-\d+\b|\$LS-\d+")` -- Purpose: Validates Pillar 5 Loss Scenario identifier format `LS-1..N`.
- **Line 419**: `Regex::new(r"(?i)safety\s+constraints?")` -- Purpose: Validates Pillar 6 Safety Constraints presence.
- **Line 420**: `Regex::new(r"(?i)\bSC-\d+\b|\$SC-\d+")` -- Purpose: Validates Pillar 6 Safety Constraint identifier format `SC-1..N`.
- **Line 426**: `Regex::new(r"(?i)fmeca|failure\s+mode")` -- Purpose: Validates Pillar 7 FMECA Criticality Matrix presence.
- **Line 441**: `Regex::new(r"(?i)\bRPN\b|Risk\s+Priority\s+Number")` -- Purpose: Validates FMECA RPN calculation column presence.
- **Line 483**: `Regex::new(r"(?i)pillar\s+8|regulatory\s+objectives|sora\s+sail")` -- Purpose: Validates Pillar 8 Regulatory Objectives keyword presence.
- **Line 484**: `Regex::new(r"(?m)^#{2,4}\s*8\.\s+")` -- Purpose: Validates Pillar 8 section heading numbering format.
- **Line 489**: `Regex::new(r"(?i)matlab|simulink|stateflow|embedded\s+coder|sldv")` -- Purpose: Validates Commercial Toolchain integration hooks presence.

##### 3. `crates/verify-baseline/src/checks/structural.rs` (7 sites, 1 import at line 13)
- **Line 64**: `Regex::new(r"(?i)flight[-_]?systems")` -- Purpose: Forbids hardcoded flight-systems domain blueprint reference in templates.
- **Line 65**: `Regex::new(r"(?i)uas[-_]?infrastructure")` -- Purpose: Forbids hardcoded UAS domain blueprint reference.
- **Line 66**: `Regex::new(r"(?i)frontend[-_]?systems")` -- Purpose: Forbids hardcoded frontend domain blueprint reference.
- **Line 67**: `Regex::new(r"(?i)safety[-_]?model")` -- Purpose: Forbids hardcoded safety-model domain blueprint reference.
- **Line 68**: `Regex::new(r"(?i)\.sysml$")` -- Purpose: Forbids concrete SysML schema files committed inside template blueprints.
- **Line 69**: `Regex::new(r"(?i)concept[-_]?paper")` -- Purpose: Forbids concept-paper files committed inside template blueprints.
- **Line 137**: `Regex::new(r#"^(?:GROUND_TRUTH|EXPECTED_SPECS|DOMAIN_SPECS|DOMAIN_PARAMS|SYSML_PARAMS|MANDATED_SPECS|PHYSICAL_LIMITS|HARDWARE_REGISTRY)\s*="#)` -- Purpose: Forbids static hardcoded test parameter assignments across auditor sources.

##### 4. `crates/verify-baseline/src/checks/wbs_integrity.rs` (1 site, 1 import at line 3)
- **Line 99**: `Regex::new(r"\[([^\]]+)\]\(([^)]+)\)")` -- Purpose: Extracts and verifies internal Markdown hyperlinks in `WBS_DELIVERABLES_SUITE.md`.

---

#### Crate 4: `crates/ingest-sysml` (52 sites in 7 files)
**Manifest**: `crates/ingest-sysml/Cargo.toml:11: regex = "1.10"`

##### 1. `crates/ingest-sysml/src/detectors.rs` (2 sites, 1 import at line 24)
- **Line 58**: `Regex::new(r"(?i)\|\s*(?:Component|Part|BOM|Port|Signal|Parameter|Interface|Property|Attribute)\s*\|")` -- Purpose: Detects Markdown schema format via structural table header keywords.
- **Line 62**: `Regex::new(r"\|[^\n]+\|\s*\n\s*\|[\s:\-]+\|")` -- Purpose: Detects Markdown table delimiter syntax.

##### 2. `crates/ingest-sysml/src/digest.rs` (2 sites, 1 import at line 26)
- **Line 211**: `Regex::new(r"^\s*(#{1,6}\s+.*)")` -- Purpose: Extracts Markdown heading section markers for schema digest.
- **Line 212**: `Regex::new(r"^\s*(container|list|typedef|identity|grouping|module)\s+([a-zA-Z0-9_\-]+)")` -- Purpose: Extracts YANG node definition headers for schema digest.

##### 3. `crates/ingest-sysml/src/lib.rs` (1 site, 1 import at line 35)
- **Line 160**: `Regex::new(r"[^a-zA-Z0-9_]")` -- Purpose: Sanitizes negative invariant names into valid SysML constraint identifiers.

##### 4. `crates/ingest-sysml/src/table.rs` (17 sites, 1 import at line 43)
- **Line 159**: `Regex::new(r"[\(\[\{][^\)\]\}]*[\)\]\}]")` -- Purpose: Strips bracketed and parenthesized unit tokens from table header (e.g. `Mass (kg)` -> `Mass`).
- **Line 168**: `Regex::new(r"[*`_#]")` -- Purpose: Strips Markdown inline formatting characters.
- **Line 172**: `Regex::new(r"[^a-zA-Z0-9_]")` -- Purpose: Sanitizes non-alphanumeric chars to underscores.
- **Line 176**: `Regex::new(r"_+")` -- Purpose: Collapses consecutive underscores.
- **Line 224**: `Regex::new(r"[\(\[]([a-zA-Z0-9_/°^%\-]+)[\)\]]")` -- Purpose: Extracts physical unit token from parentheses or brackets (e.g. `(kg)`).
- **Line 225**: `Regex::new(r"[\(\[][^\)\]]*[\)\]]")` -- Purpose: Strips unit token from header or value string.
- **Line 253**: `Regex::new(r"[*`_]")` -- Purpose: Strips bold/code/italic tokens for snake_case column normalization.
- **Line 256**: `Regex::new(r"[^a-z0-9]+")` -- Purpose: Replaces non-alphanumeric chars with underscore during column key normalization.
- **Line 283**: `Regex::new(r"\[([^\]]+)\]\([^\)]+\)")` -- Purpose: Strips Markdown hyperlinks, preserving visible text.
- **Line 287**: `Regex::new(r"(?i)<br\s*/?>")` -- Purpose: Replaces `<br>` tags with space in table cells.
- **Line 291**: `Regex::new(r"<[^>]+>")` -- Purpose: Strips arbitrary HTML tags from table cells.
- **Line 326**: `Regex::new(r"[*`]")` -- Purpose: Cleans formatting tokens before numeric parsing.
- **Line 330**: `Regex::new(r"^(0x[0-9a-fA-F]+)$")` -- Purpose: Parses hexadecimal scalar literals (e.g. `0x20`).
- **Line 339**: `Regex::new(r"^([-+]?[0-9]*\.?[0-9]+(?:[eE][-+]?[0-9]+)?)\s*([a-zA-Z0-9_/°^%\-]*)$")` -- Purpose: Parses float/int and optional physical unit string.
- **Line 371**: `Regex::new(r"[*`\[\]\(\)]")` -- Purpose: Cleans interval boundary brackets before range parsing.
- **Line 374**: `Regex::new(r"\s*(?:,|\.\.|\bto\b|:)\s*")` -- Purpose: Splits range intervals by delimiter (`,`, `..`, `to`, `:`).
- **Line 562**: `Regex::new(r"^:?-+:?$")` -- Purpose: Matches Markdown table alignment delimiter cells.

##### 5. `crates/ingest-sysml/src/translators/idl.rs` (6 sites, 1 import at line 22)
- **Line 55**: `Regex::new(r"\bmodule\s+([a-zA-Z0-9_\-]+)\s*\{")` -- Purpose: Extracts OMG IDL module name.
- **Line 69**: `Regex::new(r"(?s)\bstruct\s+([a-zA-Z0-9_\-]+)\s*\{([^}]+)\};")` -- Purpose: Extracts IDL struct blocks.
- **Line 70**: `Regex::new(r"(?m)^\s*([a-zA-Z0-9_\-<>:]+)\s+([a-zA-Z0-9_\-]+)\s*;")` -- Purpose: Extracts IDL struct field declarations.
- **Line 97**: `Regex::new(r"(?s)\binterface\s+([a-zA-Z0-9_\-]+)\s*\{([^}]+)\};")` -- Purpose: Extracts IDL interface blocks.
- **Line 98**: `Regex::new(r"(?m)^\s*(?:[a-zA-Z0-9_\-\:]+)\s+([a-zA-Z0-9_\-]+)\s*\(([^)]*)\)\s*;")` -- Purpose: Extracts IDL operation/method signatures.
- **Line 161**: `Regex::new(r"(?m)^\s*typedef\s+([a-zA-Z0-9_\-<>:]+)\s+([a-zA-Z0-9_\-]+)\s*;")` -- Purpose: Extracts IDL typedef declarations.

##### 6. `crates/ingest-sysml/src/translators/markdown.rs` (23 sites, 1 import at line 39)
- **Line 284**: `Regex::new(r"\[([^\]]+)\]\([^\)]+\)")` -- Purpose: Strips Markdown hyperlinks in normative requirement text.
- **Line 288**: `Regex::new(r"\\(?:mathbf|mathcal|text|oint)\{?([a-zA-Z0-9_\s]*)\}?")` -- Purpose: Strips LaTeX font commands in normative text.
- **Line 290**: `Regex::new(r"\s+")` -- Purpose: Collapses consecutive whitespace in normative text.
- **Line 342**: `Regex::new(r"\\(?:mathbf|mathcal|text)\{?([a-zA-Z0-9_\s]*)\}?")` -- Purpose: Strips LaTeX formatting in metadata values.
- **Line 344**: `Regex::new(r"\s+")` -- Purpose: Collapses whitespace in metadata values.
- **Line 396**: `Regex::new(r"\[([^\]]+)\]\([^\)]+\)")` -- Purpose: Strips Markdown hyperlinks in BDD acceptance criteria.
- **Line 400**: `Regex::new(r"\\[a-zA-Z]+\{?([a-zA-Z0-9_\s]*)\}?")` -- Purpose: Strips LaTeX commands in BDD criteria text.
- **Line 403**: `Regex::new(r"\s+")` -- Purpose: Collapses whitespace in BDD text.
- **Line 422**: `Regex::new(r#"(?m)^###\s+(?:Acceptance\s+Criteria:?\s*)?AC-?(?P<num>\d+)\s*[:\-]?\s*(?P<title>.*?)$"#)` -- Purpose: Extracts Acceptance Criterion section header `AC-###: <Title>`.
- **Line 524**: `Regex::new(r"\$[^$]*\$")` -- Purpose: Strips inline math expressions `$x \le 10$` from invariant documentation.
- **Line 527**: `Regex::new(r"\\[a-zA-Z]+(?:\{[^}]*\})?")` -- Purpose: Strips LaTeX commands from invariant documentation.
- **Line 538**: `Regex::new(r"\s+")` -- Purpose: Collapses whitespace in invariant doc text.
- **Line 544**: `Regex::new(r"\s+")` -- Purpose: Collapses whitespace in math comments.
- **Line 748**: `Regex::new(r"REQ-[0-9]{4}")` -- Purpose: Extracts requirement dependency references `REQ-####`.
- **Line 1416**: `Regex::new(r"^:?-+:?$")` -- Purpose: Matches table delimiter cells in generic table scanner.
- **Line 1417**: `Regex::new(r"^#\s+([^#].*)$")` -- Purpose: Extracts H1 heading from Markdown specification.
- **Line 1418**: `Regex::new(r"^(#{2,4})\s+([^#].*)$")` -- Purpose: Extracts subheadings H2..H4 for subsystem grouping.
- **Line 1419**: `Regex::new(r"(?i)\b(?:package|specification|model|spec|system)\b")` -- Purpose: Classifies heading keywords for package identification.
- **Line 1420**: `Regex::new(r"(?i)^(?:component|part|subsystem|assembly|block|module)\s*[:\-]\s*")` -- Purpose: Strips component prefix prefixes from titles.
- **Line 1421**: `Regex::new(r"[^a-z0-9]+")` -- Purpose: Sanitizes heading text for slug generation.
- **Line 1422**: `Regex::new(r"[*`]")` -- Purpose: Strips bold/code marks from heading text.
- **Line 1685**: `Regex::new(r"^[-=_\s:|]+$")` -- Purpose: Detects separator lines in Markdown table cells.
- **Line 1686**: `Regex::new(r"[*`_#]")` -- Purpose: Strips formatting marks from component column values.

##### 7. `crates/ingest-sysml/src/translators/openapi.rs` (1 site, 1 import at line 31)
- **Line 72**: `Regex::new(r#"(?m)^\s*title:\s*["']?([^"'\r\n]+)["']?"#)` -- Purpose: Fallback YAML title extractor for OpenAPI specifications.

---

#### Crate 5: `crates/compile-sysml` (8 sites in 3 files)
**Manifest**: `crates/compile-sysml/Cargo.toml:10: regex = "1.10"`

##### 1. `crates/compile-sysml/src/semantic/validator.rs` (2 sites, 1 import at line 5)
- **Line 248**: `Regex::new(r#"(?i)@SafetyRealises\s*(?:\(([^)]+)\)|:\s*([A-Za-z0-9_\-]+))"#)` -- Purpose: Extracts `@SafetyRealises(HazardId)` annotations from requirement text.
- **Line 253**: `Regex::new(r#"(?i)@TriggersHazard\s*(?:\(([^)]+)\)|:\s*([A-Za-z0-9_\-]+))"#)` -- Purpose: Extracts `@TriggersHazard(HazardId)` annotations from requirement text.

##### 2. `crates/compile-sysml/src/stpa/safety_suite.rs` (4 sites, uses `regex::Regex::new` inline)
- **Line 332**: `regex::Regex::new(r"([A-Za-z_][A-Za-z0-9_]*)\s*(<=|>=|<|>|=)\s*([^\s;]+)")` -- Purpose: Extracts constraint expression tokens (variable, operator, value) for parameter substitution.
- **Line 341**: `regex::Regex::new(r"%%([A-Za-z0-9_]+)%%")` -- Purpose: Resolves template parameters enclosed in `%%PARAM%%`.
- **Line 875**: `regex::Regex::new(r"\|\s*(UCA-\d+)\s*\|\s*([^|]+)\|\s*([^|]+)\|\s*([^|]+)\|\s*([^|]+)\|\s*([^|]+)\|\s*(SC-\d+)")` -- Purpose: Parses UCA Markdown table rows to extract UCA ID, Action, Guide Word, and Safety Constraint ID.
- **Line 900**: `regex::Regex::new(r"\|\s*(FMECA-\d+)\s*\|\s*([^|]+)\|\s*([^|]+)\|\s*([^|]+)\|")` -- Purpose: Parses FMECA Markdown table rows to extract FMECA ID, Component, and Failure Mode.
- *(Note: Line 342 carries `|caps: &regex::Captures|` closure type binding).*

##### 3. `crates/compile-sysml/src/sync/reverse.rs` (2 sites, uses `regex::Regex::new` inline)
- **Line 293**: `regex::Regex::new(r"-\s*`\+([A-Za-z0-9_]+)\s*\([^)]*\)\s*:\s*([A-Za-z0-9_]+)`")` -- Purpose: Parses reverse-sync operation/action signatures in Markdown lists `- +ActionName() : ReturnType`.
- **Line 354**: `regex::Regex::new(r"\|\s*\*\*?(SC-\d+)\*\*?\s*\|\s*([^|]+)\|\s*([^|]+)\|")` -- Purpose: Parses STPA safety constraint matrix rows `| SC-### | Statement | Invariant |`.

---

#### Crate 6: `crates/deap-core` (27 sites in 2 files)
**Manifest**: `crates/deap-core/Cargo.toml:7: regex = "1.10"`

##### 1. `crates/deap-core/src/markdown.rs` (5 sites, 1 import at line 3)
- **Line 219**: `Regex::new(r"\\begin\{aligned\}")` -- Purpose: Counts display math `\begin{aligned}` opening tags.
- **Line 220**: `Regex::new(r"\\end\{aligned\}")` -- Purpose: Counts display math `\end{aligned}` closing tags for pair parity check.
- **Line 230**: `Regex::new(r"\\begin\{align\*?\}")` -- Purpose: Detects forbidden `\begin{align}` or `\begin{align*}` top-level LaTeX environments.
- **Line 231**: `Regex::new(r"\\begin\{([a-zA-Z*]+)\}|\\end\{([a-zA-Z*]+)\}|\\&|&")` -- Purpose: Scans LaTeX tokens for environment matching and unescaped ampersand validation.
- **Line 292**: `Regex::new(r"<<[a-zA-Z0-9_\-]+>>")` -- Purpose: Strips UML stereotype tags `<<stereotype>>` before Mermaid angle bracket escaping check.

##### 2. `crates/deap-core/src/sysml_ast.rs` (22 sites, 1 import at line 3)
- **Line 694**: `Regex::new(r#"(?m)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?attribute\s+(?:def\s+)?(?P<name>[A-Za-z0-9_]+)\s*:\s*(?P<type>[A-Za-z0-9_]+)(?:\s*=\s*(?P<val>[^;]+))?;"#)` -- Purpose: Parses SysML v2 attribute definitions.
- **Line 718**: `Regex::new(r#"(?m)(?:doc\s*/\*(?P<doc>[\s\S]*?)\*/\s*)?(?:(?P<dir1>in|out|inout)\s+)?port(?:\s+def)?(?:\s+(?P<dir2>in|out|inout))?(?:\s+def)?\s+(?P<conj1>~)?(?P<name>[A-Za-z0-9_]+)(?:\s*:\s*(?P<conj2>~)?(?P<type>[A-Za-z0-9_]+))?\s*(?:\{[^{}]*\}|;)"#)` -- Purpose: Parses SysML v2 port definitions.
- **Line 752**: `Regex::new(r#"(?s)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?\baction\b(?:\s+def)?\s+(?P<name>[A-Za-z0-9_]+)(?:\s*\((?P<params>.*?)\))?\s*(?:\{(?P<body>.*?)\}|;)"#)` -- Purpose: Parses SysML v2 action definitions.
- **Line 757**: `Regex::new(r#"(?m)^\s*in\s+(?:(?:attribute|item)\s+)?(?P<name>[A-Za-z0-9_]+)\s*:\s*(?P<type>[A-Za-z0-9_]+(?:::[A-Za-z0-9_]+)*)"#)` -- Purpose: Parses action input parameters `in param: Type`.
- **Line 761**: `Regex::new(r#"(?m)^\s*out\s+(?:(?:attribute|item)\s+)?(?P<name>[A-Za-z0-9_]+)\s*:\s*(?P<type>[A-Za-z0-9_]+(?:::[A-Za-z0-9_]+)*)"#)` -- Purpose: Parses action output parameters `out param: Type`.
- **Line 829**: `Regex::new(r#"(?s)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?(?P<assert>assert\s+)?constraint\s+(?:def\s+)?(?P<name>[A-Za-z0-9_]+)(?:\((?P<params>[^)]*)\))?\s*(?:\{(?P<expr>.*?)\}|;)"#)` -- Purpose: Parses SysML v2 constraint definitions and assertions.
- **Line 868**: `Regex::new(r#"(?s)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?requirement\s+(?:def\s+)?(?P<name>[A-Za-z0-9_]+)\s*(?:\{(?P<body>.*?)\}|;)"#)` -- Purpose: Parses SysML v2 requirement definition blocks.
- **Line 872**: `Regex::new(r#"(?m)^\s*(?:id|req_id)\s*=\s*"(?P<id>[^"]+)""#)` -- Purpose: Parses requirement ID string attribute `id = "REQ-0001"`.
- **Line 873**: `Regex::new(r#"(?m)^\s*(?:doc|text)\s*=\s*"(?P<text>[^"]+)""#)` -- Purpose: Parses requirement documentation/text attribute.
- **Line 874**: `Regex::new(r#"(?m)^\s*assume\s+(?P<target>[^;]+);"#)` -- Purpose: Parses requirement `assume <target>;` relation.
- **Line 875**: `Regex::new(r#"(?m)^\s*require\s+(?P<target>[^;]+);"#)` -- Purpose: Parses requirement `require <target>;` relation.
- **Line 876**: `Regex::new(r#"(?m)^\s*derived\s+from\s+(?P<target>[^;]+);"#)` -- Purpose: Parses requirement `derived from <target>;` relation.
- **Line 877**: `Regex::new(r#"(?m)^\s*verify(?:\s+by)?\s+(?P<target>[^;]+);"#)` -- Purpose: Parses requirement `verify by <target>;` relation.
- **Line 878**: `Regex::new(r#"(?m)^\s*satisfy(?:\s+by)?\s+(?P<target>[^;]+);"#)` -- Purpose: Parses requirement `satisfy by <target>;` relation.
- **Line 942**: `Regex::new(r#"(?s)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?(?P<is_flow>flow|connection)\s+(?:def\s+)?(?P<name>[A-Za-z0-9_]+)\s*\{(?P<body>.*?)\}"#)` -- Purpose: Parses SysML v2 connection and flow definition blocks.
- **Line 946**: `Regex::new(r#"(?m)^\s*(?:connect|flow\s+from)\s+(?P<src>[A-Za-z0-9_.]+)\s+to\s+(?P<tgt>[A-Za-z0-9_.]+);"#)` -- Purpose: Parses connection endpoint statements `connect A.p1 to B.p2;`.
- **Line 997**: `Regex::new(r#"(?s)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?state\s+(?:def\s+)?(?P<name>[A-Za-z0-9_]+)\s*(?:\{(?P<body>.*?)\}|;)"#)` -- Purpose: Parses SysML v2 state definition blocks.
- **Line 1001**: `Regex::new(r#"(?m)^\s*entry\s+(?P<act>[^;]+);"#)` -- Purpose: Parses state entry action statement `entry <act>;`.
- **Line 1002**: `Regex::new(r#"(?m)^\s*do\s+(?P<act>[^;]+);"#)` -- Purpose: Parses state do action statement `do <act>;`.
- **Line 1003**: `Regex::new(r#"(?m)^\s*exit\s+(?P<act>[^;]+);"#)` -- Purpose: Parses state exit action statement `exit <act>;`.
- **Line 1105**: `Regex::new(r#"(?s)(?:doc\s*/\*(?P<doc>(?:[^*]|\*+[^*/])*)\*+/\s*)?part\s+def\s+(?P<name>[A-Za-z0-9_]+)\s*(?P<term>\{|;)"#)` -- Purpose: Parses SysML v2 part definition headers.
- **Line 1164**: `Regex::new(r#"(?s)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?package\s+(?P<name>[A-Za-z0-9_]+)\s*\{"#)` -- Purpose: Parses SysML v2 package definition headers.

---

### 1.3 Scope Discrepancy Analysis: Assumed vs. Empirical Reality

| Parameter | `implementation_plan.md` (Assumed) | Empirical Scan (Actual) | Ratio / Variance |
| :--- | :--- | :--- | :--- |
| **Total `Regex::new` Call Sites** | 43 | **181** | **+138 sites (+321%)** |
| **Workspace Crates Affected** | 4 (`assemble-conops`, `reconcile-backlog`, `verify-baseline`, `ingest-sysml`) | **6** (all 6 crates: includes `compile-sysml` & `deap-core`) | **+2 crates** |
| **Files with Regex Call Sites** | ~7 files | **19 files** | **+12 files** |
| **Import Declarations (`use regex::`)** | ~7 lines | **18 lines** | **+11 lines** |
| **Crate Manifest Dependencies** | 4 manifests | **6 manifests** | **+2 manifests** |
| **Python Script Debris on Disk** | 12 files assumed | **0 files** outside `target/` | Clean (WP1 already clean) |

#### Analysis of Discrepancies:
1. `assemble-conops`:
   - Plan assumed 1 site (`toc.rs:27`). In reality, `toc.rs` already uses `pulldown_cmark` and has **0** regex sites, but `assembler.rs` (6 sites), `params.rs` (23 sites), and `sanitize.rs` (24 sites) total **53 sites**.
2. `reconcile-backlog`:
   - Plan correctly identified 3 sites in `checklist.rs` (lines 27, 34, 63).
3. `verify-baseline`:
   - Plan assumed 28 sites across `safety_stpa.rs`, `structural.rs`, and `diagram_ast.rs`.
   - In reality: `diagram_ast.rs` has **0** sites (already refactored). `parity_gates.rs` has **2** sites, `safety_stpa.rs` has **28** sites, `structural.rs` has **7** sites, and `wbs_integrity.rs` has **1** site, totalling **38 sites**.
4. `ingest-sysml`:
   - Plan assumed 16 sites (`markdown.rs` 15, `openapi.rs` 1).
   - In reality: `detectors.rs` (2), `digest.rs` (2), `lib.rs` (1), `table.rs` (17), `idl.rs` (6), `markdown.rs` (23), `openapi.rs` (1), totalling **52 sites**.
5. Unaccounted Crates:
   - `compile-sysml`: Not accounted for in the initial 4-crate plan, but contains **8 sites** across `validator.rs` (2), `safety_suite.rs` (4), and `reverse.rs` (2), and depends directly on `regex = "1.10"`.
   - `deap-core`: The central AST foundation of the entire pipeline, not accounted for in the initial plan, contains **27 sites** across `markdown.rs` (5) and `sysml_ast.rs` (22), and depends directly on `regex = "1.10"`.

---

## 2. Logic Chain

1. **Step 1 (Empirical grep)**: Running `git grep -n "Regex::" crates/` produced exactly 181 lines across 19 source files, contradicting the initial estimate of 43 sites across 7 files.
2. **Step 2 (Import inspection)**: Running `git grep -n "use regex::" crates/` revealed 18 import statements spanning all 6 workspace crates: `assemble-conops` (3), `reconcile-backlog` (1), `verify-baseline` (4), `ingest-sysml` (7), `compile-sysml` (1), and `deap-core` (2).
3. **Step 3 (Dependency graph check)**: Running `git grep -n "regex" Cargo.toml crates/*/Cargo.toml` and `cargo tree -i regex` confirmed that all 6 crates explicitly declare `regex = "1.10"` as a direct dependency. No external dependency introduces `regex` transitively.
4. **Step 4 (Check 34 Invariant Analysis)**: Check 34 ("Zero Regex Invariant") is planned to fail the build if `Regex::`, `use regex::`, or `regex =` is found anywhere in `crates/` or root manifests. Therefore, if refactoring were confined only to the 43 sites across 4 crates documented in the original plan, Check 34 would immediately fail on the remaining 138 sites and on `compile-sysml` and `deap-core`.
5. **Step 5 (Python debris scan)**: Running `find . -name "*.py" -not -path "./target/*"` confirmed 0 Python files in the workspace working tree and `.agents/teamwork/` metadata directories.
6. **Conclusion**: To successfully achieve zero regex across the workspace and pass Check 34, all 181 regex call sites across all 6 crates must be refactored, and `regex = "1.10"` must be removed from all 6 `Cargo.toml` files.

---

## 3. Caveats

- **No Caveats**: Every `.rs` file, `Cargo.toml` manifest, and directory in the workspace was scanned empirically.
- Note on `deap-core/src/rules.rs`: Contains struct fields named `prefix_normalization_regex` and `title_extraction_prefixes_regex` deserialized from `codebase_rules.json`. These are pure string configuration fields and do not use the `regex` crate or invoke regular expressions.

---

## 4. Conclusion

The workspace contains exactly:
- **181 `Regex::new` / `regex::Regex::new` call sites**
- **19 source files** containing regex invocations
- **18 `use regex::Regex;` declarations**
- **3 `regex::Captures` type bindings**
- **6 crate `Cargo.toml` manifests** declaring `regex = "1.10"`
- **0 Python files** outside `target/`

The Ralph burndown loop must target refactoring across all 6 crates (`assemble-conops`: 53, `reconcile-backlog`: 3, `verify-baseline`: 38, `ingest-sysml`: 52, `compile-sysml`: 8, `deap-core`: 27) in order for Check 34 to pass.

---

## 5. Verification Method

To independently verify all findings in this report, execute the following commands in the workspace root:

1. **Verify call site count (181 sites)**:
   ```bash
   test $(git grep -n "Regex::" crates/ | wc -l) -eq 181
   ```

2. **Verify import declarations (18 sites)**:
   ```bash
   test $(git grep -n "use regex::" crates/ | wc -l) -eq 18
   ```

3. **Verify manifest dependencies (6 crates)**:
   ```bash
   test $(git grep -n 'regex = "1.10"' crates/*/Cargo.toml | wc -l) -eq 6
   ```

4. **Verify zero Python files in workspace**:
   ```bash
   test $(find . -name "*.py" -not -path "./target/*" | wc -l) -eq 0
   ```
