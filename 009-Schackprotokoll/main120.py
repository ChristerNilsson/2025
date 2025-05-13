from fasthtml.common import fast_app,serve,Title
from fasthtml.svg import Svg, Rect, Text, Line, Defs, Use, Group

A = 30 # Bredden på dragnummer
B = 85 # Bredden på ett drag
ABB = A + B + B
ABBABB = A + B + B + A +B + B
WIDTH = 6 * ABB # Sidans bredd

HEIGHT = 823 # Sidans höjd
DY = HEIGHT/24

app, rt = fast_app()

def page(offset,tables,topTexts,bottomTexts):

    elements =  [Text(tt['text'], x=tt['x'], y=offset+20, text_anchor="left", font_size="16") for tt in topTexts]
    elements += [Text(bt['text'], x=bt['x'], y=offset+20+23*DY) for bt in bottomTexts]

    # elements.append(Line(id="r", x1=0, y1=0, x2=100, y2=100, stroke='red', stroke_width=3))
#    elements.append(Rect(id="r", x=100, y=offset+12*DY, width=1000, height=1, fill='black', stroke='none', stroke_width=1))
    elements.append(Line(x1=A, y1=offset+12*DY, x2=6*ABB, y2=offset+12*DY, stroke='black', stroke_width=1))

    for nr in range(6):
        table = tables[nr]

        for j in range(10):
            cy = offset + table['y'] + j * DY
            cx = table['x']

            elements.append(Rect(id="r", x=cx,   y=cy+DY, width=B, height=DY, fill='white', stroke='black', stroke_width=1))
            elements.append(Rect(id="r", x=cx+B, y=cy+DY, width=B, height=DY, fill='white', stroke='black', stroke_width=2))

            number = (table['nr']+j)
            elements.append(Text(f" {number}", x=cx+B+B+A/2, y=cy + 1.7*DY, text_anchor="middle", font_size="16"))

            elements.append(Rect(id="r", x=cx+B+B+A,   y=cy+DY, width=B, height=DY, fill='white', stroke='black', stroke_width=2))
            elements.append(Rect(id="r", x=cx+B+B+A+B, y=cy+DY, width=B, height=DY, fill='white', stroke='black', stroke_width=1))


    # for nr in range(3):
    #     table = tables[nr]
    #
    #     cx = A + B + table['x'] + nr * (B + A + B)
    #     cy = offset + table['y'] + DY
    #     elements.append(Rect(id="r", x=cx, y=cy, width=B+A+B, height=10*DY, fill='none', stroke='black', stroke_width=2))

    return elements

@rt("/")
def get():
    tables = [{'nr': 1 + 10*(3*i+j), 'x':A+j*ABBABB, 'y':i*12*DY} for i in range(2) for j in range(3)]

    topTexts = []
    topTexts.append({'x':10, 'text':'White:'})
    topTexts.append({'x':110, 'text':'·'})
    topTexts.append({'x':400, 'text':'Black:'})
    topTexts.append({'x':500, 'text':'·'})
    topTexts.append({'x':800, 'text':'Date:'})
    topTexts.append({'x':900, 'text':'·'})
    topTexts.append({'x':940, 'text':'·'})
    topTexts.append({'x':1000, 'text':'Time:'})
    topTexts.append({'x':1065, 'text':'·'})
    topTexts.append({'x':1100, 'text':'Result:'})
    topTexts.append({'x':1170, 'text':'·'})

    bottomTexts = []
    bottomTexts.append({'x':10, 'text':'Christer Nilsson'})
    bottomTexts.append({'x':550, 'text':'Panorama Protocol 1.2'})
    bottomTexts.append({'x':1095, 'text':'070 · 749 6800'})

    elements = []

    elements += page(0,tables,topTexts,bottomTexts)
    elements += page(HEIGHT,tables,topTexts,bottomTexts)

    return [Title("Panorama"),Svg(*elements,width=WIDTH+2,height=2*HEIGHT)]

serve()