#!/bin/sh
# Copyright Gint Atkinson, gint.atkinson@gmail.com
# scripts/file_defect.sh
# Pre-submission schema validator & issue filer for DEAP01-spec-core.
# Validates defect dossiers strictly against the 7-section Adversarial Audit schema
# before submitting them to GitHub (via `gh issue create`) or GitLab (via `glab issue create`).

set -e

TITLE=""
BODY_FILE=""
REPO="gintatkinson/DEAP01-spec-core"
LABEL=""
PROVIDER="github"
DRY_RUN=0

while [ $# -gt 0 ]; do
  case "$1" in
    --title)
      TITLE="$2"
      shift 2
      ;;
    --body-file)
      BODY_FILE="$2"
      shift 2
      ;;
    --repo)
      REPO="$2"
      shift 2
      ;;
    --label)
      LABEL="$2"
      shift 2
      ;;
    --provider)
      PROVIDER="$2"
      shift 2
      ;;
    --dry-run|--validate-only)
      DRY_RUN=1
      shift
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

if [ -z "$BODY_FILE" ] || [ ! -f "$BODY_FILE" ]; then
  echo "Error: --body-file is required and must exist." >&2
  exit 1
fi

if [ $DRY_RUN -eq 0 ] && [ -z "$TITLE" ]; then
  echo "Error: --title is required when submitting an issue." >&2
  exit 1
fi

CONTENT=$(cat "$BODY_FILE")
ERRORS=0

log_error() {
  echo "  - $1" >&2
  ERRORS=$((ERRORS + 1))
}

# 1. Check sections ## 1. to ## 7.
for i in 1 2 3 4 5 6 7; do
  if ! printf "%s\n" "$CONTENT" | grep -q "^##[[:space:]]\+$i\."; then
    log_error "Missing mandatory section header '## $i.'"
  fi
done

# 2. Check ## Audit Source
if ! printf "%s\n" "$CONTENT" | grep -qi "^##[[:space:]]\+Audit Source"; then
  log_error "Missing mandatory '## Audit Source' section header."
fi

# 3. Check SEVERITY
if ! printf "%s\n" "$CONTENT" | grep -qE "^SEVERITY:[[:space:]]*(Critical|Important|Suggestion|Nitpick)"; then
  log_error "Missing or invalid 'SEVERITY:' line (must be Critical, Important, Suggestion, or Nitpick)."
fi

# 4. Check FILE_LOCATION
if ! printf "%s\n" "$CONTENT" | grep -qE "^FILE_LOCATION:[[:space:]]*[^[:space:]]+"; then
  log_error "Missing or empty mandatory 'FILE_LOCATION:' line."
fi

# 5. Check balanced code blocks
FENCE_COUNT=$(printf "%s\n" "$CONTENT" | grep -c '```' || true)
if [ $((FENCE_COUNT % 2)) -ne 0 ]; then
  log_error "Unbalanced code blocks: found odd number ($FENCE_COUNT) of \`\`\` fences."
fi

if [ $ERRORS -gt 0 ]; then
  echo "Defect dossier validation FAILED for $BODY_FILE with $ERRORS violation(s):" >&2
  exit 1
fi

SEVERITY=$(printf "%s\n" "$CONTENT" | grep -E "^SEVERITY:[[:space:]]*(Critical|Important|Suggestion|Nitpick)" | head -n 1 | sed 's/SEVERITY:[[:space:]]*//' | tr -d '\r')

if [ -z "$LABEL" ]; then
  case "$SEVERITY" in
    Critical|Important)
      if [ "$PROVIDER" = "gitlab" ]; then
        LABEL="type::bug"
      else
        LABEL="bug"
      fi
      ;;
    *)
      if [ "$PROVIDER" = "gitlab" ]; then
        LABEL="type::feature"
      else
        LABEL="enhancement"
      fi
      ;;
  esac
fi

if [ $DRY_RUN -eq 1 ]; then
  echo "[DRY RUN] Defect validation PASSED. Target payload:"
  echo "  Provider: $PROVIDER"
  echo "  Repo: $REPO"
  echo "  Title: ${TITLE:-[AUDIT] $(basename "$BODY_FILE")}"
  echo "  Label: $LABEL"
  echo "  Body file: $BODY_FILE"
  exit 0
fi

if [ "$PROVIDER" = "github" ]; then
  CMD="gh issue create --repo $REPO --title \"$TITLE\" --body-file \"$BODY_FILE\""
  if [ -n "$LABEL" ]; then
    CMD="$CMD --label \"$LABEL\""
  fi
  eval "$CMD"
elif [ "$PROVIDER" = "gitlab" ]; then
  CMD="glab issue create --repo $REPO --title \"$TITLE\" --description \"\$(cat \"$BODY_FILE\")\""
  if [ -n "$LABEL" ]; then
    CMD="$CMD --label \"$LABEL\""
  fi
  eval "$CMD"
else
  echo "Error: Unsupported provider '$PROVIDER'. Must be 'github' or 'gitlab'." >&2
  exit 1
fi
