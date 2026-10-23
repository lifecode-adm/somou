"""Ajusta prints do celular ao limite de proporção 2:1 da Play Store.

Corta a barra de status e a barra de navegação (proporcionais à altura, medidas
num Galaxy 1080×2340 com navegação por botões) e salva em PNG.

Uso: python tool/crop_screenshots.py <pasta-de-entrada> <pasta-de-saída>
Os arquivos são processados em ordem alfabética e saem numerados: 01.png, 02.png…
"""
import sys
from pathlib import Path
from PIL import Image

STATUS_BAR = 0.047      # topo: hora, sinal e bateria
NAVIGATION_BAR = 0.058  # base: botões de voltar, início e recentes
MAX_RATIO = 2.0

src, out = Path(sys.argv[1]), Path(sys.argv[2])
out.mkdir(parents=True, exist_ok=True)
files = sorted(p for p in src.iterdir() if p.suffix.lower() in (".png", ".jpg", ".jpeg"))
for index, path in enumerate(files, start=1):
    img = Image.open(path).convert("RGB")
    w, h = img.size
    top, bottom = round(h * STATUS_BAR), h - round(h * NAVIGATION_BAR)
    cropped = img.crop((0, top, w, bottom))
    ratio = cropped.height / cropped.width
    assert ratio <= MAX_RATIO, f"{path.name}: proporção {ratio:.2f} ainda passa de 2:1"
    target = out / f"{index:02d}.png"
    cropped.save(target)
    print(f"{path.name} {w}x{h} -> {target.name} {cropped.width}x{cropped.height} ({ratio:.2f})")
