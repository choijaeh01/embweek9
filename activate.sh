#!/usr/bin/env bash
set -euo pipefail

if [ "${BASH_SOURCE[0]:-}" = "$0" ]; then
  echo "Do not run this file directly."
  echo "Usage: source activate.sh"
  exit 1
fi

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$LAB_DIR/venv"

if [ ! -f "$VENV_DIR/bin/activate" ]; then
  echo "venv not found. Run: bash setup.sh"
  return 1
fi

source "$VENV_DIR/bin/activate"
echo "venv activated: $VIRTUAL_ENV"
