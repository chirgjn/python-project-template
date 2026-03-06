#!/usr/bin/env bash
# Full project setup — runs all setup steps in order
# Run from the project root: bash scripts/setup.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

SETUP="$ROOT/scripts/setup"

step() { echo ""; echo "── $1 ──"; }

run_step() {
    local label="$1"
    local script="$2"
    step "$label"
    if ! bash "$script"; then
        echo ""
        echo "  ✗ Step '$label' failed." >&2
        echo "    Fix the issue above, then re-run this step directly:" >&2
        echo "    bash $script" >&2
        echo "    Or restart the full setup from scratch: bash scripts/setup.sh" >&2
        exit 1
    fi
}

run_step "1. uv"              "$SETUP/install-uv.sh"
run_step "2. Python"          "$SETUP/install-python.sh"
run_step "3. Dependencies"    "$SETUP/install-deps.sh"
run_step "4. jq"              "$SETUP/install-jq.sh"
run_step "5. taplo"           "$SETUP/install-taplo.sh"
run_step "6. yamllint"        "$SETUP/install-yamllint.sh"
run_step "7. gh"              "$SETUP/install-gh.sh"
run_step "8. pnpm"            "$SETUP/install-pnpm.sh"
run_step "9. playwright-cli"  "$SETUP/install-playwright-cli.sh"
run_step "10. Claude plugins" "$SETUP/install-claude-plugins.sh"
run_step "11. Skills"         "$SETUP/install-skills.sh"
run_step "12. Verify"         "$SETUP/verify.sh"

echo ""
echo "  ✓ Setup complete."
