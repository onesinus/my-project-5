# Skill: TDD Workflow

Red-green-refactor loop for building features with AI assistance.

## Trigger

Developer says: "I need to build a feature following TDD."

## Workflow

```
┌─────────────────────┐
│ 1. Understand spec  │ ← Read docs/specs/ or acceptance criteria
└────────┬────────────┘
         ↓
┌─────────────────────┐
│ 2. Write tests      │ ← RED: tests fail (expected)
│   (failing)          │
└────────┬────────────┘
         ↓
┌─────────────────────┐
│ 3. Implement        │ ← GREEN: make tests pass
│   (minimal code)     │
└────────┬────────────┘
         ↓
┌─────────────────────┐
│ 4. Refactor         │ ← Clean up, check patterns
└────────┬────────────┘
         ↓
┌─────────────────────┐
│ 5. Verify           │ ← Run lint + type-check + all tests
└────────┬────────────┘
         ↓
┌─────────────────────┐
│ 6. Commit           │ ← Conventional commit
└─────────────────────┘
```

## Instructions for AI

### Phase 1 — Understand the spec

1. Read `docs/specs/` for any spec covering this feature. If none exists and acceptance criteria are unclear, ask the developer to write a spec first.
2. Read existing tests in `tests/` to understand conventions (naming, mock setup, assertion style).
3. Read the relevant `docs/adr/` for architecture decisions that constrain implementation.

### Phase 2 — Write failing tests (RED)

- Write one test at a time, starting with the most basic happy path.
- Use `tests/unit/` for pure logic, `tests/integration/` for database/service calls.
- Follow the Arrange-Act-Assert pattern explicitly.
- Uses descriptive names like `should_return_201_when_user_registers_with_valid_data`.

### Phase 3 — Implement (GREEN)

- Write the simplest code that makes the test pass.
- Do not optimise prematurely. You are proving the test works.
- After each test passes, move to the next test.

### Phase 4 — Refactor

- Remove duplication. Rename for clarity. Extract functions where logic is reused.
- Re-check coding conventions in existing files.
- Run tests after each refactoring step.

### Phase 5 — Verify

Run in order:
1. `bash scripts/lint.sh` — zero warnings
2. `bash scripts/type-check.sh` — zero errors
3. `bash scripts/test.sh` — all tests pass

### Phase 6 — Commit

```
git add -A
git commit -m "feat(scope): description

- TDD: [n] tests written before implementation
- Covers: [happy path, error cases]
"
```

## Exit criteria

- [ ] All acceptance criteria have corresponding tests
- [ ] Tests pass (unit + integration)
- [ ] Lint and type-check pass with zero warnings
- [ ] No secrets committed
- [ ] PR is under 400 lines (if not, split)
