# Architecture

## Design principle

Every skill and agent reads identity, paths, and channels from
`config/os.config.yaml` (never hardcoded) — see
`config/os.config.example.yaml` for the full schema. This is what makes the
same skill file work for any user without editing its prose. If you add a
skill and catch yourself hardcoding a path, a name, or a chat ID, stop —
that's the one rule this whole repo depends on.

## What shipped in v1 vs. what's still personal-only

**Shipped (`os/agents/`, `os/skills/`):** the board trio, the barbell
pipeline roles (scout, implementer, reviewer), the two quality gates
(delivery-critic, persona-qa-player), the Decision Ledger, morning briefing
+ today planner, and seven scheduled agents (followups, meeting-prep,
email-triage, orchestrator, weekly-synthesis, health-check,
briefing-morning).

**Deliberately not shipped:** anything that only makes sense as one person's
life — a personal AI companion tied to one person's calendar and history, a
vertical-specific deal-sourcing tool, anything entangled with a specific
employer, family, or organization. `examples/verticals/` shows how to build
your own version of that kind of thing on top of this base, without the base
itself assuming your specific life.

## The demo-asset rule

Any screenshot, GIF, or example output that ships in this repo's docs or
README must use a **staged or already-resolved** decision/scenario — never
someone's live, still-open deliberation. "Real system output" means real
mechanics and real formatting, not someone's actual unresolved career
decision on display in a public repo. This rule exists because the whole
pitch of this project is "here's proof it actually works," and that proof
must not cost the person publishing it their privacy.

## Memory backends

The board and ledger default to flat markdown files (`memory_backend: local`
in config) so the repo has zero required external dependencies. If you use a
tool that gives agents persistent searchable memory across sessions, you can
wire an alternate backend — the seat agents already read
`config.board.memory_backend` and branch on it; adding a new backend means
adding a new branch, not restructuring the agents.

## Security model

`config/os.config.yaml` is the only file allowed to contain secrets
(notification tokens, chat IDs) and is gitignored by default. CI (see
`.github/workflows/` once added) should run a secret-scan on every PR against
the sweep list in `docs/cookbook/sanitization-checklist.md` — treat any hit
as a blocking failure, not a warning.
