# Architecture Decision Records

This directory contains Architecture Decision Records (ADRs) for this project.

## What is an ADR?

An ADR documents a significant decision that is:
- **Hard to reverse** — changing it later would be costly
- **Surprising without context** — a future reader would wonder "why?"
- **The result of a real trade-off** — genuine alternatives existed

## When to write one

| Decision type | ADR? |
|---|---|
| Choosing a database | Yes |
| Deciding on an integration pattern | Yes |
| Library choice (easily swapped) | No |
| Code style decisions | No |
| Bug fix approach | No |

## Index

| # | Title | Status |
|---|---|---|
| 0001 | Adopt Flow-First SDLC framework | accepted |
| 0002 | Scaffold update mechanism for generated projects | accepted |

## Template

```md
# {Title}

{1–3 sentences: context, decision, and why.}

**Status:** proposed | accepted | deprecated | superseded by ADR-NNNN

**Considered options:** {only if the rejected alternatives are worth remembering}

**Consequences:** {only if non-obvious downstream effects exist}
```

## Numbering

Use sequential numbering: `0001-title.md`, `0002-title.md`, etc.
