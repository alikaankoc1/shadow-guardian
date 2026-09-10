from collections import deque
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path("assets/game/surprise")


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


def clear_side_marks(path: Path):
    im = np.array(Image.open(path).convert("RGBA"))
    h, w = im.shape[:2]
    r, g, b, a = im[:, :, 0], im[:, :, 1], im[:, :, 2], im[:, :, 3]

    # Remaining sparkle outlines: dark or near-black opaque pixels off the face.
    dark = (a > 160) & (r < 100) & (g < 100) & (b < 120)
    # Also catch pale outline fringes left after yellow removal
    fringe = (a > 40) & (a < 230) & (r > 140) & (g > 100) & (b < 160)
    # And pure black leftovers
    blackish = (a > 160) & (r < 40) & (g < 40) & (b < 50)

    candidate = dark | fringe | blackish

    # Only consider pixels away from the main head (central blob).
    # Rough head disk.
    yy, xx = np.ogrid[:h, :w]
    cx, cy = w / 2, h * 0.52
    dist = np.sqrt((xx - cx) ** 2 + (yy - cy) ** 2)
    outside_head = dist > 155

    mask = candidate & outside_head
    comps = connected_components(mask)
    print(path.name, "side comps", [(len(c),) for c in comps if len(c) > 20])

    remove = np.zeros((h, w), dtype=bool)
    for cells in comps:
        area = len(cells)
        if area < 25 or area > 2500:
            continue
        ys = [c[0] for c in cells]
        xs = [c[1] for c in cells]
        mx = sum(xs) / area
        my = sum(ys) / area
        bw = max(xs) - min(xs) + 1
        bh = max(ys) - min(ys) + 1
        # Sparkle leftovers: compact, on the sides of the head.
        if abs(mx - cx) < 90:
            continue
        if bw > 100 or bh > 100:
            continue
        if my < 40 or my > h - 40:
            continue
        for y, x in cells:
            remove[y, x] = True
            for ny in range(y - 2, y + 3):
                for nx in range(x - 2, x + 3):
                    if 0 <= ny < h and 0 <= nx < w and outside_head[ny, nx]:
                        aa = im[ny, nx, 3]
                        if aa > 0:
                            rr, gg, bb = im[ny, nx, :3]
                            if (
                                (rr < 120 and gg < 120 and bb < 140)
                                or (rr > 140 and gg > 100 and bb < 170)
                                or aa < 200
                            ):
                                remove[ny, nx] = True

    out = im.copy()
    out[remove] = [0, 0, 0, 0]
    Image.fromarray(out).save(path)
    print(" cleared", int(remove.sum()), "px")


for name in ("happy.png", "surprised.png"):
    clear_side_marks(ROOT / name)
