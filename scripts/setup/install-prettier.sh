#!/usr/bin/env bash
# Install prettier as a project dev dependency via pnpm install (repo root)
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"

echo "prettier"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

PRETTIER_BIN="$ROOT/node_modules/.bin/prettier"

if [[ -x "$PRETTIER_BIN" ]]; then
    ok "prettier $("$PRETTIER_BIN" --version) (already installed)"
    exit 0
fi

if ! command -v pnpm &>/dev/null; then
    fail "pnpm not found — run scripts/setup/install-pnpm.sh first"
fi

info "installing prettier via pnpm install (repo root)..."
pnpm install --dir "$ROOT"

if [[ ! -x "$PRETTIER_BIN" ]]; then
    fail "prettier not found at $PRETTIER_BIN after install.
       Ensure package.json exists at the repo root and re-run this script."
fi

ok "prettier $("$PRETTIER_BIN" --version)"
