---
name: incident-response
description: Debug and respond to production incidents. Use when investigating a bug, outage, or unexpected behaviour in production.
---

## Safety rules
- **Never** write code that modifies production data without explicit human confirmation
- Never suggest DROP, DELETE, UPDATE without WHERE
- Never bypass authentication or authorisation

## Workflow

1. **Classify severity** — Sev1 (outage/data loss) < 15min, Sev2 (degraded) < 1hr, Sev3 (minor) next day
2. **Gather signals** — Logs, metrics, error traces, recent deploys
3. **Identify impact** — Who is affected? Is data at risk?
4. **Find root cause** — Code change? Data issue? Dependency? Config? Scale?
5. **Mitigate** — Rollback, feature flag off, hotfix, scale up
6. **Document** — Post-mortem in `docs/runbooks/`

Full details: `docs/agents/skills/incident-response.md`
