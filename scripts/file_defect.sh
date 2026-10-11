#!/bin/sh
# Copyright Gint Atkinson, gint.atkinson@gmail.com
# POSIX wrapper: validates defect dossier via verify-baseline, then files issue.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

VERIFY_BIN="$REPO_ROOT/target/release/verify-baseline"
RECONCILE_BIN="$REPO_ROOT/target/release/reconcile-backlog"

[ -x "$VERIFY_BIN" ] || (cd "$REPO_ROOT" && cargo build --release --bin verify-baseline)

DRY_RUN=0
for arg in "$@"; do
    case "$arg" in
        --dry-run|--validate-only) DRY_RUN=1 ;;
    esac
done

"$VERIFY_BIN" check-defect "$@"
[ "$DRY_RUN" -eq 1 ] && exit 0

TITLE=""
BODY_FILE=""
REPO="gintatkinson/DEAP01-spec-core"
LABEL=""

while [ $# -gt 0 ]; do
    case "$1" in
        --title) TITLE="$2"; shift 2 ;;
        --body-file) BODY_FILE="$2"; shift 2 ;;
        --repo) REPO="$2"; shift 2 ;;
        --label) LABEL="$2"; shift 2 ;;
        *) shift ;;
    esac
done

if [ -n "$TITLE" ] && [ -n "$BODY_FILE" ]; then
    LABEL="${LABEL:-bug}"
    if [ -x "$RECONCILE_BIN" ]; then
        exec "$RECONCILE_BIN" create-issue --body-file "$BODY_FILE" --label "$LABEL" --title "$TITLE" --repo "$REPO"
    else
        exec gh issue create --repo "$REPO" --title "$TITLE" --body-file "$BODY_FILE" --label "$LABEL"
    fi
fi
