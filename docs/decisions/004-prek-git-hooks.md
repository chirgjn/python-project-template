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
