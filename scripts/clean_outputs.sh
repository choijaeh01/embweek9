#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
find "$LAB_DIR/outputs" -type f ! -name ".gitkeep" -delete
echo "outputs cleaned"
