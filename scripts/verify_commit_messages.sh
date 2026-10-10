#!/bin/sh
# Copyright Gint Atkinson, gint.atkinson@gmail.com
# Mechanical Commit Message Non-Closure Linter & Gate
# Enforces the Commit Message Non-Closure Invariant (.pipeline/constitution.md:266)

set -e

PATTERN='(^|[[:space:]]|[^[:alnum:]_])(fix|fixes|fixed|close|closes|closed|resolve|resolves|resolved)(:[[:space:]]*|[[:space:]]+)#[0-9]+'

format_violation_error() {
  local context="$1"
  local offending="$2"
  echo "ERROR: Commit message violates the Commit Message Non-Closure Invariant (.pipeline/constitution.md:266)." >&2
  if [ -n "$context" ]; then
    echo "Context: $context" >&2
  fi
  echo "Forbidden auto-closing trigger detected." >&2
  echo "" >&2
  echo "Agents and automated scripts are strictly prohibited from using issue auto-closing keywords" >&2
  echo "(fix, fixes, fixed, close, closes, closed, resolve, resolves, resolved preceding #<id>)." >&2
  echo "All commit messages referencing issues MUST use neutral citations:" >&2
  echo "  - '(refs #<id>)'" >&2
  echo "  - '(#<id>)'" >&2
  if [ -n "$offending" ]; then
    echo "" >&2
    echo "Offending message:" >&2
    printf "%s\n" "$offending" | while IFS= read -r line; do
      echo "  > $line" >&2
    done
  fi
}

check_text() {
  local text="$1"
  local context="$2"
  if printf "%s\n" "$text" | grep -E -i "$PATTERN" >/dev/null 2>&1; then
    format_violation_error "$context" "$text"
    return 1
  fi
  return 0
}

check_file() {
  local file_path="$1"
  if [ ! -f "$file_path" ]; then
    echo "Error: Commit message file does not exist: $file_path" >&2
    return 1
  fi
  local content
  content=$(cat "$file_path")
  check_text "$content" "file $file_path"
}

check_head() {
  local msg
  msg=$(git log -1 --pretty=%B)
  check_text "$msg" "HEAD commit"
}

check_range() {
  local rev_range="$1"
  local violations=0
  local commit_hash=""
  local commit_msg=""

  # Use git log with delimiter
  while IFS= read -r line; do
    if [ "$line" = "---COMMIT_SEPARATOR---" ]; then
      if [ -n "$commit_hash" ]; then
        if ! check_text "$commit_msg" "commit $commit_hash in range $rev_range"; then
          violations=$((violations + 1))
        fi
      fi
      commit_hash=""
      commit_msg=""
    elif [ -z "$commit_hash" ]; then
      commit_hash="$line"
    else
      if [ -z "$commit_msg" ]; then
        commit_msg="$line"
      else
        commit_msg="$commit_msg
$line"
      fi
    fi
  done <<EOF
$(git log --format="---COMMIT_SEPARATOR---%n%H%n%B" "$rev_range")
---COMMIT_SEPARATOR---
EOF

  if [ $violations -gt 0 ]; then
    return 1
  fi
  return 0
}

# Argument parsing
if [ $# -eq 0 ]; then
  echo "Usage: $0 [--msg-file <file> | --range <rev-range> | --head | --check-text <text>]" >&2
  exit 1
fi

while [ $# -gt 0 ]; do
  case "$1" in
    --msg-file)
      check_file "$2"
      exit $?
      ;;
    --range)
      check_range "$2"
      exit $?
      ;;
    --head)
      check_head
      exit $?
      ;;
    --check-text)
      check_text "$2" "raw text"
      exit $?
      ;;
    *)
      if [ -f "$1" ]; then
        check_file "$1"
        exit $?
      else
        echo "Unknown option: $1" >&2
        exit 1
      fi
      ;;
  esac
  shift
done
