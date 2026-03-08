#!/usr/bin/env bash
# Verify the project setup is working correctly
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"

echo "Verification"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
export PATH="${REPO_ROOT}/.local/bin:${PATH}"

if ! command -v uv &>/dev/null; then
    fail "uv not found — run scripts/setup/install-uv.sh first"
fi

if ! command -v jq &>/dev/null; then
    fail "jq not found — run scripts/setup/install-jq.sh first"
fi

if ! command -v gh &>/dev/null; then
    fail "gh not found — run scripts/setup/install-gh.sh first"
fi

if ! gh auth status &>/dev/null; then
    fail "gh is not authenticated — run: gh auth login"
fi

if ! command -v taplo &>/dev/null; then
    fail "taplo not found — run scripts/setup/install-taplo.sh first"
fi

info "running taplo lint..."
if ! taplo lint pyproject.toml; then
    fail "taplo found issues in pyproject.toml.
       Fix the issues listed above, then re-run verification."
fi
ok "pyproject.toml valid"

if [[ ! -f pyproject.toml ]]; then
    fail "pyproject.toml not found.
       Run this script from the project root directory.
       Current directory: $(pwd)"
fi

if [[ ! -d .venv ]]; then
    fail ".venv not found — run scripts/setup/install-deps.sh first"
fi

info "running tests..."
if ! uv run pytest tests/ -q; then
    fail "Tests failed.
       Check the output above for details.
       Run tests manually for more verbose output: uv run pytest tests/ -v"
fi
ok "tests pass"

info "running ruff..."
if ! uv run ruff check src/ tests/; then
    fail "Ruff found lint errors.
       Auto-fix where possible with: uv run ruff check --fix src/ tests/
       Then re-run verification: bash scripts/setup/verify-setup.sh"
fi
ok "no lint errors"

info "running shellcheck..."
if ! uv run shellcheck -x --source-path=scripts/setup scripts/*.sh scripts/setup/*.sh scripts/tools/*.sh; then
    fail "shellcheck found shell script issues.
       Fix the violations listed above, then re-run verification."
fi
ok "no shell lint errors"

info "running yamllint..."
mapfile -t YAML_FILES < <(find . \( -name '*.yaml' -o -name '*.yml' \) -not -path './.venv/*')
if ! uv run yamllint "${YAML_FILES[@]}"; then
    fail "yamllint found issues in YAML files.
       Fix the issues listed above, then re-run verification."
fi
ok "YAML files valid"

info "running actionlint..."
if ! uv run actionlint; then
    fail "actionlint found issues in .github/workflows/.
       Fix the issues listed above, then re-run verification."
fi
ok "GitHub Actions workflows valid"
