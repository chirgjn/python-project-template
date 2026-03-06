# Playwright CLI Guidelines

## Session Artifacts

Session artifacts (`.yml`, `.log`) are written to `.playwright-cli/` in the project root.

Clean up after each session:

```bash
rm .playwright-cli/*.yml .playwright-cli/*.log
```
