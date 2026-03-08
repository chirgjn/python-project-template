#!/usr/bin/env bash
# Install playwright-cli as a project devDependency via pnpm install (repo root)
# Used for mermaid diagram verification (see docs/mermaid-guidelines.md)
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"

echo "playwright-cli"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PLAYWRIGHT_CLI_BIN="$ROOT/node_modules/.bin/playwright-cli"

if [[ -x "$PLAYWRIGHT_CLI_BIN" ]]; then
    ok "playwright-cli (already installed)"
    exit 0
fi

if ! command -v pnpm &>/dev/null; then
    fail "pnpm not found — run scripts/setup/install-pnpm.sh first"
fi

info "installing playwright-cli via pnpm install (repo root)..."
pnpm install --dir "$ROOT"

if [[ ! -x "$PLAYWRIGHT_CLI_BIN" ]]; then
    fail "playwright-cli not found at $PLAYWRIGHT_CLI_BIN after install."
fi

ok "playwright-cli installed"
