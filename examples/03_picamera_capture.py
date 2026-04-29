from pathlib import Path
import time

from picamera2 import Picamera2, Preview


OUT_DIR = Path(__file__).resolve().parents[1] / "outputs"
OUT_DIR.mkdir(exist_ok=True)


def main() -> None:
    picam2 = Picamera2()
    try:
        camera_config = picam2.create_preview_configuration()
        picam2.configure(camera_config)
        picam2.start_preview(Preview.QTGL)
        picam2.start()
        time.sleep(2)
        output = OUT_DIR / "cos.jpg"
        picam2.capture_file(str(output))
        print(f"saved: {output}")
    finally:
        try:
            picam2.stop()
        except Exception:
            pass
        try:
            picam2.stop_preview()
        except Exception:
            pass
        picam2.close()


if __name__ == "__main__":
    main()
