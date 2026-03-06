# Project Name

## Getting Started

Setting up or updating your dev environment: `docs/project-setup.md`

## Commands

Quick reference: `docs/commands.md`

## Critical Rules

- **Python**: Always use `uv run` — never invoke Python directly. Details and antipatterns: `docs/python-guide/uv.md`
- **Code navigation**: Always use the LSP tool — finding definitions, references, callers, types. Do not reach for Grep or Glob when LSP can answer the question more precisely. Requires `uv sync`.

## Guides Reference

Consult the relevant guide before writing or reviewing code in that area:

| When you are... | Read |
| --------------- | ---- |
| Writing or naming variables, functions, parameters | `docs/python-guide/naming.md` — avoid shadowing builtins |
| Adding type hints or annotating signatures | `docs/python-guide/type-hints.md` |
| Writing style-sensitive code (booleans, string splitting) | `docs/python-guide/style.md` |
| Adding or modifying modules / deciding where code lives | `docs/python-guide/module-structure.md` |
| Writing, fixing, or reviewing tests | `docs/python-guide/tests.md` |
| Adding or configuring type-checking suppressions | `docs/basedpyright.md` |
| Creating or updating a PR (artefact paths, review rounds) | `docs/pr-process.md` + `docs/pr-review-guide.md` |
| Writing an implementation plan | `docs/plans-guide.md` |
| Updating requirements or the PRD | `docs/prd-guide.md` |
| Adding or modifying architecture (modules, dependencies) | `docs/architecture.md` |
| Setting up a new dev environment | `docs/project-setup.md` |
| Adding/modifying Claude Code or git hooks | `docs/hooks.md` |
| Running project commands (lint, test, type-check, etc.) | `docs/commands.md` |
| Invoking Python / avoiding uv antipatterns | `docs/python-guide/uv.md` |
| Navigating code — definitions, references, callers, types | LSP tool — always prefer over Grep/Glob |
| Adding Mermaid diagrams | `docs/mermaid-guidelines.md` |
| Working with Playwright | `docs/playwright-cli-guidelines.md` |
| Working with JSON at the command line | Use `jq` — `jq '.' file.json` to pretty-print |
| Formatting or linting TOML files | `taplo fmt pyproject.toml` |
| Linting YAML files | `scripts/tools/yamllint-fmt.sh <file>` (fix + lint) |
| Linting GitHub Actions workflows | `uv run actionlint` |

## Living Docs

<!-- NOTE: Some content in this file deliberately overlaps with contributors' global
     ~/.claude/CLAUDE.md. Do not remove that redundancy — other contributors won't
     have the same global instructions. -->

When making structural changes, keep these documents updated:

| Document | Update when |
| ------------------------------ | --------------------------------------------------------------------------------------------- |
| `docs/architecture.md` | Modules added, renamed, or responsibilities change |
| `docs/python-guide/` | New project-wide coding conventions established (edit the relevant topic file) |
| `docs/basedpyright.md` | basedpyright version, config keys, or suppression rules change |
| `docs/pr-process.md` | PR artefact paths change |
| `docs/pr-review-guide.md` | Review workflow or artefact conventions change |
| `docs/plans-guide.md` | Plan format or conventions change |
| `docs/prd-guide.md` | PRD update workflow or bump script behaviour changes |
| `assets/prd_v{version}.md` | Requirements change — update in place, then run `uv run scripts/bump_prd.py` |
| `docs/mermaid-guidelines.md` | Mermaid diagram conventions change (keep in sync with `~/.claude/docs/mermaid-guidelines.md`) |
| `docs/project-setup.md` | Toolchain, required tools, or Claude Code plugins change |
| `scripts/setup/` | Any change to `docs/project-setup.md` — keep scripts in sync |
| `docs/hooks.md` | Hook behaviour changes — Claude Code or git hooks added, removed, or modified |
| `CLAUDE.md` (this file) | Anything that changes how to navigate or work in this repo |
