"""Gera as imagens da marca Somou: carrinho branco + selo laranja com "+".

- assets/icon/: ícone do app (completo, primeiro plano adaptativo e monocromático)
- assets/splash/: splash screen e logo do cabeçalho da Home

Uso: python tool/make_images.py assets
"""
import sys
from pathlib import Path
from PIL import Image, ImageDraw

OUT = Path(sys.argv[1])
GREEN = (31, 122, 69, 255)       # header  #1F7A45
ORANGE = (255, 122, 48, 255)     # accent  #FF7A30
WHITE = (255, 255, 255, 255)
CLEAR = (0, 0, 0, 0)
SS = 4                           # supersampling

# Desenho em um espaço 1024×1024.
HANDLE = [(222, 352), (302, 352), (412, 648)]
BASKET = [(330, 438), (812, 438), (752, 648), (412, 648)]
WHEELS = [(452, 748), (716, 748)]
BADGE = (774, 330)
CENTER = (517, 550)              # centro aproximado do desenho


def motif(size, scale, bg=CLEAR, mono=False):
    s = size * SS
    img = Image.new("RGBA", (s, s), bg)
    d = ImageDraw.Draw(img)
    k = s / 1024 * scale

    def p(x, y):
        return ((x - CENTER[0]) * k + s / 2, (y - CENTER[1]) * k + s / 2)

    stroke = 58 * k
    d.line([p(*pt) for pt in HANDLE], fill=WHITE, width=round(stroke), joint="curve")
    for pt in (HANDLE[0], HANDLE[-1]):
        cx, cy = p(*pt)
        d.ellipse([cx - stroke / 2, cy - stroke / 2, cx + stroke / 2, cy + stroke / 2], fill=WHITE)
    d.polygon([p(*pt) for pt in BASKET], fill=WHITE)
    # Cantos arredondados do cesto.
    d.line([p(*pt) for pt in BASKET + [BASKET[0]]], fill=WHITE, width=round(30 * k), joint="curve")
    for wx, wy in WHEELS:
        cx, cy = p(wx, wy)
        r = 50 * k
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=WHITE)

    # Selo "+": recorte em volta, círculo laranja e uma cruz. No monocromático
    # só a forma conta, então o círculo fica branco e a cruz vazada.
    bx, by = p(*BADGE)
    ring, r = 150 * k, 118 * k
    d.ellipse([bx - ring, by - ring, bx + ring, by + ring], fill=CLEAR if mono else bg)
    d.ellipse([bx - r, by - r, bx + r, by + r], fill=WHITE if mono else ORANGE)
    arm, thick = 128 * k, 34 * k
    cross = CLEAR if mono else WHITE
    d.rounded_rectangle([bx - arm / 2, by - thick / 2, bx + arm / 2, by + thick / 2],
                        radius=thick / 2, fill=cross)
    d.rounded_rectangle([bx - thick / 2, by - arm / 2, bx + thick / 2, by + arm / 2],
                        radius=thick / 2, fill=cross)
    return img.resize((size, size), Image.LANCZOS)


icon, splash = OUT / "icon", OUT / "splash"
icon.mkdir(parents=True, exist_ok=True)
splash.mkdir(parents=True, exist_ok=True)

# Ícone completo (iOS e Android antigo): fundo verde, sem transparência.
motif(1024, 0.92, GREEN).save(icon / "icon.png")
# Camadas do ícone adaptativo; o flutter_launcher_icons já aplica 16% de margem.
motif(1024, 0.92).save(icon / "icon_foreground.png")
motif(1024, 0.92, mono=True).save(icon / "icon_monochrome.png")

# O Android 12+ recorta um círculo de 2/3 da splash, por isso a margem.
motif(1152, 0.62).save(splash / "splash.png")
# Mesmo desenho sem margem, para o cabeçalho da Home.
logo = motif(1024, 1.0)
logo.crop(logo.getbbox()).save(splash / "logo.png")
print("ok")
