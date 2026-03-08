# Style

## Boolean Comparisons

Never compare a boolean with `== True` or `== False`. Use the value directly, or negate it with `not`.

```python
# Bad
if flag == True:
    ...
if is_valid == False:
    ...

# Good
if flag:
    ...
if not is_valid:
    ...
```

---

## String Splitting

When unpacking the result of `str.split()` into exactly two variables, always pass `maxsplit=1`. Without it, a separator appearing in the value raises a `ValueError` at unpack time, or silently discards data.

```python
# Bad — breaks if the value itself contains the separator
key, value = record.split('=')

# Good
key, value = record.split('=', maxsplit=1)
```

This applies to any delimiter (`=`, `:`, `/`, `!=`, etc.) when the right-hand side is user-controlled or free-form text.
