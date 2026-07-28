# Sanitization checklist (for maintainers)

Run before every merge to `main`, and wire into CI as a blocking check:

```bash
grep -rniE \
  "@[a-zA-Z0-9.-]+\.(com|net|org|io|kr)|telegram.*chat_id.*[0-9]{6,}" \
  --include="*.md" --include="*.yaml" --include="*.sh" .
```

Plus a project-specific name/company/org sweep list — keep one in this file,
updated whenever a contributor's PR reveals a new category worth blocking
(a real name, a real employer, a real token format). This file is meant to
grow; a static checklist from launch day will miss whatever leaks next.

Any match is a blocking failure, not a warning — false positives are cheap to
dismiss in review; a leaked identifier in a public repo is not reversible by
force-pushing over it (assume it's cached/forked the moment it's pushed).

## Images and other binary assets are NOT covered by the grep above

`docs/assets/*.gif`, `*.png`, and anything else binary is invisible to a
text-only grep sweep — a screenshot or demo GIF can bake in a real name, a
real client, a real number, or a real conversation with nothing in the diff
to catch it. This is a real gap, found the hard way (a first attempt at a
demo screenshot for this repo read as too specific — a named client, a
detail that could pass for real business context — despite being entirely
invented). For any new image asset:

- Prefer generating its content from a script or a checked-in `.txt`/`.md`
  source file (so the text itself IS greppable) over hand-typing content
  directly into a screenshot tool.
- Before committing, read the actual rendered content yourself — extract
  GIF frames (`ffmpeg -i file.gif -vf "select='not(mod(n\,N))'" -vsync 0
  out_%03d.png`) and view them; don't stop at confirming the file is a valid
  image.
- Deliberately keep any names/numbers/details in demo content generic enough
  that a stranger's first reaction isn't "wait, is this real?" — that
  reaction is the failure mode, independent of whether the content is
  technically fictional.
