# Claude Code Project Guidelines

## Workflow & Quality Gates
- Follow all pipeline rules by executing `view_file` on `.pipeline/ACTIVE_RULES_BUNDLE.md`, and skills in `skills/` and `.agents/skills/`.
- Strict Planning Gate: Do not execute unauthorized modifications without an approved implementation plan.
- Execute baseline verification: `./target/release/verify-baseline . --no-domain` (or `python3 scripts/verify_downstream_baseline.py --no-domain`).
- Compile SysML v2 models: `./target/release/compile-sysml --compile` (or `python3 scripts/compile_sysml.py --compile`).
- Ingest OEM schemas/documents: `./target/release/ingest-sysml --schema schema/ --format markdown --out schema/model.sysml` (or `python3 skills/spec-orchestrator/scripts/sysmlv2_ingest.py`).
- Assemble ConOps & Mission Intent: `./target/release/assemble-conops --input-dir docs/conops/units/ --output-dir docs/conops/` (or `python3 scripts/assemble_conops.py`).
- Follow the universal initialization sequence in Section 5.6 of README.md and execute view_file on .pipeline/ACTIVE_RULES_BUNDLE.md before starting any task.
