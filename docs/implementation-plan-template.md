# [Project Name] — Implementation Plan

## Product Intent

_These guide every trade-off Claude makes during implementation. Be specific — vague intent produces vague code._

**Target user:** [Who exactly? Age, tech level, context, constraints. e.g., "75-year-old non-English-speaking seniors scanning mail they can't read"]

**Core job:** [What job is the user hiring this product to do? One sentence. e.g., "Understand a piece of mail without asking their kids for help"]

**Quality bar:** [The one-sentence test for "good enough." e.g., "If a senior can't complete a scan without help, it's a bug"]

**Trade-off priorities** (ranked — when two values conflict, the higher one wins):
1. [e.g., Privacy > Convenience — never send raw images to cloud]
2. [e.g., Accessibility > Aesthetics — 18pt minimum even if it looks clunky]
3. [e.g., Shipping > Polish — working feature beats pixel-perfect design]

---

## Constraints

_These are the guardrails. Claude should never have to guess whether something is allowed._

**Must** (non-negotiable requirements):
- [e.g., All text must meet WCAG AA contrast ratios]
- [e.g., App must work offline for core scanning flow]
- [e.g., PII must be stripped before any data leaves the device]

**Must not** (hard boundaries — things Claude should never do):
- [e.g., Never send raw images to external APIs]
- [e.g., Never require account creation to use core features]
- [e.g., Never add swipe gestures or hamburger menus]

**Prefer** (soft preferences when multiple approaches work):
- [e.g., Prefer expo-router file-based routing over manual navigation]
- [e.g., Prefer AsyncStorage over SQLite for simple key-value data]
- [e.g., Prefer native platform conventions over custom UI]

**Escalate** (decisions Claude should NOT make autonomously — ask Mike):
- [e.g., Any change to the pricing model or free tier limits]
- [e.g., Adding a new third-party service or API dependency]
- [e.g., Architectural changes that affect more than 3 existing files]
- [e.g., Anything involving auth, payments, or data deletion]

---

## Debugging & Implementation Principles

_Lessons learned. These prevent repeating past mistakes._

- For native library bugs: **read the native source code** before diagnosing. Pattern-matching wastes cycles.
- Symptom timing is diagnostic: "fails immediately" = compute failure, not I/O. "Fails with latency" = I/O problem.
- GitHub issues for unverified fixes must use **hypothesis language** ("Suspected: X. Verification required: Y"), never solution language ("Fix: do X").
- Walk the full pipeline before drilling on one hypothesis. For image bugs: (1) file loading? (2) EXIF orientation? (3) format/quality?
- Fast iteration loops don't substitute for upfront reasoning. Think before deploying.

---

## Context

_What exists already. A fresh Claude session reading this plan should understand the landscape._

**What exists:**
- [e.g., PWA with 13 screens, 20+ components, fully validated — path: `C:\...\Plainly`]
- [e.g., Vercel API endpoint at `/api/analyze-gemini` — already deployed and working]

**Key architecture decisions already made:**
- [e.g., On-device OCR via ML Kit (not cloud vision) — privacy requirement]
- [e.g., Gemini Flash for triage — validated via A/B test against GPT-4o]

**Reference codebases:**
- [e.g., PWA source: `C:\Users\myann\OneDrive\Desktop\SaaS Portfolio\Plainly`]

---

## Tech Stack

| Layer | Choice | Why |
|-------|--------|-----|
| [e.g., Framework] | [e.g., Expo / React Native] | [e.g., Cross-platform from one codebase] |
| [e.g., Navigation] | [e.g., expo-router] | [e.g., File-based routing, convention over config] |
| [e.g., OCR] | [e.g., react-native-mlkit-ocr] | [e.g., On-device, no cloud dependency] |
| [e.g., AI/LLM] | [e.g., Gemini Flash via Vercel API] | [e.g., Validated accuracy, cost-effective] |
| [e.g., Storage] | [e.g., AsyncStorage + expo-sqlite] | [e.g., KV for prefs, SQL for history] |
| [e.g., Payments] | [e.g., RevenueCat + Stripe] | [e.g., IAP for App Store compliance, Stripe for web] |

---

## Project Structure (target)

```
project-name/
├── [directory tree here]
└── ...
```

---

## Phases

_Each phase is a deployable increment. Verification checklist must pass before moving on._

### Phase 1: [Name]

**Goal:** [One sentence — what's true when this phase is done]

| New File | Reference | Key Changes |
|----------|-----------|-------------|
| `path/to/file.ts` | `reference/file.ts` | Brief description of what changes and why |

**Verification:**
- [ ] [Observable behavior, not implementation detail] (#NN if linked to an issue)
- [ ] [e.g., "Camera viewfinder displays live preview (#3)" not "CameraView component renders"]
- [ ] [e.g., "ML Kit extracts text from a captured photo (#4)" not "OCR service returns string"]

---

### Phase 2: [Name]

**Goal:** [One sentence]

| New File | Reference | Key Changes |
|----------|-----------|-------------|
| ... | ... | ... |

**Verification:**
- [ ] ...

---

_[Continue phases as needed. Each phase should be completable in 1-2 sessions.]_

---

## Decision Log

_Append decisions as they're made. This creates institutional memory — future sessions see WHY, not just WHAT._

### [Date]: [Decision Title]

**Context:** [What situation prompted this decision]
**Options considered:** [What alternatives existed]
**Decision:** [What was chosen]
**Rationale:** [Why — the reasoning, not just the conclusion]
**Implications:** [What this means for future work]

---

## Template Usage Notes

_Delete this section when using the template._

**What this template adds vs. what you already write naturally:**

1. **Product Intent** (3 fields) — Forces you to name the user, the quality bar, and the trade-off ranking. Without this, Claude defaults to "generic developer building for generic users" and makes middle-of-the-road trade-offs.

2. **Constraints** (4 categories) — Musts/must-nots prevent Claude from making decisions you'd veto. Preferences guide it when multiple approaches work. Escalation triggers prevent it from silently making high-stakes choices.

3. **Debugging Principles** — Learned patterns that prevent repeat mistakes. These are project-agnostic and should be copied forward.

4. **Decision Log** — Empty section that gets filled as the project progresses. Future Claude sessions can read WHY decisions were made, not just see the code that resulted.

5. **Issue Number Annotations** — When `set up GitHub Issues` creates issues from this plan, it annotates each checkbox with the issue number (e.g., `(#3)`). This creates a two-way link so `/issue 3` can reliably find and check off the exact item.

**The phases, verification checklists, tech stack, and file mapping tables are what you already do well.** This template just wraps them with intent and constraints so Claude can execute autonomously without guessing at your standards.
