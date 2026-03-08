# python-project-template

Generic Python project scaffold. Copy the repo, wire up the name in `pyproject.toml`, run `bash scripts/setup.sh`. Stack: uv, ruff, basedpyright, pytest, prek, Claude Code hooks.

## Structure

```
docs/             — guides and reference docs (see routing table below)
scripts/setup/    — one-shot environment installers
scripts/tools/    — lint/format wrappers invoked by hooks and pre-commit
pyproject.toml    — single source of truth for deps and tool config
pyrightconfig.json — basedpyright include/exclude
```

## Commands

```bash
uv run pytest tests/                   # run tests
uv run ruff check src/ tests/          # lint
uv run basedpyright                    # type-check
uv run ruff check --fix src/ tests/    # fix lint
```

Full reference: `docs/commands.md`

## Conventions

- `AGENTS.md` is the canonical agent instructions file; `CLAUDE.md` is a symlink (`ln -s AGENTS.md CLAUDE.md`) — never edit `CLAUDE.md` directly, never maintain two copies
- Invoke Python via `uv run` — never use `python` or `python3` directly; this ensures the managed virtual environment is always active (`docs/python-guide-uv.md`)
- Navigate code with the LSP tool for definitions, references, callers, and types — do not reach for Grep or Glob when LSP can answer more precisely; requires `uv sync`
- Never run `git commit --no-verify` — the PreToolUse hook blocks it; pre-commit hooks (ruff, basedpyright, prettier, shellcheck, taplo, yamllint, actionlint) are mandatory

## Routing

| When you are...                                         | Read                                    |
| ------------------------------------------------------- | --------------------------------------- |
| Setting up or updating your dev environment             | `docs/project-setup.md`                 |
| Running lint, test, or type-check commands              | `docs/commands.md`                      |
| Writing or naming variables, functions, parameters      | `docs/python-guide/naming.md`           |
| Adding type hints or annotating signatures              | `docs/python-guide/type-hints.md`       |
| Writing style-sensitive code (booleans, string splits)  | `docs/python-guide/style.md`            |
| Adding or modifying modules / deciding where code lives | `docs/python-guide/module-structure.md` |
| Writing, fixing, or reviewing tests                     | `docs/python-guide/tests.md`            |
| Browsing all Python conventions at once                 | `docs/python-guide/index.md`            |
| Adding or configuring type-checking suppressions        | `docs/basedpyright.md`                  |
| Creating or updating a PR                               | `docs/pr-process.md`                    |
| Reviewing a PR                                          | `docs/pr-review-guide.md`               |
| Writing an implementation plan                          | `docs/plans-guide.md`                   |
| Updating requirements or the PRD                        | `docs/prd-guide.md`                     |
| Adding or modifying architecture (modules, deps)        | `docs/architecture.md`                  |
| Adding/modifying Claude Code or git hooks               | `docs/hooks.md`                         |
| Invoking Python / avoiding uv antipatterns              | `docs/python-guide-uv.md`               |
| Adding Mermaid diagrams                                 | `docs/mermaid-guidelines.md`            |
| Working with Playwright                                 | `docs/playwright-cli-guidelines.md`     |
| Keeping docs up to date after structural changes        | `docs/maintenance.md`                   |
| Browsing architectural decisions and tool choices       | `docs/decisions/index.md`               |
| Finding or tracking an active implementation plan       | `docs/plans/index.md`                   |
| Finding or tracking a design doc                        | `docs/designs/index.md`                 |
| Finding or tracking a spec                              | `docs/specs/index.md`                   |
