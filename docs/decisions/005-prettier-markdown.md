# 005 — Use prettier for Markdown formatting

**Status:** Accepted
**Date:** 2026-03-08

## Context

Markdown files in a project with multiple contributors (human and AI agent) drift in formatting — inconsistent table alignment, trailing whitespace, blank line counts around headings. A formatter enforces consistency automatically. Several Python-native Markdown formatters exist (mdformat, pymarkdownlnt) but have differing rule sets and quality.

## Decision

We use [prettier](https://prettier.io) to format Markdown files. prettier runs on every `.md` write via the Claude Code PostToolUse hook and on every git commit via the prek pre-commit hook. It is installed globally via pnpm (`pnpm add -g prettier`).

## Consequences

- Markdown formatting is consistent across all files and contributors
- prettier's Markdown rules are stable and well-documented
- Requires pnpm and a global prettier install — additional setup step documented in `docs/project-setup.md`
- prettier reformats tables, lists, and headings opinionatedly — some formatting preferences must yield to its rules
- CI runs `prettier --check` in verify mode (no rewrite) as the enforcement backstop

## Alternatives considered

**mdformat:** Python-native, installable via uv, but less feature-complete than prettier for table formatting and has had rule changes between minor versions that cause CI churn.

**No formatter:** Without enforcement, Markdown drifts in whitespace and table alignment. AI agents in particular produce inconsistent formatting that accumulates over time.
