# Handoff Report: WP 1.1 / R1 Unify Projection Tooling in `crates/reconcile-backlog`

## 1. Observation

- **Legacy YAML Frontmatter Dependency**: In `crates/reconcile-backlog/src/frontmatter.rs` (lines 22-26), `parse_frontmatter` aborted with `None` if content did not start with `---`:
  ```rust
  let trimmed = content.trim_start();
  if !trimmed.starts_with("---") {
      return None;
  }
  ```
  Consequently, executing `./target/release/reconcile-backlog --dry-run` yielded:
  ```
  Reconciliation completed successfully:
    - Total specifications scanned: 0
  ```
- **Prohibited Regex Usage in Issue ID Updater**: In `crates/reconcile-backlog/src/frontmatter.rs` (lines 147-150), updating table issue IDs relied on `regex::Regex`:
  ```rust
  let table_issue_regex = regex::Regex::new(r"(?i)(\|\s*\*\*Issue ID\*\*\s*\|\s*)(#[^\s|]+|\d+)(\s*\|)").unwrap();
  ```
  This violated REQ-0015 (Zero-Regex Monotonic Scanning).
- **Prohibited YAML Fence Injection on New Spec Format**: When no YAML frontmatter was present, `update_frontmatter_issue_id` (line 104) injected legacy fences:
  ```rust
  let new_fm = format!("---\nissue_id: {}\n---\n\n{}", issue_id, content);
  ```
  This violated `rules/specification-metadata-integrity.md` which forbids raw `---` fences in specification markdown documents.
- **Reference Table Parser in `reverse.rs`**: In `crates/compile-sysml/src/sync/reverse.rs` (lines 85-117), a proven scalar CommonMark 2-column table parser extracts metadata rows by scanning the first 20 lines without regex.

## 2. Logic Chain

1. **Parity Porting**: Ported the CommonMark 2-column metadata table parser from `reverse.rs` into `crates/reconcile-backlog/src/frontmatter.rs`. Defined `normalize_table_key` and `parse_table_row` to extract normalized keys (`issue_id`, `title`, `type`, `parent_epic`, `subsystem`, `package`, `schema_containers`, etc.) and values from `| Attribute | Specification Detail |` tables at lines 1-10.
2. **Backward-Compatible Fallback**: Structured `parse_frontmatter` to inspect the CommonMark metadata table first. If absent, it checks legacy YAML frontmatter as a fallback so that offline mock tests continue functioning.
3. **Pure Scalar Table Updating**: Replaced regex substitution in `update_frontmatter_issue_id` with scalar line scanning:
   - Scans lines within the metadata table for `key == "issue_id"` and replaces the row with `| **Issue ID** | #<id> |`.
   - If the row is not present in an existing table, inserts it immediately after the delimiter row (`| :--- | :--- |`).
   - If no table is present and no YAML is present, injects a compliant CommonMark metadata table header.
   - If legacy YAML frontmatter already exists, updates the `issue_id: <id>` field within the YAML fence without adding new YAML fences to documents that lack them.
4. **Verification**: Executed `cargo check --workspace`, `cargo build --release --workspace`, `cargo test -p reconcile-backlog` (17/17 passed), `./target/release/reconcile-backlog --dry-run` (93/93 specifications scanned), and `./target/release/verify-baseline . --no-domain` (all 32 quality gates passed).

## 3. Caveats

- **Specification File Count**: The repository contains 93 specification files across `docs/epics` (14), `docs/features` (55), `docs/user-stories` (12), and `docs/use-cases` (12). `compile-sysml --forward-sync` generates 94 files when including `docs/safety/STPA_MATRIX.md`. `reconcile-backlog` standard directories (`docs/epics`, `docs/features`, `docs/user-stories`, `docs/use-cases`) scan all 93 specifications. All 93 are successfully discovered, parsed, and mapped.
- **Zero Em Dashes**: Verified that no Unicode em dashes (`\u2014`) exist in modified files.

## 4. Conclusion

- `crates/reconcile-backlog/src/frontmatter.rs` successfully parses native CommonMark 2-column metadata tables at lines 1-10 and updates issue IDs using zero-regex scalar string scanning.
- All 93 specification files in `docs/` are cleanly discovered and parsed by `reconcile-backlog`.
- Code changes committed in `648d6139fd57775a5f8721df95557d3b7a5214df` with neutral citation:
  `fix(reconcile-backlog): parse native commonmark metadata tables and update issue id (refs #115)`.

## 5. Verification Method

1. Verify workspace compilation:
   ```bash
   cargo check --workspace
   cargo build --release --workspace
   ```
2. Run in-crate test suite:
   ```bash
   cargo test -p reconcile-backlog
   ```
3. Run dry-run projection to confirm specification discovery:
   ```bash
   ./target/release/reconcile-backlog --dry-run
   ```
   Assert `Total specifications scanned: 93`.
4. Run full baseline conformance verification:
   ```bash
   ./target/release/verify-baseline . --no-domain
   ```
   Assert all 32 checks pass with exit code 0.
