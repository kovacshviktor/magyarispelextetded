from pathlib import Path

EXTENSIONS = {".txt", ".aff", ".dic", ".awk", ".sh", ".mk", ".am", ".ac"}

def is_utf8(path: Path) -> bool:
    try:
        path.read_text(encoding="utf-8")
        return True
    except UnicodeDecodeError:
        return False

def convert_iso_8859_2_to_utf8(path: Path) -> None:
    text = path.read_text(encoding="iso-8859-2")
    path.write_text(text, encoding="utf-8")
    print(f"Átalakítva UTF-8-ra: {path}")

def main(root: str) -> None:
    root_path = Path(root)

    for path in root_path.rglob("*"):
        if not path.is_file():
            continue
            
        if ".git" in path.parts:
        	continue

        if path.suffix.lower() not in EXTENSIONS:
            continue

        if is_utf8(path):
            continue

        try:
            convert_iso_8859_2_to_utf8(path)
        except UnicodeDecodeError:
            print(f"Nem ISO-8859-2 vagy hibás fájl: {path}")

if __name__ == "__main__":
    main(".")
