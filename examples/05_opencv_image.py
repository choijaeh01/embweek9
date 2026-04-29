from pathlib import Path

import cv2


OUT_DIR = Path(__file__).resolve().parents[1] / "outputs"
IMG_FILE = OUT_DIR / "img_1.png"


def main() -> None:
    if not IMG_FILE.exists():
        raise SystemExit(
            f"{IMG_FILE} 파일이 없습니다. 먼저 bash examples/01_rpicam_test.sh 를 실행하세요."
        )

    img = cv2.imread(str(IMG_FILE))
    if img is None:
        raise SystemExit(f"이미지를 읽지 못했습니다: {IMG_FILE}")

    img_resize = cv2.resize(img, (960, 540))
    cv2.imshow("IMG", img_resize)
    print("Press any key in the image window to close.")
    cv2.waitKey()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    main()
