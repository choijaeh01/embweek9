import cv2
from picamera2 import Picamera2


def main() -> None:
    picam2 = Picamera2()
    preview_config = picam2.create_preview_configuration(
        main={"format": "XRGB8888", "size": (640, 480)}
    )
    picam2.configure(preview_config)
    picam2.start()

    print("Camera preview started. Press ESC or q in the preview window to stop.")
    try:
        while True:
            image = picam2.capture_array()
            v_image = cv2.flip(image, 0)
            cv2.imshow("CAM Preview", v_image)
            key = cv2.waitKey(30) & 0xFF
            if key in (27, ord("q")):
                break
    finally:
        picam2.stop()
        picam2.close()
        cv2.destroyAllWindows()


if __name__ == "__main__":
    main()
