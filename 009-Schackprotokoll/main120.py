from fasthtml.common import fast_app,serve,Title
from fasthtml.svg import Svg, Rect, Text, Defs, Use, Group

A = 30 # Bredden på dragnummer
B = 85 # Bredden på ett drag
ABB = A + B + B
WIDTH = 6 * ABB # Sidans bredd

HEIGHT = 823 # Sidans höjd
DY = HEIGHT/24

app, rt = fast_app()

def page(offset,tables,topTexts,bottomTexts):

    elements =  [Text(tt['text'], x=tt['x'], y=offset+20, text_anchor="left", font_size="16") for tt in topTexts]
    elements += [Text(bt['text'], x=bt['x'], y=offset+20+23*DY) for bt in bottomTexts]

    for nr in range(2*6):
        table = tables[nr]
        for j in range(10):
            cy = offset + table['y'] + j * DY
            cx = table['x']

            elements.append(Rect(id="r", x=cx+A,   y=cy+DY, width=B, height=DY, fill='white', stroke='black', stroke_width=1))
            elements.append(Rect(id="r", x=cx+A+B, y=cy+DY, width=B, height=DY, fill='white', stroke='black', stroke_width=1))

            number = (table['nr']+j) % 10
            elements.append(Text(f" {number}", x=cx+A/2, y=cy + 1.7*DY, text_anchor="left", font_size="16"))
    return elements

@rt("/")
def get():
    tables = [{'nr': 1 + 10*(6*i+j), 'x':j*ABB, 'y':i*12*DY} for i in range(2) for j in range(6)]

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
    bottomTexts.append({'x':550, 'text':'Panorama Protocol 1.1'})
    bottomTexts.append({'x':1095, 'text':'070 · 749 6800'})

    elements = []

    elements += page(0,tables,topTexts,bottomTexts)
    elements += page(HEIGHT,tables,topTexts,bottomTexts)

    return [Title("Panorama"),Svg(*elements,width=WIDTH+2,height=2*HEIGHT)]

serve()