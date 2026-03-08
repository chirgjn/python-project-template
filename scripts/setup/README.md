# Setup Scripts

Run individual scripts as needed, or run `bash scripts/setup.sh` to execute all steps in order.

## Scripts

| Script                      | What it does                                                                                                                                                                                                        | Requires                             |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| `install-uv.sh`             | Install [uv](https://docs.astral.sh/uv/) via Homebrew or official script                                                                                                                                            | —                                    |
| `install-python.sh`         | Install Python >=3.14 via mise, uv, or Homebrew                                                                                                                                                                     | `install-uv.sh`                      |
| `install-deps.sh`           | `uv sync` — install all project dependencies into `.venv`                                                                                                                                                           | `install-uv.sh`, `install-python.sh` |
| `install-jq.sh`             | Install [jq](https://jqlang.org) via Homebrew or binary download                                                                                                                                                    | —                                    |
| `install-taplo.sh`          | Install [taplo](https://taplo.tamasfe.dev) via mise, Homebrew, or binary download                                                                                                                                   | —                                    |
| `install-yamllint.sh`       | Verify [yamllint](https://yamllint.readthedocs.io) + [yamlfix](https://lyz-code.github.io/yamlfix/) + [actionlint](https://github.com/rhysd/actionlint) are available via `uv run` (installed by `install-deps.sh`) | `install-deps.sh`                    |
| `install-gh.sh`             | Install [gh](https://cli.github.com) via Homebrew or binary download; prompts for `gh auth login`                                                                                                                   | —                                    |
| `install-pnpm.sh`           | Install [pnpm](https://pnpm.io) via mise → Homebrew (macOS) → native installer; writes `pnpm = "latest"` to `.mise.toml` when using mise                                                                            | —                                    |
| `install-prettier.sh`       | Install [prettier](https://prettier.io) as a project devDependency via `pnpm install`                                                                                                                               | `install-pnpm.sh`                    |
| `install-playwright-cli.sh` | Install `@playwright/cli` as a project devDependency via `pnpm install`                                                                                                                                             | `install-pnpm.sh`                    |
| `install-claude-plugins.sh` | Add the `cj-cc-plugins` marketplace and install all Claude Code plugins                                                                                                                                             | Claude Code CLI                      |
| `install-skills.sh`         | Install the `playwright-cli` skill via `playwright-cli install --skills`                                                                                                                                            | `install-playwright-cli.sh`          |
| `verify-setup.sh`           | Run pytest, ruff, and shellcheck to confirm the setup works                                                                                                                                                         | `install-deps.sh`                    |

## Dependencies

```
install-uv.sh
├── install-python.sh
│   └── install-deps.sh
│       └── verify-setup.sh
install-jq.sh               (standalone)
install-taplo.sh            (standalone)
install-yamllint.sh         (requires install-deps.sh)
install-gh.sh               (standalone)
install-pnpm.sh
├── install-prettier.sh
└── install-playwright-cli.sh
    └── install-skills.sh
install-claude-plugins.sh   (standalone — needs claude CLI)
```

## Common agent tasks

**Python environment only (no tooling):**

```bash
bash scripts/setup/install-uv.sh
bash scripts/setup/install-python.sh
bash scripts/setup/install-deps.sh
```

**Mermaid diagram verification only:**

```bash
bash scripts/setup/install-pnpm.sh
bash scripts/setup/install-playwright-cli.sh
bash scripts/setup/install-skills.sh
```

**Claude Code plugins only:**

```bash
bash scripts/setup/install-claude-plugins.sh
```

**Verify existing setup:**

```bash
bash scripts/setup/verify-setup.sh
```
