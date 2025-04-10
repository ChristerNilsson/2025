# Brother
# Layout: Liggande
# Marginaler: Standard

from fasthtml.common import *
from fasthtml.svg import Svg, Circle, Rect, Text

A = 30 # Bredden på dragnummer
B = 170 # Bredden på ett drag
ABB = A + B + B
WIDTH = 3 * ABB # Sidans bredd

DY = 32 # Höjden på en rad.
HEIGHT = DY * 24 # Sidans höjd

app, rt = fast_app()

@rt("/")
def get():
    elements = []
    tables = []
    tables.append({'nr':  1, 'x':0,    'y':10})
    tables.append({'nr': 11, 'x':ABB,  'y':10})
    tables.append({'nr': 21, 'x':2*ABB,'y':10})
    tables.append({'nr': 31, 'x':0,    'y':370})
    tables.append({'nr': 41, 'x':ABB,  'y':370})
    tables.append({'nr': 51, 'x':2*ABB,'y':370})
    for nr in range(6):
        table = tables[nr]
        for j in range(10):
            cy = table['y'] + j * DY
            cx = table['x']
            elements.append(Rect(width=B,height=DY,x=cx+A,   y=cy+DY, fill='white',stroke='black',stroke_width=1))
            elements.append(Rect(width=B,height=DY,x=cx+A+B, y=cy+DY, fill='white',stroke='black',stroke_width=1))
            t = Text(table['nr']+j, x=cx+A/2, y=cy + 1.7*DY, text_anchor="middle", font_size="16", fill='black')
            elements.append(t)

            for i in range(2):
                if i==0:
                    cx = table['x'] + A + 0.5*B
                else:
                    cx = table['x'] + A + 1.5*B
                elements.append(Circle(cx=cx-6, cy=cy+1.5*DY, r=0.25,fill='white',stroke='black', stroke_width=1))
                elements.append(Circle(cx=cx+0, cy=cy+1.5*DY, r=0.25,fill='white',stroke='black', stroke_width=1))
                elements.append(Circle(cx=cx+6, cy=cy+1.5*DY, r=0.25,fill='white',stroke='black', stroke_width=1))

    a = Svg(*elements,width=WIDTH,height=HEIGHT,viewBox=f"0 0 {WIDTH+1} {HEIGHT}")
    return Svg(a,w=WIDTH+1,h=HEIGHT)

serve()