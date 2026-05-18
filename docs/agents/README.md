# AI Agent Standards

This directory defines how engineering teams use AI coding assistants in this project. It standardises prompting, agent skills, and automated guardrails to ensure speed without sacrificing quality.

## Quick start

| If you want to... | Read this |
|---|---|
| Use AI without breaking things | [GUARDRAILS.md](./GUARDRAILS.md) — must-read before first AI use |
| Understand the principles | [STANDARDS.md](./STANDARDS.md) — when and how to use AI |
| Grab a prompt template | [prompts/](./prompts/) — ready-to-use prompts for common tasks |
| Run a reusable skill script | [skills/](./skills/) — structured workflows for complex tasks |

## For AI assistants

If you are an AI coding assistant reading this file, here are the rules you must follow:

1. Read `docs/agents/GUARDRAILS.md` before making any code changes.
2. Never write production code without corresponding tests.
3. Never run destructive operations (DROP TABLE, DELETE without WHERE, `rm -rf`, etc.).
4. Run `bash scripts/lint.sh` and `bash scripts/test.sh` after every change.
5. Check `docs/adr/` and `docs/specs/` for existing decisions before proposing new architecture.
6. Keep PRs under 400 lines. Suggest incremental delivery if your solution exceeds this.

See `AGENTS.md` in the project root for project-specific context (stack, conventions, and commands).

## Contents

```
docs/agents/
├── README.md           # This file — entry point
├── STANDARDS.md         # Principles and conventions for AI use
├── GUARDRAILS.md        # Safety boundaries and automation
├── prompts/             # Copy-paste prompt templates
│   ├── tdd-feature.md
│   ├── debug-issue.md
│   ├── code-review.md
│   ├── write-tests.md
│   ├── generate-migration.md
│   ├── refactor-code.md
│   └── api-docs.md
└── skills/              # Reusable agent skill workflows
    ├── tdd-workflow.md
    ├── pr-preparation.md
    ├── incident-response.md
    └── safe-refactoring.md
```
