import importlib
import sys


REQUIRED = [
    "picamera2",
    "libcamera",
    "numpy",
    "cv2",
    "torch",
    "torchvision",
    "torchaudio",
    "ultralytics",
]


def main() -> int:
    failures = 0
    for name in REQUIRED:
        try:
            module = importlib.import_module(name)
            version = getattr(module, "__version__", "")
            print(f"{name}: OK {version}")
        except Exception as exc:
            failures += 1
            print(f"{name}: FAIL {type(exc).__name__}: {exc}")

    if failures:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
