# Documentation Design: python-project-template

**Date:** 2026-03-08
**Status:** Approved

## Problem

The template ships with `AGENTS.md`, `layout.md`, and a `docs/` directory, but it does not conform to the documentation framework (`managing-project-information.md`). Specific gaps:

1. `layout.md` is missing the required YAML frontmatter (`docs: docs/`).
2. `docs/maintenance.md` lacks the framework's enforcement hierarchy, full update triggers, and auditing checklist.
3. The framework-required directory structure (`docs/decisions/`, `docs/plans/`, `docs/designs/`, `docs/specs/`, `docs/archive/`) does not exist.
4. The tool choices baked into the template (uv, ruff, basedpyright, prek, prettier, dual-layer hooks) are undocumented — a project copying the template has no record of why those tools were chosen.
5. `AGENTS.md` routing table has no entries for decisions or plans.

## Approach

**Option C — Fix defects + full directory structure + ADRs for all tool choices including the hook architecture ADR.**

Real content where the template has decisions to document. Stubs where there is nothing yet.

## Design

### 1. Defect fixes

- Add YAML frontmatter to `layout.md` (`docs: docs/`)
- Rewrite `docs/maintenance.md` to framework format: enforcement hierarchy + full update triggers table + auditing checklist

### 2. Directory structure

```
docs/
  decisions/
    index.md                              — stub listing ADRs
    001-uv-package-manager.md             — ADR
    002-ruff-linter-formatter.md          — ADR
    003-basedpyright-type-checker.md      — ADR
    004-prek-git-hooks.md                 — ADR
    005-prettier-markdown.md              — ADR
    006-dual-layer-hook-architecture.md   — ADR (non-obvious design)
  plans/
    index.md                              — stub
  designs/
    index.md                              — stub
  specs/
    index.md                              — stub
    live/                                 — .gitkeep
    in-progress/                          — .gitkeep
  archive/
    decisions/                            — .gitkeep
    plans/                                — .gitkeep
    designs/                              — .gitkeep
    specs/                                — .gitkeep
    pr-reviews/                           — .gitkeep
```

### 3. AGENTS.md routing table

Add two entries:

```
| Browsing architectural decisions and tool choices | docs/decisions/index.md |
| Finding or tracking an active plan               | docs/plans/index.md     |
```

### 4. docs/maintenance.md rewrite

Three additions to the current file:
- Enforcement hierarchy (linters → hooks → CI → written rules)
- Full update triggers table including decisions, plans, specs, designs, archive operations
- Auditing checklist
