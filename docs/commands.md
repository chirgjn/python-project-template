# Project Commands

```bash
uv run basedpyright                              # type-check
uv run pytest tests/                             # run tests
uv run pytest tests/ --cov=src --cov-report=term-missing  # with coverage
uv run ruff check src/ tests/                    # lint
uv run ruff check --fix src/ tests/              # fix lint
uv run shellcheck -x --source-path=scripts/setup scripts/*.sh scripts/setup/*.sh scripts/tools/*.sh
```
