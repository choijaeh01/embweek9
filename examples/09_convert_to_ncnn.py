from ultralytics import YOLO


def main() -> None:
    model = YOLO("yolo11n.pt")
    output = model.export(format="ncnn", imgsz=(640, 640))
    print(f"exported: {output}")


if __name__ == "__main__":
    main()
