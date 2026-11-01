#!/usr/bin/env python3
"""Draw Birtunner's original pixel art. No external assets."""

from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
ART = ROOT / "art"

W, H = 20, 24
PALETTE = {
    ".": (0, 0, 0, 0),
    "#": (10, 26, 24, 255),
    "H": (226, 255, 242, 255),
    "G": (104, 232, 168, 255),
    "g": (42, 150, 104, 255),
    "E": (16, 22, 32, 255),
    "A": (255, 186, 74, 255),
    "L": (214, 255, 236, 255),
    "K": (24, 96, 70, 255),
    "w": (255, 255, 255, 255),
}


def frame(rows: list[str]) -> list[str]:
    if len(rows) != H:
        raise SystemExit(f"expected {H} rows, got {len(rows)}")
    for i, row in enumerate(rows):
        if len(row) != W:
            raise SystemExit(f"row {i} width {len(row)}: {row}")
    return rows


# Bit, a chip-shaped runner. Frames: idle, four run steps, airborne.
IDLE = frame(
    [
        "....................",
        ".........##.........",
        "........####........",
        ".......######.......",
        "......##HHHH##......",
        ".....####HHHH##.....",
        "....##HHHHHHHH##....",
        "...##HGGGGGGGGGH##..",
        "...#HHGGGGGGGGHH#...",
        "..##HHGGEGGGGEGHH##.",
        "..#HHHGGGGGGGGGHH#..",
        "..#HHHGG####GGGHH#..",
        "..#HHHGGGGGGGGGHH#..",
        "..#HHHGAAAAAAGHHH#..",
        "..##HHGGGGGGGGHH##..",
        "...#HHHGGGGGGHHH#...",
        "...##HHHHHHHHH##....",
        "....############....",
        "......###GG###......",
        ".....####GG####.....",
        "....##LLL##LLL##....",
        "....#LLL....LLL#....",
        "....#KKK....KKK#....",
        ".....###....###.....",
    ]
)

RUN_A = frame(
    [
        "....................",
        ".........##.........",
        "........####........",
        ".......######.......",
        "......##HHHH##......",
        ".....####HHHH##.....",
        "....##HHHHHHHH##....",
        "...##HGGGGGGGGGH##..",
        "...#HHGGGGGGGGHH#...",
        "..##HHGGEGGGGEGHH##.",
        "..#HHHGGGGGGGGGHH#..",
        "..#HHHGG####GGGHH#..",
        "..#HHHGGGGGGGGGHH#..",
        "..#HHHGAAAAAAGHHH#..",
        "..##HHGGGGGGGGHH##..",
        "...#HHHGGGGGGHHH#...",
        "...##HHHHHHHHH##....",
        "....############....",
        "......###GG###......",
        "....#####GG###......",
        "...##LLL##.........#",
        "...#LLL.....##KK##..",
        "...#KKK.....#KKK#...",
        "....###......###....",
    ]
)

RUN_B = frame(
    [
        "....................",
        ".........##.........",
        "........####........",
        ".......######.......",
        "......##HHHH##......",
        ".....####HHHH##.....",
        "....##HHHHHHHH##....",
        "...##HGGGGGGGGGH##..",
        "...#HHGGGGGGGGHH#...",
        "..##HHGGEGGGGEGHH##.",
        "..#HHHGGGGGGGGGHH#..",
        "..#HHHGG####GGGHH#..",
        "..#HHHGGGGGGGGGHH#..",
        "..#HHHGAAAAAAGHHH#..",
        "..##HHGGGGGGGGHH##..",
        "...#HHHGGGGGGHHH#...",
        "...##HHHHHHHHH##....",
        "....############....",
        "......###GG###......",
        "......###GG###......",
        ".....##LL##LL##.....",
        ".....#LLL..LLL#.....",
        ".....#KKK..KKK#.....",
        "......##....##......",
    ]
)

RUN_C = frame(
    [
        "....................",
        ".........##.........",
        "........####........",
        ".......######.......",
        "......##HHHH##......",
        ".....####HHHH##.....",
        "....##HHHHHHHH##....",
        "...##HGGGGGGGGGH##..",
        "...#HHGGGGGGGGHH#...",
        "..##HHGGEGGGGEGHH##.",
        "..#HHHGGGGGGGGGHH#..",
        "..#HHHGG####GGGHH#..",
        "..#HHHGGGGGGGGGHH#..",
        "..#HHHGAAAAAAGHHH#..",
        "..##HHGGGGGGGGHH##..",
        "...#HHHGGGGGGHHH#...",
        "...##HHHHHHHHH##....",
        "....############....",
        "......###GG###......",
        "......###GG#####....",
        "#.........##LLL##...",
        "..##KK##....LLL#....",
        "...#KKK#....KKK#....",
        "....###......###....",
    ]
)

RUN_D = frame(
    [
        "....................",
        ".........##.........",
        "........####........",
        ".......######.......",
        "......##HHHH##......",
        ".....####HHHH##.....",
        "....##HHHHHHHH##....",
        "...##HGGGGGGGGGH##..",
        "...#HHGGwGGGwGHH#...",
        "..##HHGGEGGGGEGHH##.",
        "..#HHHGGGGGGGGGHH#..",
        "..#HHHGG####GGGHH#..",
        "..#HHHGGGGGGGGGHH#..",
        "..#HHHGAAAAAAGHHH#..",
        "..##HHGGGGGGGGHH##..",
        "...#HHHGGGGGGHHH#...",
        "...##HHHHHHHHH##....",
        "....############....",
        ".....####GG####.....",
        ".....##LLLLLL##.....",
        ".....#LLL..LLL#.....",
        ".....#KKK..KKK#.....",
        "......##....##......",
        "....................",
    ]
)

JUMP = frame(
    [
        "....................",
        ".........##.........",
        "........####........",
        ".......######.......",
        "......##HHHH##......",
        ".....####HHHH##.....",
        "....##HHHHHHHH##....",
        "...##HGGGGGGGGGH##..",
        "...#HHGGwGGGwGHH#...",
        "..##HHGGEGGGGEGHH##.",
        "..#HHHGGGGGGGGGHH#..",
        "..#HHHGG####GGGHH#..",
        "..#HHHGGGGGGGGGHH#..",
        "..#HHHGAAAAAAGHHH#..",
        "..##HHGGGGGGGGHH##..",
        "...#HHHGGGGGGHHH#...",
        "...##HHHHHHHHH##....",
        "....############....",
        "...###..GG..###.....",
        "..##LLL.##.LLL##....",
        "..#LLL......LLL#....",
        "..#KKK......KKK#....",
        "...###......###.....",
        "....................",
    ]
)


def blit_frame(sheet: Image.Image, rows: list[str], index: int) -> None:
    px = sheet.load()
    x0 = index * W
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            px[x0 + x, y] = PALETTE[ch]


def rounded_button(kind: str, pressed: bool) -> Image.Image:
    size = 96
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    fill = (28, 64, 70, 230) if pressed else (16, 28, 40, 214)
    border = (210, 255, 236, 255) if pressed else (90, 240, 200, 255)
    draw.rounded_rectangle((2, 2, size - 3, size - 3), radius=18, fill=fill, outline=border, width=4)
    icon = (236, 255, 248, 255)
    cx, cy = 48, 50
    if kind == "left":
        draw.polygon([(30, cy), (62, 28), (62, 72)], fill=icon)
    elif kind == "right":
        draw.polygon([(66, cy), (34, 28), (34, 72)], fill=icon)
    else:
        draw.polygon([(cx, 26), (28, 52), (40, 52), (40, 70), (56, 70), (56, 52), (68, 52)], fill=icon)
    return img


def _fill(image: Image.Image, box: tuple[int, int, int, int], color: tuple[int, int, int, int]) -> None:
    pixels = image.load()
    x0, y0, x1, y1 = box
    for y in range(y0, y1):
        for x in range(x0, x1):
            pixels[x, y] = color


def _stamp(image: Image.Image, origin: tuple[int, int], rows: list[str], palette: dict[str, tuple[int, int, int, int]]) -> None:
    pixels = image.load()
    ox, oy = origin
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            if ch != ".":
                pixels[ox + x, oy + y] = palette[ch]


def _save_icon(image: Image.Image, name: str) -> None:
    image.save(ART / name)
    image.resize((image.width * 8, image.height * 8), Image.Resampling.NEAREST).save(f"/tmp/{name}")


def desk_sprites() -> None:
    paper = (244, 230, 198, 255)
    ink = (54, 36, 28, 255)
    shade = (196, 164, 118, 255)
    red = (214, 52, 66, 255)
    white = (255, 244, 236, 255)
    sky = (86, 176, 184, 255)
    hill = (118, 168, 104, 255)
    heart = {"R": red, "w": white, "p": paper, "#": ink}

    letter = Image.new("RGBA", (24, 32), (0, 0, 0, 0))
    _fill(letter, (2, 2, 22, 30), paper)
    pixels = letter.load()
    for x in range(2, 22):
        pixels[x, 2] = ink
        pixels[x, 29] = ink
    for y in range(2, 30):
        pixels[2, y] = ink
        pixels[21, y] = ink
    # Folded corner, so it reads as a sheet of paper.
    for i, y in enumerate(range(3, 8)):
        pixels[16 + i, y] = shade
        pixels[21, y] = ink
    pixels[16, 3] = ink
    _stamp(
        letter,
        (6, 8),
        [
            ".RR..RR.",
            "RRRRRRRR",
            "RRRRRRRR",
            ".RRRRRR.",
            "..RRRR..",
            "...RR...",
        ],
        heart,
    )
    for y in (20, 23, 26):
        for x in range(5, 19):
            pixels[x, y] = shade
    _save_icon(letter, "letter_icon.png")

    album = Image.new("RGBA", (24, 28), (0, 0, 0, 0))
    _fill(album, (3, 6, 23, 24), paper)
    _fill(album, (5, 2, 21, 8), shade)
    ap = album.load()
    for x in range(3, 23):
        ap[x, 6] = ink
        ap[x, 23] = ink
    for y in range(6, 24):
        ap[3, y] = ink
        ap[22, y] = ink
    _fill(album, (6, 9, 20, 20), sky)
    _stamp(
        album,
        (6, 12),
        [
            "......gggggg",
            "....gggggggg",
            "..gggggggggg",
            "gggggggggggg",
        ],
        {"g": hill},
    )
    _save_icon(album, "album_icon.png")

    love = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    _stamp(
        love,
        (1, 1),
        [
            ".RR....RR.",
            "RRRw..wRRR",
            "RRRRRRRRRR",
            "RRRRRRRRRR",
            ".RRRpRRRR.",
            "..RRRRRR..",
            "...RRRR...",
            "....RR....",
        ],
        heart,
    )
    _save_icon(love, "love.png")


def splash_and_icon(bit: Image.Image) -> None:
    def paste_nearest(base: Image.Image, sprite: Image.Image, scale: int, center: tuple[int, int]) -> None:
        big = sprite.resize((sprite.width * scale, sprite.height * scale), Image.Resampling.NEAREST)
        base.alpha_composite(big, (center[0] - big.width // 2, center[1] - big.height // 2))

    icon = Image.new("RGBA", (128, 128), (18, 22, 34, 255))
    draw = ImageDraw.Draw(icon)
    draw.rounded_rectangle((6, 6, 121, 121), radius=24, fill=(14, 32, 36, 255), outline=(90, 240, 200, 255), width=4)
    paste_nearest(icon, bit, 3, (64, 66))
    icon.save(ROOT / "icon.png")

    splash = Image.new("RGBA", (256, 256), (18, 21, 31, 255))
    sdraw = ImageDraw.Draw(splash)
    sdraw.line((16, 48, 240, 48), fill=(32, 120, 110, 180), width=2)
    sdraw.line((16, 208, 240, 208), fill=(32, 120, 110, 180), width=2)
    sdraw.rectangle((28, 78, 92, 108), fill=(20, 40, 48, 255), outline=(80, 200, 170, 255))
    paste_nearest(splash, bit, 5, (138, 128))
    splash.save(ART / "splash.png")


def main() -> None:
    ART.mkdir(parents=True, exist_ok=True)
    frames = [IDLE, RUN_A, RUN_B, RUN_C, RUN_D, JUMP]
    sheet = Image.new("RGBA", (W * len(frames), H), (0, 0, 0, 0))
    for i, rows in enumerate(frames):
        blit_frame(sheet, rows, i)
    sheet.save(ART / "bit_sheet.png")

    preview = sheet.resize((sheet.width * 8, sheet.height * 8), Image.Resampling.NEAREST)
    preview.save("/tmp/bit_preview.png")

    for kind, name in (("left", "btn_left"), ("right", "btn_right"), ("jump", "btn_jump")):
        rounded_button(kind, False).save(ART / f"{name}.png")
        rounded_button(kind, True).save(ART / f"{name}_down.png")

    splash_and_icon(sheet.crop((0, 0, W, H)))
    desk_sprites()
    print("wrote art")


if __name__ == "__main__":
    main()
