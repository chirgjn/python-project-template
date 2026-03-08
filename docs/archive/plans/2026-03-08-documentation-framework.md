# Documentation Framework Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Bring python-project-template into full compliance with the documentation framework (`managing-project-information.md`) by fixing defects, creating the required directory structure with real ADRs for tool choices, and updating navigation.

**Architecture:** Fix two defects in existing files, create six ADRs documenting the template's tool decisions, scaffold the remaining framework-required directories with stubs, and update `AGENTS.md` routing and `docs/maintenance.md` to match the framework format.

**Tech Stack:** Markdown, YAML frontmatter. No code changes.

---

## Task 1: Fix `layout.md` frontmatter

**Files:**
- Modify: `layout.md`

The framework requires every `layout.md` to open with YAML frontmatter containing a `docs:` field. Without it, framework scripts fail fast.

**Step 1: Add frontmatter**

The file currently starts with `---` as a horizontal rule (Markdown). Replace it with proper YAML frontmatter. The file should open with:

```markdown
---
docs: docs/
---
```

The existing `---` horizontal rule at line 1 is plain Markdown — replace it with the two-field YAML block above. Keep everything else unchanged.

**Step 2: Verify prettier formats cleanly**

```bash
uv run prettier --check layout.md
```

Expected: no formatting issues (or auto-fixed by hook).

**Step 3: Commit**

```bash
git add layout.md
git commit -m "docs: add required YAML frontmatter to layout.md"
```

---

## Task 2: Create `docs/decisions/` with index stub

**Files:**
- Create: `docs/decisions/index.md`

**Step 1: Create the index stub**

```markdown
# Architectural Decision Records

Decisions that shaped this template — tool choices, architectural patterns, and non-obvious constraints.

| ADR | Title | Status |
| --- | ----- | ------ |
| [001](001-uv-package-manager.md) | Use uv as package and environment manager | Accepted |
| [002](002-ruff-linter-formatter.md) | Use ruff for linting and formatting | Accepted |
| [003](003-basedpyright-type-checker.md) | Use basedpyright for type checking | Accepted |
| [004](004-prek-git-hooks.md) | Use prek for git hook management | Accepted |
| [005](005-prettier-markdown.md) | Use prettier for Markdown formatting | Accepted |
| [006](006-dual-layer-hook-architecture.md) | Dual-layer hook architecture (prek + Claude Code hooks) | Accepted |

Add new ADRs here as project-specific decisions are made. Use sequential three-digit prefixes.
```

**Step 2: Commit**

```bash
git add docs/decisions/index.md
git commit -m "docs: add decisions/ index stub"
```

---

## Task 3: Write ADR 001 — uv

**Files:**
- Create: `docs/decisions/001-uv-package-manager.md`

**Step 1: Write the ADR**

```markdown
# 001 — Use uv as package and environment manager

**Status:** Accepted
**Date:** 2026-03-08

## Context

Python projects require a tool to manage the virtual environment, install dependencies, and run scripts reproducibly. The traditional toolchain (pip + venv + pip-tools) works but requires several separate tools and manual activation steps. pip-tools must be kept in sync with `requirements.txt` manually. Neither enforces lockfile integrity across platforms.

## Decision

We use [uv](https://docs.astral.sh/uv/) as the single tool for environment creation, dependency installation, lockfile management, and script invocation. All Python invocations go through `uv run <tool>` — never `python` or `python3` directly.

## Consequences

- All Python invocations are reproducible — the managed venv is always active via `uv run`
- A single `uv sync` installs everything including dev dependencies
- `uv.lock` provides cross-platform lockfile integrity
- Developers must install uv before any other setup step — documented in `docs/project-setup.md`
- Tools not in the venv (e.g., taplo) must still be installed separately

## Alternatives considered

**pip + venv + pip-tools:** Familiar but requires manual activation, separate tools, and manual sync between `requirements.in` and `requirements.txt`. More error-prone for multi-developer projects.

**Poetry:** Feature-complete alternative but slower than uv, heavier install, and its virtual environment management conflicts with some CI setups.
```

**Step 2: Commit**

```bash
git add docs/decisions/001-uv-package-manager.md
git commit -m "docs: add ADR 001 — uv as package manager"
```

---

## Task 4: Write ADR 002 — ruff

**Files:**
- Create: `docs/decisions/002-ruff-linter-formatter.md`

**Step 1: Write the ADR**

```markdown
# 002 — Use ruff for linting and formatting

**Status:** Accepted
**Date:** 2026-03-08

## Context

Python projects need a linter to catch errors and enforce style, and a formatter to eliminate style debates. The traditional choice (flake8 + black + isort) requires three separate tools with separate configs, and they occasionally conflict. Speed matters for hook latency — slow linters discourage running them.

## Decision

We use [ruff](https://docs.astral.sh/ruff/) for both linting and formatting. It replaces flake8, black, and isort. Config lives entirely in `pyproject.toml` under `[tool.ruff]`. Auto-fix runs on every file write via the Claude Code PostToolUse hook.

## Consequences

- Single tool, single config file — no coordination between linter and formatter
- Significantly faster than flake8 + black (written in Rust)
- Auto-fix on write means most violations never require manual intervention
- ruff's rule set is a superset of flake8 — existing flake8 configs can be migrated
- Some niche flake8 plugins have no ruff equivalent — those rules are unavailable

## Alternatives considered

**flake8 + black + isort:** Three tools, three configs, occasional conflicts between black and isort. Slower. No auto-fix in flake8.

**pylint:** More rules than ruff but significantly slower, noisier, and harder to configure. Not suitable for hook use.
```

**Step 2: Commit**

```bash
git add docs/decisions/002-ruff-linter-formatter.md
git commit -m "docs: add ADR 002 — ruff for linting and formatting"
```

---

## Task 5: Write ADR 003 — basedpyright

**Files:**
- Create: `docs/decisions/003-basedpyright-type-checker.md`

**Step 1: Write the ADR**

```markdown
# 003 — Use basedpyright for type checking

**Status:** Accepted
**Date:** 2026-03-08

## Context

Static type checking catches a class of bugs that linters and tests miss — wrong argument types, missing attributes, incorrect return types. The two main choices for Python are mypy and pyright. Claude Code agents benefit from real-time type diagnostics (LSP) during code navigation and editing.

## Decision

We use [basedpyright](https://github.com/DetachHead/basedpyright), a fork of pyright, for both command-line type checking and LSP-powered real-time diagnostics in Claude Code sessions. The `basedpyright-lsp` Claude Code plugin runs `basedpyright-langserver` via `uv run` — no global install required. Config lives in `pyrightconfig.json`.

## Consequences

- Real-time type diagnostics in Claude Code via LSP — errors appear before commit
- No global install of the language server — it runs from the uv-managed venv
- basedpyright is stricter than upstream pyright by default — more errors initially, but fewer surprises in production
- `pyrightconfig.json` must exclude `.venv/` to prevent scanning installed packages
- The `basedpyright-lsp` plugin must be installed per project — documented in `docs/project-setup.md`

## Alternatives considered

**mypy:** More mature, larger ecosystem of stubs, but slower and no LSP support suitable for Claude Code. Pyright/basedpyright is faster and has first-class LSP support.

**pyright (upstream):** basedpyright is a strict superset — it adds features and stricter defaults without removing anything. The LSP plugin targets basedpyright specifically.
```

**Step 2: Commit**

```bash
git add docs/decisions/003-basedpyright-type-checker.md
git commit -m "docs: add ADR 003 — basedpyright for type checking"
```

---

## Task 6: Write ADR 004 — prek

**Files:**
- Create: `docs/decisions/004-prek-git-hooks.md`

**Step 1: Write the ADR**

```markdown
# 004 — Use prek for git hook management

**Status:** Accepted
**Date:** 2026-03-08

## Context

Git hooks (pre-commit, post-merge, post-checkout) need to be version-controlled, installed consistently across developer machines, and fast enough not to disrupt the commit workflow. The de facto standard is `pre-commit` (the tool), but it has a significant limitation: it runs hooks in isolated virtual environments, which means it cannot reuse tools already installed in the project's uv-managed venv.

## Decision

We use [prek](https://github.com/peterdemin/prek) to manage git hooks. Hooks are defined in `.pre-commit-config.yaml` (same format as `pre-commit` for familiarity) and installed via `uv run prek install`. prek runs hooks using the project's existing venv — no separate environments per hook.

## Consequences

- Hook execution reuses the uv-managed venv — no duplicate installs, no version mismatches between hook and project
- `.pre-commit-config.yaml` format is familiar to developers who know `pre-commit`
- Faster hook execution — no venv activation overhead per hook
- prek is less widely known than `pre-commit` — new contributors may be unfamiliar
- Not all `pre-commit` hooks are compatible — hooks must be runnable via the project venv

## Alternatives considered

**pre-commit:** Industry standard but creates isolated venvs per hook. Means ruff, basedpyright, etc. are installed twice — once in the project venv, once in the hook env. Version drift between the two is a recurring source of false positives.

**Husky (Node):** Requires Node and npm/pnpm in a Python project. Inappropriate dependency.

**Raw shell scripts in `.git/hooks/`:** Not version-controlled, not portable, require per-developer manual setup.
```

**Step 2: Commit**

```bash
git add docs/decisions/004-prek-git-hooks.md
git commit -m "docs: add ADR 004 — prek for git hook management"
```

---

## Task 7: Write ADR 005 — prettier

**Files:**
- Create: `docs/decisions/005-prettier-markdown.md`

**Step 1: Write the ADR**

```markdown
# 005 — Use prettier for Markdown formatting

**Status:** Accepted
**Date:** 2026-03-08

## Context

Markdown files in a project with multiple contributors (human and AI agent) drift in formatting — inconsistent table alignment, trailing whitespace, blank line counts around headings. A formatter enforces consistency automatically. Several Python-native Markdown formatters exist (mdformat, pymarkdownlnt) but have differing rule sets and quality.

## Decision

We use [prettier](https://prettier.io) to format Markdown files. prettier runs on every `.md` write via the Claude Code PostToolUse hook and on every git commit via the prek pre-commit hook. It is installed globally via pnpm (`pnpm add -g prettier`).

## Consequences

- Markdown formatting is consistent across all files and contributors
- prettier's Markdown rules are stable and well-documented
- Requires pnpm and a global prettier install — additional setup step documented in `docs/project-setup.md`
- prettier reformats tables, lists, and headings opinionatedly — some formatting preferences must yield to its rules
- CI runs `prettier --check` in verify mode (no rewrite) as the enforcement backstop

## Alternatives considered

**mdformat:** Python-native, installable via uv, but less feature-complete than prettier for table formatting and has had rule changes between minor versions that cause CI churn.

**No formatter:** Without enforcement, Markdown drifts in whitespace and table alignment. AI agents in particular produce inconsistent formatting that accumulates over time.
```

**Step 2: Commit**

```bash
git add docs/decisions/005-prettier-markdown.md
git commit -m "docs: add ADR 005 — prettier for Markdown formatting"
```

---

## Task 8: Write ADR 006 — dual-layer hook architecture

**Files:**
- Create: `docs/decisions/006-dual-layer-hook-architecture.md`

**Step 1: Write the ADR**

```markdown
# 006 — Dual-layer hook architecture (prek + Claude Code hooks)

**Status:** Accepted
**Date:** 2026-03-08

## Context

This template enforces code quality through linting, formatting, and type checking. Two different actors make changes to files: human developers (via their editor or CLI) and Claude Code agents (via Write/Edit tool calls). These actors have different feedback loops. A git pre-commit hook catches errors at commit time — useful for humans, but too late for agents, which may make many file writes between commits. An agent that writes a bad file and doesn't know until commit has already made the mistake N times.

A second failure mode: agents can bypass git hooks entirely with `git commit --no-verify`. Without a mechanism to block this, the enforcement layer is optional.

## Decision

We use two complementary hook layers:

1. **prek git hooks** — run at commit time via `.pre-commit-config.yaml`. Catch anything that slipped through during editing. The enforcement backstop for human developers.

2. **Claude Code PostToolUse hooks** — run immediately after every Write or Edit tool call. Auto-fix and lint Python, Markdown, shell, TOML, and YAML the moment the file is written. Agents get feedback at write time, not commit time.

A **Claude Code PreToolUse hook** (`block-no-verify.sh`) blocks any `git commit --no-verify` invocation, making the git hook layer non-bypassable during agent sessions.

CI (GitHub Actions) is the third and final layer — it runs on every push and catches anything that bypassed both hook layers.

## Consequences

- Agents receive linting feedback immediately after each file write — errors don't accumulate
- Human developers are protected by git hooks at commit time
- `git commit --no-verify` is blocked during agent sessions — the hook layer cannot be bypassed
- Three-layer enforcement: write-time → commit-time → CI. Each layer is independent
- More hook scripts to maintain — `scripts/tools/` contains one script per file type plus dispatch logic
- The PostToolUse hook adds latency to every file write — benchmarked as acceptable (<500ms for most files)

## Alternatives considered

**Git hooks only:** Agents accumulate errors across multiple writes and only discover them at commit. By then, multiple files may need fixing. Not suitable for agent workflows.

**Claude Code hooks only:** Bypassing git with `--no-verify` (or working outside Claude Code) would skip all enforcement. Human developers get no backstop.

**Pre-commit as the only tool (no Claude Code hooks):** Same problem as git hooks only — agents have no write-time feedback.
```

**Step 2: Commit**

```bash
git add docs/decisions/006-dual-layer-hook-architecture.md
git commit -m "docs: add ADR 006 — dual-layer hook architecture"
```

---

## Task 9: Create stub directories for plans, designs, specs, archive

**Files:**
- Create: `docs/plans/index.md`
- Create: `docs/designs/index.md`
- Create: `docs/specs/index.md`
- Create: `docs/specs/live/.gitkeep`
- Create: `docs/specs/in-progress/.gitkeep`
- Create: `docs/archive/decisions/.gitkeep`
- Create: `docs/archive/plans/.gitkeep`
- Create: `docs/archive/designs/.gitkeep`
- Create: `docs/archive/specs/.gitkeep`
- Create: `docs/archive/pr-reviews/.gitkeep`

**Step 1: Create `docs/plans/index.md`**

```markdown
# Implementation Plans

Active plans for in-progress work. Archive to `docs/archive/plans/` after completion.

| Plan | Goal | Status |
| ---- | ---- | ------ |

Add rows as plans are created. Format: `[YYYY-MM-DD-topic](YYYY-MM-DD-topic.md)`.
```

**Step 2: Create `docs/designs/index.md`**

```markdown
# Design Docs

Pre-approval records of problems, alternatives, and recommendations for significant changes.

| Design | Goal | Status |
| ------ | ---- | ------ |

Add rows as designs are created. Archive rejected or deprecated designs to `docs/archive/designs/` — don't delete.
```

**Step 3: Create `docs/specs/index.md`**

```markdown
# Specifications

Exhaustive, authoritative descriptions of how things work. Updated when the system changes.

## Live

Specs in `live/` describe systems as they currently work.

| Spec | What it describes |
| ---- | ----------------- |

## In Progress

Specs in `in-progress/` are being written alongside active implementation.

| Spec | What it describes |
| ---- | ----------------- |
```

**Step 4: Create `.gitkeep` files for empty directories**

Create empty `.gitkeep` files in:
- `docs/specs/live/`
- `docs/specs/in-progress/`
- `docs/archive/decisions/`
- `docs/archive/plans/`
- `docs/archive/designs/`
- `docs/archive/specs/`
- `docs/archive/pr-reviews/`

Each file is empty — its only purpose is to make git track the directory.

**Step 5: Commit**

```bash
git add docs/plans/index.md docs/designs/index.md docs/specs/ docs/archive/
git commit -m "docs: add framework directory structure with stubs"
```

---

## Task 10: Rewrite `docs/maintenance.md`

**Files:**
- Modify: `docs/maintenance.md`

**Step 1: Read the current file**

Read `docs/maintenance.md` to confirm current content before modifying.

**Step 2: Rewrite to framework format**

The new file adds three sections to the existing update triggers table:

```markdown
# Maintenance Checklist

When making structural changes, keep these documents updated. Update docs in the same PR as the code change they describe.

<!-- NOTE: Some content in this file deliberately overlaps with contributors' global
     ~/.claude/CLAUDE.md. Do not remove that redundancy — other contributors won't
     have the same global instructions. -->

---

## Enforcement Hierarchy

Prefer mechanisms higher on this list — each level down drifts more:

```
1. Linter rules  — ruff, basedpyright (auto-enforced, zero drift)
2. Hooks         — prek pre-commit, Claude Code PostToolUse (auto-format on write/commit)
3. CI checks     — GitHub Actions lint.yml (catches what hooks miss)
4. Written rules — AGENTS.md, docs/ (last resort — requires humans to read)
```

Before writing a convention, ask: "Can a tool enforce this instead?"

---

## Update Triggers

| Document | Update when |
| -------- | ----------- |
| `docs/architecture.md` | Modules added, renamed, or responsibilities change |
| `docs/python-guide/` | New project-wide coding conventions established (edit the relevant topic file) |
| `docs/basedpyright.md` | basedpyright version, config keys, or suppression rules change |
| `docs/pr-process.md` | PR artefact paths change |
| `docs/pr-review-guide.md` | Review workflow or artefact conventions change |
| `docs/plans-guide.md` | Plan format or conventions change |
| `docs/prd-guide.md` | PRD update workflow or bump script behaviour changes |
| `assets/prd.md` | Requirements change — edit via the symlink, then run `uv run scripts/bump_prd.py` to version |
| `docs/mermaid-guidelines.md` | Mermaid diagram conventions change (keep in sync with `~/.claude/docs/mermaid-guidelines.md`) |
| `docs/project-setup.md` | Toolchain, required tools, or Claude Code plugins change |
| `scripts/setup/` | Any change to `docs/project-setup.md` — keep scripts in sync |
| `docs/hooks.md` | Hook behaviour changes — Claude Code or git hooks added, removed, or modified |
| `AGENTS.md` | Anything that changes how to navigate or work in this repo |
| `docs/decisions/index.md` | A new ADR is written — add a row to the index |
| `docs/plans/index.md` | A plan is created or archived — update the index row |
| `docs/specs/index.md` | A spec changes status (in-progress → live) or is added — update the index |
| `docs/decisions/<nnn>-*.md` | The decision it records is superseded — set status to `Superseded by [NNN]` and write a new ADR |

---

## Auditing Checklist

Run periodically or before a structural change:

- [ ] Is `AGENTS.md` under 80 lines? If not, extract content to `docs/`
- [ ] Does every file in `docs/` appear in `AGENTS.md`'s routing table?
- [ ] Does every routing entry match an actual task (not just a filename)?
- [ ] Do all `docs/` path references resolve? (`grep -r 'docs/' AGENTS.md docs/`)
- [ ] Are historical artifacts in `docs/archive/`, not `docs/`?
- [ ] Is anything in `AGENTS.md` enforceable by a linter or hook instead?
- [ ] Does `docs/decisions/index.md` list every ADR in `docs/decisions/`?
- [ ] Does `docs/plans/index.md` list every active plan?
- [ ] Does `docs/specs/index.md` reflect the current location and status of every spec?
- [ ] Are deprecated or rejected designs in `docs/archive/designs/`, not deleted?
```

**Step 3: Commit**

```bash
git add docs/maintenance.md
git commit -m "docs: rewrite maintenance.md to framework format"
```

---

## Task 11: Update `AGENTS.md` routing table

**Files:**
- Modify: `AGENTS.md`

**Step 1: Read the current routing table**

Read `AGENTS.md` lines 33–55 to see the current routing table.

**Step 2: Add two entries**

Add these two rows to the routing table (after the `docs/maintenance.md` entry):

```markdown
| Browsing architectural decisions and tool choices       | `docs/decisions/index.md`               |
| Finding or tracking an active implementation plan       | `docs/plans/index.md`                   |
```

**Step 3: Verify line count stays under 80**

Count lines in `AGENTS.md`. If adding these rows pushes it over 80 lines, the framework allows up to ~90 if the content is critical — two routing entries qualify.

**Step 4: Commit**

```bash
git add AGENTS.md
git commit -m "docs: add decisions and plans routing entries to AGENTS.md"
```

---

## Task 12: Update `layout.md` Contents section

**Files:**
- Modify: `layout.md`

**Step 1: Read the current Contents section**

Read `layout.md` to see the current `docs/` listing.

**Step 2: Add new directories to the Contents tree**

The `docs/` section of the Contents tree currently lists individual files. Add the new directories:

```
docs/
  python-guide/       — Python coding conventions (naming, types, style, tests, uv)
  decisions/          — Architectural Decision Records (tool choices, patterns)
  plans/              — Active implementation plans (archive after completion)
  designs/            — Design docs (live until deprecated or rejected)
  specs/              — Exhaustive specifications (live/ and in-progress/)
  archive/            — Post-merge artifacts (plans, designs, specs, pr-reviews)
  architecture.md     — module layout and dependency decisions
  commands.md         — quick-reference for lint, test, type-check commands
  hooks.md            — Claude Code and git hook configuration
  plans-guide.md      — implementation plan format and conventions
  prd-guide.md        — PRD update workflow
  pr-process.md       — PR artefact paths and review workflow
  pr-review-guide.md  — review conventions
  project-setup.md    — dev environment setup and required tooling
  basedpyright.md     — basedpyright config and suppression rules
  mermaid-guidelines.md — diagram conventions
  playwright-cli-guidelines.md — Playwright usage
  maintenance.md      — living docs checklist: what to update and when
```

**Step 3: Commit**

```bash
git add layout.md
git commit -m "docs: update layout.md Contents to include new docs directories"
```

---

## Task 13: Update `docs/plans/index.md` with this plan

**Files:**
- Modify: `docs/plans/index.md`

**Step 1: Add this plan to the index**

Add a row for the documentation framework plan:

```markdown
| [2026-03-08-documentation-framework](2026-03-08-documentation-framework.md) | Bring template into framework compliance — ADRs, directory structure, maintenance rewrite | Active |
```

**Step 2: Commit**

```bash
git add docs/plans/index.md
git commit -m "docs: register documentation framework plan in plans index"
```
