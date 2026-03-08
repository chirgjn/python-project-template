# Running Python with uv

Always invoke Python through `uv run` — never call `python` or `python3` directly.

## Invocation order of preference

1. `uv run <tool>` — standalone entry point: `uv run pytest tests/`
1. `uv run <script.py>` — run a script directly; for one-off edits write to `/tmp/` first
1. `uv run python -m <module>` — for modules with no standalone entry point
1. `uv run -` — inline stdin when a temp file is impractical:
   ```bash
   uv run - <<'EOF'
   print("hello")
   EOF
   ```

## Antipatterns to avoid

| Antipattern              | Why                                                       | Use instead                                    |
| ------------------------ | --------------------------------------------------------- | ---------------------------------------------- |
| `python3 -c '...'`       | Bypasses the uv-managed environment                       | `uv run -` with a heredoc                      |
| `python -c '...'`        | Bypasses the uv-managed environment                       | `uv run -` with a heredoc                      |
| `uv run python -c '...'` | Inline strings are hard to read and have quoting pitfalls | `uv run -` with a heredoc, or write to `/tmp/` |
| `uv run -c '...'`        | Same as above                                             | `uv run -` with a heredoc, or write to `/tmp/` |
| `python3 script.py`      | Bypasses the uv-managed environment                       | `uv run script.py`                             |
