# Issue Workflow

Use when the user says `/issue <number>`, `issue <number>`, or `work on issue <number>`.

Start with one terse confirmation line:

```text
Matched workflow: issue <number>.
```

## 1. Assess

Run:

```powershell
gh issue view <number>
```

Determine complexity:

- Simple: one-file fix, typo, small bug, clear solution.
- Complex: multi-file change, new feature, unclear solution, or unfamiliar area.

## 2. Research

For complex issues, inspect likely files, existing patterns, related tests, and dependencies. Create:

```text
docs/scratchpads/issue-<number>-<slug>.md
```

Save concise research findings there. For simple issues, create the scratchpad during planning if useful.

## 3. Plan

Check `docs/scratchpads/` for related prior work. Search related PRs or issues if needed.

Append an implementation plan to the scratchpad with:

- Issue title and link.
- Complexity classification.
- Files likely affected.
- Implementation steps.
- Verification command.
- Open questions or blockers.

## 4. Create

Implement in small focused steps. Keep commits atomic if committing is part of the requested workflow.

Do not broaden scope beyond the issue. If the issue lacks testable acceptance criteria, out-of-scope boundaries, affected files, or verification, sharpen the spec before implementation.

## 5. Test

Before deploy or final completion, run the project verification command. Default:

```powershell
npm run lint
npm run build
npm test
```

If the repository has no `package.json` or the command does not exist, stop before deploy and report the blocker. If UI changed, perform visual verification.

## 6. Deploy

Only deploy/push when requested by the workflow and checks pass.

Final commit message must include:

```text
closes #<number>
```

Prefer branch and PR workflow unless the repository explicitly instructs direct pushes to `main` and the user has not objected.

## 7. Sync

Find the implementation plan in this order:

1. **`AGENTS.md` "Plan Locations" section** — read declared paths (preferred, project-specific). Sync only entries marked ✅.
2. `docs/implementation-plan.md` (fallback if AGENTS.md has no Plan Locations section).
3. Any `*plan*.md` or `*roadmap*.md` in `docs/` (fallback).
4. Skip `docs/scratchpads/`.

Plans declared in AGENTS.md may live outside the repo (e.g., `../../LifeOS/...`) — resolve relative paths from this repo's root.

Match by `#<number>` (use the GH number, or the plan-internal number if documented in AGENTS.md), then by similarity to the issue title. If matched, flip `- [ ]` to `- [x]`, append the completion date, and commit the plan update if commits are in scope. If the plan lives outside this repo, commit there separately.

Append a completion summary to the scratchpad:

- What changed.
- Verification results.
- Plan sync result.
- Gotchas or follow-up work.

## 8. Blocked

If blocked, comment on the issue:

```powershell
gh issue comment <number> -b "Blocked: <reason>"
```

Then report the blocker to the user.
