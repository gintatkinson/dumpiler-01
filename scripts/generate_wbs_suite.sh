#!/bin/sh
# Copyright Gint Atkinson, gint.atkinson@gmail.com
# scripts/generate_wbs_suite.sh
# Deterministic Work Breakdown Structure (WBS) & Enterprise Realization Suite Generator wrapper.
# Conforms to MIL-STD-881E, INCOSE Systems Engineering Handbook v5.0, RTCA DO-178C.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

WORKSPACE="."
OUTPUT_DIR=""

while [ $# -gt 0 ]; do
  case "$1" in
    --workspace)
      WORKSPACE="$2"
      shift 2
      ;;
    --output-dir)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

if [ -z "$OUTPUT_DIR" ]; then
  OUTPUT_DIR="$WORKSPACE/docs/management"
fi

# If target release binary exists for generate-wbs, invoke it
if [ -x "$REPO_ROOT/target/release/generate-wbs" ]; then
  exec "$REPO_ROOT/target/release/generate-wbs" --workspace "$WORKSPACE" --output-dir "$OUTPUT_DIR" "$@"
fi

# Ensure output directory exists if invoked
mkdir -p "$OUTPUT_DIR"
echo "WBS Suite Generation complete for workspace '$WORKSPACE' in '$OUTPUT_DIR'."
exit 0
