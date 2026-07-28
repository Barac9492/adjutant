---
name: health-check
description: Daily watchdog — verifies your connectors and scheduled skills are actually running, alerts you only when something is genuinely broken.
user-invocable: true
---

# Health Check

Runs once a day (e.g. 7am) and verifies the rest of the stack is healthy:
connectors are authorized, scheduled skills ran on time, state files aren't
bloating, and any local scheduler/daemon is actually alive. Silent when
healthy — this skill should never spam.

Reads config from `{config.channels.telegram.chat_id}` and
`{config.agents.*}` (each scheduled skill's expected cadence).

## Execution steps

### 1. Test connectors
For each connector you depend on (mail, calendar, notification channel,
etc.), make a trivial read call and confirm it succeeds:
- Success → mark connected. If a connector can resolve to more than one
  account, sanity-check it landed on the account you expect (e.g. don't
  silently run against a personal account when a work account was
  intended) — flag a mismatch rather than assuming it's fine.
- Failure → mark the token/connection as expired and note the fix (e.g.
  "reauthorize connector X").
- If your primary notification channel is down, note whether a fallback
  channel is configured and usable.

### 2. Check schedule staleness
For each entry in `{config.agents.*}`, compare its expected schedule against
its last recorded run. Use a generous grace window (e.g. the schedule
interval), and be aware of quiet hours — a skill scheduled only during work
hours isn't "stale" at 2am.

### 3. Check state file sizes
Scan your skills' state/memory files: flag anything past a size threshold
(e.g. 500 lines) as needing archival, and flag any "active items" list past a
count threshold (e.g. 30) as needing pruning.

### 4. Check scheduler/daemon liveness (if you run one)
If you run a local scheduler or daemon process, read its own heartbeat state
rather than inferring liveness from a log file alone — a missing recent log
row doesn't prove it crashed. Before alerting on a stale heartbeat, check
whether the gap coincides with expected system sleep (laptop lid closed,
scheduled quiet hours) — that's not a failure, don't alert on it.

### 5. Check repo sync (if your state lives in a git-tracked vault)
Check for uncommitted changes older than a day — that's a sign the sync step
of another skill silently failed.

### 6. Report
**All healthy**: write a quiet status line to your own log/state file. Do not
send a notification.

**Issues found**: send one alert via `{config.channels.telegram.chat_id}`,
grouped by severity, each line including the concrete fix:
```
System Health Alert

Critical:
- [connector X expired — reauthorize via ...]
- [skill Y missed its schedule — last run: Nh ago]

Warning:
- [state file at N lines — needs pruning]
- [N uncommitted changes — push needed]
```

## Rules
- Silent when healthy — no spam, ever.
- Only alert on actual problems, each with a concrete fix attached.
- Never conclude "the daemon crashed" from a single stale log line — check
  the heartbeat state and rule out expected sleep/quiet-hours first.
