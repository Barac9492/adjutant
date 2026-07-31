# Architecture

## Design principle

Every skill and agent reads identity, paths, and channels from
`config/os.config.yaml` rather than hardcoding them. See
`config/os.config.example.yaml` for the schema. If you add a skill and catch
yourself hardcoding a path, name, chat ID, or account, stop and make that a
local configuration concern instead.

## What shipped in v1 and what is still personal-only

**Shipped (`os/agents/`, `os/skills/`):** the board trio, the barbell pipeline
roles (scout, implementer, reviewer), the two quality gates
(delivery-critic, persona-qa-player), the Decision Ledger, morning briefing
and today planner, plus seven schedulable workflow protocols (followups,
meeting-prep, email-triage, orchestrator, weekly-synthesis, health-check,
briefing-morning).

**Deliberately not shipped:** anything that only makes sense as one person's
life, such as a personal companion tied to one calendar and history, a
vertical-specific deal-sourcing tool, or anything entangled with a specific
employer, family, or organization. `examples/verticals/` shows how to build a
private specialization on top of the generic base.

**Not bundled:** email, calendar, Telegram, and scheduler connectors. The
skills describe the behavior expected once a user supplies a connector; they do
not install one. See `docs/cookbook/integrations.md` before enabling those
workflows.

## The demo-asset rule

Any screenshot, GIF, or example output that ships in this repository must use
a staged or already-resolved decision or scenario, never someone's live,
still-open deliberation. "Real system output" means real mechanics and
formatting, not someone's actual unresolved career decision on display in a
public repository.

## Memory backends

The board and ledger default to flat Markdown files (`memory_backend: local`)
so the repository has zero required external dependencies. If you use a tool
that gives agents persistent searchable memory across sessions, you can wire an
alternate backend. The seat agents already read `config.board.memory_backend`
and branch on it; adding a backend should mean adding a branch, not
restructuring the agents.

## Security model

`config/os.config.yaml` is gitignored and is the only file that should contain
personal paths, notification IDs, or connector secrets. Skills and agents must
never hardcode them.

`scripts/check-sanitization.sh` runs on every pull request and push to `main`
through `.github/workflows/sanitization.yml`. It catches a small set of likely
identifiers and tokens in text files. Treat any match as blocking, then inspect
all rendered demos and binary assets separately using
`docs/cookbook/sanitization-checklist.md`.
