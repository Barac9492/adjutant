---
name: email-triage
description: Scan inbox, classify messages by urgency (URGENT/MEETING/IMPORTANT/FYI/NOISE), and surface what needs attention. Never sends email — draft-only, classify-and-surface.
user-invocable: true
---

# Email Triage

Scans unread mail, classifies it, and produces a short briefing of what needs a
response. This skill is **classify-and-surface only** — see the hard rule below.

Reads config from `{config.identity.*}`, `{config.channels.telegram.chat_id}`,
`{config.channels.email.draft_only}`. If `channels.email.enabled` is false, skip
mail entirely and say so.

## NEVER sends email

This skill only ever reads mail and, at most, creates a **draft** in the mail
client. It never calls a send action, under any condition — not for "urgent"
items, not for routine replies, not on user request mid-run. If the user wants
something sent, that is a separate, explicit action they take themselves (or a
different, clearly-labeled skill with its own send confirmation). `draft_only`
in config is not a toggle this skill can override.

## Execution steps

### 1. Load context
Read whatever contact/relationship notes and prior-thread state you maintain
(e.g. a `contacts.md` / `important-threads.md` under your notes store) plus
the timestamp of the last run, so you only scan what's new.

### 2. Scan
Search for unread/important messages since the last run (or a sensible lookback
window, e.g. 8 hours, on first run). Cross-check today's calendar — messages
from people you're meeting with today rank higher.

### 3. Classify
For each message:

| Priority | Criteria | Action |
|---|---|---|
| **URGENT** | Time-sensitive, response needed within hours. Deal-critical, deadline language, meeting changes. | Read full thread, draft a response. |
| **MEETING REQUEST** | Someone asking to schedule time. | Hand off to a scheduling flow — check calendar, propose slots. |
| **IMPORTANT** | Response needed within 1-2 days. Direct questions, key-contact threads. | Read full thread, note the action needed. |
| **FYI** | Informational, no response needed. | One-line summary only. |
| **NOISE** | Automated, promotional. | Skip entirely. |

Signal words are domain-specific — replace with `[your own urgent-signal
keywords, e.g. "ASAP", "today", deadline language in your working languages]`.
If a fund/company/client-specific classification layer (deal flow, investor
signals, etc.) matters to you, add it here as your own rule, not a hardcoded
example.

If unsure, default to IMPORTANT — err toward surfacing, not hiding.

### 4. Draft (never send)
For URGENT/IMPORTANT items that clearly need a reply:
- Check for an existing draft on the thread first — don't duplicate.
- Create an in-thread draft matching your own voice/tone notes if you keep
  them, and the recipient's formality level.
- If the question needs your personal judgment, draft a holding reply
  ("reviewing, will follow up") rather than guessing the substantive answer.

### 5. Output
Produce a short briefing (under ~15 lines):
- **Urgent** — sender, subject, what's needed, deadline
- **Important** — sender, subject, action needed
- **FYI** — one-line list
- **Drafts created** — what's ready for the user to review and send themselves

Deliver via `{config.channels.telegram.chat_id}` if enabled, otherwise print
the briefing. Do not send unprompted messages for routine items — batch them
into the regular briefing; only genuinely time-critical items (respond within
~30 minutes) justify an immediate, unscheduled notification.

## Rules
- Never forward, reply to, or send mail — draft only, always.
- Use the thread ID when drafting replies so they land in-thread.
- Don't dump full message bodies into outputs — summarize.
- Note the specific action needed, not just "needs response."
- Any pipeline-style detection you bolt on (deal flow, leads, etc.) is
  informational only — it never triggers outreach without the user's
  explicit, separate approval.
