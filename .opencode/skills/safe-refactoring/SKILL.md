---
name: safe-refactoring
description: Refactor code without changing behaviour. Use when cleaning up code, extracting functions, renaming, or reducing duplication.
---

## Workflow

1. **Baseline** — Run `bash scripts/test.sh` to confirm tests pass
2. **Analyse** — Identify smells (long functions, duplication, poor naming, deep nesting)
3. **One refactor at a time** — Rename → Extract → Guard clauses → Split module
4. **Test after each step** — Tests must pass after every individual change
5. **Commit per step** — `refactor(scope): description`
6. **Flag bugs separately** — Do not fix bugs during refactoring; note them

Full details: `docs/agents/skills/safe-refactoring.md`
