# Codex Port Report

Date: 2026-05-04

## Summary

This repository is a SaaS project harness, not an app runtime. The port keeps Claude Code compatibility while making workflows and skills reachable from Codex.

## Architecture Decision

Canonical content now lives in neutral, repo-local docs:

- Workflows: `docs/agent-workflows/`
- Agent prompts: `docs/agents/`
- Codex skill shims: `.agents/skills/`
- Codex agent metadata: `.codex/agents/`

Claude-specific files are thin wrappers that point to the canonical sources. This avoids workflow drift between Claude Code and Codex.

## Ported Commands

The following Claude Code commands were mirrored as canonical workflows and Codex skill shims:

- `issue`
- `setup-github-issues`
- `plan`
- `verify`
- `code-review`
- `tdd`
- `triage-issues`
- `checkpoint`

Canonical files:

- `docs/agent-workflows/issue.md`
- `docs/agent-workflows/setup-github-issues.md`
- `docs/agent-workflows/plan.md`
- `docs/agent-workflows/verify.md`
- `docs/agent-workflows/code-review.md`
- `docs/agent-workflows/tdd.md`
- `docs/agent-workflows/triage-issues.md`
- `docs/agent-workflows/checkpoint.md`

Skill shims:

- `.agents/skills/issue/SKILL.md`
- `.agents/skills/setup-github-issues/SKILL.md`
- `.agents/skills/plan/SKILL.md`
- `.agents/skills/verify/SKILL.md`
- `.agents/skills/code-review/SKILL.md`
- `.agents/skills/tdd/SKILL.md`
- `.agents/skills/triage-issues/SKILL.md`
- `.agents/skills/checkpoint/SKILL.md`

## Ported Skill

The Claude debrief skill was mirrored to:

- `.agents/skills/debrief/SKILL.md`

The Claude skill now points to that canonical file:

- `.claude/skills/debrief/skill.md`

## Ported Agents

The following Claude agents were extracted to canonical prompts:

- `docs/agents/planner.md`
- `docs/agents/code-reviewer.md`
- `docs/agents/security-reviewer.md`

Codex metadata pointers were added:

- `.codex/agents/planner.toml`
- `.codex/agents/code-reviewer.toml`
- `.codex/agents/security-reviewer.toml`

Claude agent files now point to the canonical prompts:

- `.claude/agents/planner.md`
- `.claude/agents/code-reviewer.md`
- `.claude/agents/security-reviewer.md`

## Ported Rules

The security and testing rules from `.claude/rules/` are now reachable by Codex through `AGENTS.md`:

- `Always-On Security Rules`
- `Always-On Testing Rules`

## Invocation Confirmation

`AGENTS.md` now requires matched workflows to begin with:

```text
Matched workflow: <name>.
```

Each workflow and skill shim repeats the expected confirmation line.

## Verification Performed

- Validated every repo-local `.agents/skills/*/SKILL.md` with Codex skill validation.
- Checked that canonical workflow, agent, skill, and wrapper files exist.
- Checked git status before staging.
- Ran `codex debug prompt-input 'issue 12'` and confirmed the repo `AGENTS.md` instructions and local workflow skills are model-visible.
- Ran `codex debug prompt-input '$plan create an implementation plan'` and confirmed the `plan` skill shim is model-visible.
- Ran `codex debug prompt-input '$verify'` and confirmed the `verify` skill shim is model-visible.
- Ran `git diff --check`; no whitespace errors were reported.

## Known Limits

- This repository has no `package.json`, so app-level commands such as `npm run lint`, `npm run build`, and `npm test` are not runnable yet.
- `.codex/agents/*.toml` is a portable metadata layer for the harness. Codex skill discovery is handled through `.agents/skills/*/SKILL.md` and `AGENTS.md`.
