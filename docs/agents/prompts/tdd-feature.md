# Prompt: Build a feature with TDD

## When to use

You have a clear feature requirement and want to build it test-first.

## Template

```
Context:
- Feature: [one-line description]
- Acceptance criteria:
  1. [criterion 1]
  2. [criterion 2]
- Existing files to reference: [paths to related code]
- Test framework: [e.g. Jest, pytest, Go testing]

Task:
Build this feature using TDD (red-green-refactor).

Phase 1 — Write tests first:
- Write failing tests that cover all acceptance criteria
- Tests should be in tests/unit/ or tests/integration/ as appropriate
- Include: happy path, error cases, edge cases

Phase 2 — Write implementation:
- Make the tests pass with the simplest correct implementation
- Follow existing code patterns in src/

Phase 3 — Refactor:
- Clean up without breaking tests
- Check for: duplicate code, naming, error handling, type safety

Constraints:
- Do not skip Phase 1
- Every public function must have a test
- Run lint and type-check after implementation
- Keep changes focused — do not modify unrelated files

Output format:
Show the test file first, then the implementation. Highlight any refactoring done in Phase 3.
```

## Example

```
Context:
- Feature: User registration endpoint with email + password
- Acceptance criteria:
  1. POST /api/auth/register creates a user and returns 201
  2. Returns 409 if email already exists
  3. Returns 422 if password < 8 characters
- Existing files to reference: src/routes/auth.ts, src/models/user.ts
- Test framework: Jest + Supertest

Task: Build this feature using TDD...
```
