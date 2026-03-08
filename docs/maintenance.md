# Maintenance Checklist

When making structural changes, keep these documents updated. Update docs in the same PR as the code change they describe.

<!-- NOTE: Some content in this file deliberately overlaps with contributors' global
     ~/.claude/CLAUDE.md. Do not remove that redundancy — other contributors won't
     have the same global instructions. -->

---

## Enforcement Hierarchy

Prefer mechanisms higher on this list — each level down drifts more:

```
1. Linter rules  — ruff, basedpyright (auto-enforced, zero drift)
2. Hooks         — prek pre-commit, Claude Code PostToolUse (auto-format on write/commit)
3. CI checks     — GitHub Actions lint.yml (catches what hooks miss)
4. Written rules — AGENTS.md, docs/ (last resort — requires humans to read)
```

Before writing a convention, ask: "Can a tool enforce this instead?"

---

## Update Triggers

| Document                      | Update when                                                                                   |
| ----------------------------- | --------------------------------------------------------------------------------------------- |
| `docs/architecture.md`        | Modules added, renamed, or responsibilities change                                            |
| `docs/python-guide/`          | New project-wide coding conventions established (edit the relevant topic file)                |
| `docs/basedpyright.md`        | basedpyright version, config keys, or suppression rules change                                |
| `docs/pr-process.md`          | PR artefact paths change                                                                      |
| `docs/pr-review-guide.md`     | Review workflow or artefact conventions change                                                |
| `docs/plans-guide.md`         | Plan format or conventions change                                                             |
| `docs/prd-guide.md`           | PRD update workflow or bump script behaviour changes                                          |
| `assets/prd.md`               | Requirements change — edit via the symlink, then run `uv run scripts/bump_prd.py` to version  |
| `docs/mermaid-guidelines.md`  | Mermaid diagram conventions change (keep in sync with `~/.claude/docs/mermaid-guidelines.md`) |
| `docs/project-setup.md`       | Toolchain, required tools, or Claude Code plugins change                                      |
| `scripts/setup/`              | Any change to `docs/project-setup.md` — keep scripts in sync                                  |
| `docs/hooks.md`               | Hook behaviour changes — Claude Code or git hooks added, removed, or modified                 |
| `AGENTS.md`                   | Anything that changes how to navigate or work in this repo                                    |
| `docs/decisions/index.md`     | A new ADR is written — add a row to the index                                                 |
| `docs/plans/index.md`         | A plan is created or archived — update the index row                                          |
| `docs/specs/index.md`         | A spec changes status (in-progress → live) or is added — update the index                    |
| `docs/decisions/<nnn>-*.md`   | The decision it records is superseded — set status to `Superseded by [NNN]` and write a new ADR |

---

## Auditing Checklist

Run periodically or before a structural change:

- [ ] Is `AGENTS.md` under 80 lines? If not, extract content to `docs/`
- [ ] Does every file in `docs/` appear in `AGENTS.md`'s routing table?
- [ ] Does every routing entry match an actual task (not just a filename)?
- [ ] Do all `docs/` path references resolve? (`grep -r 'docs/' AGENTS.md docs/`)
- [ ] Are historical artifacts in `docs/archive/`, not `docs/`?
- [ ] Is anything in `AGENTS.md` enforceable by a linter or hook instead?
- [ ] Does `docs/decisions/index.md` list every ADR in `docs/decisions/`?
- [ ] Does `docs/plans/index.md` list every active plan?
- [ ] Does `docs/specs/index.md` reflect the current location and status of every spec?
- [ ] Are deprecated or rejected designs in `docs/archive/designs/`, not deleted?
