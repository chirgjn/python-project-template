# PRD Guide

The PRD lives in `assets/prd.md` — a symlink to the current versioned file (`assets/prd_v{major}.{minor}.md`).

---

## How to update the PRD

1. Edit `assets/prd.md` (the symlink) directly — never create a new versioned file or copy.
1. When the changes are ready to be versioned, run the bump script:
   ```bash
   uv run scripts/bump_prd.py
   ```
   This renames the file, updates the symlink, patches the version header and date, and inserts a new row in the version history table.
1. Fill in the `_TBD_` placeholder in the new version history row with a description of the changes made.
1. Verify the PRD contents:
   - `**Version:**` header matches the new version
   - `**Date:**` header shows today's date
   - Version history table is in reverse chronological order (newest row at top)
   - The new row's Changes column is filled in (not `_TBD_`)

**Do not** manually rename the PRD file, recreate it, or touch the symlink — the bump script handles all of that atomically.

---

## PRD file format

The PRD file should open with a header block followed by a version history table:

```markdown
# Project Requirements Document

**Version:** 1.0
**Date:** January 1, 2026
**Status:** Active

---

## Version History

| Version | Date            | Author | Changes         |
| ------- | --------------- | ------ | --------------- |
| 1.0     | January 1, 2026 | Author | Initial version |

---

## 1. Overview

...
```

The bump script locates the `| Version | Date` table header to insert new rows. Keep this format intact.

---

## Creating the initial PRD

1. Create `assets/prd_v1.0.md` with the format above.
1. Create the symlink:
   ```bash
   ln -s prd_v1.0.md assets/prd.md
   ```
1. Commit both files:
   ```bash
   git add assets/prd_v1.0.md assets/prd.md
   git commit -m "docs: add initial PRD v1.0"
   ```

---

## Bump script behaviour

`scripts/bump_prd.py` performs a minor version bump (`1.0` → `1.1`, `2.9` → `2.10`):

1. Reads the current version from the symlink target filename
1. Renames the file (`prd_v1.0.md` → `prd_v1.1.md`)
1. Updates the symlink to point at the new filename
1. Patches `**Version:**` and `**Date:**` in the file header
1. Inserts a new `_TBD_` row at the top of the version history table
1. Updates any reference to the old filename in `CLAUDE.md`

For major version bumps, rename the file manually and update the symlink — the bump script only handles minor increments.
