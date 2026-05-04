---
name: debrief
description: Explain recent build work or the overall architecture in plain language. Use when Mike says "debrief", "teach me what we built", "explain what happened", "give me the big picture", or asks for a learning-focused recap of recent code changes or a project structure.
---

# Debrief

Explain what was built, why it was built that way, and what Mike should remember.

## Detect Scope

Check recent context first:

```powershell
git diff --stat HEAD~3
git log --oneline -5
git status --short
```

If there are meaningful recent commits or uncommitted changes, focus on recent work. If not, give a system overview.

If unclear, ask whether to debrief recent changes or the big picture.

## Gather Context

For recent changes:

- Inspect changed files.
- Identify new dependencies, patterns, and data flow.
- Note bugs fixed and verification performed.

For big-picture debriefs:

- Read project entry points and package/config files.
- Map core components and how data moves through them.
- Identify key technology choices.

## Output

Use concise, plain language. Explain why decisions matter, not just what files changed.

For a quick debrief, include:

- What changed.
- How it works.
- Key decisions.
- Watch-outs.

For a deep debrief, add:

- Architecture overview.
- Data flow.
- Code highlights.
- Tradeoffs.
- Pitfalls to avoid.

If saving a debrief is requested, write it under:

```text
C:\Users\myann\OneDrive\Desktop\LifeOS\advisors\learning-coach\ai-engineering\debriefs\
```

Name files as:

```text
YYYY-MM-DD_short-description.md
```
