#!/usr/bin/env bash
set -euo pipefail
echo "=== Type check: mypy ==="
pip install mypy -q && mypy src/ 2>&1
