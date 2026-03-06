#!/usr/bin/env bash
# Auto-fix ruff violations; only fail if unfixable errors remain.
# Usage: ruff-fix.sh [file ...]   (defaults to src/ tests/ if no args)
if [ $# -eq 0 ]; then
    TARGETS=(src/ tests/)
else
    TARGETS=("$@")
fi
uv run ruff check --fix "${TARGETS[@]}" || true
uv run ruff check "${TARGETS[@]}"
