# Brother
# Layout: Liggande
# Marginaler: Standard

from fasthtml.common import *
from fasthtml.svg import Svg, Circle, Rect, Text

A = 30 # Bredden på dragnummer
B = 85 # Bredden på ett drag
ABB = A + B + B
WIDTH = 6 * ABB # Sidans bredd

HEIGHT = 823 # Sidans höjd
DY = HEIGHT/24

app, rt = fast_app()

def page(offset,tables,topTexts,bottomTexts):
    elements = []
    for header in topTexts:
        elements.append(Text(header['text'], x=header['x'], y=offset+20, text_anchor="left", font_size="16", fill='black'))

    for header in bottomTexts:
        elements.append(Text(header['text'], x=header['x'], y=offset+20+23*DY, text_anchor="left", font_size="16", fill='black'))

    for nr in range(2*6):
        table = tables[nr]
        for j in range(10):
            cy = offset + table['y'] + j * DY
            cx = table['x']
            elements.append(Rect(width=B,height=DY,x=cx+A,   y=cy+1*DY, fill='white',stroke='black',stroke_width=1))
            elements.append(Rect(width=B,height=DY,x=cx+A+B, y=cy+1*DY, fill='white',stroke='black',stroke_width=1))
            t = Text(table['nr']+j, x=cx+A/2, y=cy + 1.7*DY, text_anchor="middle", font_size="16", fill='black')
            elements.append(t)
    return elements

@rt("/")
def get():
    tables = []
    tables.append({'nr':  1, 'x':0,     'y':0})
    tables.append({'nr': 11, 'x':ABB,   'y':0})
    tables.append({'nr': 21, 'x':2*ABB, 'y':0})
    tables.append({'nr': 31, 'x':3*ABB, 'y':0})
    tables.append({'nr': 41, 'x':4*ABB, 'y':0})
    tables.append({'nr': 51, 'x':5*ABB, 'y':0})
    tables.append({'nr': 61, 'x':0,     'y':0+12*DY})
    tables.append({'nr': 71, 'x':ABB,   'y':0+12*DY})
    tables.append({'nr': 81, 'x':2*ABB, 'y':0+12*DY})
    tables.append({'nr': 91, 'x':3*ABB, 'y':0+12*DY})
    tables.append({'nr': 101,'x':4*ABB, 'y':0+12*DY})
    tables.append({'nr': 111,'x':5*ABB, 'y':0+12*DY})

    topTexts = []
    topTexts.append({'x':10, 'text':'White:'})
    topTexts.append({'x':400, 'text':'Black:'})
    topTexts.append({'x':800, 'text':'Date:'})
    topTexts.append({'x':1000, 'text':'Time:'})
    topTexts.append({'x':1100, 'text':'Result:'})

    bottomTexts = []
    bottomTexts.append({'x':10, 'text':'Christer Nilsson 070-749 6800'})

    elements = []
    elements += page(0,tables,topTexts,bottomTexts)
    elements += page(HEIGHT,tables,topTexts,bottomTexts)

    return Svg(*elements,width=WIDTH+2,height=2*HEIGHT)

serve()