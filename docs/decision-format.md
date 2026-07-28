# Decision Ledger file format

One file per decision in `{config.decisions.ledger_path}`, named
`<kebab-case-id>.md`.

## Frontmatter (machine-read — keep keys exact)

```yaml
---
id: example-decision           # synthetic placeholder — not a real tracked decision
title: "On [the decision, in a few words]"
status: open              # open | decided | deferred
category: career          # free text — career, financial, strategic, personal...
deadline: 2099-12-31       # ISO date; must have a stated basis (see below) — this
                            # placeholder is deliberately far-future so it reads
                            # as an example, not a live deadline (see the
                            # demo-asset rule in docs/ARCHITECTURE.md)
deadline_basis: "External application window closes"
lean: "leaning toward option A unless condition B is met"
review_count: 0
last_reviewed: null        # ISO date, set on first review
---
```

## Body sections

```markdown
## What's being decided
One paragraph. Concrete, not a mood.

## Options
- **Option A**: ...
- **Option B**: ...

## What Would Change My Mind
A short, checkable list — the /decide review gate checks THIS list against
reality every time, so make each item something that can actually be
observed as having happened or not. "I feel more confident" is not checkable.
"Company X makes a formal offer above $Y" is.

## Decision Log
Append-only. Never edit or delete a past entry — this is the record of how
the decision moved (or didn't) over time.

- **YYYY-MM-DD**: [what happened / what was decided / what was reviewed]
```

## Board minutes format (`{config.decisions.board_minutes_path}/<date>.md`)

```yaml
---
date: YYYY-MM-DD
session: 1
decisions_discussed: [example-decision]
---

## Veteran
[challenge / what changed / demand]

## Pragmatist
[challenge / what changed / demand]

## Operator
[challenge / what changed / demand]

## Consensus
[where the three seats agreed]

## Sharpest unresolved challenge
[the one nobody answered]

## Action
[ONE action] — owner: [name] — due: [date]
```

Board seat memory files
(`{config.decisions.board_minutes_path}/_memory/<seat>.md`) use plain
markdown with two headings: `## Session Log` (append-only, dated entries) and
`## Demands outstanding` (a live list — add on issue, remove on met/conceded).
