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
