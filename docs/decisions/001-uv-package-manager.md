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
