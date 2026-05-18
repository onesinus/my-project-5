---
name: tdd-workflow
description: Build a feature using TDD (red-green-refactor). Use when building a new feature, implementing a function, or writing code.
---

## Workflow

1. **Understand spec** — Read `docs/specs/` or acceptance criteria
2. **Write failing tests (RED)** — Start with happy path, one test at a time
3. **Implement (GREEN)** — Simplest code to pass the test
4. **Refactor** — Clean up, remove duplication, check patterns
5. **Verify** — Run `bash scripts/lint.sh`, `bash scripts/type-check.sh`, `bash scripts/test.sh`
6. **Commit** — Conventional commit: `feat(scope): description`

## Rules
- Write the test BEFORE the implementation
- Every public function must have a test
- Follow the Arrange-Act-Assert pattern
- Use `tests/unit/` for pure logic, `tests/integration/` for database/service calls

Full details: `docs/agents/skills/tdd-workflow.md`
