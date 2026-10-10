#!/bin/sh
# Copyright Gint Atkinson, gint.atkinson@gmail.com
# Subagent Output Integrity & Escape Tokens Gate
# Verifies:
# 1. Non-zero file size
# 2. Existence on filesystem
# 3. Valid code fence balancing
# 4. Zero unreplaced {{REQUIRED_*}} escape tokens

set -e

DIR=""
FILES=""

while [ $# -gt 0 ]; do
  case "$1" in
    --dir)
      DIR="$2"
      shift 2
      ;;
    --files)
      shift
      while [ $# -gt 0 ] && [ "${1#--}" = "$1" ]; do
        FILES="$FILES $1"
        shift
      done
      ;;
    *)
      if [ -d "$1" ]; then
        DIR="$1"
      elif [ -f "$1" ]; then
        FILES="$FILES $1"
      fi
      shift
      ;;
  esac
done

TARGET_FILES=""
if [ -n "$DIR" ] && [ -d "$DIR" ]; then
  TARGET_FILES=$(find "$DIR" -name "*.md" -type f)
fi

if [ -n "$FILES" ]; then
  TARGET_FILES="$TARGET_FILES $FILES"
fi

if [ -z "$TARGET_FILES" ]; then
  # If no targets provided, nothing to verify
  exit 0
fi

FAILED=0
CHECKED=0

for f in $TARGET_FILES; do
  if [ ! -f "$f" ]; then
    continue
  fi
  CHECKED=$((CHECKED + 1))

  # 1. Non-zero size
  if [ ! -s "$f" ]; then
    echo "ERROR: Subagent output file is empty: $f" >&2
    FAILED=$((FAILED + 1))
    continue
  fi

  # 2. Escape tokens
  if grep -q '{{REQUIRED_' "$f" 2>/dev/null; then
    echo "ERROR: Unreplaced {{REQUIRED_*}} escape token detected in: $f" >&2
    FAILED=$((FAILED + 1))
    continue
  fi

  # 3. Unbalanced code blocks
  fence_count=$(grep -c '```' "$f" 2>/dev/null || true)
  if [ $((fence_count % 2)) -ne 0 ]; then
    echo "ERROR: Unbalanced code fences in: $f (found $fence_count fences)" >&2
    FAILED=$((FAILED + 1))
    continue
  fi
done

if [ $FAILED -gt 0 ]; then
  echo "Subagent output verification FAILED ($FAILED errors out of $CHECKED files)." >&2
  exit 42
fi

echo "Subagent output verification PASSED ($CHECKED files verified)."
exit 0
