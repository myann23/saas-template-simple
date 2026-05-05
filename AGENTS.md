# Agent Workflow Contract

This repository uses command-style triggers. When a trigger is used, execute the matching workflow exactly and do not skip required steps.

## Global Rules

- When a trigger matches, start with one terse line: `Matched workflow: <name>.`
- Use `docs/agent-workflows/` as the portable source of truth for mirrored agent workflows.
- Use GitHub Issues as the source of truth for technical work.
- If a required command/check cannot run, stop before deploy and report the blocker.
- Keep a concise progress log in the issue scratchpad for institutional memory.

## Trigger: `/issue <number>` (or `issue <number>`, `work on issue <number>`)

Run the workflow from `docs/agent-workflows/issue.md`:

Extract `<number>` from the user request and follow the canonical workflow exactly.

## Trigger: `set up GitHub Issues for <project-name>`

Run the workflow from `docs/agent-workflows/setup-github-issues.md`.

Extract `<project-name>` from the user request and follow the canonical workflow exactly.

## Non-Matching Requests

For requests that do not match the triggers above, use normal engineering workflow and project conventions.

## Branch Strategy — project-specific, fill in per project

Choose one. Solo / pre-launch projects often prefer direct-to-main for speed; teams or post-launch projects benefit from PR gating.

**Pattern A — Direct to default branch (no PR):**

```markdown
## Branch Strategy

**Direct to <main|master>. Skip PRs.**

Solo dev, pre-launch — PRs add ceremony without payoff until production traffic exists. Each issue's final commit closes its GH issue via `closes #<N>` in the message.

Switch to PR workflow after [milestone — e.g., domain attach issue #N] when default branch = production. Until then, broken default is just a quick follow-up commit.

Exception: changes touching DNS, secrets, or the deploy pipeline open a PR so preview can be eyeballed before merge.
```

**Pattern B — PR workflow (default if no Branch Strategy declared):**

```markdown
## Branch Strategy

**Branch + PR for every issue.**

Each issue gets its own feature branch (`issue-<N>-<slug>`). Commit, push branch, open PR, wait for CI green, then merge. Use `closes #<N>` in commit or PR description to auto-close the issue on merge.

CI must pass before merge. Vercel preview URL on each PR enables eyeball verification before production.
```

If this section is missing, the `/issue` workflow defaults to Pattern B (PR workflow) as the safer choice for unknown projects.

## Required Reading (by issue label) — project-specific, fill in per project

When `/issue <N>` runs, step 2 (Research) reads the GH issue's labels and consults this table to load the right project context. The workflow delegates the reads to a research subagent (e.g., Claude Code's `Explore` agent type, or Codex CLI's planner persona) so the main session's context stays lean. The subagent returns a tight digest that gets saved to the scratchpad.

Each project should populate this table before any `/issue` runs. Map each label your project uses to the docs that should be read for that issue type.

| Label | Docs to load |
|---|---|
| `ui` | (replace) brand system doc, customer voice doc, design references |
| `api`, `infra` | (replace) architecture / spec doc |
| `content` | (replace) content strategy, customer language source |
| `seo`, `analytics` | (replace) spec sections relevant to those concerns |
| `docs`, `polish`, `setup`, `improvement` | (typically no extra reads — CLAUDE.md + issue body sufficient) |

**Always-on (read regardless of label):** `CLAUDE.md`, `AGENTS.md`, the GH issue body, the implementation plan entry matching the issue (path declared in Plan Locations below).

If this section is missing or empty, the `/issue` workflow falls back to inspecting files named in the issue body's "Files Likely Affected" field.

## Plan Locations (project-specific — fill in per project)

When syncing checkboxes after `/issue` (step 7 of `docs/agent-workflows/issue.md`), declared paths take precedence over path globs. Paths are relative to this repo's root.

Each project should populate this section before any `/issue` runs. Plans may live outside this repo — e.g., a sibling `LifeOS/` for orchestration-heavy workflows.

| Role | Path | Sync? |
|---|---|---|
| Implementation plan (Issue Index + per-issue bodies) | `docs/implementation-plan.md` (replace with actual path) | ✅ Flip checkboxes here |
| Spec / build plan | `docs/build-plan.md` (replace with actual path) | ❌ Read-only |
| Roadmap (timeline) | `docs/roadmap.md` (replace with actual path) | ❌ Read-only |

Adding a new plan? Append a row. Renaming/moving an existing plan? Update the path. The `/issue` workflow reads this section first; falls back to `docs/` glob only if Plan Locations is missing or empty.

If the implementation plan lives outside this repo (e.g., `../../LifeOS/...`), the `/issue` workflow commits the checkbox sync in that repo separately, not in this one.

## Always-On Security Rules

- Before commits, check for hardcoded secrets, missing input validation, SQL injection risk, XSS risk, CSRF gaps, auth/authz gaps, missing endpoint rate limits, and sensitive error messages.
- Store secrets in environment variables, never source code.
- Validate user input by type, length, format, and allowed values before using it.
- Use parameterized database queries; never concatenate user-controlled values into queries.
- If a critical security issue is found, stop normal work, report or fix it, rotate exposed secrets if needed, search for similar issues, and add regression tests.

Forbidden patterns:

- `eval()` with user input.
- `innerHTML` or `dangerouslySetInnerHTML` with unsanitized data.
- Plaintext password storage.
- Logging passwords, tokens, or PII.
- Disabling HTTPS in production.
- Using wildcard CORS origins in production.

## Always-On Testing Rules

- Maintain or improve test coverage for new code.
- Prefer test-first development for new features, bug fixes, refactors, critical business logic, auth, financial calculations, and security-sensitive paths.
- Test behavior rather than implementation details.
- Cover happy paths, edge cases, and error states.
- Keep tests isolated and deterministic.
- Mock external services, not internal code, unless project conventions say otherwise.
- Fix flaky tests or remove them only with explicit rationale.
- Use 100% coverage expectation for financial calculations, authentication logic, security-critical code, and core business logic.

## Mirrored Workflow Triggers

These workflows mirror Claude Code commands for Codex-friendly natural-language use:

| Trigger | Workflow |
|---|---|
| `/plan`, `plan` | `docs/agent-workflows/plan.md` |
| `/verify`, `verify`, `run checks` | `docs/agent-workflows/verify.md` |
| `/code-review`, `code review`, `review my changes` | `docs/agent-workflows/code-review.md` |
| `/tdd`, `tdd` | `docs/agent-workflows/tdd.md` |
| `/triage-issues`, `triage issues` | `docs/agent-workflows/triage-issues.md` |
| `/checkpoint`, `checkpoint` | `docs/agent-workflows/checkpoint.md` |
| `debrief`, `explain what we built` | `.agents/skills/debrief/SKILL.md` |
