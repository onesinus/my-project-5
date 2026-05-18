#!/usr/bin/env bash
set -euo pipefail

echo "=== PR Validation ==="

# Check branch name
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ ! "$BRANCH" =~ ^(feat|fix|chore|docs|refactor|test|perf)/ ]]; then
  echo "WARNING: Branch name should follow pattern: type/description"
  echo "  e.g. feat/add-login, fix/null-pointer"
fi

# Check for large files (exclude .git, dependency dirs, and build artifacts)
LARGE_FILES=$(find . -type f -size +500k ! -path './.git/*' ! -path '*/node_modules/*' ! -path '*/target/*' ! -path '*/vendor/*' ! -path '*/.gradle/*' ! -path '*/__pycache__/*' 2>/dev/null)
if [ -n "$LARGE_FILES" ]; then
  echo "WARNING: Large files detected:"
  echo "$LARGE_FILES"
fi

# Check commit messages
if git log -1 --pretty=%B | grep -qP '^fixup!'; then
  echo "ERROR: Contains fixup commits. Rebase before merging."
  exit 1
fi

echo "=== Validation complete ==="
