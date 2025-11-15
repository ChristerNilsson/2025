# from fasthtml.common import FastHTML, serve

# app = FastHTML(live=True)

# @app.get("/")
# def home():
#     return "<h1>Hello, World</h1>"

# serve()

##############################

# from fasthtml.common import *
# page = Html(
#     Head(Title('Some page')),
#     Body(Div('Some text, ', A('A link', href='https://example.com'), Img(src="https://placehold.co/200"), cls='myclass')))
# print(to_xml(page))

##############################

from fasthtml.common import *
app = FastHTML()
rt = app.route

@rt("/greet/{nm}")
def get(nm:str):
    return Html(Head(Body(Div(f'Slumpad text {nm}, ', A('A link', href='https://example.com'), Img(src="https://placehold.co/200"), cls='myclass'))))

serve()

##############################

