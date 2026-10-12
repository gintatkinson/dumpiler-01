# Progress: Work Package 2 (crates/assemble-conops)

Last visited: 2026-10-12T12:35:30Z
Status: Complete (with upstream inventory defect reported)

## Tasks
- [x] Read DISPATCH.md and initialize governance documents (.pipeline/constitution.md, .pipeline/ACTIVE_RULES_BUNDLE.md, SKILL.md)
- [x] Create BRIEFING.md and progress.md
- [x] Inspect crates/assemble-conops/src/toc.rs and crates/assemble-conops/Cargo.toml
- [x] Refactor extract_headings and verify_markdown_links in crates/assemble-conops/src/toc.rs to use pulldown_cmark AST events (zero regex in toc.rs)
- [x] Add pulldown-cmark = "0.13" to crates/assemble-conops/Cargo.toml
- [x] Verify cargo check -p assemble-conops compiles with 0 errors and 0 warnings
- [x] Document upstream inventory gap: crates/assemble-conops contains 53 additional regex sites across assembler.rs, params.rs, sanitize.rs blocking immediate eviction of regex from Cargo.toml
- [x] Write handoff.md
- [ ] Send completion message to orchestrator
