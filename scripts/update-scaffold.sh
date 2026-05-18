#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
fail()  { echo -e "${RED}[FAIL]${NC} $1"; }

CHECK_ONLY=false
APPLY=false
HELP=false
for arg in "$@"; do
  case "$arg" in
    --check) CHECK_ONLY=true ;;
    --apply) APPLY=true ;;
    --help|-h) HELP=true ;;
  esac
done

if $HELP; then
  echo "Usage: bash scripts/update-scaffold.sh [--check] [--apply]"
  echo ""
  echo "  --check    Compare project files against latest scaffold (no changes)"
  echo "  --apply    Update files that haven't been locally modified"
  echo "  --help     Show this help"
  echo ""
  echo "Without flags, shows a summary of what would change."
  exit 0
fi

PROJECT_DIR=$(pwd)
MANIFEST="$PROJECT_DIR/MANIFEST.yml"
SCAFFOLD_VER_FILE="$PROJECT_DIR/.scaffold-version"
SCAFFOLD_SRC_FILE="$PROJECT_DIR/.scaffold-source"

if [ ! -f "$MANIFEST" ]; then
  fail "No MANIFEST.yml found. Is this a scaffold-generated project?"
  exit 1
fi

if [ ! -f "$SCAFFOLD_SRC_FILE" ]; then
  warn ".scaffold-source not found. Using default."
  SCAFFOLD_SOURCE="https://github.com/trinitywizards/sdlc-framework.git"
else
  SCAFFOLD_SOURCE=$(cat "$SCAFFOLD_SRC_FILE")
fi

CURRENT_VERSION="unknown"
if [ -f "$SCAFFOLD_VER_FILE" ]; then
  CURRENT_VERSION=$(cat "$SCAFFOLD_VER_FILE" | tr -d '[:space:]')
fi

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

info "Fetching latest scaffold from $SCAFFOLD_SOURCE ..."
if ! git clone --depth 1 --quiet "$SCAFFOLD_SOURCE" "$TMP_DIR/scaffold" 2>/dev/null; then
  fail "Failed to fetch scaffold. Check your network and .scaffold-source."
  exit 1
fi

LATEST_VERSION="unknown"
if [ -f "$TMP_DIR/scaffold/VERSION" ]; then
  LATEST_VERSION=$(cat "$TMP_DIR/scaffold/VERSION" | tr -d '[:space:]')
fi

echo ""
info "Current scaffold version: $CURRENT_VERSION"
info "Latest scaffold version:  $LATEST_VERSION"
echo ""

SCAFFOLD_MANIFEST="$TMP_DIR/scaffold/MANIFEST.yml"
if [ ! -f "$SCAFFOLD_MANIFEST" ]; then
  fail "No MANIFEST.yml found in latest scaffold."
  exit 1
fi

# Parse the manifest using pure Python (no yaml dependency needed)
PARSE_PY=$(cat << 'PYEOF'
import json, os, re, sys

manifest_path = sys.argv[1]
project_dir = sys.argv[2]

entries = []
current = {}
with open(manifest_path) as f:
    for line in f:
        m_path = re.match(r'^- path:\s*(.+)$', line)
        m_rendered = re.match(r'\s+rendered:\s*(.+)$', line)
        if m_path:
            if current:
                entries.append(current)
            current = {'path': m_path.group(1).strip(), 'rendered': False}
        elif m_rendered:
            val = m_rendered.group(1).strip().lower()
            current['rendered'] = val == 'true'
if current:
    entries.append(current)

# Filter to entries that exist in the project
filtered = [e for e in entries if os.path.exists(os.path.join(project_dir, e['path']))]
print(json.dumps(filtered))
PYEOF
)

MANIFEST_JSON=$(python3 -c "$PARSE_PY" "$SCAFFOLD_MANIFEST" "$PROJECT_DIR")
TOTAL=$(echo "$MANIFEST_JSON" | python3 -c "import sys,json; print(len(json.loads(sys.stdin.read())))")

echo "=== File comparison ==="
echo ""

CHANGED=0
CONFLICTS=0
UPDATED=0

while IFS='|' read -r path rendered; do
  [ -z "$path" ] && continue
  file_in_project="$PROJECT_DIR/$path"
  scaffold_file="$TMP_DIR/scaffold/$path"

  if [ ! -f "$scaffold_file" ]; then
    continue
  fi

  if [ ! -f "$file_in_project" ]; then
    echo "  + $path (new in scaffold)"
    CHANGED=$((CHANGED+1))
    if $APPLY; then
      mkdir -p "$(dirname "$file_in_project")"
      cp "$scaffold_file" "$file_in_project"
      UPDATED=$((UPDATED+1))
      echo "    added"
    fi
    continue
  fi

  if diff -q "$scaffold_file" "$file_in_project" > /dev/null 2>&1; then
    continue
  fi

  CHANGED=$((CHANGED+1))

  if git -C "$PROJECT_DIR" diff --quiet HEAD -- "$path" 2>/dev/null; then
    echo "  ~ $path (scaffold changed, project is clean)"
    if [ "$rendered" = "True" ] || [ "$rendered" = "true" ]; then
      echo "    (rendered file — manual merge recommended)"
    fi
    if $APPLY; then
      cp "$scaffold_file" "$file_in_project"
      UPDATED=$((UPDATED+1))
      echo "    updated"
    fi
  else
    echo "  ! $path (scaffold AND project changed — conflict)"
    echo "    Diff saved to $path.scaffold-latest.diff"
    diff -u "$file_in_project" "$scaffold_file" > "$PROJECT_DIR/$path.scaffold-latest.diff" 2>/dev/null || true
    CONFLICTS=$((CONFLICTS+1))
    if $APPLY; then
      echo "    SKIPPED — review and merge manually"
    fi
  fi
done < <(echo "$MANIFEST_JSON" | python3 -c "
import sys, json
for e in json.load(sys.stdin):
    print(f\"{e['path']}|{e['rendered']}\")
")

echo ""
echo "=== Summary ==="
echo "  Manifest files: $TOTAL"
echo "  Changed:        $CHANGED"
echo "  Updated:        $UPDATED"
echo "  Conflicts:      $CONFLICTS"

if [ "$CHANGED" -eq 0 ]; then
  echo ""
  ok "Project is up to date with scaffold version $LATEST_VERSION."
  exit 0
fi

echo ""
if $APPLY; then
  echo "$LATEST_VERSION" > "$SCAFFOLD_VER_FILE"
  ok "Updated .scaffold-version to $LATEST_VERSION."
  if [ "$CONFLICTS" -gt 0 ]; then
    warn "$CONFLICTS file(s) had conflicts — merge manually."
    exit 1
  fi
else
  info "Run with --apply to update clean files."
fi
