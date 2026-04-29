from pathlib import Path
import time

import cv2
from picamera2 import Picamera2
from ultralytics import YOLO


LAB_DIR = Path(__file__).resolve().parents[1]
OUT_DIR = LAB_DIR / "outputs"
OUT_DIR.mkdir(exist_ok=True)
MODEL_DIR = LAB_DIR / "yolo11n_ncnn_model"


def main() -> None:
    if not MODEL_DIR.exists():
        raise SystemExit(
            "yolo11n_ncnn_model 디렉터리가 없습니다. 먼저 python examples/09_convert_to_ncnn.py 를 실행하세요."
        )

    picam2 = Picamera2()
    picam2.preview_configuration.main.size = (640, 480)
    picam2.preview_configuration.main.format = "RGB888"
    picam2.preview_configuration.align()
    picam2.configure("preview")
    picam2.start()

    model = YOLO(str(MODEL_DIR), task="detect")
    prev_time = time.time()

    print("YOLO NCNN camera started. Press q in the preview window to stop.")
    try:
        while True:
            frame = picam2.capture_array()

            current_time = time.time()
            elapsed_time = current_time - prev_time
            prev_time = current_time
            fps = 1 / elapsed_time if elapsed_time > 0 else 0.0

            results = model(frame, verbose=False)
            annotated_frame = results[0].plot()

            for result in results:
                for box in result.boxes:
                    print(result.names[int(box.cls[0])])

            cv2.putText(
                annotated_frame,
                f"FPS : {fps:.2f}",
                (10, 30),
                cv2.FONT_HERSHEY_SIMPLEX,
                1,
                (0, 255, 0),
                2,
                cv2.LINE_AA,
            )
            cv2.imshow("YOLO Real-time Detection", annotated_frame)
            cv2.imwrite(str(OUT_DIR / "yolo_annotated_latest.jpg"), annotated_frame)

            if cv2.waitKey(1) & 0xFF == ord("q"):
                break
    finally:
        picam2.stop()
        picam2.close()
        cv2.destroyAllWindows()


if __name__ == "__main__":
    main()
