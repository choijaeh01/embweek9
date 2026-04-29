#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$LAB_DIR/venv"
PREPARE_YOLO="${PREPARE_YOLO:-1}"

cd "$LAB_DIR"

echo "== embweek9 setup =="
echo "Lab directory: $LAB_DIR"

if ! command -v apt-get >/dev/null 2>&1; then
  echo "이 스크립트는 Raspberry Pi OS/Debian 계열에서 실행해야 합니다."
  exit 1
fi

echo
echo "== Installing apt packages =="
sudo apt-get update
sudo apt-get install -y \
  python3-pip python3-venv python3-picamera2 \
  rpicam-apps \
  libjpeg-dev libopenblas-dev libopenmpi-dev libomp-dev \
  python3-torch python3-torchvision python3-torchaudio

echo
echo "== Creating Python virtual environment =="
python3 -m venv --system-site-packages "$VENV_DIR"

echo
echo "== Installing Python packages in venv =="
"$VENV_DIR/bin/python" -m pip install --upgrade pip
"$VENV_DIR/bin/python" -m pip install --only-binary=:all: \
  "numpy<2" \
  "opencv-contrib-python==4.10.0.84" \
  pillow pyyaml requests scipy tqdm psutil py-cpuinfo pandas seaborn matplotlib \
  ultralytics-thop
"$VENV_DIR/bin/python" -m pip install --no-deps ultralytics

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
echo "다음 명령으로 환경을 활성화하세요:"
echo "  source activate.sh"
echo
echo "상태 확인:"
echo "  bash check.sh"
