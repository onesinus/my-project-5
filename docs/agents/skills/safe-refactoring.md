# Skill: Safe Refactoring

Refactor code with zero behaviour change using AI assistance.

## Trigger

Developer says: "Refactor this module" or "Clean up this code."

## Workflow

```
┌─────────────────────────┐
│ 1. Baseline tests       │ ← Run tests, confirm they pass
└────────┬────────────────┘
         ↓
┌─────────────────────────┐
│ 2. Analyse code         │ ← Identify smells, plan refactors
└────────┬────────────────┘
         ↓
┌─────────────────────────┐
│ 3. One refactor at a time│ ← Small, reversible steps
└────────┬────────────────┘
         ↓
┌─────────────────────────┐
│ 4. Test after each step │ ← Tests must still pass
└────────┬────────────────┘
         ↓
┌─────────────────────────┐
│ 5. Commit per step      │ ← Each refactor is its own commit
└────────┬────────────────┘
         ↓
┌─────────────────────────┐
│ 6. Final verification    │ ← Full test suite + lint
└─────────────────────────┘
```

## Instructions for AI

### 1. Baseline

```bash
bash scripts/test.sh          # Must pass before touching anything
bash scripts/lint.sh          # Note existing warnings (don't fix them in this PR)
```

### 2. Analyse and plan

Identify these code smells — but do not list ones that don't exist:

- **Long method/function** (> 30 lines) — can be extracted
- **Duplicate code** (same logic in > 1 place) — can be unified
- **Poor naming** (unclear or misleading names) — can be renamed
- **Deep nesting** (> 3 levels) — can use early returns or guard clauses
- **Large module** (> 300 lines) — can be split
- **Mutating parameters** — can return new values instead
- **Mixed concerns** (e.g., formatting + business logic in one function)

Prioritise the list by risk (lowest first):
1. Renames (safest — IDE tools handle references)
2. Extract function (mechanical, easy to verify)
3. Early returns / guard clauses (local change)
4. Split module (needs import changes — test carefully)
5. Remove duplication (may touch many files — do last)

### 3. One refactor at a time

For each refactoring step:

1. Describe what you are about to change and why
2. Make the change
3. Run `bash scripts/test.sh`
4. Only if tests pass, move to the next step
5. If a test fails, revert the change and try a different approach

### 4. Commit per step

```bash
git add -A
git commit -m "refactor(scope): extract [name] from [parent]

- Pure refactor: no behaviour change
- Tests pass before and after
"
```

### 5. Flag issues separately

If you find a bug during refactoring:
- Do NOT fix it — that changes behaviour
- Note it in a separate section: `BUG FOUND: [description]`
- The developer will create a separate PR for the bug fix

## Exit criteria

- [ ] All original tests still pass
- [ ] Lint/type-check pass (same or fewer warnings)
- [ ] Each refactoring step is a separate commit
- [ ] No behaviour changes introduced
- [ ] No bug fixes mixed in (noted separately)
