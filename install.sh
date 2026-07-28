#!/usr/bin/env bash
# adjutant installer — copies the os/ tree into ~/.claude, then tells you
# to run /setup yourself (it doesn't launch Claude Code for you).
set -euo pipefail

CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "adjutant installer"
echo "  source: $REPO_DIR/os"
echo "  target: $CLAUDE_DIR"
echo

if [ ! -d "$CLAUDE_DIR" ]; then
  echo "error: $CLAUDE_DIR does not exist. Install Claude Code first: https://claude.com/claude-code"
  exit 1
fi

mkdir -p "$CLAUDE_DIR/agents" "$CLAUDE_DIR/skills"

copy_with_check() {
  local src="$1" dst="$2" kind="$3"
  if [ -e "$dst" ]; then
    echo "  skip (exists): $kind/$(basename "$dst") — remove it first if you want adjutant's version"
  else
    cp -R "$src" "$dst"
    echo "  installed: $kind/$(basename "$dst")"
  fi
}

echo "Agents:"
for agent in "$REPO_DIR"/os/agents/*.md; do
  copy_with_check "$agent" "$CLAUDE_DIR/agents/$(basename "$agent")" "agents"
done

echo
echo "Skills:"
for skill_dir in "$REPO_DIR"/os/skills/*/; do
  name="$(basename "$skill_dir")"
  copy_with_check "$skill_dir" "$CLAUDE_DIR/skills/$name" "skills"
done

echo
if [ -f "$REPO_DIR/os/CLAUDE.md" ]; then
  if [ -f "$CLAUDE_DIR/../CLAUDE.md" ] || [ -f "./CLAUDE.md" ]; then
    echo "Note: os/CLAUDE.md was NOT auto-merged into your project's CLAUDE.md."
    echo "      Read $REPO_DIR/os/CLAUDE.md and fold in what you want — this file"
    echo "      encodes the barbell pipeline and delivery gates this OS assumes."
  fi
fi

echo
echo "Install complete. Next: open Claude Code in this repo and run:"
echo
echo "    /setup"
echo
echo "That's the onboarding wizard — it writes config/os.config.yaml and gets"
echo "you a working /today or /decide within a few minutes."
