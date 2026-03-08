# 007 — Use pnpm for Node tooling

**Status:** Accepted
**Date:** 2026-03-09

## Context

This is a Python project, but two tools require Node: prettier (Markdown formatting) and
@playwright/cli (browser automation for mermaid diagram verification). A Node package manager is
needed to install and run them consistently across developer machines and CI.

## Decision

We use [pnpm](https://pnpm.io) to manage Node devDependencies. prettier and @playwright/cli are
declared in `package.json` and installed locally into `node_modules/` via `pnpm install`. No global
Node installs are used for project tooling.

pnpm itself is installed via `scripts/setup/install-pnpm.sh` using the preference order:

1. **mise** — `mise use pnpm@latest` installs pnpm and writes `pnpm = "latest"` to `.mise.toml`
   (project-scoped)
2. **Homebrew** (macOS only) — `brew install pnpm`
3. **Native installer** — `curl https://get.pnpm.io/install.sh | sh -` as a last resort

## Consequences

- Node devDependencies are version-locked via `pnpm-lock.yaml` — consistent across contributors and
  CI
- No global Node tool installs — tooling is fully contained within the project
- When installed via mise, pnpm is project-scoped in `.mise.toml` rather than global mise config
- pnpm is the only Node-related system prerequisite; it is not itself a Node devDependency

## Alternatives considered

**npm:** Bundled with Node but slower and produces a different lockfile format. pnpm is faster and
has stricter dependency isolation.

**yarn:** Similar to pnpm but less efficient on disk. pnpm is preferred for global tool conventions
in this project.

**pnpm dlx (no install):** Running `pnpm dlx prettier` avoids a `package.json` entirely but
downloads on every invocation and cannot be version-locked. A local devDependency is more
reproducible.
