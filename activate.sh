#!/usr/bin/env bash
set -euo pipefail

if [ "${BASH_SOURCE[0]:-}" = "$0" ]; then
  echo "이 파일은 실행하는 것이 아니라 source 해야 합니다."
  echo "사용법: source activate.sh"
  exit 1
fi

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$LAB_DIR/venv"

if [ ! -f "$VENV_DIR/bin/activate" ]; then
  echo "venv가 없습니다. 먼저 bash setup.sh 를 실행하세요."
  return 1
fi

source "$VENV_DIR/bin/activate"
echo "venv activated: $VIRTUAL_ENV"
