# Work on GitHub Issue

Work on GitHub issue #$ARGUMENTS

## ASSESS

1. Fetch issue details: `gh issue view $ARGUMENTS`
2. Determine complexity:
   - **Simple**: One-file fix, typo, small bug, clear solution → skip to PLAN
   - **Complex**: Multiple files, new feature, unclear approach, unfamiliar area → do RESEARCH first

## RESEARCH (complex issues only)

Use the Task tool to spawn an Explore subagent:

```
Analyze issue #$ARGUMENTS for this codebase. Find:
1. Files likely affected by this change
2. Existing patterns for similar functionality
3. Related tests and testing conventions
4. Dependencies or integrations to consider

Return a concise context summary (under 500 words).
```

Create scratchpad at `docs/scratchpads/issue-$ARGUMENTS-{slug}.md` and save research findings.

## PLAN

1. Check `docs/scratchpads/` for previous work on similar issues
2. Search PRs: `gh pr list --search "keywords"`
3. Break down into small, manageable tasks
4. Append plan to scratchpad (or create scratchpad if skipped research)

## CREATE

- Implement in small steps according to your plan
- Commit after each meaningful change
- Keep commits focused and atomic

## TEST (Mandatory)

**You MUST run these checks before DEPLOY. Do not skip.**

### 1. Write Unit Tests

Every new source file MUST have a corresponding test file. Follow existing project patterns:

- Check existing test files for mock strategies and conventions
- Test the happy path, edge cases, and error states
- Place test files adjacent to source (e.g., `__tests__/` folders) following the project's convention

### 2. Run Verification

```bash
# Minimum verification (always run)
npm run lint && npm run build && npm test
```

- All existing tests must still pass (no regressions)
- All new tests must pass
- If any check fails, fix and re-run

### 3. Visual Check (if UI changes)

- Test visually with browser tools or screenshots

Do not proceed to DEPLOY with failing tests or lint errors.

## DEPLOY

- Final commit with message: `"Description (closes #$ARGUMENTS)"`
- Push to main

## SYNC

Update the implementation plan to reflect completed work.

1. **Find the plan.** Look for `docs/implementation-plan.md`. If missing, check for any `*plan*.md` or `*roadmap*.md` in `docs/` (exclude scratchpads). If no plan file exists, note it and skip to step 4.

2. **Find the checkbox.** In the plan file, search for:
   - A checkbox line containing `#$ARGUMENTS` (exact issue number) — preferred match
   - Fallback: a `- [ ]` line whose text closely matches the issue title
   - Look within verification checklists under phase headings

3. **Update it.** If matched:
   - Flip `- [ ]` to `- [x]`
   - Append: ` *(Mon DD)*`
   - Commit: `"Update plan: mark #$ARGUMENTS complete"`

4. **Report.** Append to scratchpad completion summary (what was done, plan sync result, any gotchas):
   - "Plan synced: [checkbox text] in [Phase N] checked off"
   - OR "No matching checkbox found in [plan file] for #$ARGUMENTS"
   - OR "No implementation plan found in docs/"

## If Blocked

- Add comment: `gh issue comment $ARGUMENTS -b "Blocked: [reason]"`
- For complex work, post progress updates to the issue

---

Use `gh` CLI for all GitHub operations.
If things go off track after 2-3 corrections, `/clear` and start fresh.
