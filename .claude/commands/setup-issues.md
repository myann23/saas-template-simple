# Setup GitHub Issues for a Project

Set up issue-based development for repo: $ARGUMENTS

## Usage

```
/setup-issues <owner/repo>                    # Scaffolding only
/setup-issues <owner/repo> --from-plan <path> # Scaffolding + create issues from a plan file
```

Examples:
```
/setup-issues myann23/new-project-name
/setup-issues myann23/new-project-name --from-plan docs/implementation-plan.md
```

## What This Does

1. Creates type labels (feature, bug, improvement, blocked)
2. Creates milestone labels (mvp, v2)
3. Creates category labels (ui, api, auth, db, infra, docs)
4. Creates milestones (MVP, v2, Backlog)
5. Creates issue templates (feature, bug, improvement)
6. Creates `docs/scratchpads/` and `docs/implementation-plan.md` if missing
7. **If `--from-plan` is passed:** parses the plan and creates one issue per task
8. Verifies setup at the end

All `gh` calls are idempotent — re-running is safe (`|| true` masks "already exists" errors).

## Process

### 1. Create Labels (idempotent)

```bash
# Type labels
gh label create feature     --color 0E8A16 --description "New functionality"               --repo $ARGUMENTS || true
gh label create bug         --color D73A4A --description "Something isn't working"          --repo $ARGUMENTS || true
gh label create improvement --color A2EEEF --description "Enhancement to existing feature"  --repo $ARGUMENTS || true
gh label create blocked     --color B60205 --description "Waiting on external dependency"   --repo $ARGUMENTS || true

# Milestone labels
gh label create mvp         --color FBCA04 --description "MVP milestone"                    --repo $ARGUMENTS || true
gh label create v2          --color C5DEF5 --description "Version 2 milestone"              --repo $ARGUMENTS || true

# Category labels (delete any that don't apply to this project)
gh label create ui          --color BFD4F2 --description "User interface"                   --repo $ARGUMENTS || true
gh label create api         --color 5319E7 --description "API / backend endpoints"          --repo $ARGUMENTS || true
gh label create auth        --color D4C5F9 --description "Authentication / authorization"   --repo $ARGUMENTS || true
gh label create db          --color 0052CC --description "Database / schema"                --repo $ARGUMENTS || true
gh label create infra       --color 333333 --description "Infrastructure / deployment"      --repo $ARGUMENTS || true
gh label create docs        --color 0075CA --description "Documentation"                    --repo $ARGUMENTS || true
```

### 2. Create Milestones (idempotent)

```bash
gh api repos/$ARGUMENTS/milestones -f title="MVP"     -f state="open" -f description="Minimum viable product" 2>/dev/null || true
gh api repos/$ARGUMENTS/milestones -f title="v2"      -f state="open" -f description="Version 2 features"     2>/dev/null || true
gh api repos/$ARGUMENTS/milestones -f title="Backlog" -f state="open" -f description="Future considerations"  2>/dev/null || true
```

### 3. Create Issue Templates (committed via API)

Create `.github/ISSUE_TEMPLATE/feature.md`, `bug.md`, `improvement.md` using `gh api repos/$ARGUMENTS/contents/...` with base64-encoded body. If the file already exists, the API returns 422 — wrap each call with `|| true`.

Templates use frontmatter to auto-apply labels:

**feature.md** (label: `feature`):
```
## Summary
[One-line description]

## User Story
As a [user type], I want [goal] so that [benefit].

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Technical Notes
[Optional: API endpoints, components affected, etc.]

## Milestone
[MVP / v2 / Backlog]
```

**bug.md** (label: `bug`):
```
## Description
[What's broken]

## Steps to Reproduce
1.
2.

## Expected vs Actual
- Expected:
- Actual:

## Environment
[Browser, OS, device, etc.]
```

**improvement.md** (label: `improvement`):
```
## Current Behavior
[How it works now]

## Proposed Improvement
[How it should work]

## Why
[User benefit or technical reason]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
```

### 4. Create Local Doc Scaffolding

These files anchor the `/issue` and `/plan` workflows. Skip files that already exist.

```bash
mkdir -p docs/scratchpads

# README in scratchpads (only if missing)
[ -f docs/scratchpads/README.md ] || cat > docs/scratchpads/README.md <<'EOF'
# Scratchpads

Planning artifacts for GitHub issues. Naming: `issue-{number}-{slug}.md`.

These create institutional memory — search here for prior art on similar problems before starting new work.
EOF

# Implementation plan starter (only if missing — never overwrite a real plan)
[ -f docs/implementation-plan.md ] || cat > docs/implementation-plan.md <<'EOF'
# Implementation Plan

> Each task below is a **spec**, not a wishlist. The richer the spec, the more autonomously it can be delegated (e.g., to Codex). Vague tasks force iterative dialogue with Claude Code; sharp tasks can run end-to-end.
>
> Required per task: title (`- [ ] ...`). Optional but high-leverage: acceptance criteria, out-of-scope, files affected, verification.

## Phase 1: Foundation

- [ ] Task title here
  - **Acceptance criteria** (testable):
    - [ ] Criterion 1
    - [ ] Criterion 2
  - **Out of scope:** what NOT to touch
  - **Files affected:** `path/to/file.ts`, `path/to/other.tsx` (if known)
  - **Verification:** how to confirm done — `npm test`, manual UI check, etc.

- [ ] Second task title

## Phase 2: Core Features

- [ ] Task title

## Phase 3: Polish

- [ ] Task title
EOF
```

### 5. (Optional) Create Issues from Plan — `--from-plan <path>`

When `--from-plan <path>` is passed, parse the plan and create one issue per unchecked task.

**Plan format assumed:**
- `## Phase N: <Phase Name>` headings define phases
- `- [ ] <task title>` lines under each phase become issues
- Already-checked `- [x]` tasks are skipped (already done)
- Each top-level task may carry **nested spec fields** as indented bullets — extract them when present:
  - `**Acceptance criteria** (testable):` → followed by `- [ ]` lines (preserve as-is in issue body)
  - `**Out of scope:** ...` → single-line text
  - `**Files affected:** ...` → comma-separated paths
  - `**Verification:** ...` → single-line text

**Phase → milestone mapping:**
- Phase 1 → MVP
- Phase 2 → MVP (unless plan has 4+ phases, then → v2)
- Phase 3+ → v2 (last phase → Backlog)
- Override: if a phase heading contains "(MVP)", "(v2)", or "(Backlog)", use that explicit tag

**For each task, Claude should:**
1. **Infer type label** from task wording: `feature` (default), `bug` (mentions "fix", "broken"), `improvement` (mentions "refactor", "improve", "polish"), `docs` (mentions "document", "README")
2. **Infer category labels** — first from explicit `Files affected` paths if present, then fall back to keyword matching:
   - `components/`, `app/(?!api)`, `.tsx` → `ui`
   - `app/api/`, `routes/`, `server/` → `api`
   - `auth`, `session`, `login` → `auth`
   - `schema.`, `migrations/`, `prisma/`, `db/` → `db`
   - `vercel.`, `Dockerfile`, `.github/workflows/`, `infra/` → `infra`
   - `README`, `docs/`, `.md` → `docs`
   - Apply 0-2 categories, not all of them
3. **Build the issue body** using whatever spec fields the plan provided:
   ```
   From implementation plan: <PLAN_PATH>
   Phase: <phase name>

   ## Acceptance Criteria
   <copy verbatim from plan if present, else leave: "- [ ] (define before implementing)">

   ## Out of Scope
   <copy from plan if present, else omit section>

   ## Files Affected
   <copy from plan if present, else omit section>

   ## Verification
   <copy from plan if present, else: "Run lint + build. Add tests if applicable.">
   ```
4. **Create the issue** with type + category labels and milestone:
   ```bash
   gh issue create \
     --repo $ARGUMENTS \
     --title "<task title>" \
     --label "<type>[,<category1>][,<category2>]" \
     --milestone "<milestone>" \
     --body "<assembled body>"
   ```
5. **Print the issue number and title** as it's created
6. **Cross-link plan ↔ issues** — after all issues are created, edit the plan file in place: append `(#42)` to each task title so `- [ ] Task title here` becomes `- [ ] Task title here (#42)`. This keeps the plan and the issue tracker in sync.

**Spec-quality observation:** As you parse, count tasks that have full spec fields (acceptance criteria + out-of-scope + verification) vs. tasks that are title-only. Report the ratio at the end. A plan that's mostly title-only is a signal to iterate further in Claude Code before delegating execution.

**Idempotency for plan ingestion:** before creating an issue, check `gh issue list --search "<task title>" --state all` — if a matching open or closed issue exists, skip with a note.

### 6. Verify Setup

After all the above, run and print the results:

```bash
echo "=== Labels ==="
gh label list --repo $ARGUMENTS

echo "=== Milestones ==="
gh api repos/$ARGUMENTS/milestones --jq '.[] | "\(.title): \(.description)"'

echo "=== Issue Templates ==="
gh api repos/$ARGUMENTS/contents/.github/ISSUE_TEMPLATE --jq '.[].name'

echo "=== Local docs ==="
ls -la docs/scratchpads/ docs/implementation-plan.md 2>/dev/null

# If --from-plan was used:
echo "=== Issues created ==="
gh issue list --repo $ARGUMENTS --limit 50
```

Confirm to the user: counts of labels, milestones, templates, and (if applicable) issues created.

## Notes for Claude Code

- Run sections 1-4 always. Run section 5 only if `--from-plan <path>` is in the args.
- Always run section 6 at the end and surface the output to the user.
- If any step fails for a non-existence reason (auth, network, permissions), stop and report — don't continue silently.
- The category labels (`ui`, `api`, `auth`, `db`, `infra`, `docs`) are sensible defaults. After setup, ask the user if any should be removed for this project.
