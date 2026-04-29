from pathlib import Path

import cv2


OUT_DIR = Path(__file__).resolve().parents[1] / "outputs"
IMG_FILE = OUT_DIR / "img_1.png"


def main() -> None:
    if not IMG_FILE.exists():
        raise SystemExit(
            f"{IMG_FILE} does not exist. Run: bash examples/01_rpicam_test.sh"
        )

    img = cv2.imread(str(IMG_FILE))
    if img is None:
        raise SystemExit(f"Could not read image: {IMG_FILE}")

    img_resize = cv2.resize(img, (960, 540))
    cv2.imshow("IMG", img_resize)
    print("Press any key in the image window to close.")
    cv2.waitKey()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    main()
