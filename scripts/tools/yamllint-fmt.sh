#!/usr/bin/env bash
set -euo pipefail
# Fix then lint YAML files: yamlfix auto-fixes, yamllint validates.
# Usage: yamllint-fmt.sh [file ...]  (defaults to all *.yaml/*.yml in the project)
# Note: yamlfix is skipped for .github/ files — it cannot safely reformat GHA workflows.
if [ $# -eq 0 ]; then
    mapfile -t TARGETS < <(find . \( -name '*.yaml' -o -name '*.yml' \) \
        -not -path './.venv/*' -not -path './.git/*' -not -path './node_modules/*' \
        -not -name 'pnpm-lock.yaml')
else
    TARGETS=("$@")
fi

# yamlfix pass: exclude .github/ (GHA workflows use block scalars that yamlfix mangles)
YAMLFIX_TARGETS=()
for f in "${TARGETS[@]}"; do
    case "$f" in
        ./.github/*|.github/*) ;;
        *) YAMLFIX_TARGETS+=("$f") ;;
    esac
done
if [ "${#YAMLFIX_TARGETS[@]}" -gt 0 ]; then
    uv run yamlfix "${YAMLFIX_TARGETS[@]}"
fi

uv run yamllint "${TARGETS[@]}"
