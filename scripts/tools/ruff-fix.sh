#!/usr/bin/env bash
# Lint Python with ruff. Auto-fixes locally; check-only in CI.
# Usage: ruff-fix.sh [--check] [file ...]   (defaults to src/ tests/ if no args)
#   --check  Report violations without modifying files (used in CI)
CHECK=0
if [ "${1-}" = "--check" ]; then
    CHECK=1
    shift
fi

if [ $# -eq 0 ]; then
    TARGETS=()
    for dir in src/ tests/; do
        [[ -d "$dir" ]] && TARGETS+=("$dir")
    done
    if [ "${#TARGETS[@]}" -eq 0 ]; then exit 0; fi
else
    TARGETS=("$@")
fi

if [ "$CHECK" -eq 1 ]; then
    uv run ruff check "${TARGETS[@]}"
else
    uv run ruff check --fix "${TARGETS[@]}" || true
    uv run ruff check "${TARGETS[@]}"
fi
