"""Cute chibi ocean characters for Shadow Guardian (project original CC0)."""

from PIL import Image, ImageDraw
import os

OUT = r"c:\Users\Ali Kaan\Desktop\GitHub\shadow-guardian\assets\game\ocean"


def canvas():
    img = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    return img, ImageDraw.Draw(img)


def soft_shadow(d, box=(110, 420, 400, 475)):
    d.ellipse(box, fill=(30, 50, 80, 48))


def eyes(d, left, right, r=18, pupil=9):
    for cx, cy in (left, right):
        d.ellipse((cx - r, cy - r, cx + r, cy + r), fill=(255, 255, 255, 255))
        d.ellipse(
            (cx - pupil, cy - pupil + 2, cx + pupil, cy + pupil + 2),
            fill=(45, 55, 75, 255),
        )
        d.ellipse((cx - 5, cy - 8, cx - 1, cy - 4), fill=(255, 255, 255, 220))


def make_whale(path):
    img, d = canvas()
    soft_shadow(d, (100, 400, 410, 460))
    # body
    d.ellipse((70, 140, 440, 420), fill=(70, 110, 150, 255))
    d.ellipse((70, 140, 320, 300), fill=(95, 140, 180, 255))
    # belly
    d.ellipse((120, 260, 400, 420), fill=(230, 240, 250, 255))
    # eye patches
    d.ellipse((145, 195, 230, 275), fill=(230, 240, 250, 255))
    d.ellipse((280, 195, 365, 275), fill=(230, 240, 250, 255))
    eyes(d, (188, 235), (322, 235), r=16, pupil=8)
    # smile
    d.arc((200, 300, 310, 360), 20, 160, fill=(90, 120, 150, 255), width=6)
    # dorsal
    d.polygon([(240, 145), (270, 55), (300, 145)], fill=(60, 95, 135, 255))
    # flippers
    d.ellipse((55, 300, 140, 370), fill=(60, 95, 135, 255))
    d.ellipse((370, 300, 455, 370), fill=(60, 95, 135, 255))
    # blush
    d.ellipse((125, 270, 165, 300), fill=(240, 170, 180, 120))
    d.ellipse((345, 270, 385, 300), fill=(240, 170, 180, 120))
    img.save(path)


def make_penguin(path):
    img, d = canvas()
    soft_shadow(d, (140, 430, 370, 480))
    # body
    d.ellipse((120, 70, 390, 430), fill=(55, 70, 95, 255))
    d.ellipse((145, 95, 300, 250), fill=(75, 95, 125, 255))
    # belly
    d.ellipse((165, 180, 345, 410), fill=(250, 252, 255, 255))
    # face ovals
    d.ellipse((155, 110, 250, 220), fill=(250, 252, 255, 255))
    d.ellipse((260, 110, 355, 220), fill=(250, 252, 255, 255))
    eyes(d, (205, 160), (305, 160), r=17, pupil=8)
    # beak
    d.polygon([(235, 185), (275, 185), (255, 230)], fill=(255, 160, 60, 255))
    d.polygon([(242, 188), (268, 188), (255, 215)], fill=(255, 190, 100, 255))
    # flippers
    d.ellipse((85, 230, 155, 340), fill=(45, 60, 85, 255))
    d.ellipse((355, 230, 425, 340), fill=(45, 60, 85, 255))
    # feet
    d.ellipse((175, 405, 235, 445), fill=(255, 160, 60, 255))
    d.ellipse((275, 405, 335, 445), fill=(255, 160, 60, 255))
    # blush
    d.ellipse((150, 195, 185, 220), fill=(240, 170, 180, 130))
    d.ellipse((325, 195, 360, 220), fill=(240, 170, 180, 130))
    img.save(path)


def make_narwhal(path):
    img, d = canvas()
    soft_shadow(d, (110, 410, 400, 465))
    # horn
    d.polygon([(245, 40), (270, 200), (235, 200)], fill=(240, 230, 200, 255))
    d.polygon([(245, 40), (258, 200), (245, 200)], fill=(255, 245, 220, 255))
    # spiral marks
    for y in range(55, 185, 28):
        d.line([(248, y), (262, y + 10)], fill=(210, 195, 160, 255), width=3)
    # body
    d.ellipse((80, 170, 430, 430), fill=(150, 205, 230, 255))
    d.ellipse((90, 180, 300, 320), fill=(185, 225, 245, 255))
    # belly
    d.ellipse((130, 280, 390, 430), fill=(245, 250, 255, 255))
    eyes(d, (190, 260), (300, 260), r=18, pupil=9)
    d.arc((210, 300, 290, 350), 15, 165, fill=(100, 150, 180, 255), width=5)
    # flippers
    d.ellipse((60, 300, 130, 370), fill=(120, 180, 210, 255))
    d.ellipse((380, 300, 450, 370), fill=(120, 180, 210, 255))
    # blush
    d.ellipse((130, 285, 170, 315), fill=(240, 170, 180, 120))
    d.ellipse((340, 285, 380, 315), fill=(240, 170, 180, 120))
    # tiny spots
    d.ellipse((350, 230, 375, 255), fill=(120, 180, 210, 180))
    d.ellipse((320, 200, 340, 220), fill=(120, 180, 210, 160))
    img.save(path)


def make_fish(path):
    img, d = canvas()
    soft_shadow(d, (120, 405, 390, 460))
    # tail
    d.polygon([(70, 200), (160, 255), (70, 320)], fill=(255, 140, 50, 255))
    d.polygon([(85, 220), (150, 255), (85, 295)], fill=(255, 175, 80, 255))
    # body
    d.ellipse((130, 150, 430, 380), fill=(255, 150, 55, 255))
    d.ellipse((160, 165, 340, 290), fill=(255, 185, 95, 255))
    # fins
    d.polygon([(250, 150), (290, 70), (320, 150)], fill=(255, 130, 40, 255))
    d.polygon([(240, 320), (280, 400), (310, 320)], fill=(255, 130, 40, 255))
    # eye
    d.ellipse((320, 210, 390, 280), fill=(255, 255, 255, 255))
    d.ellipse((345, 230, 380, 265), fill=(45, 55, 75, 255))
    d.ellipse((350, 235, 362, 247), fill=(255, 255, 255, 220))
    # smile
    d.arc((350, 280, 410, 330), 20, 140, fill=(200, 100, 40, 255), width=5)
    # scales hint
    for cx, cy in ((220, 250), (250, 280), (200, 290)):
        d.arc((cx, cy, cx + 35, cy + 30), 200, 340, fill=(255, 120, 40, 160), width=3)
    # blush
    d.ellipse((300, 275, 335, 300), fill=(255, 140, 140, 130))
    img.save(path)


def make_octopus(path):
    img, d = canvas()
    soft_shadow(d, (100, 430, 410, 485))
    # tentacles
    tent_color = (230, 110, 150, 255)
    tent_dark = (200, 80, 120, 255)
    for i, x in enumerate([95, 150, 210, 280, 340, 395]):
        sway = 12 if i % 2 == 0 else -12
        d.ellipse((x, 280, x + 55, 460), fill=tent_color if i % 2 else tent_dark)
        d.ellipse(
            (x + sway, 400, x + 50 + sway, 470),
            fill=tent_color if i % 2 else tent_dark,
        )
        # suckers
        d.ellipse((x + 15, 360, x + 35, 380), fill=(255, 180, 200, 200))
        d.ellipse((x + 18, 410, x + 38, 430), fill=(255, 180, 200, 180))
    # head
    d.ellipse((110, 70, 400, 340), fill=(245, 130, 165, 255))
    d.ellipse((130, 90, 300, 240), fill=(255, 165, 190, 255))
    eyes(d, (205, 185), (305, 185), r=22, pupil=11)
    # smile
    d.arc((220, 220, 290, 280), 20, 160, fill=(190, 70, 110, 255), width=6)
    # blush
    d.ellipse((145, 210, 185, 240), fill=(255, 140, 160, 140))
    d.ellipse((325, 210, 365, 240), fill=(255, 140, 160, 140))
    img.save(path)


def make_crab(path):
    img, d = canvas()
    soft_shadow(d, (110, 420, 400, 475))
    # legs
    leg = (220, 90, 80, 255)
    for x in (95, 140, 350, 395):
        d.ellipse((x, 250, x + 40, 400), fill=leg)
        d.ellipse((x - 10, 370, x + 50, 420), fill=leg)
    # claws
    d.ellipse((40, 160, 150, 280), fill=(240, 110, 90, 255))
    d.ellipse((55, 175, 120, 230), fill=(255, 255, 255, 0))  # noop keep solid
    d.pieslice((40, 160, 150, 280), 200, 40, fill=(240, 110, 90, 255))
    d.ellipse((50, 175, 110, 235), fill=(255, 150, 120, 255))
    d.ellipse((360, 160, 470, 280), fill=(240, 110, 90, 255))
    d.ellipse((400, 175, 460, 235), fill=(255, 150, 120, 255))
    # claw tips gap
    d.polygon([(70, 200), (115, 185), (115, 250), (70, 235)], fill=(0, 0, 0, 0))
    # body
    d.ellipse((130, 140, 380, 370), fill=(245, 105, 85, 255))
    d.ellipse((150, 155, 300, 270), fill=(255, 140, 110, 255))
    eyes(d, (210, 230), (300, 230), r=20, pupil=10)
    # smile
    d.arc((230, 265, 280, 310), 15, 165, fill=(180, 60, 50, 255), width=5)
    # blush
    d.ellipse((155, 255, 190, 285), fill=(255, 150, 150, 120))
    d.ellipse((320, 255, 355, 285), fill=(255, 150, 150, 120))
    img.save(path)


def main():
    os.makedirs(OUT, exist_ok=True)
    make_whale(os.path.join(OUT, "whale.png"))
    make_penguin(os.path.join(OUT, "penguin.png"))
    make_narwhal(os.path.join(OUT, "narwhal.png"))
    make_fish(os.path.join(OUT, "fish.png"))
    make_octopus(os.path.join(OUT, "octopus.png"))
    make_crab(os.path.join(OUT, "crab.png"))
    # remove old triple-fish assets
    for old in ("blue_fish.png", "pink_fish.png"):
        p = os.path.join(OUT, old)
        if os.path.exists(p):
            os.remove(p)
    print("ocean assets ready:", sorted(os.listdir(OUT)))


if __name__ == "__main__":
    main()
