#!/usr/bin/env bash
# Install required Claude Code skills at project level
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"

echo "Claude Code skills"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PLAYWRIGHT_CLI_BIN="$ROOT/node_modules/.bin/playwright-cli"

if [[ ! -x "$PLAYWRIGHT_CLI_BIN" ]]; then
    fail "playwright-cli not found — run scripts/setup/install-playwright-cli.sh first"
fi

SKILL_DIR="$ROOT/.claude/skills/playwright-cli"

if [[ -d "$SKILL_DIR" ]]; then
    ok "playwright-cli skill (already installed)"
    exit 0
fi

info "installing playwright-cli skill..."
if ! "$PLAYWRIGHT_CLI_BIN" install --skills; then
    fail "Failed to install playwright-cli skill.
       Run manually: pnpm exec playwright-cli install --skills"
fi
ok "playwright-cli skill installed"
