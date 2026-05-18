# my-project-5

Version 0.1.0



## Stack

- **Api:** Python + FastAPI (Python) >=0.115.0

## Quick reference

| Action | Command |
|---|---|
| Dev server | `bash scripts/run.sh` |
| Lint | `bash scripts/lint.sh` |
| Type check | `bash scripts/type-check.sh` |
| Tests | `bash scripts/test.sh` |
| Coverage | `bash scripts/coverage.sh` |
| Build | `bash scripts/build.sh` |
| Install deps | `bash scripts/setup.sh` |

## Project structure

```
.
├── src/               # Source code
├── tests/
│   ├── unit/          # Fast, isolated tests
│   ├── integration/   # Tests with real dependencies
│   ├── e2e/           # Full end-to-end flows
│   └── fixtures/      # Shared test data
├── docs/
│   ├── adr/           # Architecture Decision Records
│   ├── specs/         # Feature specifications
│   ├── runbooks/      # Operational procedures
│   ├── metrics/       # DORA metrics & retros
│   └── agents/        # AI agent standards and skills
├── scripts/           # Development scripts
└── AGENTS.md          # This file — AI agent context
```

## Conventions

- **Commits:** Conventional Commits (`feat(scope): message`, `fix(scope): message`, etc.)
- **PRs:** < 400 lines, What/Why/Testing sections, labeled
- **Branches:** `type/description` (e.g. `feat/add-login`)
- **Tests:** One `tests/` directory per layer (unit/integration/e2e)
- **Decisions:** ADRs in `docs/adr/` for architecture choices

## AI Agent Instructions

This project uses **Claude (opencode)** with **Full (pre-commit + CI)** guardrails.

### Required reading

1. **`docs/agents/GUARDRAILS.md`** — safety boundaries (read first)
2. **`docs/agents/STANDARDS.md`** — when and how to use AI
3. **`docs/agents/skills/`** — reusable workflows for common tasks
4. **`docs/agents/prompts/`** — prompt templates for consistent prompting

### Mandatory rules

1. **Tests required** — never write production code without corresponding tests.
2. **No destructive ops** — never write DROP TABLE, DELETE without WHERE, rm -rf, etc.
3. **Run checks** — run `bash scripts/lint.sh` and `bash scripts/test.sh` after every change.
4. **Check decisions first** — read `docs/adr/` and `docs/specs/` before proposing architecture changes.
5. **Small PRs** — keep under 400 lines. Split large changes into multiple PRs.
6. **Guardrails** — run `bash scripts/guardrails-check.sh` before committing.

### Common commands

| Action | Command |
|---|---|
| Lint | `bash scripts/lint.sh` |
| Type check | `bash scripts/type-check.sh` |
| Tests (all) | `bash scripts/test.sh` |
| Tests (unit) | `bash scripts/test.sh --unit` |
| Tests (integration) | `bash scripts/test.sh --integration` |
| Coverage | `bash scripts/coverage.sh` |
| Guardrails | `bash scripts/guardrails-check.sh` |
| Build | `bash scripts/build.sh` |
