# Wiring up the scheduler

Adjutant ships the *what* (skills, agents, config) but not the *when*. You
need something to fire each enabled skill on its `schedule` (a standard cron
expression in `config/os.config.yaml`).

> **Preflight first.** Only schedule a skill after you have run it manually
> with its real data source and inspected a safe result. A cron job is not a
> connector. Read the [integration guide](integrations.md) before enabling
> email, calendar, or Telegram-dependent routines.

Pick whichever scheduler matches your setup:

## Option A: Claude Code scheduled tasks

Some Claude Code environments expose native scheduled or cron task creation.
If yours does, create one task per enabled agent in your config, pointing it at
the corresponding skill invocation, such as `/briefing-morning`. Check your
environment's own documentation for the exact mechanism; it changes quickly
and this repository deliberately does not hardcode one platform's UI.

## Option B: system cron and the Claude Code CLI

If you can invoke Claude Code non-interactively from your shell, a plain
crontab entry works:

```bash
# crontab -e
0 7 * * * cd /path/to/your/adjutant-installed-project && claude -p "/briefing-morning" >> ~/adjutant.log 2>&1
```

Match the minute and hour to each skill's `schedule` field. This is portable,
but it is only safe after you have completed the manual preflight and verified
that the CLI has the right project context and connector permissions.

## Option C: a task runner you already use

If you already run GitHub Actions, a home server with systemd timers, or a
similar runner, use the same pattern: invoke Claude Code non-interactively
against this repository on the configured schedule.

## Whichever you pick

- Start with `decision_ledger_review` if you configured a ledger. Add
  `briefing_morning` only after its sources and delivery path pass manual
  preflight, then confirm it fires reliably for a week before enabling more.
- Do not enable a connector-dependent skill until its manual run has verified
  the correct account and safe behavior.
- `health-check` is meant to catch silent failures. Enable it once two or more
  scheduled agents are actually running.
- A scheduler that silently stops firing is worse than no automation because
  it makes stale output look current. Keep a timestamped run log that
  `health-check` can inspect.
