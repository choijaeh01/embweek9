from pathlib import Path

from picamera2 import Picamera2, Preview


OUT_DIR = Path(__file__).resolve().parents[1] / "outputs"
OUT_DIR.mkdir(exist_ok=True)


def main() -> None:
    picam2 = Picamera2()
    try:
        camera_config = picam2.create_preview_configuration()
        picam2.configure(camera_config)
        picam2.start_preview(Preview.QTGL)
        output = OUT_DIR / "cos.h264"
        picam2.start_and_record_video(str(output), duration=5)
        print(f"saved: {output}")
    finally:
        try:
            picam2.stop_preview()
        except Exception:
            pass
        picam2.close()


if __name__ == "__main__":
    main()
