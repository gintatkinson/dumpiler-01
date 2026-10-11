#!/bin/sh
# Copyright Gint Atkinson, gint.atkinson@gmail.com
# POSIX delegation wrapper for verify-baseline check-commit-msg.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BIN="$REPO_ROOT/target/release/verify-baseline"

if [ ! -x "$BIN" ]; then
    echo "verify-baseline release binary not found. Building..." >&2
    (cd "$REPO_ROOT" && cargo build --release --bin verify-baseline)
fi

exec "$BIN" check-commit-msg "$@"
