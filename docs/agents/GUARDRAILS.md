# Guardrails — AI Safety Boundaries

Automated and documented boundaries that AI coding assistants must never cross.

## Fatal — hard block (automated)

These operations are **never allowed**, even when explicitly requested. Pre-commit hooks and CI will reject them.

| Operation | Why blocked | Detection |
|---|---|---|
| `DROP TABLE`, `DROP DATABASE`, `TRUNCATE` | Data loss | Pre-commit hook |
| `DELETE FROM <table>` without `WHERE` | Data loss | Pre-commit hook |
| `rm -rf /`, `rm -rf *` | System damage | Pre-commit hook |
| Hardcoded secrets / API keys | Security breach | `detect-secrets` hook |
| `UPDATE <table> SET` without `WHERE` | Data corruption | Pre-commit hook |
| `GRANT ALL PRIVILEGES` | Privilege escalation | Pre-commit hook |
| Disable auth / bypass middleware | Security bypass | Manual review required |
| `exec()`, `eval()` in production | Code injection | Lint rule |

## Strict — enforced in CI

These will fail CI if violated.

| Check | Enforcement | When |
|---|---|---|
| New `.ts/.py/.go` file without corresponding test | CI script checks `tests/` | Every PR |
| Coverage drops below threshold | CI coverage check | Every PR |
| Lint or type-check warnings | CI lint/type-check stages | Every PR |
| PR exceeds 400 lines | PR checks workflow | Every PR |
| `console.log`, `debugger`, `print()` in prod code | Lint rule | Pre-commit + CI |

## Advisory — flagged for human review

These produce warnings but don't block CI. The engineer must acknowledge before merging.

| Pattern | Why flagged |
|---|---|
| Large dependency added (`package.json` / `Cargo.toml` / `requirements.txt`) | Supply chain risk |
| Database migration in the same PR as business logic | Should be separate PR |
| Comment says "AI generated" or "TODO: fix later" | Known tech debt |
| No error handling on external calls | Production crash risk |
| File exceeds 300 lines | Likely should be decomposed |

## Guardrail automation

The following scripts enforce guardrails:

```bash
bash scripts/guardrails-check.sh    # Run all local guardrails
bash scripts/guardrails-check.sh --ci   # CI-specific checks
```

The following pre-commit hooks run automatically:

- `check-added-large-files` — rejects files > 500 KB
- `detect-secrets` — rejects committed secrets
- `guardrails-destructive` — blocks dangerous SQL/system commands
- `guardrails-test-requirement` — checks new code files have test files

## Override policy

Guardrails can be overridden only with:

1. A written justification in the PR description
2. Approval from the squad lead or tech lead
3. An ADR if the override is permanent

To temporarily bypass a guardrail (e.g., for a migration script):

```bash
# Add to commit message:
SKIP_GUARDRAIL=reason-here
```

Example: `SKIP_GUARDRAIL=migration-script` — only valid for migration-type scripts.
