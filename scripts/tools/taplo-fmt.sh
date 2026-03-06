#!/usr/bin/env bash
set -euo pipefail
# Format TOML files with taplo.
# Usage: taplo-fmt.sh [file ...]  (defaults to all *.toml in the project if no args)
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
export PATH="${REPO_ROOT}/.local/bin:${PATH}"

if [ $# -eq 0 ]; then
    mapfile -t TARGETS < <(find . -name '*.toml' -not -path './.venv/*' -not -path './.git/*')
else
    TARGETS=("$@")
fi
taplo fmt "${TARGETS[@]}"
