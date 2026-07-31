#!/usr/bin/env bash
# Lightweight public-data tripwire. It scans text files only; review binaries
# and rendered assets manually as described in docs/cookbook/sanitization-checklist.md.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

PATTERN='@[A-Za-z0-9._%+-]+\.(com|net|org|io|kr)|chat_id[[:space:]]*:[^0-9]{0,2}[0-9]{6,}|[0-9]{8,10}:[A-Za-z0-9_-]{25,}|gh[pousr]_[A-Za-z0-9_]{20,}'
MATCHES="$(grep -rniE \
  --exclude-dir=.git \
  --include='*.md' \
  --include='*.yaml' \
  --include='*.yml' \
  --include='*.sh' \
  "$PATTERN" . || true)"

if [[ -n "$MATCHES" ]]; then
  echo "Sanitization check failed. Remove or deliberately redesign these matches:" >&2
  echo "$MATCHES" >&2
  exit 1
fi

echo "Sanitization check passed. Remember to inspect binary demo assets manually."
