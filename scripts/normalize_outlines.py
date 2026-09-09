"""Normalize sprite outlines to a consistent dark navy stroke.

Usage:
  python scripts/normalize_outlines.py

Creates backups under assets/game/_outline_backup/ then rewrites PNGs
with a uniform ~3px navy outline (scaled by image size).
"""

from __future__ import annotations

import shutil
from pathlib import Path

from PIL import Image, ImageFilter

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "assets" / "game"
BACKUP = GAME / "_outline_backup"
OUTLINE = (41, 56, 69, 255)  # AppColors.navy-ish
TARGET_DIRS = [
    "nature",
    "vehicles",
    "fruits",
    "animals",
    "professions",
    "ocean",
    "space",
    "fairy_tale",
    "surprise",
]


def alpha_mask(img: Image.Image) -> Image.Image:
    if img.mode != "RGBA":
        img = img.convert("RGBA")
    return img.split()[-1]


def stroke_width_for(size: int) -> int:
    # Keep relative outline similar across small/large sprites.
    return max(2, min(5, round(size / 90)))


def add_outline(src: Image.Image) -> Image.Image:
    img = src.convert("RGBA")
    alpha = alpha_mask(img)
    width = stroke_width_for(max(img.size))

    # Dilate alpha to create outer silhouette.
    expanded = alpha
    for _ in range(width):
        expanded = expanded.filter(ImageFilter.MaxFilter(3))

    outline = Image.new("RGBA", img.size, (0, 0, 0, 0))
    outline_pixels = outline.load()
    exp = expanded.load()
    alp = alpha.load()
    w, h = img.size
    for y in range(h):
        for x in range(w):
            if exp[x, y] > 20 and alp[x, y] < 20:
                outline_pixels[x, y] = OUTLINE

    # Soften jagged outline a touch, then composite original on top.
    outline = outline.filter(ImageFilter.SMOOTH_MORE)
    composed = Image.alpha_composite(outline, img)
    return composed


def main() -> None:
    BACKUP.mkdir(parents=True, exist_ok=True)
    count = 0
    for folder in TARGET_DIRS:
        src_dir = GAME / folder
        if not src_dir.exists():
            continue
        for path in sorted(src_dir.glob("*.png")):
            rel = path.relative_to(GAME)
            backup_path = BACKUP / rel
            backup_path.parent.mkdir(parents=True, exist_ok=True)
            if not backup_path.exists():
                shutil.copy2(path, backup_path)

            # Always normalize from backup so reruns stay stable.
            source = Image.open(backup_path)
            result = add_outline(source)
            result.save(path)
            count += 1
            print(f"ok {rel}")
    print(f"Normalized {count} sprites.")


if __name__ == "__main__":
    main()
