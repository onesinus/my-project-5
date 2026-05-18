#!/usr/bin/env bash
set -euo pipefail
echo "=== Coverage: pytest-cov ==="
pip install -e ".[dev]" -q && python -m pytest --cov=src --cov-report=term --cov-report=html 2>&1
