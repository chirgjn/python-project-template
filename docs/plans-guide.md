# Plans Guide

Design plans live in `docs/plans/{YYYY-MM-DD}-{topic}.md`. They are written before implementation begins and are never deleted — they record how decisions were made.

---

## When to write a plan

Write a plan before:

- Implementing a non-trivial feature (more than one file or one task)
- Refactoring module boundaries or public APIs
- Any change with rollback risk

Skip a plan for:

- Simple bug fixes with an obvious solution
- Documentation-only changes
- Single-file mechanical changes (rename, move, format)

---

## File naming

```
docs/plans/{YYYY-MM-DD}-{topic}.md
```

- Date is when the plan was written, not when work starts
- Topic is lowercase, hyphen-separated (`module-restructure`, `add-auth`, `migrate-db`)
- One plan per feature or initiative — do not create separate design and implementation files unless the design phase is long enough to warrant its own artefact

---

## Plan structure

````markdown
# {Topic} Plan

**Goal:** One sentence — what will be true when this is done.

**Architecture:** How the solution is structured. What changes, what stays the same. Key design decisions.

**Tech Stack:** Languages, libraries, frameworks, tools involved.

---

### Task 1: {Short title}

**Files:**

- Create: `path/to/new_file.py`
- Modify: `path/to/existing_file.py`

**Step 1: {Action}**

{Commands or code. Be explicit — include exact file paths, expected output, and verification commands.}

```bash
uv run pytest tests/ -v
```
````

Expected: {what success looks like}.

**Step 2: Commit**

```bash
git add <files>
git commit -m "feat: ..."
```

---

### Task 2: ...

---

## Risk Notes

- {Edge case or breakage risk and mitigation}
- {Rollback strategy if something goes wrong}

## Sequencing

| Order | Task         | Depends On |
| ----- | ------------ | ---------- |
| 1     | Task 1 title | none       |
| 2     | Task 2 title | 1          |

```

______________________________________________________________________

## Writing good tasks

Each task should be:

- **Independently committable** — one logical change, one commit
- **Verifiable** — ends with a test run or command that confirms success
- **Explicit** — exact file paths, not "update the config file"
- **Ordered** — tasks should be sequenced so each one builds on a green baseline

The verification step at the end of each task is not optional. A plan without verification commands is not a plan — it is a wish list.

______________________________________________________________________

## Plans are immutable history

Once implementation starts, do not edit the plan to reflect what actually happened. If the implementation diverges from the plan, that is fine — the plan records the intent, not the outcome. Record divergences and actual decisions in the PR review artefacts (`docs/pr-reviews/`).
```
