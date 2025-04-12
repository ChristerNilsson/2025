# Brother
# Layout: Liggande
# Marginaler: Standard

# round sparar inte många bytes
# Defs sparar kanske 50% av storleken
# Text klarar inte att överföra innehåll som parameter med Defs/Use

from fasthtml.common import *
from fasthtml.svg import Svg, Rect, Text, Defs, Use, Line

# A = 30 # Bredden på dragnummer
# B = 85 # Bredden på ett drag
# ABB = A + B + B
# WIDTH = 6 * ABB # Sidans bredd
#
# HEIGHT = 823 # Sidans höjd
# DY = HEIGHT/24

app, rt = fast_app()

# def page(offset,tables,topTexts,bottomTexts):
#     elements = []
#     for header in topTexts:
#         elements.append(Text(header['text'], x=header['x'], y=round(offset+20,2), text_anchor="left", fill='black', font_size="16"))
#
#     for header in bottomTexts:
#         elements.append(Text(header['text'], x=header['x'], y=round(offset+20+23*DY,2), text_anchor="left", fill='black', font_size="16"))
#
#     for nr in range(2*6):
#         table = tables[nr]
#         for j in range(10):
#             cy = offset + table['y'] + j * DY
#             cx = table['x']
#             elements.append(Use(href="#r", x=cx+A,   y=round(cy+1*DY,2)))
#             elements.append(Use(href="#r", x=cx+A+B, y=round(cy+1*DY,2)))
#             number = table['nr']+j
#             if number == 13: number = "·"
#             elements.append(Text(number, x=cx+A/2, y=round(cy + 1.7*DY,2), text_anchor="middle", fill='black', font_size="16"))
#     return elements

@rt("/")
def get():

    elements = []

    # elements.append(Svg(
    #     width="100",
    #     height="100",
    #     viewBox="0 0 100 100",
    #     children=[
    #         # Första linjen vid 20%
    #         Line(x1="10", y1="20", x2="90", y2="20", stroke="black", stroke_width="1"),
    #         # Andra linjen vid 80%
    #         Line(x1="10", y1="80", x2="90", y2="80", stroke="black", stroke_width="1")
    #     ],
    #     # style="width: 100; height: 100;"
    # ))


    # page = Page(children=[svg])
    # html = page.render()
    # print(html)

    # elements += Line(x1,y1,x2,y2)

    elements = []

    elements.append(Rect(width=80, height=80, x=10, y=10, fill='white', stroke='black', stroke_width=0.1))

    return [Title("Chess Landscape"),Svg(*elements,width='100%',height='100vh', viewBox="0 0 100 100")]

serve()