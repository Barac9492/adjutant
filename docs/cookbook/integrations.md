# Connector contract

Adjutant ships Claude Code skills and workflow protocols. It does **not** ship
an email, calendar, Telegram, or scheduler runtime. A connector-dependent
skill becomes useful only after you install and test a connector that your own
Claude Code environment can use.

This boundary is deliberate: the reusable core should not silently read a
personal inbox, calendar, or chat account.

## Before enabling any connector-dependent skill

1. **Choose the connector.** Use a built-in tool, an MCP server, or a local
   adapter you already trust. Adjutant does not prescribe one.
2. **Verify the account with a read-only call.** Confirm it is the intended
   account before you schedule anything. A successful login to the wrong
   account is a failure.
3. **Run the skill manually once.** Inspect the result and verify that it
   neither sends a message nor creates an external event unexpectedly.
4. **Record the last successful run.** Only then enable its scheduler entry
   in `config/os.config.yaml`.
5. **Keep secrets local.** Put connector credentials only in a gitignored
   config file or your connector's secret store. Never put them in a skill,
   agent, screenshot, commit message, or issue.

## Supported boundaries

| Workflow | What Adjutant supplies | What you supply |
| --- | --- | --- |
| `/today`, `/briefing`, `/decide`, `/board` | Local Markdown instructions and state formats | A readable notes/decision directory |
| `email-triage`, `followups` | Classification and draft-only rules | A mail connector with read and draft capabilities |
| `meeting-prep`, `orchestrator` | Calendar-aware preparation and synthesis protocols | A calendar connector and any note/contact sources you choose |
| `briefing-morning`, `weekly-synthesis` | Output format and prioritization rules | Source connectors, a delivery method, and a scheduler |
| Telegram delivery | A channel field used by skills | A Telegram adapter. No bot transport ships in this repo. |

## Telegram

Do not turn on `channels.telegram.enabled` merely because you have a chat ID.
You need a tested Telegram adapter first. If that adapter needs a bot token,
store it locally in `config/os.config.yaml` or its own secret store, never in a
skill file. The setup wizard should not ask you to paste a token into a chat.

Run a harmless, explicit test message yourself before allowing a scheduled
skill to deliver to Telegram. If you do not have an adapter, leave the channel
disabled. The relevant skills must write to a local file or print their result
instead.

## Email and calendar

Treat email and calendar access as capability boundaries, not assumptions.

- Test the exact account first with a read-only operation.
- Keep `email-triage` draft-only. It may create a draft only after you verify
  that the connector supports in-thread drafting safely.
- Never auto-create an event with external attendees or send an invitation
  without an explicit user confirmation.
- If a connector cannot distinguish accounts, do not schedule it for work that
  could touch the wrong inbox or calendar.

## Scheduling comes last

A cron job proves only that a command fired. It does not prove that a connector
was authorized, that the right account was used, or that the result was useful.
Use the [scheduling guide](scheduling.md) only after the manual preflight above
passes. Then enable `health-check` once two or more routines are running so
silent failures are surfaced.
