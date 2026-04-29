# TA Checklist

수업 전에 조교가 확인할 항목입니다.

## 1. 수업 전 이미지 상태 통일

가능하면 모든 Raspberry Pi를 같은 이미지 또는 같은 패키지 상태로 맞추세요.

권장 기준:

- Raspberry Pi OS Bookworm
- 64-bit aarch64
- VNC 접속 가능
- 인터넷 연결 가능
- 카메라 케이블 정상 연결

## 2. 레포 배포 방식

학생에게 다음 형태로 안내하는 것이 가장 단순합니다.

```bash
git clone <배포된 GitHub URL> embweek9
cd embweek9
bash setup.sh
source activate.sh
bash check.sh
```

수업 시간이 짧다면 조교가 미리 각 Pi에서 `setup.sh`까지 실행해두는 것이 좋습니다.

## 3. 수업 시작 5분 점검

모든 학생에게 먼저 아래 명령을 실행하게 하세요.

```bash
cd ~/embweek9
source activate.sh
bash check.sh
```

`check.sh`가 실패하면 본 실습으로 넘어가기 전에 바로 조교가 확인합니다.

## 4. 가장 흔한 실패 지점

### 카메라가 인식되지 않음

확인:

```bash
rpicam-hello --list-cameras
```

대응:

- 카메라 케이블 방향 확인
- 전원 재부팅
- 카메라 커넥터 잠금 확인

### VNC에서 카메라 창이 안 뜸

VNC 데스크톱 안의 터미널에서 실행해야 합니다.

```bash
rpicam-hello --qt-preview -t 0
```

SSH 터미널만 쓰는 경우에는 `--nopreview` 명령으로 검증합니다.

### H.264 영상 저장 실패

에러 예:

```text
Unable to find an appropriate H.264 codec
```

대응:

```bash
sudo apt install -y rpicam-apps
```

### OpenCV 설치 후 Picamera2 import 실패

대부분 `numpy 2.x`가 설치된 경우입니다.

대응:

```bash
source activate.sh
pip install --force-reinstall "numpy<2" "opencv-contrib-python==4.10.0.84"
```

### YOLO 설치가 너무 오래 걸림

Pi에서는 `pip install torch torchvision torchaudio`를 사용하지 않는 것이 좋습니다.
이 레포의 `setup.sh`는 apt의 CPU용 PyTorch를 설치합니다.

## 5. 권장 수업 운영

시간이 부족하면 다음 흐름으로 압축하세요.

1. `check.sh`
2. `examples/01_rpicam_test.sh`
3. `examples/03_picamera_capture.py`
4. `examples/06_opencv_camera_preview.py`
5. `examples/10_yolo_ncnn_camera.py`

OpenCV 설치, YOLO 모델 변환은 시간이 걸릴 수 있으므로 수업 전에 `setup.sh`에서 완료해두는 편이 안정적입니다.

## 6. 조교가 미리 생성해두면 좋은 파일

각 Pi에서 다음이 이미 있으면 수업 진행이 빠릅니다.

```text
venv/
yolo11n.pt
yolo11n_ncnn_model/
```

확인:

```bash
ls -lh yolo11n.pt
du -sh yolo11n_ncnn_model
```
