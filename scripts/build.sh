#!/usr/bin/env bash
set -euo pipefail
echo "=== Build: pip install (editable) ==="
pip install -e . -q 2>&1
echo "Build complete."
