# AI Agent Standards

Principles and conventions for using AI coding assistants in this project.

## Principles

1. **AI is a force multiplier, not a replacement.** Every AI-generated change must be reviewed and understood by a human before merging.
2. **Tests are non-negotiable.** AI must generate tests alongside production code. No tests = no merge.
3. **Security is shared responsibility.** AI can introduce vulnerabilities. Review all generated code for injection risks, hardcoded secrets, and auth bypasses.
4. **Document decisions, not implementations.** AI is great at writing code but bad at capturing *why*. Humans write ADRs; AI generates code.
5. **Small increments, fast feedback.** Keep AI-generated PRs under 400 lines. If a change is larger, decompose it into multiple PRs.
6. **You own what you ship.** The engineer pressing merge owns the quality of AI-generated output. Review it as if you wrote it yourself.

## When to use AI

| Scenario | AI recommended? | Notes |
|---|---|---|
| Boilerplate / scaffolding | Yes | AI excels at repetitive patterns |
| Unit tests for stable code | Yes | High ROI, low risk |
| Debugging with clear error | Yes | Provide the error + relevant context |
| Refactoring with no behavior change | Yes | Verify with tests after |
| Database migrations | Cautiously | Review for data loss, always test on copy |
| Architecture decisions | No | That's what ADRs and human discussion are for |
| Security-critical code (auth, crypto) | No | Human expert review required |
| Production data operations | Never | Runbooks only, human-executed |

## Prompting conventions

All prompts to AI assistants should follow this structure:

```
Context: [what the AI needs to know — files, ADRs, issue link]
Task: [what to do, one sentence]
Constraints: [language, framework, test requirements, guardrails]
Output format: [what the response should look like]
```

### Good example

```
Context: I'm adding a POST /api/checkout endpoint to src/routes/checkout.ts.
The cart logic lives in src/services/cart.ts. Existing tests use Jest.
Task: Add the checkout endpoint with full test coverage.
Constraints: TypeScript, Express, must handle validation errors,
must not modify the cart service interface.
Output format: Code changes grouped by file, then test instructions.
```

### Bad example

```
Write a checkout API.
```

## Required reviews

| Change type | Review needed | AI-only? |
|---|---|---|
| Boilerplate / config | Light review | OK |
| Unit tests | Peer review | OK after review |
| Business logic | Peer review + passing CI | No |
| Database schema | Peer review + ADR | No |
| Security / auth | Security team review | No |
| Infrastructure / deployment | Platform team review | No |
