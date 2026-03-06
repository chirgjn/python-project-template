# Tests

## Use `pythonpath` in `pyproject.toml`, not `sys.path.insert`

`sys.path.insert` in test files breaks when pytest is invoked from a directory other than the repo root, and is incompatible with editable installs. Use pytest's built-in path management instead.

```python
# Bad — fragile, breaks outside repo root
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))
```

```toml
# Good — pyproject.toml
[tool.pytest.ini_options]
pythonpath = ["src", "scripts"]
```

With `pythonpath` set, test files can import project modules directly with no path manipulation.

______________________________________________________________________

## Suppress print output per-test, not globally

Redirecting `sys.stdout` before `unittest.main()` swallows test results — you won't see pass/fail output. Suppress `print()` at the individual test level using `@patch('builtins.print')` or a context manager.

```python
# Bad — redirects stdout before the runner, hiding all output
if __name__ == '__main__':
    sys.stdout = io.StringIO()
    unittest.main(verbosity=2)

# Good — suppress only within the test that needs it
@patch('builtins.print')
def test_logs_warning(self, mock_print):
    result = process(data)
    mock_print.assert_called()

# Entry point stays clean
if __name__ == '__main__':
    unittest.main(verbosity=2)
```

______________________________________________________________________

## Write precise assertions

Tautological conditions — those that are always true — give false confidence. Assertions must be specific enough to catch real regressions.

```python
# Bad — always True, catches nothing
self.assertTrue(isinstance(value, (int, type(value))))

# Good — enumerate the actual accepted types
self.assertIsInstance(value, int)
```

Prefer `assertIsInstance` over `assertTrue(isinstance(...))` — it produces a better failure message.

______________________________________________________________________

## Use `self.assertIsInstance`, not bare `assert isinstance`

Bare `assert` statements are silenced when Python runs with `-O` (optimised mode), which coverage runners can enable. They also produce no message on failure.

```python
# Bad — eliminated by -O; no failure message
assert isinstance(result, list)

# Good — always runs; prints a useful message on failure
self.assertIsInstance(result, list)
```

______________________________________________________________________

## Don't let `finally` swallow test failures

If a `finally` block raises (e.g. `os.unlink` raises `PermissionError` in CI), it replaces any assertion failure that was already propagating — the developer sees the wrong error.

```python
# Bad — PermissionError from unlink can mask the real failure
try:
    result = run(tmp_path)
    self.assertEqual(result, expected)
finally:
    os.unlink(tmp_path)

# Good — use a context manager; cleanup is automatic and silent
with tempfile.NamedTemporaryFile(delete=True) as f:
    result = run(f.name)
    self.assertEqual(result, expected)
```

______________________________________________________________________

## Keep imports at module level

Imports inside method bodies create shadowing risk, confuse type checkers, and add maintenance overhead. Move all imports to the top of the file.

```python
# Bad — import inside test method
def test_value_types(self):
    import numpy as np
    self.assertIsInstance(value, (int, np.integer))

# Good — import at module level
import numpy as np

class TestIO(unittest.TestCase):
    def test_value_types(self):
        self.assertIsInstance(value, (int, np.integer))
```

______________________________________________________________________

## Annotate `@patch` mock parameters

basedpyright reports `reportUnknownParameterType` on unannotated mock parameters. Annotate them as `MagicMock`.

```python
from unittest.mock import MagicMock, patch

# Bad — mock_print is untyped
@patch("builtins.print")
def test_logs_warning(self, mock_print):
    ...

# Good
@patch("builtins.print")
def test_logs_warning(self, mock_print: MagicMock) -> None:
    ...
```

______________________________________________________________________

## Decorate `setUp` with `@override`

`setUp` overrides `unittest.TestCase.setUp`. Without `@override`, basedpyright reports `reportImplicitOverride`.

```python
from typing import override

class TestMyModule(unittest.TestCase):
    @override
    def setUp(self) -> None:
        ...
```

______________________________________________________________________

## Assign discarded return values to `_`

basedpyright reports `reportUnusedCallResult` when a function's return value is silently discarded. Assign to `_` to signal intent.

```python
# Bad — return value silently discarded; basedpyright warns
f.write_text("content")

# Good
_ = f.write_text("content")
```
