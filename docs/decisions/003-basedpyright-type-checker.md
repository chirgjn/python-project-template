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
