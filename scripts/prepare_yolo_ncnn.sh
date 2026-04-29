#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_PY="$LAB_DIR/venv/bin/python"

cd "$LAB_DIR"

if [ ! -x "$VENV_PY" ]; then
  echo "venv not found. Run: bash setup.sh"
  exit 1
fi

"$VENV_PY" examples/08_yolo_model_names.py
"$VENV_PY" examples/09_convert_to_ncnn.py
