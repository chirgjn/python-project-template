#!/usr/bin/env bash
set -uo pipefail
# Type-check Python files with basedpyright.
# Usage: basedpyright-lint.sh  (always checks the whole project — basedpyright ignores filenames)
# Exit code 3 = included paths do not exist (no Python files yet) — treat as success.
uv run basedpyright
code=$?
if [ "$code" -eq 3 ]; then exit 0; fi
exit "$code"
