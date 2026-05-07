from pathlib import Path

TEXT_EXTENSIONS = {
    ".txt", ".aff", ".dic", ".awk", ".sh", ".mk", ".am", ".ac",
    ".tex", ".bib", ".bbl", ".sed"
}

TEXT_FILENAMES = {
    "Makefile", "makefile", "HUNSPELL_heading"
}

SKIP_EXTENSIONS = {
    ".png", ".jpg", ".jpeg", ".gif", ".pdf", ".zip"
}

def is_candidate_text_file(path: Path) -> bool:
    if path.suffix.lower() in SKIP_EXTENSIONS:
        return False

    if path.suffix.lower() in TEXT_EXTENSIONS:
        return True

    if path.name in TEXT_FILENAMES:
        return True

    if path.suffix == "":
        return True

    return False

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

        if not is_candidate_text_file(path):
            continue

        if is_utf8(path):
            continue

        try:
            convert_iso_8859_2_to_utf8(path)
        except UnicodeDecodeError:
            print(f"Nem ISO-8859-2 vagy hibás fájl: {path}")

if __name__ == "__main__":
    main(".")
