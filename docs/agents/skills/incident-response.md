# Skill: Incident Response

AI-assisted triage and response for production incidents.

## Trigger

Developer says: "We have a production incident" or "Help me debug this outage."

## Workflow

```
┌─────────────────────────┐
│ 1. Classify severity    │ ← Sev1/Sev2/Sev3
└────────┬────────────────┘
         ↓
┌─────────────────────────┐
│ 2. Gather signals       │ ← Logs, metrics, error traces
└────────┬────────────────┘
         ↓
┌─────────────────────────┐
│ 3. Identify impact      │ ← What's broken? Who is affected?
└────────┬────────────────┘
         ↓
┌─────────────────────────┐
│ 4. Find root cause      │ ← Trace through code + data
└────────┬────────────────┘
         ↓
┌─────────────────────────┐
│ 5. Mitigate             │ ← Rollback, feature flag, hotfix
└────────┬────────────────┘
         ↓
┌─────────────────────────┐
│ 6. Document             │ ← Post-mortem in docs/runbooks/
└─────────────────────────┘
```

## Instructions for AI

**Critical rule**: AI must never suggest or execute operations on production data directly. All mitigations must go through a human.

### 1. Classify severity

| Severity | Definition | SLA |
|---|---|---|
| Sev1 | Complete outage, data loss, security breach | < 15 min response |
| Sev2 | Major feature degraded, some users affected | < 1 hour response |
| Sev3 | Minor issue, workaround available | Next business day |

### 2. Gather signals

Ask the developer for:
- Error logs and stack traces (from the monitoring tool)
- Recent deploys or config changes (check git log)
- Related metrics (latency, error rate, CPU/memory)
- Affected endpoints or features

### 3. Identify impact

- How many users/requests are affected?
- Is data at risk?
- Is this a regression (worked before)?
- Are there related alerts or dependent services failing?

### 4. Find root cause

Analyze the error along these axes:

- **Code change**: Did a recent deploy introduce this? `git log --oneline -20`
- **Data issue**: Missing migration, bad data, constraint violation
- **Dependency**: Downstream API, database, cache, message queue
- **Configuration**: Feature flag, environment variable, rate limit
- **Scale**: Traffic spike, resource exhaustion, thundering herd

For each hypothesis, ask: "What evidence would confirm or rule this out?"

### 5. Mitigate

| Mitigation | When to use | AI can... |
|---|---|---|
| Rollback deploy | Regression from recent deploy | Suggest commit to rollback to |
| Feature flag off | Feature behind flag causing issues | Tell human which flag to disable |
| Hotfix | Logic bug, needs immediate fix | Write the fix (human deploys) |
| Scale up | Resource exhaustion | Suggest scaling config (human executes) |
| Replay / repair data | Data corruption | Write repair script (human reviews + runs) |

### 6. Document

After mitigation, help write a post-mortem following the template in `docs/runbooks/incident-response.md`:

- What happened (timeline)
- Impact
- Root cause
- How it was fixed
- Preventive measures

## Safety rules

1. **Never** write code that modifies production data without explicit human confirmation
2. Never suggest `DROP`, `DELETE`, `UPDATE` without `WHERE` — flag as UNSAFE
3. Never bypass authentication or authorisation
4. If unsure, ask — do not guess
