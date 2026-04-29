# Troubleshooting

## `rpicam -hello` 명령이 안 됩니다

공백이 들어간 명령은 잘못된 명령입니다.

올바른 명령:

```bash
rpicam-hello
rpicam-still
rpicam-vid
```

## 카메라 목록이 비어 있습니다

확인:

```bash
rpicam-hello --list-cameras
```

대응:

- 카메라 케이블 방향 확인
- 커넥터 잠금 확인
- 재부팅

```bash
sudo reboot
```

## VNC에서 미리보기 창이 안 보입니다

VNC 데스크톱 안의 터미널에서 실행하세요.

```bash
rpicam-hello --qt-preview -t 0
```

SSH 터미널에서 실행하면 GUI 창이 보이지 않을 수 있습니다.

## `Unable to find an appropriate H.264 codec`

`rpicam-apps-lite`만 있거나 encoder 구성요소가 부족할 수 있습니다.

```bash
sudo apt update
sudo apt install -y rpicam-apps
```

다시 확인:

```bash
rpicam-vid --nopreview -t 3000 -o outputs/video.h264
```

## `No module named cv2`

venv가 활성화되지 않았거나 setup이 끝나지 않았습니다.

```bash
cd ~/embweek9
source activate.sh
bash setup.sh
```

## `numpy.dtype size changed`

OpenCV 설치 과정에서 `numpy 2.x`가 들어가 Picamera2 관련 패키지와 충돌한 경우입니다.

```bash
source activate.sh
pip install --force-reinstall "numpy<2" "opencv-contrib-python==4.10.0.84"
```

확인:

```bash
python - <<'PY'
import numpy, cv2
from picamera2 import Picamera2
print(numpy.__version__)
print(cv2.__version__)
print("picamera2 OK")
PY
```

## YOLO 설치가 CUDA 패키지를 다운로드합니다

Pi에서는 수업용으로 apt의 CPU용 PyTorch를 사용하는 것이 안정적입니다.

```bash
sudo apt install -y python3-torch python3-torchvision python3-torchaudio
source activate.sh
pip install --no-deps ultralytics
```

## NCNN 모델 디렉터리가 없습니다

```bash
source activate.sh
python examples/09_convert_to_ncnn.py
```

정상 결과:

```text
yolo11n_ncnn_model/
```

## OpenCV 창에서 키가 안 먹습니다

마우스로 OpenCV 창을 한 번 클릭한 뒤 `q`, `ESC`, 또는 `s`를 누르세요.

## 모든 상태를 다시 확인하고 싶습니다

```bash
bash check.sh
```

출력 중 `FAIL`이 있으면 그 항목부터 해결하세요.
