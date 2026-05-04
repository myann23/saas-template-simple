# Checkpoint Workflow

Use when the user says `/checkpoint`, `create checkpoint`, `verify checkpoint`, or asks to snapshot workflow state.

Start with:

```text
Matched workflow: checkpoint.
```

Supported actions:

- `create <name>`: run quick verification if available, record current git SHA, and log the checkpoint.
- `verify <name>`: compare current state against the recorded checkpoint.
- `list`: show known checkpoints.
- `clear`: remove old checkpoints, keeping the latest five.

Store checkpoint metadata in `.claude/checkpoints.log` unless a neutral `docs/` or `.agent/` checkpoint file already exists.

Do not use destructive rollback commands unless the user explicitly requests them.
