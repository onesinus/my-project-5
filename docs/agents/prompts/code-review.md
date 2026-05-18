# Prompt: Review code

## When to use

You need an AI-assisted code review on a PR or a set of changes.

## Template

```
Context:
- PR/Change: [description or diff]
- Language/Framework: [e.g. TypeScript + Express]
- Focus areas: [what concerns you most: security, performance, correctness, maintainability]

Task:
Review the following code for:

1. Correctness: Does the code do what it claims? Edge cases?
2. Security: Injection risks, auth bypass, secret exposure, input validation?
3. Error handling: Are errors caught, logged, and handled gracefully?
4. Maintainability: Is the code clear? Naming? Duplication? Too complex?
5. Test coverage: Are there tests for the changed paths? Missing cases?
6. Performance: N+1 queries, unnecessary allocations, sync in async context?

Output format:
For each issue: file:line — Severity (critical/major/minor) — Description — Suggestion

Start with critical issues, end with strengths (things done well).

Constraints:
- Be specific — reference exact lines
- Distinguish between "must fix" and "nice to have"
- Do not comment on formatting if linter covers it
```

## Example

```
Context:
- PR/Change: Adds POST /api/checkout endpoint (diff attached)
- Language/Framework: TypeScript + Express
- Focus areas: Security, data integrity
...
```
