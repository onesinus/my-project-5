#!/usr/bin/env bash
set -euo pipefail
echo "Bootstrapping project..."

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Run setup
"$SCRIPT_DIR/setup.sh"

# Create .env from example if it doesn't exist
if [ -f ".env.example" ] && [ ! -f ".env" ]; then
  cp .env.example .env
  echo "  Created .env from .env.example"
fi

echo "Bootstrap complete."
