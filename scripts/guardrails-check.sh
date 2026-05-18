#!/usr/bin/env bash
set -euo pipefail

# Guardrails Check
# Validates AI-generated code against project standards.
# Usage: bash scripts/guardrails-check.sh [--ci] [--fix]

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
PASS=0
FAIL=0
WARN=0

pass() { echo -e "${GREEN}[PASS]${NC} $1"; PASS=$((PASS+1)); }
fail() { echo -e "${RED}[FAIL]${NC} $1"; FAIL=$((FAIL+1)); }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; WARN=$((WARN+1)); }

CI_MODE=false
if [[ "${1:-}" == "--ci" ]]; then
  CI_MODE=true
fi

echo "=== Guardrails Check ==="
echo ""

# ------------------------------------------------------------------
# 1. Destructive operations in staged/new files
# ------------------------------------------------------------------
echo "--- Destructive operations check ---"

if git rev-parse --git-dir > /dev/null 2>&1; then
  STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null || true)
  UNSTAGED_FILES=$(git diff --name-only --diff-filter=ACM 2>/dev/null || true)
  ALL_CHANGED=$(echo -e "$STAGED_FILES\n$UNSTAGED_FILES" | sort -u | grep -v '^$' || true)

  if [ -n "$ALL_CHANGED" ]; then
    DESTRUCTIVE=$(grep -rn \
      -e 'DROP TABLE\|DROP DATABASE\|TRUNCATE TABLE' \
      -e 'DELETE FROM' \
      -e "rm -rf /\|rm -rf \*" \
      -e "UPDATE .* SET" \
      -e 'GRANT ALL PRIVILEGES' \
      $ALL_CHANGED 2>/dev/null \
      | grep -v '\.md:\|\.yml:\|guardrails-check\.sh:' \
      || true)

    if [ -n "$DESTRUCTIVE" ]; then
      fail "Found potentially destructive operations:"
      echo "$DESTRUCTIVE"
    else
      pass "No destructive operations detected"
    fi
  else
    pass "No changed files to check"
  fi
else
  warn "Not a git repository — skipping destructive ops check"
fi

# ------------------------------------------------------------------
# 2. Test coverage check (new source files must have corresponding tests)
# ------------------------------------------------------------------
echo ""
echo "--- Test coverage check ---"

if [ -n "${ALL_CHANGED:-}" ]; then
  MISSING_TESTS=0
  while IFS= read -r file; do
    if [[ "$file" =~ ^src/(.+)\.(ts|tsx|js|jsx|py|go|rs|java)$ ]]; then
      base="${BASH_REMATCH[1]}"
      ext="${BASH_REMATCH[2]}"
      test_file_found=false
      for test_dir in tests/unit tests/integration; do
        for test_ext in "test.$ext" "spec.$ext" "_test.go" "_test.py" "Test.java"; do
          if [ -f "$test_dir/${base}.$test_ext" ] || [ -f "$test_dir/${base}_test.$ext" ] || [ -f "$test_dir/${base}_test.go" ] || [ -f "$test_dir/${base}_test.py" ]; then
            test_file_found=true
            break 2
          fi
        done
      done
      if [ "$test_file_found" = false ]; then
        warn "No test file found for: $file"
        MISSING_TESTS=$((MISSING_TESTS+1))
      fi
    fi
  done <<< "$ALL_CHANGED"

  if [ "$MISSING_TESTS" -gt 0 ]; then
    if [ "$CI_MODE" = true ]; then
      fail "$MISSING_TESTS source file(s) missing corresponding tests"
    else
      warn "$MISSING_TESTS source file(s) missing corresponding tests (advisory in local mode)"
    fi
  else
    pass "All new source files have corresponding tests"
  fi
else
  pass "No changed files — skipping test coverage check"
fi

# ------------------------------------------------------------------
# 3. Debug code check
# ------------------------------------------------------------------
echo ""
echo "--- Debug code check ---"

if [ -n "${ALL_CHANGED:-}" ]; then
  DEBUG_PATTERNS=$(grep -rn \
    -e 'console\.log\|console\.debug\|console\.trace' \
    -e '\bdebugger\b' \
    -e 'print(' \
    -e 'TODO:' \
    -e 'FIXME:' \
    $ALL_CHANGED 2>/dev/null || true)

  if [ -n "$DEBUG_PATTERNS" ]; then
    warn "Found debug code / TODOs (review before merge):"
    echo "$DEBUG_PATTERNS"
  else
    pass "No debug code or TODOs detected"
  fi
else
  pass "No changed files — skipping debug code check"
fi

# ------------------------------------------------------------------
# 4. Hardcoded secrets check (quick scan — pre-commit detect-secrets is authoritative)
# ------------------------------------------------------------------
echo ""
echo "--- Secrets check (quick scan) ---"

if [ -n "${ALL_CHANGED:-}" ]; then
  SECRET_PATTERNS=$(grep -rn \
    -e 'api[_-]key\s*=\s*['\"'][^'\"]+['\"']' \
    -e 'password\s*=\s*['\"'][^'\"]+['\"']' \
    -e 'secret\s*=\s*['\"'][^'\"]+['\"']' \
    -e 'token\s*=\s*['\"'][^'\"]+['\"']' \
    --include="*.{ts,js,py,rs,go,java,tsx,jsx}" \
    $ALL_CHANGED 2>/dev/null || true)

  if [ -n "$SECRET_PATTERNS" ]; then
    fail "Potential hardcoded secrets detected:"
    echo "$SECRET_PATTERNS"
  else
    pass "No obvious secrets detected"
  fi
else
  pass "No changed files — skipping secrets check"
fi

# ------------------------------------------------------------------
# Summary
# ------------------------------------------------------------------
echo ""
echo "=== Summary ==="
echo -e "${GREEN}Passed:${NC} $PASS"
echo -e "${RED}Failed:${NC} $FAIL"
echo -e "${YELLOW}Warnings:${NC} $WARN"

if [ "$FAIL" -gt 0 ]; then
  echo ""
  echo "❌ Some guardrails failed. Fix before committing."
  exit 1
else
  echo ""
  echo "✅ All guardrails passed."
  exit 0
fi
