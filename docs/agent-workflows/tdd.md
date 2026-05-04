# TDD Workflow

Use when the user says `/tdd`, asks for test-driven development, or requests a bug fix with a reproducing test.

Start with:

```text
Matched workflow: tdd.
```

Follow RED, GREEN, REFACTOR:

1. Define the expected behavior.
2. Write or update a failing test.
3. Run the targeted test and confirm it fails for the expected reason.
4. Implement the smallest change that passes.
5. Run the targeted test again.
6. Refactor only with tests green.
7. Run broader verification before completion.

Prefer behavior tests over implementation-detail tests. Include edge cases and error states when they affect product behavior.
