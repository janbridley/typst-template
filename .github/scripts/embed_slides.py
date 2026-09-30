#!/usr/bin/env python3
"""Regenerate the rendered-slides table in README.md.

Expects slides/slide-<n>.svg (one file per PDF page, as produced by
    typst compile main.typ 'slides/slide-{p}.svg')
and rewrites everything between the <!-- slides:start --> / <!-- slides:end -->
markers in README.md with a one-column markdown table holding one row per
slide. Rendered slides and the PDF are committed back by CI
(git-auto-commit-action). Exits non-zero if the slides are missing or the
markers aren't found, so CI fails loudly instead of silently emptying the
README.
"""

import re
import sys
from pathlib import Path

README = Path(__file__).resolve().parent.parent.parent / "README.md"
SLIDES_DIR = Path(__file__).resolve().parent.parent.parent / "slides"
START = "<!-- slides:start -->"
END = "<!-- slides:end -->"
NAME_RE = re.compile(r"slide-(\d+)\.svg$")


def main() -> int:
    slides = []
    for path in SLIDES_DIR.glob("slide-*.svg"):
        match = NAME_RE.search(path.name)
        if match:
            slides.append((int(match.group(1)), path))
    slides.sort()

    if not slides:
        print("embed-slides: no slides/slide-*.svg found", file=sys.stderr)
        return 1

    rows = "\n".join(
        f"| ![Slide {number}](slides/{path.name}) |" for number, path in slides
    )
    table = f"| Slides ({len(slides)}) |\n| --- |\n{rows}"

    text = README.read_text(encoding="utf-8")
    if START not in text or END not in text:
        print(
            f"embed-slides: {START}/{END} markers missing from README.md",
            file=sys.stderr,
        )
        return 1

    pattern = re.compile(re.escape(START) + r".*?" + re.escape(END), re.DOTALL)
    new_text = pattern.sub(f"{START}\n{table}\n{END}", text, count=1)
    if new_text != text:
        README.write_text(new_text, encoding="utf-8")
        print(f"embed-slides: README updated with {len(slides)} slides")
    else:
        print(f"embed-slides: README already up to date ({len(slides)} slides)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
