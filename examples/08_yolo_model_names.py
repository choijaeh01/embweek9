from ultralytics import YOLO


def main() -> None:
    model = YOLO("yolo11n.pt")
    print(f"class count: {len(model.names)}")
    for idx, name in model.names.items():
        print(f"{idx:2d}: {name}")


if __name__ == "__main__":
    main()
