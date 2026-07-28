# Roadmap

## Shipped (v1)

Board trio, Decision Ledger, barbell pipeline (scout/implementer/reviewer),
delivery-critic, persona-qa-player, briefing + today, and seven scheduled
agents (followups, meeting-prep, email-triage, orchestrator,
weekly-synthesis, health-check, briefing-morning). See `docs/ARCHITECTURE.md`.

## Planned (v1.1+, not yet extracted)

- **Writing/ideation agent** — generates content ideas from a configurable
  set of source feeds and a personal "interesting to me" framework.
- **Source scanner** — periodic sweep of configured feeds (news, forums,
  wherever) filtered through your own stated interests, surfaced as a short
  digest rather than a raw feed dump.
- **Revenue/goal tracker** — a generic version of "track progress against a
  numeric goal over time, close periods, flag drift" — useful for far more
  than one specific goal type.
- **Opportunity radar** — periodic scan for a configurable class of
  opportunity (could be media appearances, could be job leads, could be
  anything pattern-matchable) with a scoring rubric you define.
- **Conversation/pattern analyzer** — looks across your own agent session
  history for recurring patterns worth surfacing back to you.

## Never shipping in core

Anything that only makes sense as one specific person's life — a personal AI
companion tied to one calendar and one history, deeply vertical tools (a
specific industry's deal-sourcing logic), anything entangled with a specific
employer or organization. If you build one of these on top of agent-os,
`examples/verticals/` is the place to show it off as a worked example — not
core.

## How to help

- **Good first issues**: genericize one of the "planned" items above from
  scratch (there's no private version to extract from for these — they're
  open design problems, not extraction work).
- **Vertical examples**: if you've adapted the board/ledger for a specific
  field, a PR to `examples/verticals/` showing the customization (not your
  actual private data) is exactly the kind of contribution this needs.
- **Scheduler integrations**: `docs/cookbook/scheduling.md` covers the
  general pattern; a tested, copy-pasteable recipe for a specific platform
  (GitHub Actions, a specific cron-as-a-service tool, etc.) is a welcome PR.

See `CONTRIBUTING.md` before opening a PR — the sanitization checklist there
is non-negotiable for any PR touching `os/` or `docs/`.
