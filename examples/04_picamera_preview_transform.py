import time

from libcamera import Transform
from picamera2 import Picamera2, Preview


def main() -> None:
    picam2 = Picamera2()
    try:
        picam2.start_preview(
            Preview.QTGL,
            x=100,
            y=200,
            width=800,
            height=600,
            transform=Transform(vflip=1),
        )
        picam2.start()
        print("Preview is open for 10 seconds.")
        time.sleep(10)
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
