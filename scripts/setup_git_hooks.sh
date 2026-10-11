#!/bin/sh
# Copyright Gint Atkinson, gint.atkinson@gmail.com
# Git hooks setup and pipeline infrastructure whitelist (.pipeline/constitution.md:266)
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GIT_DIR="$REPO_ROOT/.git"
[ -d "$GIT_DIR" ] || { echo "Error: .git directory not found at $GIT_DIR" >&2; exit 1; }

find "$REPO_ROOT" -name ".DS_Store" -type f -delete 2>/dev/null || true
HOOKS_DIR="$GIT_DIR/hooks"
mkdir -p "$HOOKS_DIR"

cat << 'EOF' > "$HOOKS_DIR/pre-commit"
#!/bin/sh
set -e
[ -x scripts/verify_subagent_output.sh ] && ./scripts/verify_subagent_output.sh --dir docs
[ -x ./target/release/verify-baseline ] && ./target/release/verify-baseline . --no-domain
EOF
chmod 0755 "$HOOKS_DIR/pre-commit"

cat << 'EOF' > "$HOOKS_DIR/commit-msg"
#!/bin/sh
[ -x scripts/verify_commit_messages.sh ] && ./scripts/verify_commit_messages.sh --msg-file "$1"
EOF
chmod 0755 "$HOOKS_DIR/commit-msg"
rm -f "$HOOKS_DIR/pre-push"

GITIGNORE="$REPO_ROOT/.gitignore"
touch "$GITIGNORE"
for pat in '!/skills/' '!/skills/**' '!/rules/' '!/rules/**' '!/.pipeline/' '!/.pipeline/**' '!/.agents/' '!/.agents/**' '!/scripts/' '!/scripts/**'; do
  grep -q -F "$pat" "$GITIGNORE" 2>/dev/null || printf "%s\n" "$pat" >> "$GITIGNORE"
done

(cd "$REPO_ROOT" && git add .pipeline/ skills/ rules/ scripts/ .agents/ 2>/dev/null || true)
echo "Successfully configured git hooks and staged pipeline infrastructure."
