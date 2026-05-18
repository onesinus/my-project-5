# Incident Response

## Severity levels

| Level | Description | Response time | SLA |
|---|---|---|---|
| SEV1 | Service down, data loss | Immediate | < 1 hour to mitigate |
| SEV2 | Feature degraded, partial outage | < 30 min | < 4 hours to fix |
| SEV3 | Cosmetic, low-impact bug | < 4 hours | < 1 week |

## Process

### 1. Detect
- Automated alert (monitoring dashboard)
- User report (support channel)
- Internal discovery

### 2. Triage
1. Acknowledge the alert
2. Determine severity level
3. Assign incident lead
4. Create incident channel (Slack/Discord)

### 3. Mitigate
1. **Stop the bleeding** — rollback, feature flag off, block traffic
2. **Document** — what happened, what was affected, current state
3. **Communicate** — status updates every 30 min for SEV1

### 4. Resolve
1. Apply fix (follow normal PR process but expedited)
2. Verify in staging
3. Deploy to production
4. Monitor for 30 min to confirm stability

### 5. Learn (within 48 hours)
1. Hold blameless post-mortem
2. Fill out [post-mortem template](#post-mortem-template)
3. Create action items
4. Track MTTR

## Post-mortem template

```md
# Post-mortem — {date}

**Incident:** {brief title}
**Severity:** SEV1 / SEV2 / SEV3
**Duration:** {start time} → {end time} ({total minutes})

## Summary
{1-2 paragraph description of what happened and impact}

## Timeline
- {time}: {event}
- {time}: {event}

## Root cause
{What caused the incident}

## Detection
{How was it detected? Automated alert? User report?}

## Mitigation
{What was done to stop the bleeding}

## Action items
| What | Owner | Tracked in |
|---|---|---|
| {Improvement} | @person | Issue #NNN |
```

## MTTR tracking

```bash
# Record MTTR in a local log or spreadsheet
date,severity,incident,duration_minutes
2026-01-15,SEV1,payment-gateway-down,45
2026-02-03,SEV2,slow-search-results,120
```

Monthly MTTR = sum of all incident durations / number of incidents
