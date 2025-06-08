from fasthtml.common import fast_app,serve,Title
from fasthtml.svg import Svg, Rect, Text, Line

A = 30 # Bredden på dragnummer
B = 85 + 5 + 5 # Bredden på ett drag
ABB = A + B + B
WIDTH = 6 * ABB # Sidans bredd

HEIGHT = 823+83 # Sidans höjd
DY = HEIGHT/24

app, rt = fast_app()

# def badMoves(x,offset):
#     return [Circle(13,x+i*32, offset+A/2, fill='none', stroke='black') for i in range(3)]

def page(offset,tables,topTexts,bottomTexts):

    elements =  [Text(tt['text'], x=tt['x'], y=offset+20,       text_anchor=tt['anchor'], font_size="16") for tt in topTexts]
    elements += [Text(bt['text'], x=bt['x'], y=offset+20+23*DY, text_anchor=bt['anchor']) for bt in bottomTexts]
    # elements += badMoves(3*B + 2*A,  offset)
    # elements += badMoves(7*B + 3.5*A,offset)

    elements.append(Line(x1=A, y1=offset+12*DY, x2=6.0*A+12*B, y2=offset+12*DY, stroke='black', stroke_width=1))

    for nr in range(12):
        table = tables[nr]

        for j in range(10):
            cy = offset + table['y'] + j * DY
            cx = table['x']

            number = (table['nr']+j)
            #elements.append(Text(f" {number}", x=cx+B+B+A/2, y=cy + 1.7*DY, text_anchor="middle", font_size="16"))
            elements.append(Text(f" {number}", x=cx+0+0-A/2, y=cy + 1.7*DY, text_anchor="middle", font_size="16"))

            elements.append(Rect(id="r", x=cx,   y=cy+DY, width=B, height=DY, fill='white', stroke='black', stroke_width=1))
            elements.append(Rect(id="r", x=cx+B, y=cy+DY, width=B, height=DY, fill='white', stroke='black', stroke_width=1))

            # elements.append(Text(f" {number}", x=cx+B+B+A-A/2, y=cy + 1.7*DY, text_anchor="middle", font_size="16"))

            # elements.append(Rect(id="r", x=cx+B+B+A,   y=cy+DY, width=B, height=DY, fill='white', stroke='black', stroke_width=1))
            # elements.append(Rect(id="r", x=cx+B+B+A+B, y=cy+DY, width=B, height=DY, fill='white', stroke='black', stroke_width=1))
            # elements.append(Rect(id="r", x=cx+B+B+A*1.0,   y=cy+DY, width=B, height=DY, fill='white', stroke='black', stroke_width=1))
            # elements.append(Rect(id="r", x=cx+B+B+A*1.0+B, y=cy+DY, width=B, height=DY, fill='white', stroke='black', stroke_width=1))

    return elements

@rt("/")
def get():
#    tables = [{'nr': 1 + 10*(3*i+j), 'x':A/2+j*(1.5*A + 4*B), 'y':i*12*DY} for i in range(2) for j in range(3)]
    tables = [{'nr': 1 + 60*i + 10*j, 'x':A/1+j*(1.0*A + 2*B), 'y':i*12*DY} for i in range(2) for j in range(6)]

    topTexts = []
    topTexts.append({'x':1.0*A, 'text':'White:', 'anchor':'left'})
    topTexts.append({'x':1.0*A+B, 'text':'·', 'anchor':'left'})
    topTexts.append({'x':2.5*A + 4*B, 'text':'Black:', 'anchor':'left'})
    topTexts.append({'x':2.5*A + 5*B, 'text':'·', 'anchor':'left'})
    topTexts.append({'x':4.0*A + 8*B, 'text':'Date:', 'anchor':'left'})
    topTexts.append({'x':7.5*A + 8*B, 'text':'·', 'anchor':'left'})
    topTexts.append({'x':8.5*A + 8*B, 'text':'·', 'anchor':'left'})
    topTexts.append({'x':4.0*A + 10*B, 'text':'Time:', 'anchor':'left'})
    topTexts.append({'x':6.5*A + 10*B, 'text':'·', 'anchor':'left'})
    topTexts.append({'x':5.0*A + 11*B, 'text':'Res:', 'anchor':'left'})
    # topTexts.append({'x':1170, 'text':'·', 'anchor':'left'})

    bottomTexts = []
    bottomTexts.append({'x':1.0*A, 'text':'Christer Nilsson', 'anchor':'left'})
    bottomTexts.append({'x':3.5*A+6*B, 'text':'Panorama Protocol 1.4', 'anchor':'middle'})
    bottomTexts.append({'x':2.5*A+12*B, 'text':'070 · 749 6800', 'anchor':'right'})

    elements = []

    elements += page(0,tables,topTexts,bottomTexts)
    elements += page(HEIGHT,tables,topTexts,bottomTexts)

    return [Title("Panorama"),Svg(*elements,width=WIDTH+2,height=2*HEIGHT)]

serve()