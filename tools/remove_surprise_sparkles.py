from collections import deque
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path("assets/game/surprise")


def is_yellow(r, g, b, a):
    return a > 180 and r > 180 and g > 140 and b < 130 and (int(r) + int(g)) > int(b) * 2.5


def is_dark(r, g, b, a):
    return a > 180 and r < 90 and g < 90 and b < 110


def connected_components(mask):
    h, w = mask.shape
    seen = np.zeros_like(mask, dtype=bool)
    comps = []
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
                    (cy - 1, cx - 1),
                    (cy - 1, cx + 1),
                    (cy + 1, cx - 1),
                    (cy + 1, cx + 1),
                ):
                    if 0 <= ny < h and 0 <= nx < w and mask[ny, nx] and not seen[ny, nx]:
                        seen[ny, nx] = True
                        q.append((ny, nx))
            comps.append(cells)
    return comps


def remove_sparkles(path: Path, keep_center_yellow: bool):
    im = np.array(Image.open(path).convert("RGBA"))
    h, w = im.shape[:2]
    yellow = np.zeros((h, w), dtype=bool)
    for y in range(h):
        for x in range(w):
            r, g, b, a = im[y, x]
            yellow[y, x] = is_yellow(r, g, b, a)

    comps = connected_components(yellow)
    print(path.name, "yellow comps", len(comps), [len(c) for c in comps])

    remove = np.zeros((h, w), dtype=bool)
    cx0, cy0 = w / 2, h / 2
    for cells in comps:
        ys = [c[0] for c in cells]
        xs = [c[1] for c in cells]
        minx, maxx = min(xs), max(xs)
        miny, maxy = min(ys), max(ys)
        bw, bh = maxx - minx + 1, maxy - miny + 1
        area = len(cells)
        mx, my = sum(xs) / area, sum(ys) / area

        # Sparkles are small cross-like blobs on the sides.
        # Keep larger yellow ornaments (hat tip / crown) near top-center.
        is_side = abs(mx - cx0) > 70
        is_small = area < 900 and bw < 90 and bh < 90
        near_top_center = abs(mx - cx0) < 80 and my < h * 0.42

        if keep_center_yellow and near_top_center and not is_side:
            continue
        if is_small and is_side:
            for y, x in cells:
                remove[y, x] = True
            # Also clear dark outline touching the sparkle.
            for y, x in cells:
                for ny in range(y - 3, y + 4):
                    for nx in range(x - 3, x + 4):
                        if 0 <= ny < h and 0 <= nx < w:
                            r, g, b, a = im[ny, nx]
                            if is_dark(r, g, b, a):
                                remove[ny, nx] = True

    # Dilate remove a bit for anti-aliased fringe
    dilate = remove.copy()
    ys, xs = np.where(remove)
    for y, x in zip(ys, xs):
        for ny in range(y - 1, y + 2):
            for nx in range(x - 1, x + 2):
                if 0 <= ny < h and 0 <= nx < w:
                    r, g, b, a = im[ny, nx]
                    if a > 0 and (
                        is_yellow(r, g, b, a)
                        or is_dark(r, g, b, a)
                        or (r > 160 and g > 120 and b < 150 and a < 230)
                    ):
                        dilate[ny, nx] = True

    out = im.copy()
    out[dilate] = [0, 0, 0, 0]
    Image.fromarray(out).save(path)
    print(" saved", path.name, "removed", int(dilate.sum()), "px")


for name in ("happy.png", "surprised.png"):
    remove_sparkles(ROOT / name, keep_center_yellow=True)
