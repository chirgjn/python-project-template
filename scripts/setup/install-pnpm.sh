#!/usr/bin/env bash
# Install pnpm via the official script if not already present
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"

echo "pnpm"

if command -v pnpm &>/dev/null; then
    ok "pnpm $(pnpm --version) (already installed)"
    exit 0
fi

# Detect the user's login shell and its profile file
USER_SHELL=$(basename "${SHELL:-bash}")
case "$USER_SHELL" in
    zsh)  PROFILE="$HOME/.zshrc" ;;
    bash) PROFILE="${BASH_ENV:-${HOME}/.bashrc}" ;;
    fish) PROFILE="$HOME/.config/fish/config.fish" ;;
    *)    PROFILE="$HOME/.profile" ;;
esac

info "installing pnpm for $USER_SHELL (profile: $PROFILE)..."
TMPFILE=$(mktemp)
curl -fsSL https://get.pnpm.io/install.sh -o "$TMPFILE"
SHELL="$(command -v "$USER_SHELL")" sh "$TMPFILE"
rm -f "$TMPFILE"

# Source the updated profile to make pnpm available in this session.
# Skip for fish — fish syntax is not compatible with bash source.
if [[ "$USER_SHELL" == "fish" ]]; then
    warn "fish shell detected — cannot source profile from bash."
    warn "Open a new terminal tab and re-run: bash scripts/setup/install-playwright-cli.sh"
    exit 0
fi

if [[ -f "$PROFILE" ]]; then
    # shellcheck disable=SC1090
    source "$PROFILE"
else
    warn "Profile $PROFILE not found — pnpm may not be on PATH yet."
    warn "Try opening a new terminal and re-running this script."
fi

if ! command -v pnpm &>/dev/null; then
    fail "pnpm not found on PATH after install.
       The install likely succeeded but PATH is not updated yet.
       Open a new terminal and verify with: pnpm --version
       If still missing, check that $PROFILE contains the pnpm PATH line."
fi

ok "pnpm $(pnpm --version)"
