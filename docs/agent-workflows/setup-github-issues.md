# Setup GitHub Issues Workflow

Use when the user says `set up GitHub Issues for <project-name>` or asks to create GitHub issues from the implementation plan.

Start with one terse confirmation line:

```text
Matched workflow: setup GitHub Issues.
```

## 1. Source Documents

Use:

1. `docs/implementation-plan.md` if present.
2. `docs/implementation-plan-template.md` as fallback.

If the source is only a template with placeholders, report that the plan needs real tasks before creating issues.

## 2. Ensure Repository Metadata

Use `gh` to create missing labels and milestones. Keep commands idempotent by checking existing labels/milestones first, or by handling already-exists errors explicitly.

Required labels:

- `feature`
- `bug`
- `improvement`
- `blocked`
- `mvp`
- `v2`
- `ui`
- `api`
- `auth`
- `db`
- `infra`
- `docs`

Required milestones:

- `MVP`
- `v2`
- `Backlog`

## 3. Extract Work Items

Parse phases and unchecked checklist items from the implementation plan.

Each issue should be atomic enough for one focused session and include:

- Summary.
- User story or value.
- Acceptance criteria.
- Technical notes.
- Out of scope.
- Milestone.

Infer type label from wording:

- `bug`: fix, broken, regression, error.
- `improvement`: improve, refactor, polish.
- `feature`: default.
- `docs`: documentation-focused work.

Infer up to two category labels from files or keywords.

## 4. Create Issues

Use templates in `.github/ISSUE_TEMPLATE/` when applicable.

Before creating each issue, search existing open and closed issues by title. Skip duplicates and report the existing issue number.

Create issues with:

```powershell
gh issue create --repo <owner/repo> --title "<title>" --label "<labels>" --milestone "<milestone>" --body "<body>"
```

## 5. Annotate Plan

After creating each issue, append the issue number to the source checkbox:

```text
- [ ] Original task title (#NN)
```

Commit the plan annotation if committing is in scope:

```text
Annotate implementation plan with issue numbers
```

## 6. Verify And Report

Verify labels, milestones, templates, and created issues with `gh`.

Return:

- Created issue numbers and titles grouped by milestone.
- Skipped duplicates.
- Spec quality ratio: tasks with acceptance criteria, out-of-scope, and verification vs. title-only tasks.
- Recommended execution order.
