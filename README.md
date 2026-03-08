# python-project-template

> **AI agent?** Read [AGENTS.md](AGENTS.md) first.

Generic setup scaffolding for Python projects using [uv](https://docs.astral.sh/uv/). Extracted for reuse across projects.

## What's included

### Setup scripts (`scripts/setup/`)

One-shot installers for every tool the project needs. Run them individually or all at once:

```bash
bash scripts/setup.sh
```

| Script                      | Installs                                                                  |
| --------------------------- | ------------------------------------------------------------------------- |
| `install-uv.sh`             | [uv](https://docs.astral.sh/uv/) — Python package and environment manager |
| `install-python.sh`         | Python 3.14+ via mise → uv → Homebrew                                     |
| `install-deps.sh`           | Project dependencies via `uv sync`; installs git hooks via prek           |
| `install-jq.sh`             | [jq](https://jqlang.org) — JSON query tool                                |
| `install-taplo.sh`          | [taplo](https://taplo.tamasfe.dev) — TOML formatter/linter                |
| `install-yamllint.sh`       | yamllint + yamlfix + actionlint (via `uv sync`)                           |
| `install-gh.sh`             | [gh](https://cli.github.com) — GitHub CLI                                 |
| `install-pnpm.sh`           | [pnpm](https://pnpm.io) — Node package manager                            |
| `install-prettier.sh`       | [prettier](https://prettier.io) — Markdown formatter                      |
| `install-playwright-cli.sh` | playwright-cli — used for Mermaid diagram verification                    |
| `install-claude-plugins.sh` | Claude Code plugins (superpowers, basedpyright-lsp, etc.)                 |
| `install-skills.sh`         | Claude Code skills (playwright-cli skill)                                 |
| `verify-setup.sh`           | Runs pytest, ruff, shellcheck, yamllint, actionlint to confirm setup      |

### Linter/hook scripts (`scripts/tools/`)

Wrappers invoked by Claude Code hooks and git pre-commit hooks:

| Script                       | What it does                                                          |
| ---------------------------- | --------------------------------------------------------------------- |
| `ruff-fix.sh`                | Auto-fix then lint Python with ruff                                   |
| `basedpyright-lint.sh`       | Type-check with basedpyright                                          |
| `prettier-fix.sh`            | Format Markdown with prettier                                         |
| `shellcheck-lint.sh`         | Lint shell scripts with shellcheck                                    |
| `taplo-fmt.sh`               | Format TOML files with taplo                                          |
| `yamllint-fmt.sh`            | Auto-fix then lint YAML with yamlfix + yamllint                       |
| `actionlint-lint.sh`         | Lint GitHub Actions workflows with actionlint                         |
| `post-write-lint.sh`         | Claude Code PostToolUse hook — dispatches to the above by file type   |
| `block-no-verify.sh`         | Claude Code PreToolUse hook — blocks `git commit --no-verify`         |
| `uv-sync-if-lock-changed.sh` | Post-merge/post-checkout hook — runs `uv sync` when `uv.lock` changes |

### Config files

| File                      | Purpose                                                                                                                       |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `pyproject.toml`          | Project metadata + all dev deps pre-wired (ruff, basedpyright, pytest, prek, shellcheck-py, yamllint, yamlfix, actionlint-py) |
| `.pre-commit-config.yaml` | prek git hook definitions (pre-commit, post-merge, post-checkout)                                                             |
| `.claude/settings.json`   | Claude Code hooks and enabled plugins                                                                                         |
| `.mise.toml`              | Pinned taplo version                                                                                                          |
| `.yamllint.yaml`          | yamllint config (120-char line limit, GHA truthy ignore)                                                                      |
| `pyrightconfig.json`      | basedpyright include/exclude (prevents scanning `.venv/`)                                                                     |

### Docs (`docs/`)

**Reference guides**

| Doc                            | Contents                                                          |
| ------------------------------ | ----------------------------------------------------------------- |
| `project-setup.md`             | Step-by-step setup guide                                          |
| `hooks.md`                     | Claude Code hooks, git hooks, and CI enforcement                  |
| `basedpyright.md`              | Type checking config, error fixing, baseline usage                |
| `commands.md`                  | Quick reference for common commands                               |
| `architecture.md`              | Module layout template, dependency rules, and conventions         |
| `pr-process.md`                | PR artefact paths at a glance                                     |
| `pr-review-guide.md`           | Full review workflow — rounds, frontmatter, artefacts, checklists |
| `prd-guide.md`                 | PRD update workflow and bump script usage                         |
| `plans-guide.md`               | When and how to write implementation plans                        |
| `mermaid-guidelines.md`        | Diagram palette, syntax rules, and verification workflow          |
| `playwright-cli-guidelines.md` | Session artifact cleanup                                          |
| `maintenance.md`               | Update triggers and auditing checklist for keeping docs current   |

**Python conventions (`python-guide/`)**

| Doc                                | Contents                                      |
| ---------------------------------- | --------------------------------------------- |
| `python-guide/index.md`            | Python conventions index                      |
| `python-guide/naming.md`           | Avoid shadowing builtins                      |
| `python-guide/type-hints.md`       | Annotating signatures and dataclass fields    |
| `python-guide/style.md`            | Boolean comparisons, string splitting         |
| `python-guide/module-structure.md` | Separating concerns across modules            |
| `python-guide/tests.md`            | Assertions, mocks, imports, cleanup, coverage |
| `python-guide-uv.md`               | uv invocation patterns and antipatterns       |

**Decisions, plans, and specs**

| Directory    | Contents                                                                    |
| ------------ | --------------------------------------------------------------------------- |
| `decisions/` | Architectural Decision Records — tool choices and non-obvious constraints   |
| `plans/`     | Active implementation plans (archived to `archive/plans/` after completion) |
| `designs/`   | Design docs — problem, alternatives, recommendation (pre-approval)          |
| `specs/`     | Exhaustive specifications (`live/` and `in-progress/`)                      |
| `archive/`   | Post-merge artifacts — completed plans, deprecated designs, old specs       |

### `scripts/bump_prd.py`

Automates PRD minor version bumps: renames the versioned file, updates the `assets/prd.md` symlink, patches the version header and date, inserts a new version history row, and updates any reference in `CLAUDE.md`. See `docs/prd-guide.md`.

```bash
uv run scripts/bump_prd.py
```

### `CLAUDE.md`

A generalized project-level `CLAUDE.md` wired to all the docs above. Rename the top heading and extend as needed for your project.

## Usage

Copy this repo into a new project, then:

1. Edit `pyproject.toml` — set `name`, `description`, and add your runtime `dependencies`. All dev deps are already included.
2. Run `bash scripts/setup.sh` to install all tooling.
3. Start coding — linting and type checking run automatically on every file write and git commit.

## Requirements

- macOS or Linux
- bash 4+
- Homebrew (optional but recommended for macOS)
