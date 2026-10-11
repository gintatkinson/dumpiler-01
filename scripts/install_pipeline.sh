#!/bin/sh
# Copyright Gint Atkinson, gint.atkinson@gmail.com
# DEAP Pipeline Bootstrap Installer
set -eu

command -v git >/dev/null 2>&1 || { echo "ERROR: 'git' required." >&2; exit 1; }
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="."
PROFILE=""

while [ $# -gt 0 ]; do
  case "$1" in
    --profile) PROFILE="$2"; shift 2 ;;
    -r|--role|-p|--provider|-t|--tracker|--platform) shift 2 ;;
    --target) TARGET_DIR="$2"; shift 2 ;;
    -h|--help)
      echo "Usage: install_pipeline.sh [--profile PROFILE] [--target DIR]"
      exit 0 ;;
    *)
      if [ -d "$1" ] || [ ! -e "$1" ]; then
        TARGET_DIR="$1"
      fi
      shift ;;
  esac
done

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
if [ -n "$PROFILE" ]; then
  mkdir -p "$TARGET_DIR/.pipeline"
  printf '{\n  "active_profile": "%s"\n}\n' "$PROFILE" > "$TARGET_DIR/.pipeline/profile_config.json"
  echo "Successfully configured pipeline for profile: $PROFILE"
fi

[ -x "$SCRIPT_DIR/setup_git_hooks.sh" ] && "$SCRIPT_DIR/setup_git_hooks.sh"

if [ -f "$TARGET_DIR/Cargo.toml" ] && command -v cargo >/dev/null 2>&1; then
  echo "Building native Rust workspace binaries..."
  (cd "$TARGET_DIR" && cargo build --release)
fi

echo "==> Digital Pipeline Installation Complete. 0 manual steps remaining."
exit 0
