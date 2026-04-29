# PPT 수정 권고

현재 PPT 흐름은 좋지만, 학생 실습용으로는 몇 가지 명령과 설치 지시를 반드시 수정하는 것이 좋습니다.

## 필수 수정

| 위치 | 현재 표현 | 문제 | 권장 수정 |
| --- | --- | --- | --- |
| 슬라이드 5 | `rpicam -hello --list-cameras` | 실제 명령이 아님 | `rpicam-hello --list-cameras` |
| 슬라이드 5 | `rpicam -hello` | 실제 명령이 아님 | `rpicam-hello --qt-preview -t 0` 또는 `rpicam-hello` |
| 슬라이드 6 | `rpicam -still -o image.jpg` | 실제 명령이 아님 | `rpicam-still -o image.jpg` |
| 슬라이드 6 | `rpicam -vid -o video.h264` | 실제 명령이 아님 | `rpicam-vid -o video.h264` |
| 슬라이드 10 | `python -m venv --system-site-packages venv` | 환경에 따라 `python`이 없을 수 있음 | `python3 -m venv --system-site-packages venv` |
| 슬라이드 11 | `pip3 install opencv-contrib-python` | 최신 numpy 2.x가 설치되면 Picamera2와 충돌 가능 | `pip install "numpy<2" "opencv-contrib-python==4.10.0.84"` |
| 슬라이드 18 | `sudo apt-get –y install ...` | en dash 문자 때문에 명령 실패 가능 | `sudo apt-get install -y ...` |
| 슬라이드 18 | `libjpeg -dev` 등 | 패키지명 사이 공백 때문에 실패 | `libjpeg-dev libopenblas-dev libopenmpi-dev libomp-dev` |
| 슬라이드 18 | `pip3 install torch torchvision torchaudio ultralytics` | Pi에서 CUDA 대용량 패키지 또는 비호환 패키지를 끌어올 수 있음 | apt로 CPU torch 설치 후 `pip install --no-deps ultralytics` |

## 권장 설치 명령

PPT에는 아래 설치 흐름을 넣는 것이 안전합니다.

```bash
sudo apt update
sudo apt install -y \
  python3-pip python3-venv python3-picamera2 \
  rpicam-apps \
  libjpeg-dev libopenblas-dev libopenmpi-dev libomp-dev \
  python3-torch python3-torchvision python3-torchaudio

python3 -m venv --system-site-packages venv
source venv/bin/activate
pip install "numpy<2" "opencv-contrib-python==4.10.0.84"
pip install --no-deps ultralytics
```

## VNC 관련 안내 추가

VNC로 미리보기 창을 보려면 다음 문장을 슬라이드 5 근처에 추가하는 것이 좋습니다.

```text
VNC에서 미리보기 창을 보려면 VNC 데스크톱 안의 터미널에서 실행한다.
SSH 터미널에서 실행하면 GUI 창이 보이지 않을 수 있다.
```

권장 명령:

```bash
rpicam-hello --qt-preview -t 0
```

자동 검증 또는 SSH 환경에서는:

```bash
rpicam-hello --nopreview -t 3000
rpicam-still --nopreview -o image.jpg
rpicam-vid --nopreview -t 5000 -o video.h264
```

## 코드 수정 권고

### 슬라이드 9

현재 코드는 `picam2.start()` 직후 프로그램이 종료되어 창이 바로 사라질 수 있습니다.

권장:

```python
import time
time.sleep(10)
```

또는 학생 실습에서는 이 레포의 `examples/04_picamera_preview_transform.py`를 사용하세요.

### 슬라이드 17

파일 이름 문자열에 앞 공백이 들어가 있습니다.

현재:

```python
picam2.capture_file(" test"+str(img_no)+".jpg")
```

권장:

```python
picam2.capture_file("test"+str(img_no)+".jpg")
```

이 레포에서는 `outputs/test1.jpg`, `outputs/test2.jpg`처럼 저장합니다.

### 슬라이드 24-26

`YOLO("yolo11n_ncnn_model")`는 경고가 날 수 있으므로 task를 명시하는 편이 좋습니다.

```python
model = YOLO("yolo11n_ncnn_model", task="detect")
```

## PPT와 레포의 역할 분리

권장 운영:

- PPT: 개념, 흐름, 왜 이 코드를 쓰는지 설명
- GitHub 레포: 실제 실행 명령, 검증 스크립트, 완성 코드

학생에게는 PPT 코드를 직접 타이핑하게 하기보다 레포 예제를 실행하고 일부만 수정하게 하는 방식이 안정적입니다.
