#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$LAB_DIR/venv"
PREPARE_YOLO="${PREPARE_YOLO:-1}"
OS_CODENAME="unknown"

cd "$LAB_DIR"

echo "== embweek9 setup =="
echo "Lab directory: $LAB_DIR"

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This script must be run on Raspberry Pi OS or Debian."
  exit 1
fi

if [ -r /etc/os-release ]; then
  # shellcheck disable=SC1091
  source /etc/os-release
  OS_CODENAME="${VERSION_CODENAME:-unknown}"
fi

ARCH="$(uname -m)"
echo "OS codename: $OS_CODENAME"
echo "Architecture: $ARCH"

if [ "$ARCH" != "aarch64" ]; then
  echo "Warning: this lab is designed for 64-bit Raspberry Pi OS(aarch64)."
  echo "Current architecture is $ARCH. YOLO/PyTorch may fail."
fi

echo
echo "== Installing apt packages =="
sudo apt-get update
sudo apt-get install -y \
  python3-pip python3-venv python3-picamera2 \
  rpicam-apps \
  libjpeg-dev libopenblas-dev libopenmpi-dev libomp-dev \
  python3-torch python3-torchvision python3-torchaudio

if [ "$OS_CODENAME" = "trixie" ]; then
  echo
  echo "== Installing Trixie system Python packages =="
  sudo apt-get install -y \
    python3-opencv python3-numpy python3-pil python3-yaml python3-requests \
    python3-scipy python3-tqdm python3-psutil python3-pandas \
    python3-seaborn python3-matplotlib
fi

echo
echo "== Creating Python virtual environment =="
python3 -m venv --system-site-packages "$VENV_DIR"

echo
echo "== Installing Python packages in venv =="
"$VENV_DIR/bin/python" -m pip install --upgrade pip

case "$OS_CODENAME" in
  bookworm)
    "$VENV_DIR/bin/python" -m pip install --only-binary=:all: \
      "numpy<2" \
      "opencv-contrib-python==4.10.0.84" \
      pillow pyyaml requests scipy tqdm psutil py-cpuinfo pandas seaborn matplotlib \
      ultralytics-thop
    "$VENV_DIR/bin/python" -m pip install --no-deps ultralytics
    ;;
  trixie)
    "$VENV_DIR/bin/python" -m pip install --no-deps \
      py-cpuinfo ultralytics-thop ultralytics
    ;;
  *)
    echo "Unsupported OS codename: $OS_CODENAME"
    echo "Run this on Raspberry Pi OS Bookworm or Trixie."
    exit 1
    ;;
esac

if [ "$PREPARE_YOLO" = "1" ]; then
  echo
  echo "== Preparing YOLO11n and NCNN model =="
  "$VENV_DIR/bin/python" examples/08_yolo_model_names.py
  "$VENV_DIR/bin/python" examples/09_convert_to_ncnn.py
else
  echo
  echo "Skipping YOLO preparation because PREPARE_YOLO=$PREPARE_YOLO"
fi

echo
echo "== Setup complete =="
echo "Activate the environment with:"
echo "  source activate.sh"
echo
echo "Check your setup with:"
echo "  bash check.sh"
