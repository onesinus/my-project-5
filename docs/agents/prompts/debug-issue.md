# Prompt: Debug an issue

## When to use

You have a failing test, bug report, or unexpected behaviour with a clear reproduction path.

## Template

```
Context:
- Issue: [brief description of the bug]
- Reproduction: [steps to reproduce or test command]
- Expected behaviour: [what should happen]
- Actual behaviour: [what actually happens]
- Error output: [paste error logs, stack traces]
- Relevant files: [paths to suspected files]

Task:
Debug this issue systematically.

1. Identify root cause — what line/assumption is wrong?
2. Propose a fix (minimal change)
3. Write or update a test that would have caught this
4. Verify the fix: run [test/lint/type-check commands]

Constraints:
- Minimal change — fix the root cause, not the symptoms
- Add a regression test so this bug cannot reappear
- Do not change existing test behaviour unless the bug is in the test

Output format:
Root cause → Fix → Test → Verification evidence
```

## Example

```
Context:
- Issue: GET /api/users returns 500 when users table is empty
- Reproduction: bash scripts/test.sh --integration
- Expected behaviour: Returns empty array []
- Actual behaviour: Internal server error (500)
- Error output: TypeError: Cannot read properties of null (reading 'map')
  at src/routes/users.ts:42
- Relevant files: src/routes/users.ts, src/services/user-service.ts

Task: Debug this issue systematically.
```
