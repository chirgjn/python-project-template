# basedpyright

Static type checking for this project uses [basedpyright](https://docs.basedpyright.com/), a stricter fork of pyright with additional rules and better defaults.

## Running

```bash
uv run basedpyright
```

Always invoke via `uv run` — never call `basedpyright` or `python` directly.

## Configuration

basedpyright is configured in `pyrightconfig.json` at the project root:

```json
{
  "include": ["src", "tests"],
  "extraPaths": ["scripts"],
  "exclude": ["scripts"]
}
```

- **`include`** — directories that are fully type-checked (`src` and `tests`)
- **`extraPaths`** — directories added to the import search path so imports from `scripts/` resolve correctly in `src`/`tests`
- **`exclude`** — directories skipped during type-checking (scripts are excluded because they are not part of the library surface)

**`include` is mandatory.** Without it, basedpyright treats the entire project tree — including `.venv/` — as the analysis root. This causes it to analyse all third-party packages, producing tens of thousands of errors and making the pre-commit hook take several minutes instead of seconds.

## Dependencies

basedpyright is a dev dependency in `pyproject.toml`:

```toml
[dependency-groups]
dev = [
    "basedpyright>=1.38.1",
    ...
]
```

Run `uv sync` to install.

## Fixing Errors

basedpyright errors must be resolved by fixing the code or adding accurate type annotations. Do not add `# type: ignore` or `# pyright: ignore` comments to suppress errors unless the root cause is genuinely unfixable (e.g., a missing third-party stub that cannot be installed).

When a suppression is unavoidable, use the most specific rule name available:

```python
value = some_untyped_lib.get_value()  # pyright: ignore[reportUnknownVariableType]
```

Never use a bare `# type: ignore` — it silences all checkers globally for that line.

### Do not use blanket `pyrightconfig.json` suppressions to silence errors

Setting a rule to `"none"` in `pyrightconfig.json` suppresses it for the entire project permanently. This hides future regressions. The correct fix is always to address the root cause.

### Do not use `--level error` to silence warnings

`--level error` hides all warnings, including real correctness signals like `reportUnusedCallResult`. Suppress noise at the rule level in `pyrightconfig.json` instead.

### Baseline file for untyped third-party libraries

When an entire third-party library lacks stubs and the resulting wave of warnings cannot be fixed by adding stubs, use the basedpyright baseline file to acknowledge them once:

```bash
uv run basedpyright --writebaseline
```

This writes `.basedpyright/baseline.json` recording the exact location and rule code of every current diagnostic. On subsequent runs, basedpyright suppresses any diagnostic that matches a baseline entry and exits 0. Commit the baseline file so the clean state is reproducible across clones.

Use the baseline only for warnings that are truly unfixable (missing third-party stubs). Do not use it to hide errors or warnings in project-owned code.
