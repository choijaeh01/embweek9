# embweek9: Raspberry Pi 5 Camera, OpenCV, YOLO 실습

이 레포는 RPi5 카메라 실습을 수업 시간에 안정적으로 진행하기 위한 학생용 실습 자료입니다.

PPT는 개념과 흐름을 설명하는 자료로 사용하고, 실제 명령과 코드는 이 레포의 순서를 기준으로 진행하세요.

## 실습 목표

- Raspberry Pi 5에서 CSI 카메라가 정상 인식되는지 확인한다.
- `rpicam-hello`, `rpicam-still`, `rpicam-vid`로 미리보기, 사진, 동영상 촬영을 수행한다.
- Picamera2로 Python 카메라 제어를 수행한다.
- OpenCV로 이미지 표시, 카메라 프리뷰, 사진 저장을 수행한다.
- YOLO11n 모델을 NCNN 형식으로 변환하고 카메라 영상에서 실시간 객체 탐지를 실행한다.

## 준비물

- Raspberry Pi 5
- Raspberry Pi OS Bookworm 계열
- RPi5 호환 CSI 카메라와 22-pin 카메라 케이블
- VNC 접속 환경
- 인터넷 연결

GUI 창이 필요한 예제는 반드시 **VNC 데스크톱 안의 터미널**에서 실행하세요.

## 빠른 시작

```bash
git clone https://github.com/choijaeh01/embweek9.git
cd embweek9
bash setup.sh
source activate.sh
bash check.sh
```

`setup.sh`는 다음 작업을 수행합니다.

- apt 패키지 설치
- `venv` 생성
- OpenCV, Ultralytics 설치
- YOLO11n 모델 다운로드
- YOLO11n NCNN 모델 변환

YOLO 모델 다운로드와 NCNN 변환을 나중에 하고 싶다면 다음처럼 실행할 수 있습니다.

```bash
PREPARE_YOLO=0 bash setup.sh
source activate.sh
bash scripts/prepare_yolo_ncnn.sh
```

## 실습 순서

### 1. 카메라 기본 동작 확인

```bash
bash examples/01_rpicam_test.sh
```

VNC 화면에서 직접 미리보기를 보고 싶으면 VNC 터미널에서 실행하세요.

```bash
rpicam-hello --qt-preview -t 0
```

종료는 터미널에서 `Ctrl+C`를 누르면 됩니다.

### 2. Picamera2로 5초 영상 저장

```bash
python examples/02_picamera_record.py
```

결과 파일:

```text
outputs/cos.h264
```

### 3. Picamera2로 사진 저장

```bash
python examples/03_picamera_capture.py
```

결과 파일:

```text
outputs/cos.jpg
```

### 4. Picamera2 프리뷰 위치, 크기, 상하 반전

```bash
python examples/04_picamera_preview_transform.py
```

창이 10초 동안 표시됩니다.

### 5. OpenCV 이미지 표시

먼저 `examples/01_rpicam_test.sh`가 `outputs/img_1.png`를 만든 상태여야 합니다.

```bash
python examples/05_opencv_image.py
```

이미지 창에서 아무 키나 누르면 종료됩니다.

### 6. OpenCV 카메라 미리보기

```bash
python examples/06_opencv_camera_preview.py
```

프리뷰 창에서 `q` 또는 `ESC`를 누르면 종료됩니다.

### 7. OpenCV 카메라 사진 저장

```bash
python examples/07_opencv_capture_save.py
```

- `s`: 사진 저장
- `q` 또는 `ESC`: 종료

결과 파일:

```text
outputs/test1.jpg
outputs/test2.jpg
...
```

### 8. YOLO11n 클래스 정보 확인

```bash
python examples/08_yolo_model_names.py
```

정상이라면 클래스 개수 `80`이 표시됩니다.

### 9. YOLO11n 모델을 NCNN으로 변환

```bash
python examples/09_convert_to_ncnn.py
```

결과 디렉터리:

```text
yolo11n_ncnn_model/
```

### 10. YOLO NCNN 카메라 실시간 탐지

```bash
python examples/10_yolo_ncnn_camera.py
```

프리뷰 창에서 `q`를 누르면 종료됩니다.

최근 결과 이미지는 계속 아래 파일로 저장됩니다.

```text
outputs/yolo_annotated_latest.jpg
```

## 환경 확인

수업 시작 전이나 문제가 생겼을 때 실행하세요.

```bash
bash check.sh
```

이 스크립트는 다음 항목을 확인합니다.

- `rpicam` 명령 존재 여부
- 카메라 인식 여부
- 사진 저장 가능 여부
- H.264 영상 저장 가능 여부
- Python 패키지 import 가능 여부
- YOLO 모델 파일 존재 여부
- NCNN 모델 디렉터리 존재 여부

## 자주 생기는 문제

자세한 내용은 [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)를 보세요.

핵심만 요약하면 다음과 같습니다.

- `rpicam -hello`가 아니라 `rpicam-hello`입니다.
- VNC에서 미리보기 창을 보려면 `rpicam-hello --qt-preview -t 0`을 사용하세요.
- SSH 터미널에서 GUI 창을 띄우려 하지 말고 VNC 데스크톱 터미널에서 실행하세요.
- OpenCV 설치 시 `numpy<2`를 유지해야 Picamera2와 충돌하지 않습니다.
- Pi에서는 `pip install torch ...` 대신 apt의 CPU용 PyTorch 패키지를 사용합니다.

## 추가 과제

기본 실습을 끝낸 뒤 이해도를 확인하려면 [docs/ASSIGNMENTS.md](docs/ASSIGNMENTS.md)의 선택 과제를 진행하세요.
