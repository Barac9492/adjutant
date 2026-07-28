---
name: briefing-morning
description: Send one short, conversational daily briefing — not a dashboard — picking the handful of things that actually matter today.
user-invocable: true
---

# Morning Briefing

The design goal: one message, read in 30 seconds, that feels like a person who
already read everything telling you what matters today — not a system dump.

Reads config from `{config.identity.name}`, `{config.identity.language}`,
`{config.channels.telegram.chat_id}`, and whatever other skills you run
(`followups`, `email-triage`, etc.) for their surfaced items.

## Protocol

### 1. Gather (read, don't editorialize yet)
Pull together, from whatever sources you maintain:
- Today's and tomorrow's calendar
- Anything overdue or due today (from `followups`, if you run it)
- Anything queued for delivery from other skills you run
- Any pending items awaiting your approval
- Recent context — what you did/published/decided in the last day or two, so
  the brief can reference it instead of ignoring it

### 2. Synthesize — pick exactly 3
1. **The one thing that needs action today** (meeting, deadline, follow-up)
2. **The one thing from yesterday that needs closure** (a reply, a draft, a
   decision)
3. **The one thing that's interesting** (a signal, a discovery, a connection worth mentioning)

If nothing fits #3, skip it — two items is fine. If everything is urgent, lead
with the single most urgent thing and mention the rest in one line, don't list
them all.

### 3. Compose — like a person, not a report
Rules:
- Write in `{config.identity.language}`, casual register if that's your norm.
- No emoji section headers, no bullet dashboards, no "Good morning" boilerplate.
- Weave data into sentences — don't list it.
- End with a question or an invitation, not a summary.
- Cap it — 6 lines is a good target.

**Good**: "Two meetings today — coffee with X, then the weekly. Still haven't
sent that follow-up from yesterday, I drafted it — want me to send?"

**Bad**: a briefing with section headers, emoji bullets, and a wall of items.

**Good on a quiet day**: "Nothing on the calendar today. Good day to get
something written."

### 4. Optional mood/energy adaptation
If you track your own energy/mood state elsewhere, use it to calibrate: a
flow-state day might get one line or nothing; a heavy day might get a
shortened, decisive 2-item version; a day you've marked "don't disturb" should
get no brief at all. This is optional — only wire it up if you already have a
signal to read.

### 5. Deliver
Send as ONE message via `{config.channels.telegram.chat_id}`. Not a thread,
not multiple messages. Log what was sent so tomorrow's brief can reference it.

## Rules
- Never fabricate an "interesting" item — if there's nothing genuinely
  noteworthy, drop item 3.
- Don't repeat the same reminder verbatim two days running — vary the framing
  or drop it if it's already been said.
