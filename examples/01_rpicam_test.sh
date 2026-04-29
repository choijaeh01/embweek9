#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="$LAB_DIR/outputs"
mkdir -p "$OUT_DIR"

echo "== Camera list =="
rpicam-hello --list-cameras

echo
echo "== 3-second preview =="
echo "VNC 창에서 미리보기를 보려면 다음 명령을 직접 실행하세요:"
echo "  rpicam-hello --qt-preview -t 3000"
echo
echo "자동 검증용으로는 화면 없이 3초간 카메라를 실행합니다."
rpicam-hello --nopreview -t 3000

echo
echo "== Still image =="
rpicam-still --nopreview -t 1000 -o "$OUT_DIR/image.jpg"
ls -lh "$OUT_DIR/image.jpg"

echo
echo "== H.264 video =="
rpicam-vid --nopreview -t 5000 -o "$OUT_DIR/video.h264"
ls -lh "$OUT_DIR/video.h264"

echo
echo "== PNG image for OpenCV =="
rpicam-still --nopreview -t 1000 --encoding png -o "$OUT_DIR/img_1.png"
ls -lh "$OUT_DIR/img_1.png"
