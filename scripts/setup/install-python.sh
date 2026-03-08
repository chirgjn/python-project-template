#!/usr/bin/env bash
# Install Python >=3.14 — prefers mise, falls back to uv, then Homebrew
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"

echo "Python"

if ! command -v uv &>/dev/null; then
    fail "uv not found — run scripts/setup/install-uv.sh first"
fi

if uv python find ">=3.14" &>/dev/null; then
    ok "Python >=3.14 (already available)"
    exit 0
fi

if command -v mise &>/dev/null; then
    info "installing Python >=3.14 via mise..."
    mise install
else
    # uv is guaranteed available (checked above); brew is a last resort
    if ! uv python install ">=3.14" && command -v brew &>/dev/null; then
        info "uv install failed, trying Homebrew..."
        brew install python@3.14
    fi
fi

if ! uv python find ">=3.14" &>/dev/null; then
    fail "Python >=3.14 still not found after install.
       Check output above for errors.
       Then verify with: uv python list"
fi

ok "Python >=3.14 ready"
