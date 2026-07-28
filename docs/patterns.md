# Reusable engineering patterns

The mechanisms behind this OS, extracted so you can apply them somewhere
other than exactly where they're used here.

## The barbell: cheap-smart-cheap-fresh

Split any non-trivial task into four roles, each played by a differently
capable (and differently priced) agent: a cheap **scout** gathers raw facts,
your best model **plans** from those facts without re-reading everything
itself, a cheap-to-mid **implementer** builds to the plan, and a **fresh-
context reviewer** — someone with zero attachment to the implementation —
checks the result against the plan. State lives in files between phases, not
in a single long conversation, which is what makes each phase resumable and
each role's context genuinely fresh. See `os/CLAUDE.md` and
`os/agents/{scout,implementer,reviewer}.md`.

Why it beats one model doing everything: a model that wrote the code is
structurally bad at reviewing it — it shares the author's blind spots by
construction. Splitting scout/plan from implement from review isn't
bureaucracy, it's the only way to get an actually independent check without
hiring a second person.

## Adversarial memory: critique that compounds

A one-off "be a skeptic" prompt produces sharp critique that resets to zero
every time you ask again. Giving a critic **persistent, seat-specific
memory** — a standing record of what it already challenged and what you
promised — turns critique into a compounding pressure instead of a one-time
performance. See `os/skills/board/SKILL.md`: three seats, three separate
memory files, each seat re-raising its own unanswered demand until it's
answered or beaten on the merits.

The generalizable version: any advisory agent gets sharper if you (a) give it
a narrow, non-overlapping mandate (one seat = one concern, never all three at
once) and (b) let it read its own prior output before generating new output.

## The re-analysis lock

For decisions where you already know your failure mode is "elaborate
analysis, then no commitment," build a gate that refuses to produce fresh
analysis on request and instead forces a binary: what changed since last
time, and given that, commit or defer — no third option. See
`os/skills/decide/SKILL.md`. The insight generalizes past personal decisions:
any recurring "let's think about this again" request is a signal to check
whether you're gathering information or avoiding a commitment that's already
overdue.

## Fresh-context delivery gates

Two gates, two different fresh-context roles: `delivery-critic` reviews any
static deliverable (a doc, a list, a design) against a calibrated bar before
a user sees it; `persona-qa-player` actually operates a deployed app as a
named persona and files a friction report before the user opens the URL
themselves. Both work because they're spawned with no memory of how the
work was produced — they can only judge the artifact, not the effort behind
it.

## Config-as-the-only-seam

Every skill in this repo reads identity/paths/channels from one config file
instead of hardcoding them. The generalizable version: whenever you're about
to write a prompt or script that's "basically generic but for one detail,"
put that one detail in a config file and reference it — the alternative is a
prompt you have to rewrite by hand every time you reuse it, which in practice
means you never do.
