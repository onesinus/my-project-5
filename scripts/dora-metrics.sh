#!/usr/bin/env bash
# DORA metrics calculator
# Usage: bash scripts/dora-metrics.sh [days]
# Default: last 30 days
set -euo pipefail

DAYS="${1:-30}"
SINCE=$(date -d "$DAYS days ago" +%Y-%m-%d 2>/dev/null || date -j -v-${DAYS}d +%Y-%m-%d)

echo "=== DORA Metrics (last $DAYS days, since $SINCE) ==="
echo ""

# 1. Deployment Frequency
echo "1. Deployment Frequency"
echo "-----------------------"
DEPLOYS=$(git log --oneline --since="$SINCE" --first-parent main 2>/dev/null | wc -l)
echo "   Commits to main: $DEPLOYS"
if [ "$DEPLOYS" -gt 0 ]; then
  FREQ=$(echo "scale=2; $DEPLOYS / $DAYS" | bc)
  echo "   Frequency: $FREQ deploys/day"
fi
echo ""

# 2. Lead Time for Changes
echo "2. Lead Time for Changes"
echo "------------------------"
RECENT=$(git log --merges --first-parent main --since="$SINCE" --format="%H" 2>/dev/null | head -5)
COUNT=0
LEAD_TOTAL=0
for MERGE in $RECENT; do
  MERGE_TIME=$(git log -1 --format="%ct" "$MERGE" 2>/dev/null)
  FIRST_COMMIT=$(git log "$MERGE" --not --ancestry-path=$(git merge-base "$MERGE" main^) 2>/dev/null | tail -1 | awk '{print $1}')
  if [ -n "$FIRST_COMMIT" ]; then
    FIRST_TIME=$(git log -1 --format="%ct" "$FIRST_COMMIT" 2>/dev/null)
    LEAD_SECS=$((MERGE_TIME - FIRST_TIME))
    LEAD_HOURS=$((LEAD_SECS / 3600))
    LEAD_TOTAL=$((LEAD_TOTAL + LEAD_HOURS))
    COUNT=$((COUNT + 1))
  fi
done
if [ "$COUNT" -gt 0 ]; then
  AVG=$((LEAD_TOTAL / COUNT))
  echo "   Average: ${AVG}h (from $COUNT PRs)"
else
  echo "   No PRs found in period"
fi
echo ""

# 3. Change Failure Rate (proxy: reverts / total deploys)
echo "3. Change Failure Rate"
echo "----------------------"
REVERTS=$(git log --oneline --since="$SINCE" --grep="revert" --first-parent main 2>/dev/null | wc -l)
if [ "$DEPLOYS" -gt 0 ]; then
  FAIL_RATE=$(echo "scale=2; $REVERTS * 100 / $DEPLOYS" | bc)
  echo "   Reverts: $REVERTS"
  echo "   Deploys: $DEPLOYS"
  echo "   Failure rate: ${FAIL_RATE}%"
fi
echo ""

# 4. Deployment tags
echo "4. Recent releases (tags)"
echo "-------------------------"
git tag --sort=-creatordate --format="%(refname:short) - %(creatordate:short)" 2>/dev/null | head -10
echo ""

echo "=== Done ==="
