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
