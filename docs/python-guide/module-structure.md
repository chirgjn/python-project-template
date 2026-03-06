# Module Structure

Separate concerns into distinct modules. A single file should not mix data definitions, transformation logic, orchestration, and demo code.

```
src/<package>/
  __init__.py
  config.py        # dataclasses, constants, enums
  transforms.py    # pure data transformation functions
  io.py            # I/O and orchestration (reads files, calls transforms)
  __main__.py      # demo / script entry point
```

Keep `if __name__ == '__main__':` blocks out of library modules. Move demos to `__main__.py` or a top-level `scripts/` directory.

```python
# Bad — demo code lives inside a library module
# src/mypackage/processor.py
def process(filepath, options): ...

if __name__ == '__main__':
    result = process('./data/sample.csv', Options())
    print(result)

# Good — library module is clean; demo lives separately
# scripts/run_example.py
from mypackage.processor import process, Options

result = process('./data/sample.csv', Options())
print(result)
```
