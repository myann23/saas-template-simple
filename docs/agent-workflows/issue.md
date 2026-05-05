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

For complex issues:

1. Read the GH issue's labels.
2. Consult `AGENTS.md` → "Required Reading (by issue label)" table for the docs that match those labels. Always include the always-on docs (CLAUDE.md, AGENTS.md, issue body, matching impl plan entry).
3. **Delegate the reads to a research subagent** to keep the main session context lean. In Claude Code, use the `Explore` agent type. In Codex CLI, spawn a research helper or use a planner persona. Subagent prompt template:

   > "Read these docs: [paths from Required Reading]. Then map the files likely affected by GH issue #<N> in this repo. Return a tight digest under 500 words covering: (1) file paths likely to change, (2) existing patterns to reuse, (3) dependencies on other issues, (4) prior art in `docs/scratchpads/`, (5) gotchas. Cite specific files/lines for non-obvious points."

4. Save the subagent's digest to `docs/scratchpads/issue-<number>-<slug>.md` as the **Research** section.

For simple issues (one-file fixes, typos), the main agent can do the reads inline without a subagent — but always reference `AGENTS.md` Required Reading first to avoid missing project-specific context.

If `AGENTS.md` has no Required Reading section, fall back to inspecting likely files based on the issue body's "Files Likely Affected" field.

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
