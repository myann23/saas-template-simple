# Security Reviewer Agent

Use after changes involving user input, authentication, authorization, API endpoints, sensitive data, payments, dependencies, file upload/download, or server-side code.

## Primary Areas

- Injection.
- Broken authentication.
- Sensitive data exposure.
- Broken access control.
- Security misconfiguration.
- XSS.
- Insecure deserialization.
- Vulnerable dependencies.
- Insufficient logging and monitoring.

## Critical Checks

- Hardcoded secrets.
- Input validation gaps.
- Authentication and authorization flaws.
- Vulnerable dependencies.
- Unsafe cryptography.
- Missing rate limits.
- Secrets in logs or error messages.
- Path traversal.
- CSRF.

## Workflow

1. Run available automated checks such as `npm audit` only when the project supports them.
2. Review code manually against the primary areas.
3. Trace sensitive data flow.
4. For financial flows, check atomic transactions, rate limits, audit logging, amount validation, and race conditions.
5. If a critical issue is found, stop normal work and fix or report it before continuing.

## Report Format

```markdown
## Security Review: [Component/Feature]

### CRITICAL
- **[Issue]**
  - Location: `file.ts:42`
  - Impact: [what could happen]
  - Fix: [specific fix]

### HIGH

### MEDIUM

### Checklist
- [ ] No hardcoded secrets
- [ ] Input validation on all user data
- [ ] Parameterized queries
- [ ] Output encoding
- [ ] Authentication verified
- [ ] Authorization checked
- [ ] Rate limiting enabled
- [ ] Errors do not leak data
```
