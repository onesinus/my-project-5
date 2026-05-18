# Prompt: Refactor code without changing behaviour

## When to use

You have working code that needs cleanup — extracting functions, renaming, simplifying, removing duplication.

## Template

```
Context:
- Source file(s): [paths to files to refactor]
- Goal: [extract module / rename for clarity / reduce duplication / simplify conditional logic]
- Existing tests: [paths to test files for verification]

Task:
Refactor the following code with zero behaviour change.

Rules:
1. Run the existing tests before refactoring to confirm they pass
2. Make one refactoring change at a time (extract method, rename, etc.)
3. Run tests after each change to verify nothing broke
4. Do not change any external API, function signatures, or return types
5. Do not fix bugs during refactoring — note them separately

Output format:
List each refactoring step with:
- File:lines changed
- What was done (and why)
- Test result after this step

Guardrails:
- If you see a potential bug, flag it as a NOTE for a separate PR
- Do not combine refactoring with feature work
- Keep each refactoring PR small and focused on one concern
```

## Example

```
Context:
- Source file(s): src/services/checkout.ts (currently 480 lines)
- Goal: Extract payment processing into a separate module
- Existing tests: tests/unit/services/checkout.test.ts

Task: Refactor src/services/checkout.ts...
```
