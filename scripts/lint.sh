#!/usr/bin/env bash
set -euo pipefail
echo "=== Lint: ruff ==="
pip install ruff -q && ruff check src/ 2>&1
