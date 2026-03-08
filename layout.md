---
docs: docs/
---

# python-project-template

Repo root for the Python project template. Read this file to orient before touching structure, then consult `docs/` for conventions and guides.

## Contents

```
docs/                 — all project documentation and guides
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

scripts/              — developer tooling scripts
  setup/              — environment setup scripts
  tools/              — utility scripts (e.g. yamllint-fmt.sh)
  bump_prd.py         — PRD version bump script
  setup.sh            — top-level setup entry point

pyproject.toml        — project metadata, dependencies, and tool config
pyrightconfig.json    — basedpyright configuration
```

## What Lives Here

- `layout.md` (this file) — structural map for the repo
- `AGENTS.md` — canonical agent instructions (identity, structure, commands, conventions, routing)
- `CLAUDE.md -> AGENTS.md` — symlink for Claude Code
- `pyproject.toml` — single source of truth for dependencies and tool config
- `pyrightconfig.json` — type checker config

## What Doesn't Live Here

- Source code lives in a `src/` directory (add when the project is scaffolded)
- Per-topic conventions belong in `docs/python-guide/`, not at the root
- Scripts belong in `scripts/`, not at the root
