#!/bin/sh
# Copyright Gint Atkinson, gint.atkinson@gmail.com
# ==============================================================================
# DEAP Safety-Critical Engineering Pipeline Bootstrap Installer
# Clean POSIX shell installer for native Rust toolchain and pipeline governance.
# ==============================================================================
set -eu

cleanup() {
  local exit_code=$?
  if [ $exit_code -ne 0 ]; then
    echo "Installer exiting with code ${exit_code}." >&2
  fi
  exit $exit_code
}

trap cleanup EXIT
trap 'echo "Installation interrupted by user." >&2; exit 130' INT
trap 'echo "Installation terminated by signal." >&2; exit 143' TERM

# 1. Validate host prerequisites
if ! command -v git >/dev/null 2>&1; then
  echo "ERROR: 'git' command not found. Git is required to install the pipeline." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TARGET_DIR="."
ROLE=""
PROVIDER="auto"
PROFILE=""

while [ $# -gt 0 ]; do
  case "$1" in
    --profile)
      PROFILE="$2"
      shift 2
      ;;
    -r|--role)
      ROLE="$2"
      shift 2
      ;;
    -p|--provider|-t|--tracker|--platform)
      PROVIDER="$2"
      shift 2
      ;;
    --target)
      TARGET_DIR="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: install_pipeline.sh [OPTIONS] [TARGET_DIR]"
      echo ""
      echo "Options:"
      echo "  --profile PROFILE      Target implementation profile"
      echo "  -r, --role ROLE        Repository role: 'domain-template' or 'customer-project'"
      echo "  -p, --provider PROV    Issue tracker provider: 'github', 'gitlab', or 'auto'"
      echo "  --target DIR           Target directory"
      echo "  -h, --help             Show this help message"
      exit 0
      ;;
    *)
      if [ -d "$1" ] || [ ! -e "$1" ]; then
        TARGET_DIR="$1"
      fi
      shift
      ;;
  esac
done

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

# 2. Configure profile if specified
if [ -n "$PROFILE" ]; then
  PIPELINE_DIR="$TARGET_DIR/.pipeline"
  mkdir -p "$PIPELINE_DIR"
  cat << EOF > "$PIPELINE_DIR/profile_config.json"
{
  "active_profile": "$PROFILE"
}
EOF
  echo "Successfully configured pipeline for profile: $PROFILE"
fi

# 3. Setup git hooks and whitelist
if [ -x "$SCRIPT_DIR/setup_git_hooks.sh" ]; then
  "$SCRIPT_DIR/setup_git_hooks.sh"
elif [ -f "$SCRIPT_DIR/setup_git_hooks.sh" ]; then
  sh "$SCRIPT_DIR/setup_git_hooks.sh"
fi

# 4. Build native Rust binaries if Cargo.toml is present
if [ -f "$TARGET_DIR/Cargo.toml" ] && command -v cargo >/dev/null 2>&1; then
  echo "Building native Rust workspace binaries..."
  (cd "$TARGET_DIR" && cargo build --release)
fi

echo "==> Digital Pipeline Installation Complete. 0 manual steps remaining."
exit 0
