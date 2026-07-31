#!/usr/bin/env bash
# adjutant installer — copies the os/ tree into ~/.claude and installs the
# project-level CLAUDE.md doctrine without overwriting an existing file.
set -euo pipefail

CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_CLAUDE="$REPO_DIR/CLAUDE.md"

printf '%s\n' "adjutant installer"
printf '  source: %s\n' "$REPO_DIR/os"
printf '  Claude Code target: %s\n' "$CLAUDE_DIR"
printf '  project doctrine: %s\n\n' "$PROJECT_CLAUDE"

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
echo "Project instructions:"
if [ -f "$REPO_DIR/os/CLAUDE.md" ]; then
  if [ -e "$PROJECT_CLAUDE" ]; then
    echo "  skip (exists): CLAUDE.md — keep your project instructions and manually merge"
    echo "  $REPO_DIR/os/CLAUDE.md if you want adjutant's barbell pipeline and gates."
  else
    cp "$REPO_DIR/os/CLAUDE.md" "$PROJECT_CLAUDE"
    echo "  installed: CLAUDE.md — Claude Code will load the adjutant doctrine in this repo."
  fi
fi

echo
echo "Install complete. Next: open Claude Code in this repository and run:"
echo
echo "    /setup"
echo
echo "Start with /decide add for a local-only first result. /today and external"
echo "automation need the notes and connector setup described in the README."
