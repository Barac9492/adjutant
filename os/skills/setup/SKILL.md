---
name: setup
description: "First-run setup wizard — interviews the user and writes config/os.config.yaml. Run this once after install.sh, or any time to reconfigure."
user-invocable: true
allowed-tools: Read, Write, Edit, Bash, Glob
---

# adjutant Setup Wizard

This is the entire onboarding experience — if it fails to produce a working
config, nothing else in this OS works. Be fast, be concrete, don't ask
questions you can answer yourself by looking at the filesystem.

## Steps

### 0. Check for an existing config
If `config/os.config.yaml` already exists, read it, show a compact summary of
the current settings, and ask whether the user wants to reconfigure
everything or just change specific fields. If they want a targeted change,
skip to the relevant question below and edit only that field.

### 1. Copy the template
If no config exists yet: read `config/os.config.example.yaml`, copy it to
`config/os.config.yaml`. Confirm `config/os.config.yaml` is listed in
`.gitignore` at the repo root — if it isn't, stop and fix `.gitignore` first
(this file may contain connector secrets; it must never be committed).

### 2. Identity (fast — 2 questions max)
Ask: name, and timezone (offer to detect it from the system clock/locale and
just confirm rather than making them type an IANA string). Write both.

### 3. Notes vault (optional, skip gracefully)
Ask if they keep notes anywhere Claude Code can read (Obsidian, plain
markdown folder, Notion export, etc). If yes, get the path, verify it exists
with a directory listing, and ask if there's an index/MOC file. If no, leave
`vault.path` empty and say plainly which skills (`briefing`, `today`) will be
inert without it — don't hide the tradeoff.

### 4. Decision Ledger (optional, skip gracefully)
Ask if they want to track open high-stakes decisions (career moves, big
purchases, strategic calls — anything where they tend to over-analyze without
committing). If yes:
- Set `decisions.ledger_path` (default: `{vault.path}/Decisions` if a vault
  was configured, else ask for a plain path and create the directory).
- Create the ledger directory and copy `docs/decision-format.md`'s spec into
  a `README.md` there so the format is self-documenting in place.
- Ask for their first 1-3 open decisions RIGHT NOW using the `/decide add`
  flow from `os/skills/decide/SKILL.md` — an empty ledger demos nothing.
  This is the single highest-leverage thing this wizard can do: don't skip it
  even if the user seems eager to move on.
- Set `decisions.board_minutes_path` to `{ledger_path}/_board` and create it
  with a `_memory/` subfolder holding empty `veteran.md`, `pragmatist.md`,
  `operator.md` files (each with `## Session Log` and `## Demands
  outstanding` headings). Also create `{ledger_path}/_weekly/` so the
  Decision Ledger has a local fallback when no notification channel is enabled.

### 5. Board domain
If a ledger was configured, ask one question: "What's your field? (VC,
engineering, medicine, sales, something else)" — write it to
`board.veteran.domain`. This single field is what makes the veteran seat feel
like a real person instead of a template.

### 6. Notification channel (optional, skip gracefully)
Ask whether they prefer to pull results manually or already have a tested
notification adapter. Adjutant does not ship a Telegram transport. If they
already have an adapter, first point them to
`docs/cookbook/integrations.md` and have them verify a harmless, explicit
manual delivery against the correct account. Only then set
`channels.telegram.enabled: true` and its chat ID.

Never ask them to paste a bot token into chat. If their adapter needs one,
they should add it locally to the gitignored config or the adapter's secret
store and the wizard should redact it. If they do not have a tested adapter,
leave channels disabled. Connector-dependent skills must print or write their
result locally rather than claim a message was sent.

### 7. Which agents to enable
Show the `agents:` block from the config and ask which they want enabled day
one. Recommend starting with `decision_ledger_review` if they set up a ledger.
Only recommend `briefing_morning` after they have completed its manual
source and delivery preflight in `docs/cookbook/integrations.md`. Do not
enable everything by default; an overwhelming first week is how people abandon
a personal-automation setup.

### 8. Wire the scheduler
This repo does not install a scheduler. Tell the user plainly what to do next
depending on what's available in their environment (Claude Code scheduled
tasks / cron / a task runner they already use) — point at
`docs/cookbook/scheduling.md` rather than trying to set it up yourself, since
this varies by platform and getting it wrong here silently breaks every
"scheduled" skill.

### 9. Confirm and close
Print the final config (redact every connector secret and chat ID as `***`),
tell them exactly what to try first (`/decide list` if they configured a
ledger, otherwise `/today` only when a notes vault exists), and stop. Do not
over-explain — let them experience the system working.

## Hard rules

- Never write personal/secret values anywhere except `config/os.config.yaml`.
- Never suggest committing `os.config.yaml`. If the user asks to commit "the
  whole repo" with `git add -A` or similar, warn them first and confirm the
  gitignore is catching it.
- If any step can't be completed (no vault, no channel, no ledger interest),
  degrade gracefully and move on — a wizard that blocks on an optional step
  is worse than one that skips it and says what's inert as a result.
