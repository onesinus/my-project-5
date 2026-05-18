#!/usr/bin/env bash
set -euo pipefail
echo "Setting up project..."
pip install -e ".[dev]" -q 2>/dev/null || true
if command -v pre-commit &> /dev/null && [ -f ".pre-commit-config.yaml" ]; then
  echo "  Installing pre-commit hooks..."
  pre-commit install --hook-type pre-commit --hook-type commit-msg
fi
echo "Setup complete."
