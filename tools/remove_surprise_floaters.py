from collections import deque
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter

ROOT = Path("assets/game/surprise")


def largest_opaque_component(alpha, threshold=40):
    h, w = alpha.shape
    mask = alpha > threshold
    seen = np.zeros_like(mask, dtype=bool)
    best = []
    for y in range(h):
        for x in range(w):
            if not mask[y, x] or seen[y, x]:
                continue
            q = deque([(y, x)])
            seen[y, x] = True
            cells = []
            while q:
                cy, cx = q.popleft()
                cells.append((cy, cx))
                for ny, nx in (
                    (cy - 1, cx),
                    (cy + 1, cx),
                    (cy, cx - 1),
                    (cy, cx + 1),
                ):
                    if 0 <= ny < h and 0 <= nx < w and mask[ny, nx] and not seen[ny, nx]:
                        seen[ny, nx] = True
                        q.append((ny, nx))
            if len(cells) > len(best):
                best = cells
    keep = np.zeros_like(mask, dtype=bool)
    for y, x in best:
        keep[y, x] = True
    return keep


def keep_main_character(path: Path, dilate: int = 2):
    im = Image.open(path).convert("RGBA")
    arr = np.array(im)
    alpha = arr[:, :, 3]
    keep = largest_opaque_component(alpha)
    print(path.name, "main pixels", int(keep.sum()))

    # Dilate keep mask so soft edges of the character remain.
    keep_img = Image.fromarray((keep.astype(np.uint8) * 255))
    for _ in range(dilate):
        keep_img = keep_img.filter(ImageFilter.MaxFilter(3))
    keep = np.array(keep_img) > 0

    out = arr.copy()
    out[~keep] = [0, 0, 0, 0]
    Image.fromarray(out).save(path)
    print(" kept", int(keep.sum()), "cleared floaters")


# Re-copy originals? We already damaged yellow. Main character should still be intact.
for name in ("happy.png", "surprised.png"):
    keep_main_character(ROOT / name, dilate=3)
