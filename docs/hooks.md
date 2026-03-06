# Hooks

Two categories of hooks are active in this project, plus an LSP plugin.

## Claude Code hooks (`scripts/tools/`)

Configured in `.claude/settings.json` (shared, checked into the repo). Scripts live in `scripts/tools/`.

| Hook | Trigger | Script | Behaviour |
|---|---|---|---|
| PreToolUse | `Bash` tool | `block-no-verify.sh` | Blocks `git commit --no-verify` so pre-commit hooks always run. |
| PostToolUse | `Write` or `Edit` tool | `post-write-lint.sh` | Auto-fixes ruff violations on `.py` writes; auto-formats then prose-lints `.md` writes; runs shellcheck on `.sh` writes; auto-formats `.toml` writes with taplo; auto-fixes then lints `.yaml`/`.yml` writes with yamlfix + yamllint; runs actionlint on writes to `.github/workflows/` files. Type checking is handled live by the `basedpyright-lsp` plugin — no need to re-run basedpyright on every write. |

ruff auto-fixes what it can; unfixable violations still block the edit. mdformat auto-formats in place. proselint findings are warnings only — they never block an edit or commit.

## basedpyright LSP plugin

A plugin from the [`cj-cc-plugins`](https://github.com/chirgjn/claude-code-plugins) marketplace that runs `basedpyright-langserver` via `uv run`, giving Claude real-time type diagnostics and code navigation (go to definition, find references, hover) without needing a global install. Install with `claude plugin install basedpyright-lsp@cj-cc-plugins --scope project`. The setup script (`scripts/setup/install-claude-plugins.sh`) handles this automatically.

A `SessionStart` hook verifies `basedpyright-langserver` is available in the uv-managed venv. If it's missing, it prints a reminder to run `uv sync`.

## Git hooks (managed by prek)

Git hooks are managed by [prek](https://github.com/peterdemin/prek), a fast pre-commit framework. The hook configuration lives in `.pre-commit-config.yaml` at the repo root.

### Pre-commit

| Hook | Behaviour |
|---|---|
| `ruff` | Auto-fixes staged `.py` files; unfixable violations block the commit |
| `basedpyright` | Runs basedpyright (blocking) on all `.py` files |
| `mdformat` | Auto-formats staged `.md` files in place |
| `shellcheck` | Runs shellcheck (blocking) on staged `.sh` files |
| `taplo` | Auto-formats staged `.toml` files in place |
| `yamllint` | Auto-fixes staged `.yaml`/`.yml` files with yamlfix, then lints with yamllint (blocking) |
| `actionlint` | Lints staged `.github/workflows/` files with actionlint (blocking) |
| `proselint` | Runs proselint (warn only) on staged `.md` files — never blocks a commit |

If a basedpyright or unfixable ruff error blocks a commit, fix it manually:

```bash
uv run basedpyright              # inspect type errors
```

`basedpyright` exits 1 on any warning by default. `pyrightconfig.json` in the repo root selectively suppresses known-noise rules while keeping genuine errors active. To suppress a specific warning project-wide, add the rule to `pyrightconfig.json`. To suppress a single instance, use `# pyright: ignore[ruleName]` on the relevant line.

The hooks are installed automatically by `scripts/setup/install-deps.sh`. After a fresh clone, run:

```bash
bash scripts/setup/install-deps.sh
```

or the full setup:

```bash
bash scripts/setup.sh
```

To re-install hooks manually:

```bash
uv run prek install -t pre-commit -t post-merge -t post-checkout
```

### Post-merge / post-checkout

| Hook | Behaviour |
|---|---|
| `uv-sync` | Runs `uv sync` if `uv.lock` changed (fires on `git pull`, `git merge`, `git checkout`, `git switch`) |

## CI enforcement (GitHub Actions)

The `.github/workflows/lint.yml` workflow is the mandatory gate — it runs on every push and pull request to any branch. Even if a developer skips local hook setup, CI will catch lint and formatting issues before code can land.

| Check | Behaviour |
|---|---|
| `ruff check` | Blocking — fails the workflow on any violation |
| `basedpyright` | Blocking — fails the workflow on any type error |
| `mdformat --check` | Blocking — fails if any Markdown file isn't formatted (verify mode, no rewrite) |
| `pytest` | Blocking — fails the workflow on any test failure |
| `shellcheck` | Blocking — fails the workflow on any shell script violation |
| `taplo lint` | Blocking — fails if any TOML file has lint errors |
| `yamllint` | Blocking — fails if any YAML file has lint errors |
| `actionlint` | Blocking — fails if any GitHub Actions workflow has lint errors |

proselint is **not** run in CI — it remains a local-only tool (Claude Code hook and git pre-commit).

Local hooks remain the fast feedback loop for developers; CI is the enforcement backstop.
