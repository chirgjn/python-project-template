#!/usr/bin/env bash
set -euo pipefail
# Lint shell scripts with shellcheck.
# Usage: shellcheck-lint.sh [file ...]  (defaults to scripts/ if no args)
if [ $# -eq 0 ]; then
    mapfile -t TARGETS < <(find scripts/ -name '*.sh' -type f)
else
    TARGETS=("$@")
fi
uv run shellcheck -x --source-path=scripts/setup "${TARGETS[@]}"
