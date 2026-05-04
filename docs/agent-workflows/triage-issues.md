# Triage Issues Workflow

Use when the user says `/triage-issues`, `triage issues`, or asks what GitHub issues to tackle next.

Start with:

```text
Matched workflow: triage issues.
```

Run:

```powershell
gh issue list --state open --limit 50
```

For each issue, assess:

- Clarity of acceptance criteria.
- Priority.
- Milestone.
- Labels.
- Dependencies.
- Expected effort.

Suggest a prioritized execution order and identify issues needing clarification before implementation.
