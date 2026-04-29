from pathlib import Path

import cv2
from picamera2 import Picamera2


OUT_DIR = Path(__file__).resolve().parents[1] / "outputs"
OUT_DIR.mkdir(exist_ok=True)


def main() -> None:
    picam2 = Picamera2()
    preview_config = picam2.create_preview_configuration(
        main={"format": "XRGB8888", "size": (640, 480)}
    )
    picam2.configure(preview_config)
    picam2.start()

    img_no = 0
    print("Press s to save a photo. Press ESC or q to stop.")
    try:
        while True:
            image = picam2.capture_array()
            v_image = cv2.flip(image, 0)
            cv2.imshow("CAM Preview", v_image)

            key = cv2.waitKey(30) & 0xFF
            if key in (27, ord("q")):
                break
            if key == ord("s"):
                img_no += 1
                output = OUT_DIR / f"test{img_no}.jpg"
                picam2.capture_file(str(output))
                print(f"saved: {output}")
    finally:
        picam2.stop()
        picam2.close()
        cv2.destroyAllWindows()


if __name__ == "__main__":
    main()
