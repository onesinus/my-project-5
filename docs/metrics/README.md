# DORA Metrics

Track these four standard DevOps metrics to measure team velocity and stability.

## The Four Metrics

| Metric | What it measures | Target (Elite) | How we track it |
|---|---|---|---|
| **Deployment Frequency** | How often we deploy to production | On-demand (multiple/day) | Commits merged to main + deployments |
| **Lead Time for Changes** | Time from first commit to production | < 1 hour | First commit → merge → deploy timestamp |
| **Mean Time to Recovery (MTTR)** | Time to restore service after incident | < 1 hour | Incident start → resolved time |
| **Change Failure Rate** | % of deployments causing a failure | < 5% | Deployments that trigger a revert or incident |

## How to Measure

### Deployment Frequency

```bash
# Count deployments in the last N days
git log --oneline --since="7 days ago" --author="$(git log -1 --format='%an')" | wc -l

# Or use the release tags
git tag --sort=-creatordate | head -20
```

### Lead Time for Changes

For each PR, measure:
1. Time of first commit on the branch
2. Time of merge to main
3. Time of deployment to production

```bash
# Lead time for the last merged PR
git log --merges --first-parent main --oneline -1
```

### Change Failure Rate

```bash
# Count reverts as a proxy for failures
git log --oneline --grep="revert" --since="30 days ago" | wc -l
# Divide by total deployments in the same period
```

### MTTR

Tracked via incident records (see [incident-response.md](../runbooks/incident-response.md)).

## Dashboard

Recommended setup:
1. GitHub Actions exports metrics as JSON artifacts
2. A simple dashboard (Grafana, Datadog, or a static page) visualises them
3. Monthly retro reviews the trend

## Benchmark targets

| Level | Deploy Frequency | Lead Time | MTTR | Change Failure Rate |
|---|---|---|---|---|
| Elite | Multiple/day | < 1 hour | < 1 hour | < 5% |
| High | Once/day | < 1 day | < 1 day | < 10% |
| Medium | Once/week | < 1 week | < 1 week | < 15% |
| Low | Once/month | > 1 month | > 1 month | > 15% |

## Implementation checklist

- [ ] Track deployments (mark each production deploy)
- [ ] Tag releases consistently (`v0.1.0`, `v0.2.0`, etc.)
- [ ] Log incidents with start/end timestamps
- [ ] Run weekly metrics report
- [ ] Review trends at monthly retro
