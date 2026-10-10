#!/bin/sh
# Copyright Gint Atkinson, gint.atkinson@gmail.com
# POSIX shell script wrapper for native Rust reconcile-backlog utility.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

BIN="$REPO_ROOT/target/release/reconcile-backlog"

if [ ! -x "$BIN" ]; then
    echo "reconcile-backlog release binary not found. Building..." >&2
    (cd "$REPO_ROOT" && cargo build --release --bin reconcile-backlog)
fi

exec "$BIN" "$@"
