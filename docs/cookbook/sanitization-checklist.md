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
