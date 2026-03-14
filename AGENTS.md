# Agent Workflow Contract

This repository uses command-style triggers. When a trigger is used, execute the matching workflow exactly and do not skip required steps.

## Global Rules

- Use GitHub Issues as the source of truth for technical work.
- If a required command/check cannot run, stop before deploy and report the blocker.
- Keep a concise progress log in the issue scratchpad for institutional memory.

## Trigger: `/issue <number>` (or `issue <number>`, `work on issue <number>`)

Run the workflow from `.claude/commands/issue.md`:

1. ASSESS
- Run: `gh issue view <number>`
- Determine complexity:
  - Simple: one-file fix, typo, small bug, clear solution
  - Complex: multi-file/new feature/unclear or unfamiliar area

2. RESEARCH (complex issues only)
- Analyze likely files, existing patterns, related tests, and dependencies.
- Create scratchpad: `docs/scratchpads/issue-<number>-<slug>.md`
- Save research findings there.

3. PLAN
- Check `docs/scratchpads/` for prior related work.
- Search related PRs/issues as needed.
- Append an implementation plan to the scratchpad.

4. CREATE
- Implement in small, focused steps.
- Keep commits atomic.

5. TEST (mandatory before deploy)
- Add unit tests for new source files following project conventions.
- Run minimum verification:
```bash
npm run lint && npm run build && npm test
```
- If UI changed, perform visual verification.
- Do not proceed with failing lint/build/tests.

6. DEPLOY
- Final commit message must include: `closes #<number>`
- Push changes.

7. SYNC
- Find the plan: `docs/implementation-plan.md` first, then any `*plan*.md` or `*roadmap*.md` in `docs/` (skip scratchpads).
- Match by issue number (`#<number>` in the checkbox text) first, then by text similarity to issue title.
- If matched: flip `- [ ]` to `- [x]`, append date, commit the plan file.
- Report sync result in the scratchpad completion summary.

8. IF BLOCKED
- Comment on issue: `gh issue comment <number> -b "Blocked: <reason>"`

## Trigger: `set up GitHub Issues for <project-name>`

Create GitHub issues from the implementation plan phases/checklists.

1. Source documents
- Primary: `docs/implementation-plan.md` (if present)
- Fallback: `docs/implementation-plan-template.md`

2. Extract work items
- Parse phases and verification/acceptance checklist items.
- Split into atomic issues (single focused session per issue).
- Include: summary, user story/value, acceptance criteria, technical notes, out-of-scope, milestone.

3. Create issues
- Use templates in `.github/ISSUE_TEMPLATE/` (`feature.md`, `bug.md`, `improvement.md`).
- Add labels: type label (`feature`/`bug`/`improvement`) plus category labels when applicable.
- Assign milestone (`MVP`, `v2`, `Backlog`) based on phase intent.

4. Annotate the plan
- After creating each issue, update the source checkbox in the implementation plan to include the issue number: `- [ ] Original text (#NN)`
- This creates the two-way link that `/issue` uses for reliable plan syncing.
- Commit: `"Annotate implementation plan with issue numbers"`

5. Ensure repo setup
- If labels/milestones are missing, create them per `docs/github-issues-manual.md`.

6. Output summary
- Return created issue numbers/titles grouped by milestone and recommended execution order.

## Non-Matching Requests

For requests that do not match the triggers above, use normal engineering workflow and project conventions.
