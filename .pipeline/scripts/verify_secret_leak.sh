#!/bin/sh
# Copyright Gint Atkinson, gint.atkinson@gmail.com
# Post-Build CI Secret Leak Scanner
# POSIX shell implementation

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

SCAN_DIRS="dist build/web build/macos"
FOUND_ANY=0
ALL_ERRORS=0

echo "=== Post-Build CI Secret Leak Scanner ==="

for d in $SCAN_DIRS; do
  TARGET_PATH="$WORKSPACE_DIR/$d"
  if [ -d "$TARGET_PATH" ]; then
    FOUND_ANY=1
    echo "Scanning directory: $d"
    # Scan for PEM private keys
    if grep -r -E -i "-----BEGIN[[:space:]]+([A-Z0-9_-]+[[:space:]]+)?PRIVATE[[:space:]]+KEY-----" "$TARGET_PATH" 2>/dev/null; then
      echo "  - Potential PEM Private Key found in $d" >&2
      ALL_ERRORS=$((ALL_ERRORS + 1))
    fi
    # Scan for AWS keys
    if grep -r -E "AKIA[0-9A-Z]{16}" "$TARGET_PATH" 2>/dev/null; then
      echo "  - Potential AWS Access Key ID found in $d" >&2
      ALL_ERRORS=$((ALL_ERRORS + 1))
    fi
  else
    echo "Directory not found (skipped): $d"
  fi
done

if [ $FOUND_ANY -eq 0 ]; then
  echo ""
  echo "Note: None of the post-build directories exist. Skipping scan. (Run build first to generate assets for scanning)"
  exit 0
fi

if [ $ALL_ERRORS -gt 0 ]; then
  echo ""
  echo "[!] CI Security Gate Failure: Potential Secrets or Credentials Leaked." >&2
  exit 1
else
  echo ""
  echo "Success: No secret leaks detected in post-build assets."
  exit 0
fi
