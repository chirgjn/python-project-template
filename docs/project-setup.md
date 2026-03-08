# Project Setup Guide

Step-by-step setup for a new developer or agent. Follow in order.

---

## 1. uv

[uv](https://docs.astral.sh/uv/) manages the virtual environment and all dependencies.

```bash
bash scripts/setup/install-uv.sh
```

---

## 2. Python 3.14+

This project requires Python 3.14 or later. The version is pinned in `.python-version`. The setup script installs it automatically using the first available method: mise → uv → Homebrew.

```bash
bash scripts/setup/install-python.sh
```

---

## 3. Install project dependencies

From the project root:

```bash
uv sync
```

This creates `.venv/` and installs all runtime and dev dependencies, including:

| Package               | Purpose                         |
| --------------------- | ------------------------------- |
| `pytest`              | Tests                           |
| `ruff`                | Python linting / auto-fix       |
| `basedpyright`        | Static type checking (LSP)      |
| `shellcheck-py`       | Shell script linting            |
| `prek`                | Pre-commit hook framework       |
| `yamllint`, `yamlfix` | YAML linting / auto-fix         |
| `actionlint-py`       | GitHub Actions workflow linting |

---

## 4. jq

[jq](https://jqlang.org) is used to query and pretty-print JSON from the command line — useful for inspecting API responses, config files, and structured data.

```bash
bash scripts/setup/install-jq.sh
```

---

## 5. taplo

[taplo](https://taplo.tamasfe.dev) is used to format and lint `pyproject.toml` and other TOML config files. The setup script installs it automatically using the first available method: mise → Homebrew → binary download. Taplo is not available via apt.

The pinned version lives in `.mise.toml` and is the single source of truth for local installs and CI. To upgrade, update `.mise.toml`.

```bash
bash scripts/setup/install-taplo.sh
```

---

## 6. actionlint

[actionlint](https://github.com/rhysd/actionlint) is a static checker for GitHub Actions workflow files. It validates expression syntax, action inputs/outputs, embedded shell scripts (via shellcheck), and security best practices — catching errors that yamllint misses.

actionlint is installed as a Python wrapper (`actionlint-py`) via `uv sync` — no separate install step is needed. Run it via:

```bash
uv run actionlint
```

---

## 7. gh (GitHub CLI)

[gh](https://cli.github.com) is used to interact with GitHub — creating PRs, reviewing issues, and managing releases from the command line.

```bash
bash scripts/setup/install-gh.sh
```

After installation, authenticate with GitHub:

```bash
gh auth login
```

Recommended options:

- Account type: GitHub.com
- Protocol: SSH
- SSH key: Generate a new SSH key (or select an existing one)
- Auth method: Login with a web browser

Then configure git to use gh as the credential helper:

```bash
gh auth setup-git
```

Verify authentication:

```bash
gh auth status
```

---

## 8. pnpm

[pnpm](https://pnpm.io) manages Node devDependencies (prettier, @playwright/cli). The setup script
installs pnpm using the first available method: mise → Homebrew (macOS only) → native installer.
When installed via mise, `pnpm = "latest"` is written to `.mise.toml` (project-scoped).

```bash
bash scripts/setup/install-pnpm.sh
```

Then install Node devDependencies:

```bash
bash scripts/setup/install-prettier.sh
bash scripts/setup/install-playwright-cli.sh
```

---

## 9. Claude Code plugins

Install all required plugins by running:

```bash
bash scripts/setup/install-claude-plugins.sh
```

This script:

1. Adds the [`cj-cc-plugins`](https://github.com/chirgjn/claude-code-plugins) marketplace from GitHub.
1. Installs marketplace plugins (superpowers, commit-commands, etc.) at project scope.
1. Installs the `basedpyright-lsp` plugin from `cj-cc-plugins` — provides real-time type diagnostics and code navigation via `uv run basedpyright-langserver`. No global install needed; it uses the venv binary from `uv sync`.

To install manually:

```bash
claude plugin marketplace add chirgjn/claude-code-plugins --scope project
claude plugin install basedpyright-lsp@cj-cc-plugins --scope project
```

---

## 10. Skills

```bash
bash scripts/setup/install-skills.sh
```

This installs the `playwright-cli` skill (used for mermaid diagram verification — see `docs/mermaid-guidelines.md`) via the binary already installed in `node_modules/.bin/playwright-cli`.

---

## Hooks

Linting hooks fire automatically during Claude Code sessions. See `docs/hooks.md` for what runs, when, and how to unblock yourself if ruff fails.

---

## Verify everything

```bash
jq --version                   # jq available
taplo --version                # taplo available
taplo lint pyproject.toml      # pyproject.toml is valid
gh auth status                 # gh authenticated
uv run pytest tests/           # tests pass
uv run ruff check src/ tests/  # no Python lint errors
uv run basedpyright            # no type errors
uv run shellcheck -x --source-path=scripts/setup scripts/*.sh scripts/setup/*.sh scripts/tools/*.sh  # no shell lint errors
uv run yamllint .pre-commit-config.yaml  # YAML files valid
uv run actionlint                        # GitHub Actions workflows valid
```
