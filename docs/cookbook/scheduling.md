# Wiring up the scheduler

adjutant ships the *what* (skills, agents, config) but not the *when*. You
need something to actually fire each enabled skill on its `schedule` (a
standard cron expression in `config/os.config.yaml`). Pick whichever matches
your setup:

## Option A — Claude Code scheduled tasks (if your Claude Code build has them)
Some Claude Code environments expose native scheduled/cron task creation.
If yours does, create one task per enabled agent in your config, pointing it
at the corresponding skill invocation (e.g. a task that runs `/briefing-morning`
daily at the configured hour). Check your environment's own docs for the
exact tool — this varies by platform and moves fast enough that a hardcoded
guide here would go stale.

## Option B — system cron + the Claude Code CLI
If you can invoke Claude Code non-interactively from your shell, a plain
crontab entry works:

```bash
# crontab -e
0 7 * * * cd /path/to/your/adjutant-installed-project && claude -p "/briefing-morning" >> ~/adjutant.log 2>&1
```

Match the minute/hour to each skill's `schedule` field in your config. This
is the most portable option and has no dependency on any particular Claude
Code feature.

## Option C — a task runner you already use
If you already run GitHub Actions, a home server with systemd timers, or
similar, wire the same pattern: invoke Claude Code non-interactively against
this repo on the configured schedule.

## Whichever you pick

- Start with just the `briefing_morning` and `decision_ledger_review` agents enabled
  (the setup wizard defaults to this). Confirm they fire reliably for a week
  before enabling more — a scheduler that silently stops firing is worse than
  no automation, because you'll trust output that stopped updating.
- The `health-check` skill (if enabled) is meant to catch exactly this: it
  checks whether each scheduled agent actually ran recently and flags
  silent failures. Enable it once you have 2+ other agents scheduled.
