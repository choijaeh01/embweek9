#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="$LAB_DIR/outputs"
mkdir -p "$OUT_DIR"

echo "== Camera list =="
rpicam-hello --list-cameras

echo
echo "== 3-second preview =="
echo "To see the preview in VNC, run this command in the VNC desktop terminal:"
echo "  rpicam-hello --qt-preview -t 3000"
echo
echo "For automatic checking, this script runs the camera for 3 seconds without preview."
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
