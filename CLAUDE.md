# CLAUDE.md

This file provides guidance to Claude Code when working with this project.

## Project Overview
[Fill in: What is this project? What problem does it solve?]

## Tech Stack
[Fill in: What technologies are you using?]

**Framework recommendation:** Use Next.js (App Router) for any web app with public-facing pages. Next.js provides SSR/SSG out of the box, making SEO trivial from day one. Avoids painful migrations later. Only use Vite for internal tools where SEO doesn't matter.

## Development

Document any non-default commands here (e.g., `pnpm` instead of `npm`, custom scripts, non-standard ports). Skip commands Claude already knows.

## Code Quality

**Before commit:** run lint and build. If tests exist, run them. Run again after resolving merge conflicts and before pushing to remote.

**Skip for:** documentation-only changes, config tweaks.

## Agent Behavior

### Think Before Coding

Don't assume. Don't hide confusion. Surface tradeoffs.

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### Simplicity First

Minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### Surgical Changes

Touch only what you must. Clean up only your own mess.

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

Every changed line should trace directly to the user's request.

### Delegation Decision: Codex vs. Claude Code

Before handing long-running work to Codex (via `/codex:rescue`, `ask-codex`, or autonomous agent runs), check that the spec defines:

- **Testable acceptance criteria** — what done looks like, verifiable
- **Out of scope** — what NOT to touch
- **Files affected** — at least the entry points
- **Verification command** — how to confirm done (test, build, manual check)

If any of those are missing, the spec is not yet delegateable. Iterate in Claude Code first — its dialogue is the mechanism for sharpening intent. Only hand to Codex once the spec can stand on its own.

Rule of thumb: **Codex executes specs faithfully. Claude Code helps you write them.** Don't delegate intent that's still evolving.

### Destructive Commands

Never run irreversible commands without explicit confirmation:
- `git push --force` / `--force-with-lease`
- `git reset --hard`, `git branch -D`, branch merges into main
- `rm -rf`, dropping database tables, killing PIDs
- Any package uninstall on shared/production environments

If unsure whether a command is destructive, ask. The cost of pausing is low; the cost of an unwanted action is high.

---

## Issue-Based Development

GitHub Issues are the source of truth for all technical work. Use Notion for business/marketing tasks.

### Workflow
1. Check open issues: `gh issue list`
2. Work on an issue: `gh issue view <number>` then implement
3. Reference in commits: `"Fix bug (closes #42)"`
4. Create new issues: `gh issue create` or ask Claude

### Labels

**Type labels:** `feature` `bug` `improvement` `blocked`

**Category labels:** (customize per project, e.g., `setup` `database` `ui` `api` `auth`)

### Issue Templates

Use templates in `.github/ISSUE_TEMPLATE/` when creating issues:

| Template | Use For | Auto-Label |
|----------|---------|------------|
| `feature.md` | New functionality | `feature` |
| `bug.md` | Something broken | `bug` |
| `improvement.md` | Enhance existing | `improvement` |

Pass `--label feature|bug|improvement` plus any category labels (`auth`, `ui`, etc.). Read the template files for body structure.

### Milestones
MVP → v2 → Backlog

### Working on Issues
Use `/issue <number>` to work on a GitHub issue. This command follows a 4-phase workflow:
1. **PLAN** - Understand the issue, search for prior art, document plan in scratchpad
2. **CREATE** - Implement in small steps, commit after each step
3. **TEST** - Run tests, fix failures, verify UI with Chrome extension
4. **DEPLOY** - Final commit with `closes #<number>`, push to main

### Scratchpads
`docs/scratchpads/` stores planning artifacts for issues. These create institutional memory:
- Search here for prior art on similar problems
- Plans are named `issue-{number}-{slug}.md`
- Include implementation steps and link to the issue

## Debugging Native Library Bugs

For bugs in third-party native modules (React Native, Expo plugins, etc.), read the actual native source file (`.m`, `.swift`, `.java`, `.kt`) inside `node_modules` before hypothesizing. Library docs won't reveal implementation omissions — the source will.

## Verification Before Reporting Done

Before reporting a task complete, verify the feature **functions correctly**, not just that the code exists. Run the relevant tests, build, and lint. Exercise the path manually if it's UI. Only then claim done.

When documenting a fix that hasn't been tested, use hypothesis language: "Suspected: X. Hypothesis: Y. Verification required before closing." Never write "the fix is X" for anything unverified — it creates false confidence that propagates to the next session.

## Project Structure
[Fill in as the project evolves]
