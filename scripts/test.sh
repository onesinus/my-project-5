#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

RUN_UNIT=false; RUN_INTEGRATION=false; RUN_E2E=false; COVERAGE=false; WATCH=false; EXTRA_ARGS=()

parse_args() {
  if [ $# -eq 0 ]; then RUN_UNIT=true; RUN_INTEGRATION=true; RUN_E2E=true; return; fi
  while [ $# -gt 0 ]; do
    case "$1" in
      --unit) RUN_UNIT=true; shift ;;
      --integration) RUN_INTEGRATION=true; shift ;;
      --e2e) RUN_E2E=true; shift ;;
      --all) RUN_UNIT=true; RUN_INTEGRATION=true; RUN_E2E=true; shift ;;
      --coverage) COVERAGE=true; shift ;;
      --watch) WATCH=true; shift ;;
      --) shift; EXTRA_ARGS=("$@"); break ;;
      *) EXTRA_ARGS+=("$1"); shift ;;
    esac
  done
  if [ "$RUN_UNIT" = false ] && [ "$RUN_INTEGRATION" = false ] && [ "$RUN_E2E" = false ]; then
    RUN_UNIT=true; RUN_INTEGRATION=true
  fi
}

run_pytest() { local marker="$1"; local args=("${EXTRA_ARGS[@]}"); $COVERAGE && args+=("--cov=src" "--cov-report=term"); [ -n "$marker" ] && args+=("-m" "$marker"); pip install -e ".[dev]" -q; python -m pytest "${args[@]}" 2>&1 | tail -20; }

parse_args "$@"
echo "=== Test runner: pytest ==="; echo ""
FAILURES=0
run_tests() { local label="$1" marker="$2"; echo "--- $label ---"; set +e; run_pytest "$marker"; local ec=$?; set -euo pipefail; [ $ec -ne 0 ] && FAILURES=$((FAILURES + 1)); echo ""; }
$RUN_UNIT && run_tests "Unit tests" "unit"
$RUN_INTEGRATION && run_tests "Integration tests" "integration"
$RUN_E2E && run_tests "E2E tests" "e2e"
echo "=== Done ==="; [ $FAILURES -gt 0 ] && echo "$FAILURES test layer(s) failed." && exit 1; echo "All tests passed."
