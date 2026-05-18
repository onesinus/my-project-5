# Prompt: Write tests for existing code

## When to use

You have production code that lacks test coverage and want to add it.

## Template

```
Context:
- Source file(s): [paths to files that need tests]
- Test framework: [e.g. Jest, pytest, Go testing, JUnit]
- Existing tests (if any): [paths to existing test files for reference]
- Coverage target: [e.g. 90% line coverage, all public functions]

Task:
Write tests for the following code. Target [coverage target].

Test structure:
- Unit tests for pure logic / utility functions (tests/unit/)
- Integration tests for database/external service calls (tests/integration/)
- Edge cases: empty state, error responses, boundary values, concurrency where applicable

Constraints:
- Do not modify production code in this prompt
- Use the same patterns as existing tests (mock setup, assertions, fixtures)
- Use descriptive test names: [function_name] should [expected_behaviour]
- Follow the Arrange-Act-Assert pattern

Output format:
Complete test file(s) that can be dropped into the test directory directly.
Highlight any production code issues found while writing tests (untestable patterns, missing error handling).
```

## Example

```
Context:
- Source file(s): src/services/pricing.ts, src/services/discount.ts
- Test framework: Jest
- Existing tests: tests/unit/services/pricing.test.ts (partial)
- Coverage target: 90% line coverage for all public functions

Task: Write tests for the following code...
```
