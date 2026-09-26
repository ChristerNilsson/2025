from base64 import b64encode
from pathlib import Path

from fasthtml.common import fast_app, serve, Title
from fasthtml.svg import Svg, Rect, Text, Line, Image

A = 30 # Bredden på dragnummer
B = 85 + 5 + 5 # Bredden på ett drag
ABB = A + B + B
WIDTH = 6 * ABB # Sidans bredd

HEIGHT = 823 + 83 # Sidans höjd
DY = HEIGHT / 24
LOGO = 'data:image/svg+xml;base64,' + b64encode(
    Path(__file__).with_name('seniorschackstockholm.svg').read_bytes()
).decode('ascii')

app, rt = fast_app()


def information(offset):
    left, right = 12, ABB - 12
    split = left + 132
    elements = [Image(href=LOGO, x=left, y=offset + DY,
                      width=right-left, height=2*DY,
                      preserveAspectRatio='xMidYMid meet')]
    fields = [
        ('Tävling/match', 'Datum'),
        ('Klass/grupp', 'Rond'),
        ('Bord', 'Tid'),
        ('Vit', 'Elo'),
        ('Klubb', 'Poäng'),
        ('Svart', 'Elo'),
        ('Klubb', 'Poäng'),
    ]
    for row, labels in enumerate(fields):
        y = offset + (4 + 2.4*row)*DY
        for label, x, end in ((labels[0], left, split-10),
                              (labels[1], split, right)):
            elements.append(Text(label, x=x, y=y, font_size='16'))
            elements.append(Line(x1=x, y1=y+1.4*DY, x2=end,
                                 y2=y+1.4*DY, stroke='black', stroke_width=1))
    elements.append(Text('Panorama 1.5', x=left, y=offset+21.5*DY,
                         font_size='16'))
    elements.append(Text('Christer Nilsson', x=left, y=offset+22.5*DY,
                         font_size='16'))
    return elements


def page(offset, tables):
    elements = information(offset)
    elements.append(Line(x1=ABB+A, y1=offset+12*DY, x2=WIDTH,
                         y2=offset+12*DY, stroke='black', stroke_width=1))

    for table in tables:
        for j in range(10):
            cy = offset + table['y'] + j*DY
            cx = table['x']
            elements.append(Text(str(table['nr']+j), x=cx-A/2,
                                 y=cy+1.7*DY, text_anchor='middle', font_size='16'))
            elements.append(Rect(x=cx, y=cy+DY, width=B, height=DY,
                                 fill='white', stroke='black', stroke_width=1))
            elements.append(Rect(x=cx+B, y=cy+DY, width=B, height=DY,
                                 fill='white', stroke='black', stroke_width=1))
    return elements


@rt('/')
def get():
    tables = [{'nr': 1 + 50*i + 10*j, 'x': A+(j+1)*ABB, 'y': i*12*DY}
              for i in range(2) for j in range(5)]
    elements = page(0, tables) + page(HEIGHT, tables)
    return [Title('Panorama'), Svg(*elements, width=WIDTH+2, height=2*HEIGHT)]


if __name__ == '__main__':
    serve()
