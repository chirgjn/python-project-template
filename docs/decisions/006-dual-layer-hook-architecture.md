# 006 — Dual-layer hook architecture (prek + Claude Code hooks)

**Status:** Accepted
**Date:** 2026-03-08

## Context

This template enforces code quality through linting, formatting, and type checking. Two different actors make changes to files: human developers (via their editor or CLI) and Claude Code agents (via Write/Edit tool calls). These actors have different feedback loops. A git pre-commit hook catches errors at commit time — useful for humans, but too late for agents, which may make many file writes between commits. An agent that writes a bad file and doesn't know until commit has already made the mistake N times.

A second failure mode: agents can bypass git hooks entirely with `git commit --no-verify`. Without a mechanism to block this, the enforcement layer is optional.

## Decision

We use two complementary hook layers:

1. **prek git hooks** — run at commit time via `.pre-commit-config.yaml`. Catch anything that slipped through during editing. The enforcement backstop for human developers.

2. **Claude Code PostToolUse hooks** — run immediately after every Write or Edit tool call. Auto-fix and lint Python, Markdown, shell, TOML, and YAML the moment the file is written. Agents get feedback at write time, not commit time.

A **Claude Code PreToolUse hook** (`block-no-verify.sh`) blocks any `git commit --no-verify` invocation, making the git hook layer non-bypassable during agent sessions.

CI (GitHub Actions) is the third and final layer — it runs on every push and catches anything that bypassed both hook layers.

## Consequences

- Agents receive linting feedback immediately after each file write — errors don't accumulate
- Human developers are protected by git hooks at commit time
- `git commit --no-verify` is blocked during agent sessions — the hook layer cannot be bypassed
- Three-layer enforcement: write-time → commit-time → CI. Each layer is independent
- More hook scripts to maintain — `scripts/tools/` contains one script per file type plus dispatch logic
- The PostToolUse hook adds latency to every file write — benchmarked as acceptable (<500ms for most files)

## Alternatives considered

**Git hooks only:** Agents accumulate errors across multiple writes and only discover them at commit. By then, multiple files may need fixing. Not suitable for agent workflows.

**Claude Code hooks only:** Bypassing git with `--no-verify` (or working outside Claude Code) would skip all enforcement. Human developers get no backstop.

**Pre-commit as the only tool (no Claude Code hooks):** Same problem as git hooks only — agents have no write-time feedback.
