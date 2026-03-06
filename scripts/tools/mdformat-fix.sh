#!/usr/bin/env bash
# Auto-format markdown; only fail if mdformat itself errors.
# Usage: mdformat-fix.sh [file ...]   (defaults to docs/ *.md CLAUDE.md if no args)
if [ $# -eq 0 ]; then
    TARGETS=(docs/ *.md CLAUDE.md)
else
    TARGETS=("$@")
fi
uv run mdformat "${TARGETS[@]}" || true
uv run mdformat --check "${TARGETS[@]}"
