import base64


def main():
    image_path = "data/bugcat.webp"
    with open(image_path, "rb") as image_file:
        image_bytes = image_file.read()
        base64_string = base64.b64encode(image_bytes).decode("utf-8")
    print("Hello, here comes the BUGCAT!")
    print(base64_string)


if __name__ == "__main__":
    main()
