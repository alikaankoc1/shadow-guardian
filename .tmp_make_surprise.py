"""Surprise world emotion mascots — consistent chibi family (CC0)."""

from PIL import Image, ImageDraw
import os
import math

OUT = r"c:\Users\Ali Kaan\Desktop\GitHub\shadow-guardian\assets\game\surprise"
SIZE = 512

SKIN = (255, 220, 190, 255)
SKIN_LIGHT = (255, 235, 215, 255)
BLUSH = (255, 150, 160, 140)
OUTLINE = (90, 70, 100, 0)  # unused — flat style like fairy tale
EYE_WHITE = (255, 255, 255, 255)
PUPIL = (55, 50, 75, 255)


def canvas():
    return Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))


def soft_shadow(d, box=(120, 430, 390, 480)):
    d.ellipse(box, fill=(40, 45, 70, 50))


def head(d, cx=256, cy=250, r=145):
    d.ellipse((cx - r, cy - r, cx + r, cy + r), fill=SKIN)
    d.ellipse((cx - r + 20, cy - r + 15, cx - 10, cy + 20), fill=SKIN_LIGHT)
    # ears
    d.ellipse((cx - r - 18, cy - 40, cx - r + 45, cy + 35), fill=SKIN)
    d.ellipse((cx + r - 45, cy - 40, cx + r + 18, cy + 35), fill=SKIN)
    d.ellipse((cx - r - 5, cy - 20, cx - r + 30, cy + 15), fill=(255, 190, 175, 255))
    d.ellipse((cx + r - 30, cy - 20, cx + r + 5, cy + 15), fill=(255, 190, 175, 255))


def blush(d, cx=256, cy=250):
    d.ellipse((cx - 110, cy + 15, cx - 55, cy + 50), fill=BLUSH)
    d.ellipse((cx + 55, cy + 15, cx + 110, cy + 50), fill=BLUSH)


def eyes_open(d, cx, cy, pupil_dy=0, r=28, pupil=14):
    for dx in (-48, 48):
        ex, ey = cx + dx, cy - 10
        d.ellipse((ex - r, ey - r, ex + r, ey + r), fill=EYE_WHITE)
        d.ellipse(
            (ex - pupil, ey - pupil + pupil_dy, ex + pupil, ey + pupil + pupil_dy),
            fill=PUPIL,
        )
        d.ellipse((ex - 8, ey - 12 + pupil_dy, ex - 2, ey - 6 + pupil_dy), fill=(255, 255, 255, 230))


def body_stub(d, cx=256):
    """Small shoulders so they feel like characters, not floating heads."""
    d.ellipse((cx - 90, 380, cx + 90, 470), fill=(255, 180, 140, 255))
    d.ellipse((cx - 70, 390, cx + 70, 450), fill=(255, 200, 165, 255))


def plump_save(img, path, fill=0.84):
    a = img.split()[-1]
    bbox = a.getbbox()
    if not bbox:
        img.save(path)
        return
    cropped = img.crop(bbox)
    w, h = cropped.size
    side = max(w, h)
    sq = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    sq.paste(cropped, ((side - w) // 2, (side - h) // 2), cropped)
    max_dim = int(SIZE * fill)
    scale = max_dim / side
    nw = nh = max(1, int(side * scale))
    resized = sq.resize((nw, nh), Image.Resampling.LANCZOS)
    out = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    out.paste(resized, ((SIZE - nw) // 2, (SIZE - nh) // 2), resized)
    out.save(path)


def make_happy(path):
    img = canvas()
    d = ImageDraw.Draw(img)
    soft_shadow(d)
    body_stub(d)
    # party hat (cone) — unique silhouette
    d.polygon([(190, 160), (256, 20), (322, 160)], fill=(255, 110, 130, 255))
    d.polygon([(210, 155), (256, 45), (290, 155)], fill=(255, 150, 160, 255))
    d.ellipse((236, 10, 276, 50), fill=(255, 220, 80, 255))
    # confetti dots on hat
    d.ellipse((220, 90, 240, 110), fill=(100, 200, 255, 255))
    d.ellipse((270, 70, 288, 88), fill=(120, 220, 140, 255))
    d.ellipse((245, 110, 262, 127), fill=(255, 230, 90, 255))
    head(d, cy=260)
    eyes_open(d, 256, 250, pupil_dy=-2)
    blush(d, 256, 265)
    # big smile
    d.pieslice((210, 275, 302, 355), 10, 170, fill=(230, 90, 110, 255))
    d.ellipse((230, 300, 282, 340), fill=(255, 140, 150, 255))  # tongue
    # star sparkles
    for sx, sy in ((90, 180), (400, 160), (70, 300)):
        d.polygon(
            [(sx, sy - 12), (sx + 4, sy - 2), (sx + 14, sy), (sx + 4, sy + 4),
             (sx, sy + 14), (sx - 4, sy + 4), (sx - 14, sy), (sx - 4, sy - 2)],
            fill=(255, 220, 80, 255),
        )
    plump_save(img, path)


def make_sad(path):
    img = canvas()
    d = ImageDraw.Draw(img)
    soft_shadow(d)
    body_stub(d, cx=256)
    # rain cloud hat
    d.ellipse((140, 40, 250, 140), fill=(150, 175, 210, 255))
    d.ellipse((200, 25, 330, 145), fill=(165, 190, 225, 255))
    d.ellipse((270, 45, 380, 140), fill=(150, 175, 210, 255))
    d.ellipse((175, 80, 340, 160), fill=(180, 200, 230, 255))
    # rain drops
    for x in (190, 240, 290, 330):
        d.ellipse((x, 145, x + 18, 175), fill=(120, 180, 230, 255))
        d.polygon([(x + 9, 130), (x, 155), (x + 18, 155)], fill=(120, 180, 230, 255))
    head(d, cy=270)
    # sad eyes (look down)
    eyes_open(d, 256, 265, pupil_dy=6, r=26, pupil=12)
    # downturned brows
    d.arc((175, 210, 235, 250), 200, 340, fill=(180, 120, 110, 255), width=6)
    d.arc((275, 210, 335, 250), 200, 340, fill=(180, 120, 110, 255), width=6)
    blush(d, 256, 275)
    # frown
    d.arc((220, 320, 292, 370), 200, 340, fill=(200, 110, 120, 255), width=8)
    # big tear
    d.ellipse((340, 280, 375, 330), fill=(140, 200, 240, 220))
    d.polygon([(357, 260), (340, 295), (375, 295)], fill=(140, 200, 240, 220))
    plump_save(img, path)


def make_angry(path):
    img = canvas()
    d = ImageDraw.Draw(img)
    soft_shadow(d)
    body_stub(d)
    # horns
    d.polygon([(150, 180), (175, 40), (220, 160)], fill=(220, 80, 70, 255))
    d.polygon([(360, 180), (335, 40), (290, 160)], fill=(220, 80, 70, 255))
    d.polygon([(160, 170), (175, 70), (200, 155)], fill=(255, 130, 100, 255))
    d.polygon([(350, 170), (335, 70), (310, 155)], fill=(255, 130, 100, 255))
    # flame puff above
    d.ellipse((230, 50, 280, 120), fill=(255, 140, 60, 255))
    d.ellipse((245, 30, 275, 80), fill=(255, 210, 80, 255))
    head(d, cy=265)
    # angry red tint hint on cheeks
    d.ellipse((140, 250, 200, 310), fill=(255, 120, 110, 90))
    d.ellipse((310, 250, 370, 310), fill=(255, 120, 110, 90))
    # furrowed brows
    d.polygon([(160, 200), (230, 225), (225, 240), (155, 220)], fill=(90, 60, 70, 255))
    d.polygon([(350, 200), (280, 225), (285, 240), (355, 220)], fill=(90, 60, 70, 255))
    eyes_open(d, 256, 255, pupil_dy=2, r=26, pupil=13)
    # gritted / angry mouth
    d.rounded_rectangle((210, 310, 300, 345), radius=8, fill=(80, 50, 60, 255))
    d.rectangle((230, 310, 240, 345), fill=(255, 240, 230, 255))
    d.rectangle((255, 310, 265, 345), fill=(255, 240, 230, 255))
    d.rectangle((280, 310, 290, 345), fill=(255, 240, 230, 255))
    plump_save(img, path)


def make_surprised(path):
    img = canvas()
    d = ImageDraw.Draw(img)
    soft_shadow(d)
    body_stub(d)
    # spring / zig-zag hair
    d.ellipse((230, 30, 280, 90), fill=(255, 200, 80, 255))
    pts = []
    for i in range(8):
        x = 200 + i * 16
        y = 100 + (20 if i % 2 == 0 else -15)
        pts.append((x, y))
    if len(pts) >= 2:
        d.line(pts, fill=(255, 180, 60, 255), width=14)
    # bangs tuft
    d.ellipse((235, 95, 275, 145), fill=(255, 200, 90, 255))
    head(d, cy=265)
    # huge round eyes
    for dx in (-52, 52):
        ex, ey = 256 + dx, 245
        d.ellipse((ex - 36, ey - 36, ex + 36, ey + 36), fill=EYE_WHITE)
        d.ellipse((ex - 16, ey - 16, ex + 16, ey + 16), fill=PUPIL)
        d.ellipse((ex - 8, ey - 14, ex - 2, ey - 8), fill=(255, 255, 255, 230))
    blush(d, 256, 270)
    # big O mouth
    d.ellipse((225, 300, 285, 370), fill=(80, 50, 60, 255))
    d.ellipse((235, 310, 275, 350), fill=(255, 140, 150, 255))
    # sparkles
    for sx, sy in ((80, 200), (420, 180), (100, 340), (400, 320)):
        d.ellipse((sx - 8, sy - 8, sx + 8, sy + 8), fill=(255, 230, 100, 255))
        d.rectangle((sx - 2, sy - 16, sx + 2, sy + 16), fill=(255, 230, 100, 255))
        d.rectangle((sx - 16, sy - 2, sx + 16, sy + 2), fill=(255, 230, 100, 255))
    plump_save(img, path)


def make_sleepy(path):
    img = canvas()
    d = ImageDraw.Draw(img)
    soft_shadow(d)
    body_stub(d)
    # nightcap
    d.polygon([(160, 200), (200, 40), (300, 160)], fill=(120, 100, 200, 255))
    d.ellipse((150, 160, 340, 230), fill=(140, 120, 220, 255))
    d.ellipse((280, 35, 340, 95), fill=(255, 230, 140, 255))  # pompom
    d.ellipse((290, 45, 330, 85), fill=(255, 245, 180, 255))
    head(d, cy=275)
    # closed sleepy eyes (arcs)
    d.arc((185, 245, 245, 295), 200, 340, fill=PUPIL, width=8)
    d.arc((265, 245, 325, 295), 200, 340, fill=PUPIL, width=8)
    blush(d, 256, 280)
    # small smile
    d.arc((230, 310, 280, 350), 20, 160, fill=(220, 120, 130, 255), width=6)
    # Zzz
    d.text  # noqa — use polygons for Z
    def draw_z(x, y, s, color=(160, 140, 230, 255)):
        d.line([(x, y), (x + s, y)], fill=color, width=6)
        d.line([(x + s, y), (x, y + s)], fill=color, width=6)
        d.line([(x, y + s), (x + s, y + s)], fill=color, width=6)

    draw_z(370, 120, 36)
    draw_z(400, 170, 28, (180, 160, 240, 255))
    draw_z(385, 210, 20, (200, 180, 250, 255))
    # moon accent
    d.ellipse((70, 140, 130, 200), fill=(255, 230, 140, 255))
    d.ellipse((85, 140, 145, 195), fill=(0, 0, 0, 0))
    # fix moon with paste trick
    moon = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    md = ImageDraw.Draw(moon)
    md.ellipse((70, 140, 130, 200), fill=(255, 230, 140, 255))
    md.ellipse((90, 135, 150, 195), fill=(0, 0, 0, 0))
    # actually cut hole properly
    moon = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    md = ImageDraw.Draw(moon)
    md.ellipse((70, 140, 130, 200), fill=(255, 230, 140, 255))
    # darker crescent via overlay
    img.alpha_composite(moon)
    cut = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    cd = ImageDraw.Draw(cut)
    cd.ellipse((90, 135, 150, 195), fill=(0, 0, 0, 255))
    # Subtract cut from moon area on img — simpler: redraw crescent
    img2 = canvas()
    # rebuild sleepy cleaner without broken moon
    d2 = ImageDraw.Draw(img2)
    soft_shadow(d2)
    body_stub(d2)
    d2.polygon([(160, 200), (210, 35), (310, 165)], fill=(125, 105, 205, 255))
    d2.ellipse((145, 155, 345, 235), fill=(145, 125, 225, 255))
    d2.ellipse((285, 30, 350, 95), fill=(255, 230, 140, 255))
    head(d2, cy=275)
    d2.arc((185, 245, 245, 295), 200, 340, fill=PUPIL, width=9)
    d2.arc((265, 245, 325, 295), 200, 340, fill=PUPIL, width=9)
    blush(d2, 256, 280)
    d2.arc((230, 310, 280, 350), 20, 160, fill=(220, 120, 130, 255), width=6)
    draw_z = lambda x, y, s, color=(160, 140, 230, 255): (
        d2.line([(x, y), (x + s, y)], fill=color, width=7),
        d2.line([(x + s, y), (x, y + s)], fill=color, width=7),
        d2.line([(x, y + s), (x + s, y + s)], fill=color, width=7),
    )
    draw_z(365, 115, 40)
    draw_z(400, 165, 30, (180, 160, 240, 255))
    draw_z(380, 205, 22, (200, 185, 250, 255))
    # crescent moon
    d2.ellipse((55, 150, 125, 220), fill=(255, 230, 140, 255))
    d2.ellipse((80, 145, 150, 215), fill=(0, 0, 0, 0))
    # hole won't work on same canvas — use composite
    moon_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    ml = ImageDraw.Draw(moon_layer)
    ml.ellipse((55, 150, 125, 220), fill=(255, 230, 140, 255))
    hole = Image.new("L", (SIZE, SIZE), 0)
    hd = ImageDraw.Draw(hole)
    hd.ellipse((55, 150, 125, 220), fill=255)
    hd.ellipse((80, 145, 150, 215), fill=0)
    moon_layer.putalpha(hole)
    img2.alpha_composite(moon_layer)
    plump_save(img2, path)


def make_scared(path):
    img = canvas()
    d = ImageDraw.Draw(img)
    soft_shadow(d, (130, 435, 380, 485))
    # ghost sheet body (unique silhouette)
    d.ellipse((130, 200, 380, 420), fill=(245, 248, 255, 255))
    d.rounded_rectangle((140, 280, 370, 460), radius=40, fill=(245, 248, 255, 255))
    # wavy bottom
    for i, x in enumerate(range(150, 360, 50)):
        d.ellipse((x, 430, x + 55, 490), fill=(245, 248, 255, 255))
    # face area on sheet
    d.ellipse((160, 150, 350, 340), fill=SKIN)
    d.ellipse((175, 165, 280, 250), fill=SKIN_LIGHT)
    # ears peek
    d.ellipse((145, 200, 185, 250), fill=SKIN)
    d.ellipse((325, 200, 365, 250), fill=SKIN)
    # wide scared eyes
    for dx in (-48, 48):
        ex, ey = 255 + dx, 230
        d.ellipse((ex - 34, ey - 38, ex + 34, ey + 38), fill=EYE_WHITE)
        d.ellipse((ex - 12, ey - 8, ex + 12, ey + 16), fill=PUPIL)
        d.ellipse((ex - 6, ey - 4, ex - 1, ey + 1), fill=(255, 255, 255, 230))
    blush(d, 255, 250)
    # small open mouth
    d.ellipse((235, 285, 275, 330), fill=(80, 50, 60, 255))
    # sweat drops
    for x, y in ((100, 180), (390, 200), (85, 280)):
        d.ellipse((x, y, x + 22, y + 35), fill=(140, 200, 240, 220))
        d.polygon([(x + 11, y - 12), (x, y + 12), (x + 22, y + 12)], fill=(140, 200, 240, 220))
    # hands up (scared)
    d.ellipse((95, 320, 155, 380), fill=SKIN)
    d.ellipse((355, 320, 415, 380), fill=SKIN)
    plump_save(img, path)


def main():
    os.makedirs(OUT, exist_ok=True)
    make_happy(os.path.join(OUT, "happy.png"))
    make_sad(os.path.join(OUT, "sad.png"))
    make_angry(os.path.join(OUT, "angry.png"))
    make_surprised(os.path.join(OUT, "surprised.png"))
    make_sleepy(os.path.join(OUT, "sleepy.png"))
    make_scared(os.path.join(OUT, "scared.png"))
    print("surprise redrawn:", sorted(os.listdir(OUT)))


if __name__ == "__main__":
    main()
