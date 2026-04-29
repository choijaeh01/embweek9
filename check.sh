#!/usr/bin/env bash
set -u

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_PY="$LAB_DIR/venv/bin/python"
OUT_DIR="$LAB_DIR/outputs"
FAILURES=0

mkdir -p "$OUT_DIR"
cd "$LAB_DIR"

pass() {
  echo "PASS: $1"
}

fail() {
  echo "FAIL: $1"
  FAILURES=$((FAILURES + 1))
}

warn() {
  echo "WARN: $1"
}

run_check() {
  local name="$1"
  shift
  echo
  echo "== $name =="
  if "$@"; then
    pass "$name"
  else
    fail "$name"
  fi
}

echo "embweek9 environment check"
echo "Lab directory: $LAB_DIR"

echo
echo "== System =="
if [ -r /etc/os-release ]; then
  # shellcheck disable=SC1091
  source /etc/os-release
  echo "OS codename: ${VERSION_CODENAME:-unknown}"
else
  echo "OS codename: unknown"
fi
echo "Architecture: $(uname -m)"
echo "Python: $(python3 --version)"
if [ "$(uname -m)" != "aarch64" ]; then
  warn "This is not 64-bit Raspberry Pi OS(aarch64). YOLO/PyTorch may fail."
fi

run_check "rpicam-hello exists" command -v rpicam-hello
run_check "rpicam-still exists" command -v rpicam-still
run_check "rpicam-vid exists" command -v rpicam-vid
run_check "camera is detected" timeout 10 rpicam-hello --list-cameras
run_check "still image capture" timeout 20 rpicam-still --nopreview -t 1000 -o "$OUT_DIR/check_image.jpg"
run_check "h264 video capture" timeout 20 rpicam-vid --nopreview -t 3000 -o "$OUT_DIR/check_video.h264"

echo
echo "== Python venv =="
if [ -x "$VENV_PY" ]; then
  pass "venv exists"
else
  fail "venv missing. Run: bash setup.sh"
fi

if [ -x "$VENV_PY" ]; then
  run_check "Python packages" "$VENV_PY" scripts/check_python_packages.py
else
  warn "Skipping Python package checks because venv is missing."
fi

echo
echo "== YOLO files =="
if [ -f "$LAB_DIR/yolo11n.pt" ]; then
  pass "yolo11n.pt exists"
else
  warn "yolo11n.pt is missing. Run: python examples/08_yolo_model_names.py"
fi

if [ -d "$LAB_DIR/yolo11n_ncnn_model" ]; then
  pass "yolo11n_ncnn_model exists"
else
  warn "NCNN model is missing. Run: python examples/09_convert_to_ncnn.py"
fi

echo
echo "== Outputs =="
ls -lh "$OUT_DIR" || true

echo
if [ "$FAILURES" -eq 0 ]; then
  echo "All required checks passed."
  exit 0
else
  echo "$FAILURES required check(s) failed."
  exit 1
fi
