#!/usr/bin/env bash
set -euo pipefail

# Extract file_path from the tool input JSON
FILE=$(echo "$CLAUDE_TOOL_INPUT" | jq -r '.file_path // ""')

if [ -z "$FILE" ]; then
    exit 0
fi

case "$FILE" in
    *.py)
        scripts/tools/ruff-fix.sh "$FILE"
        ;;
    *.md)
        scripts/tools/prettier-fix.sh "$FILE"
        ;;
    *.sh)
        scripts/tools/shellcheck-lint.sh "$FILE"
        ;;
    *.toml)
        scripts/tools/taplo-fmt.sh "$FILE"
        ;;
    *.yaml|*.yml)
        scripts/tools/yamllint-fmt.sh "$FILE"
        case "$FILE" in
            .github/workflows/*|./.github/workflows/*)
                uv run actionlint "$FILE"
                ;;
        esac
        ;;
esac
