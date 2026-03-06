# Type Hints

Annotate all function signatures and dataclass fields. Use the built-in generic forms available since Python 3.9 — no need to import from `typing`.

```python
# Bad — no hints, bare generics
def transform(df, conditions):
    ...

@dataclass
class Options:
    column_types: dict = field(default_factory=dict)
    columns_to_drop: list = field(default_factory=list)

# Good — annotated, specific generics
def transform(df: pd.DataFrame, conditions: list[str]) -> pd.DataFrame:
    ...

@dataclass
class Options:
    column_types: dict[str, str] = field(default_factory=dict)
    columns_to_drop: list[str] = field(default_factory=list)
```

Return types should always be annotated, including `-> None` for functions that don't return a value.
