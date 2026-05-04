# Code Review Workflow

Use when the user says `/code-review`, `code review`, `review my changes`, or asks for a security/quality review.

Start with:

```text
Matched workflow: code review.
```

Review changed files first:

```powershell
git diff --name-only HEAD
git diff
```

Prioritize findings over summary. Order by severity:

1. Critical security or data-loss bugs.
2. High-confidence behavioral regressions.
3. Missing tests for risky changes.
4. Performance, maintainability, and accessibility issues.

Check for:

- Hardcoded secrets.
- Injection risks.
- XSS and unsafe HTML.
- Missing input validation.
- Authentication or authorization gaps.
- Path traversal.
- CSRF risks.
- Large functions/files.
- Debug statements.
- Missing tests.

If there are no findings, say so clearly and mention residual risk or test gaps.
