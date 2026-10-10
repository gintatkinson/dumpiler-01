#!/bin/sh
# Copyright Gint Atkinson, gint.atkinson@gmail.com
# scripts/setup_git_hooks.sh
# Clean up Git hooks and whitelist pipeline infrastructure directories.
# Installs pre-commit hook and commit-msg hook (enforcing .pipeline/constitution.md:266).
# Removes pre-push hooks to prevent auto-triggered compiler runs.
# Appends whitelist rules to .gitignore and stages pipeline directories.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GIT_DIR="$REPO_ROOT/.git"

if [ ! -d "$GIT_DIR" ]; then
  echo "Error: .git directory not found at $GIT_DIR" >&2
  exit 1
fi

# 1. Purge .DS_Store files
find "$REPO_ROOT" -name ".DS_Store" -type f -delete 2>/dev/null || true

# 2. Install pre-commit hook
HOOKS_DIR="$GIT_DIR/hooks"
mkdir -p "$HOOKS_DIR"

PRE_COMMIT="$HOOKS_DIR/pre-commit"
cat << 'EOF' > "$PRE_COMMIT"
#!/bin/sh
set -e
# Pre-commit hook: Subagent Output Integrity & Baseline Conformance Gate
if [ -x ./target/release/verify-subagent ]; then
  ./target/release/verify-subagent docs
elif [ -x scripts/verify_subagent_output.sh ]; then
  ./scripts/verify_subagent_output.sh --dir docs
elif [ -f scripts/verify_subagent_output.sh ]; then
  sh scripts/verify_subagent_output.sh --dir docs
fi

if [ -x ./target/release/verify-baseline ]; then
  ./target/release/verify-baseline . --no-domain
elif [ -x ./target/debug/verify-baseline ]; then
  ./target/debug/verify-baseline . --no-domain
fi
EOF
chmod 0755 "$PRE_COMMIT"
echo "Successfully installed Git pre-commit hook: $PRE_COMMIT"

# 3. Install commit-msg hook
COMMIT_MSG="$HOOKS_DIR/commit-msg"
cat << 'EOF' > "$COMMIT_MSG"
#!/bin/sh
# Commit-msg hook: Reject auto-closing trigger keywords (.pipeline/constitution.md:266)
if [ -x scripts/verify_commit_messages.sh ]; then
  ./scripts/verify_commit_messages.sh --msg-file "$1"
elif [ -f scripts/verify_commit_messages.sh ]; then
  sh scripts/verify_commit_messages.sh --msg-file "$1"
fi
EOF
chmod 0755 "$COMMIT_MSG"
echo "Successfully installed Git commit-msg hook: $COMMIT_MSG"

# 4. Remove pre-push hook if present
if [ -f "$HOOKS_DIR/pre-push" ]; then
  rm -f "$HOOKS_DIR/pre-push"
  echo "Successfully removed pre-push hook: $HOOKS_DIR/pre-push"
fi

# 5. Whitelist pipeline infrastructure in .gitignore
GITIGNORE="$REPO_ROOT/.gitignore"
if [ ! -f "$GITIGNORE" ]; then
  touch "$GITIGNORE"
fi

PATTERNS="!/skills/
!/skills/**
!/rules/
!/rules/**
!/.pipeline/
!/.pipeline/**
!/.agents/
!/.agents/**
!/scripts/
!/scripts/**"

ADDED=0
for pat in $PATTERNS; do
  if ! grep -q -F "$pat" "$GITIGNORE" 2>/dev/null; then
    if [ $ADDED -eq 0 ]; then
      printf "\n# Pipeline infrastructure (whitelisted by setup_git_hooks.sh)\n" >> "$GITIGNORE"
    fi
    echo "$pat" >> "$GITIGNORE"
    ADDED=$((ADDED + 1))
  fi
done

if [ $ADDED -gt 0 ]; then
  echo "Appended $ADDED whitelist entries to .gitignore"
else
  echo "Infrastructure whitelist entries already present in .gitignore"
fi

# 6. Stage pipeline infrastructure
(
  cd "$REPO_ROOT"
  git add .pipeline/ skills/ rules/ scripts/ .agents/ 2>/dev/null || true
)
echo "Staged pipeline infrastructure directories"
