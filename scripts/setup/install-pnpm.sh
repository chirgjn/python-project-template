#!/usr/bin/env bash
# Install pnpm using mise -> brew (macOS only) -> native installer
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"

echo "pnpm"

if command -v pnpm &>/dev/null; then
    ok "pnpm $(pnpm --version) (already installed)"
    exit 0
fi

info "installing pnpm..."
if command -v mise &>/dev/null; then
    mise use pnpm@latest
elif [[ "$(uname -s)" == "Darwin" ]] && command -v brew &>/dev/null; then
    brew install pnpm
else
    # Native installer — works on macOS and Linux
    curl -fsSL https://get.pnpm.io/install.sh | sh -
    # The native installer appends to the shell profile; source it for this session
    # shellcheck disable=SC1090
    for profile in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
        [[ -f "$profile" ]] && source "$profile" && break
    done
fi

if ! command -v pnpm &>/dev/null; then
    fail "pnpm not found on PATH after install.
       If PATH was not updated in this session, open a new terminal and verify: pnpm --version"
fi

ok "pnpm $(pnpm --version)"
