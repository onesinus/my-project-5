#!/usr/bin/env bash
set -euo pipefail
echo "=== Dev server: FastAPI ==="
uvicorn src.main:app --reload
