from pathlib import Path
import sys

SKIP_DIRS = {".git"}
SKIP_EXTENSIONS = {
    ".png", ".jpg", ".jpeg", ".gif",
    ".zip", ".gz", ".pdf", ".so", ".o"
}

def check_file(path: Path) -> None:
    data = path.read_bytes()

    try:
        data.decode("utf-8")
        return
    except UnicodeDecodeError as e:
        print(f"\nNEM UTF-8: {path}")
        print(f"Pozíció: {e.start}")
        print(f"Hibás byte: 0x{data[e.start]:02X}")

        start = max(0, e.start - 80)
        end = min(len(data), e.start + 80)
        snippet = data[start:end]

        print("\nHEX:")
        print(snippet.hex(" "))

        print("\nKörnyezet ISO-8859-2-ként:")
        print(snippet.decode("iso-8859-2", errors="replace"))

        print("\nKörnyezet UTF-8-ként, hibákkal:")
        print(snippet.decode("utf-8", errors="replace"))
        
def main(root: str) -> None:
    root_path = Path(root)

    for path in root_path.rglob("*"):
        if any(part in SKIP_DIRS for part in path.parts):
            continue

        if not path.is_file():
            continue

        if path.suffix.lower() in SKIP_EXTENSIONS:
            continue

        check_file(path)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        main(sys.argv[1])
    else:
        main(".")
