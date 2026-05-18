# Skill: PR Preparation

Prepare a pull request for review with all checks passing.

## Trigger

Developer says: "I'm ready to open a PR" or "Prepare this for PR."

## Workflow

```
┌─────────────────────────┐
│ 1. Self-review diff     │ ← Check for debug code, TODOs, secrets
└────────┬────────────────┘
         ↓
┌─────────────────────────┐
│ 2. Run all checks       │ ← lint → type-check → test → coverage
└────────┬────────────────┘
         ↓
┌─────────────────────────┐
│ 3. Write PR description │ ← What / Why / Testing
└────────┬────────────────┘
         ↓
┌─────────────────────────┐
│ 4. Label and assign     │ ← Add labels, set reviewers
└────────┬────────────────┘
         ↓
┌─────────────────────────┐
│ 5. Verify PR size       │ ← < 400 lines, else split
└─────────────────────────┘
```

## Instructions for AI

### 1. Self-review the diff

Check for these common AI-generated code issues:

- [ ] No hardcoded secrets, API keys, or credentials
- [ ] No `console.log`, `print()`, `debugger`, or `// TODO:` left in
- [ ] No commented-out code blocks
- [ ] No overly broad error handlers (e.g., bare `except:` or empty `catch {}`)
- [ ] No SQL injection vectors (use parameterized queries)
- [ ] No missing input validation on user-facing endpoints
- [ ] No circular dependencies between modules

### 2. Run all checks

Execute in order:

```bash
bash scripts/lint.sh
bash scripts/type-check.sh
bash scripts/test.sh
bash scripts/guardrails-check.sh
```

If any check fails, fix before proceeding.

### 3. Write PR description

Use this template:

```markdown
## What

[One-line summary of the change]

Closes #[issue-number]

## Why

[Why this change is needed]

## Testing

- [ ] Unit tests: [number] new, [number] modified
- [ ] Integration tests: [number] new, [number] modified
- [ ] Manual testing: [what was tested manually]

## Checklist

- [ ] Tests cover the change
- [ ] Lint/type-check pass
- [ ] Changes are backward compatible
- [ ] No new dependencies added
```

### 4. Add labels

Add at least one label:
- `feat` / `fix` / `chore` / `docs` / `refactor` / `test`
- `ai-assisted` — always add this for AI-generated PRs

### 5. Verify PR size

Count lines changed (excluding generated files, lockfiles, etc.):

```bash
git diff --stat main...HEAD
```

If > 400 lines:
- Identify the logical split points
- Suggest breaking into 2+ PRs
- Keep this PR focused on the smallest meaningful unit

## Exit criteria

- [ ] All automated checks pass
- [ ] PR description has What / Why / Testing
- [ ] Label `ai-assisted` applied
- [ ] PR size < 400 lines
- [ ] No secrets, debug code, or TODOs in diff
