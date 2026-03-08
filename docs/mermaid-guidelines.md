# Mermaid Diagram Guidelines

Designed for **GitHub dark mode** (background `#0d1117`). For `graph`/`flowchart` diagrams, always style nodes explicitly — never rely on Mermaid defaults.

## Palette

The 7-tier palette applies to `graph`/`flowchart` diagrams via `style` declarations. For `sequenceDiagram`, use `rect` blocks (see table below). For `classDiagram`, `stateDiagram`, and `erDiagram`, no fill palette styling is applied.

### 7-Tier Grayscale

Apply by **what a node does**, not which branch it's on. All tiers are visually distinct from the `#0d1117` background. Text flips from black to white between tiers 2 and 3.

| Tier | Role                    | `style` declaration                         |
| ---- | ----------------------- | ------------------------------------------- |
| 1    | Input / entry           | `fill:#e0e0e0,stroke:#ffffff,color:#000000` |
| 2    | Phase / section         | `fill:#b0b0b0,stroke:#d0d0d0,color:#000000` |
| 3    | Transform / action      | `fill:#808080,stroke:#a8a8a8,color:#ffffff` |
| 4    | Decision / control flow | `fill:#585858,stroke:#888888,color:#ffffff` |
| 5    | Output / result         | `fill:#404040,stroke:#686868,color:#ffffff` |
| 6    | Annotation / secondary  | `fill:#282828,stroke:#484848,color:#ffffff` |
| 7    | Terminal / endpoint     | `fill:#1c1c1c,stroke:#383838,color:#ffffff` |

### Accent Styles (Tokyo Night)

Accent colours are applied as **stroke-only on top of a standard grayscale tier fill** — never as fill values or text colour. Text colour follows the grayscale tier rule (tiers 1–2 → `#000000`, tiers 3–7 → `#ffffff`). Default to grayscale-only; only add an accent stroke when the semantic distinction genuinely matters. Keep accent usage to a minimum across any diagram.

**Priority order:** when you need N accent colours and no role fits, always take the first N from this list so diagrams stay consistent.

| Priority | Colour    | Role                  | Example `style` declaration                 |
| -------- | --------- | --------------------- | ------------------------------------------- |
| 1        | `#f7768e` | Error / dead-end      | `fill:#585858,stroke:#f7768e,color:#ffffff` |
| 2        | `#e0af68` | Warning / highlighted | `fill:#585858,stroke:#e0af68,color:#ffffff` |
| 3        | `#9ece6a` | Success / positive    | `fill:#585858,stroke:#9ece6a,color:#ffffff` |
| 4        | `#7aa2f7` | Info / in-progress    | `fill:#585858,stroke:#7aa2f7,color:#ffffff` |
| 5        | `#bb9af7` | Purple / categorical  | `fill:#585858,stroke:#bb9af7,color:#ffffff` |
| 6        | `#73daca` | Teal / neutral        | `fill:#585858,stroke:#73daca,color:#ffffff` |
| 7        | `#ff9e64` | Orange / caution      | `fill:#585858,stroke:#ff9e64,color:#ffffff` |

**Rules:**

- Roles take precedence over order — if a node's semantic fits a role, use that role's colour regardless of its position in the priority list.
- When no role fits, pick the next unused colour in priority order.
- The grayscale fill tier is chosen independently by node role (see 7-Tier Grayscale above) — the accent only affects the stroke.
- In `sequenceDiagram`, accent colours are not used in `rect` blocks — only tiers 4–6 grayscale `rect` values are permitted.

### `sequenceDiagram` rect backgrounds (tiers 4–6 only)

| Tier | Role                    | `rect rgb(...)`        |
| ---- | ----------------------- | ---------------------- |
| 4    | Decision / control flow | `rect rgb(88, 88, 88)` |
| 5    | Output / result         | `rect rgb(64, 64, 64)` |
| 6    | Annotation / secondary  | `rect rgb(40, 40, 40)` |

Tiers 1–3 and 7 are not used in `sequenceDiagram` rect blocks — tiers 1–3 are too light to provide useful contrast as region backgrounds against node fills, and tier 7 is too close to the `#0d1117` canvas background.

Off-palette rgb values are not permitted — they break palette consistency even if visually similar.

## Semantic Role Rules

- **Decision diamonds** `{...}` always use tier 4 — never error or output tiers
- **Sibling nodes of the same role** must share the same tier — no mixing within a role class
- **Never mix fill and stroke from different tiers** on the same node
- **Subgraph backgrounds** use tier 6 or 7 to recede behind foreground nodes
- **Highlights** override tier style entirely — use sparingly (max ~20–30% of nodes in a diagram)
- **Ambiguous roles:** When a node's role does not map cleanly to any tier, assign the tier of the closest functional equivalent and apply that tier consistently across all similar nodes in the diagram.

## Syntax Rules

### Universal

- Apply `style <id> fill:...,stroke:...,color:...` explicitly to every node in `graph`/`flowchart` diagrams
- **Line breaks in node labels:** Use `<br/>` inside `["..."]` labels, not `\n` — `\n` renders as literal text
- **Edge label quotes:** Use `|label text|` without quotes — quoted labels render with poor contrast
- **Edge style:** Do not apply `linkStyle` unless a specific edge needs semantic emphasis — default edge stroke is acceptable.
- **Subgraph fill:** Apply `style <subgraph-id> fill:...,stroke:...,color:...` to the subgraph id using tier 6 or 7; note that some renderers ignore subgraph stroke.

### `sequenceDiagram`

- Use `rect rgb(r,g,b)` blocks for background regions — values must match the table above exactly
- Return arrows always go back to the direct caller — the participant that sent the most recent request, not the chain originator.
- Declare explicit `participant` blocks to avoid ambiguous return targets

### `classDiagram`

- `---` inside class body blocks is invalid syntax — use `+returns ...` as a regular member instead
- Member syntax: `+name : type`, not `+type name` — Mermaid treats the first token after `+` as the member name
- Methods use `+methodName(paramType) ReturnType` — do not use `:` for methods, only for fields.

## Verification

Render diagrams using a local HTTP server + playwright-cli (no Node dependency required).

**Step 1: Write the diagram to an HTML file**

```python
# Write to /tmp/diagram_preview.py, then: uv run /tmp/diagram_preview.py
diagram = """graph TD
    ...
"""

html = f"""<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><style>body {{ background: #0d1117; margin: 0; padding: 20px; }}</style></head>
<body>
<div class="mermaid">{diagram}</div>
<script type="module">
  import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
  mermaid.initialize({{ startOnLoad: true, theme: 'dark' }});
</script>
</body>
</html>"""

with open('/tmp/diagram.html', 'w') as f:
    f.write(html)
```

**Step 2: Serve and screenshot with playwright-cli**

```bash
# Start server (in background)
uv run python -m http.server 9731 --directory /tmp &

# Open, wait for render, screenshot
playwright-cli open "http://localhost:9731/diagram.html"
playwright-cli run-code "async page => { await page.waitForSelector('.mermaid svg', {timeout: 10000}); }"
playwright-cli screenshot --filename=/tmp/diagram.png
playwright-cli close

# Stop server
kill $(lsof -ti:9731)
```

**Step 3: Review the screenshot**

- All 7 grayscale tiers are visually distinct from each other and from the background
- Text is legible on every node (no low-contrast label)
- Accent-stroked nodes have a visible coloured border matching their role colour
- No two adjacent nodes of different tiers look identical
- No `\n` rendered as literal text in any label

**Step 4: Clean up**

```bash
rm /tmp/diagram.html /tmp/diagram.png
rm -f .playwright-cli/*.yml .playwright-cli/*.log
```
