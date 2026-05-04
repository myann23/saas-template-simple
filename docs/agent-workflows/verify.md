# Verification Workflow

Use when the user says `/verify`, `verify`, `run checks`, or asks whether the repo is ready to commit or PR.

Start with:

```text
Matched workflow: verify.
```

Run checks sequentially and stop on the first hard failure unless the user asks for a full failure inventory.

Default checks:

```powershell
npm run build
npx tsc --noEmit
npm run lint
npm test
```

Adapt to the repository's package manager and scripts. If no package manifest or scripts exist, report that verification is blocked rather than inventing commands.

Also check:

- Uncommitted changes.
- Debug statements in source files.
- Test coverage when the project supports it.

Summarize pass/fail status and the next fix.
