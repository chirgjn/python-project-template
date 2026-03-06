# Naming

## Don't shadow Python builtins

Avoid using builtin names as field, variable, or parameter names. Shadowing a builtin makes it unavailable in that scope and causes confusing bugs.

```python
# Bad — shadows builtins.filter, builtins.list, builtins.id
class Config:
    filter: list = field(default_factory=list)

def process(list, id):
    ...

# Good — use descriptive names that reflect intent
class Config:
    filter_conditions: list[str] = field(default_factory=list)

def process(items, record_id):
    ...
```

Common builtins to avoid: `filter`, `map`, `list`, `dict`, `set`, `type`, `id`, `input`, `format`, `min`, `max`, `sum`, `len`, `range`, `zip`, `open`.
