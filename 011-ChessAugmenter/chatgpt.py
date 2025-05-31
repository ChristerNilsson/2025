import chess.pgn
import chess.engine
import chess
import os
import time
import io
import re

TIME = 0.1
MPV = 5

HEADERS = "Date White WhiteElo Black BlackElo Result TimeControl ChapterURL".split(" ")
STOCKFISH_PATH = "C:\\Program Files\\stockfish\\stockfish-windows-x86-64-avx2.exe"

whiteStats = [0,0,0,0,0]
blackStats = [0,0,0,0,0]

def rensa_och_formattera_pgn(pgn_text):
    # Extrahera taggar (rader som börjar med [ och slutar med ])
    taggar = "\n".join(re.findall(r"^\[.*?\]$", pgn_text, re.MULTILINE))

    # Ta bort kommentarer, varianter och NAGs
    kropp = re.sub(r"\{[^}]*\}", "", pgn_text)  # kommentarer
    kropp = re.sub(r";[^\n]*", "", kropp)       # radkommentarer
    kropp = re.sub(r"\$\d+", "", kropp)         # NAGs
    kropp = re.sub(r"\([^()]*\)", "", kropp)    # varianter

    # Läs spelet i python-chess
    game = chess.pgn.read_game(io.StringIO(kropp))

    def rensa_node(node):
        node.comment = ""
        node.nags.clear()
        for var in node.variations:
            rensa_node(var)

    if not game:
        return taggar  # endast taggar

    rensa_node(game)

    # Bygg ny draglista med ett drag per rad
    node = game
    draglista = []
    move_number = 1
    while node.variations:
        next_node = node.variations[0]
        move = node.board().san(next_node.move)
        if node.board().turn:  # vit
            draglista.append(f"{move_number}. {move}")
        else:  # svart
            draglista[-1] += f" {move}"
            move_number += 1
        node = next_node

    # Slå ihop taggar + drag
    return taggar + "\n\n" + "\n".join(draglista) + "\n"


# def rensa_och_radbryt_pgn(pgn_text):
#     # Steg 1: Ta bort kommentarer, radkommentarer, NAGs, varianter
#     pgn_text = re.sub(r"\{[^}]*\}", "", pgn_text)
#     pgn_text = re.sub(r";[^\n]*", "", pgn_text)
#     pgn_text = re.sub(r"\$\d+", "", pgn_text)
#     pgn_text = re.sub(r"\([^()]*\)", "", pgn_text)
#
#     # Steg 2: Ladda in och ta bort ev. .comment
#     game = chess.pgn.read_game(io.StringIO(pgn_text))
#
#     def rensa_node(node):
#         node.comment = ""
#         node.nags.clear()
#         for var in node.variations:
#             rensa_node(var)
#
#     if game is None:
#         return ""
#
#     rensa_node(game)
#
#     # Steg 3: Gå igenom huvudvarianten och skriv ett drag per rad
#     node = game
#     draglista = []
#     move_number = 1
#     while node.variations:
#         next_node = node.variations[0]
#         move = node.board().san(next_node.move)
#         if node.board().turn:  # vit vid drag
#             draglista.append(f"{move_number}. {move}")
#         else:  # svart vid drag
#             draglista[-1] += f" {move}"
#             move_number += 1
#         node = next_node
#
#     return "\n".join(draglista)

# def rensa_pgn_fullständigt(pgn_text):
#     # Ta bort kommentarer: { ... }
#     pgn_text = re.sub(r"\{[^}]*\}", "", pgn_text)
#     # Ta bort radkommentarer: ; ...
#     pgn_text = re.sub(r";[^\n]*", "", pgn_text)
#     # Ta bort NAGs: $1, $2, ..., $255
#     pgn_text = re.sub(r"\$\d+", "", pgn_text)
#     # Ta bort varianter: ( ... )
#     # OBS: detta tar inte bort nästlade parenteser
#     pgn_text = re.sub(r"\([^()]*\)", "", pgn_text)
#
#     # Läs in i python-chess för att rensa eventuella .comment
#     input_io = io.StringIO(pgn_text)
#     game = chess.pgn.read_game(input_io)
#
#     def rensa_node(node):
#         node.comment = ""
#         node.nags.clear()  # säkerhetsåtgärd
#         for var in node.variations:
#             rensa_node(var)
#
#     if game:
#         rensa_node(game)
#         output_io = io.StringIO()
#         print(game, file=output_io, end="\n\n")
#         return output_io.getvalue()
#     else:
#         return ""


# def rensa_alla_kommentarer(pgn_text):
#     # Ta bort kommentarer inom { ... }
#     pgn_text = re.sub(r"\{[^}]*\}", "", pgn_text)
#     # Ta bort kommentarer som börjar med ;
#     pgn_text = re.sub(r";[^\n]*", "", pgn_text)
#
#     # Ladda PGN i python-chess för att ta bort inbyggda .comment
#     input_io = io.StringIO(pgn_text)
#     game = chess.pgn.read_game(input_io)
#
#     def rensa_node_kommentarer(node):
#         node.comment = ""
#         for variation in node.variations:
#             rensa_node_kommentarer(variation)
#
#     if game:
#         rensa_node_kommentarer(game)
#
#         # Exportera rent PGN
#         output_io = io.StringIO()
#         print(game, file=output_io, end="\n\n")
#         return output_io.getvalue()
#     else:
#         return ""

# def rensa_kommentarer(pgn_text):
#     input_io = io.StringIO(pgn_text)
#     game = chess.pgn.read_game(input_io)
#
#     def ta_bort_kommentarer(node):
#         node.comment = ""
#         for variation in node.variations:
#             ta_bort_kommentarer(variation)
#
#     ta_bort_kommentarer(game)
#
#     output_io = io.StringIO()
#     print(game, file=output_io, end="\n\n")
#     return output_io.getvalue()

def centipawn(score):
    if score.is_mate():
        return 100000 if score.mate() > 0 else -100000
    return score.score()

def klassificera(cp_diff):
    cp_diff = abs(cp_diff)
    if cp_diff < 20: return 0  # utmärkt
    elif cp_diff < 50: return 1   # bättre drag fanns
    elif cp_diff < 100: return 2   # inaccuracy
    elif cp_diff < 300: return 3   # mistake
    else: return 4   # blunder

def dots(n):
    return "•" * n

def dump(b,d): return f"{b} {d} {abs(b-d)} {klassificera(b-d)}"

def pretty(nr, white, black=None):
    WIDTH = [-2,-7,7,-4,4,-7,7]
    [a,b,c,d] = white
    klassW = klassificera(b - d)
    if a == c or klassW == 0:
        klassW = 0
        c = ''
    whiteStats[klassW] += 1
    if black:
        [e,f,g,h] = black
        klassB = klassificera(f - h)
        if e == g or klassB == 0:
            klassB = 0
            g = ''
        blackStats[klassB] += 1
        data = [str(nr), a, e, dots(klassW), dots(klassB), c, g]
    else:
        data = [str(nr), a, '', dots(klassW), '', c, '']

    res = ''
    for i in range(7):
        w = WIDTH[i]
        if w < 0: res += data[i].rjust(-w)
        if w > 0: res += data[i].ljust(w)
        if i == 3: res += ' | '
        else: res += ' '

    return res

def process(pgnfile):
    global whiteStats,blackStats

    whiteStats = [0, 0, 0, 0, 0]
    blackStats = [0, 0, 0, 0, 0]

    def header(i):
        if i == 9: return f"Seek time: {TIME} seconds MPV: {MPV}"
        if i == 10: return f"Damage: •••• 300 ••• 100 •• 50 • 20 (centipawns)"
        if i >= len(HEADERS): return ""
        term = HEADERS[i]
        if term in game.headers:
            return term + ": " + game.headers[term]
        else:
            return ""

    with open('pgn/' + pgnfile, encoding='utf8') as pgn:
        game = chess.pgn.read_game(pgn)

    engine = chess.engine.SimpleEngine.popen_uci(STOCKFISH_PATH)
    engine.configure({"Skill Level": 20, "Hash": 1024, "Threads": 4, "Move Overhead": 0})

    board = game.board()

    analys = []
    evalueringar = []
    moves = list(game.mainline_moves())

    print(f"{filename} {len(moves)}",'', end='')
    for i in range(len(moves)):
        move = moves[i]
        print('.', end='')
        info = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)[0]
        evalueringar.append([info["score"], info["pv"][0]])  # score & bästa drag
        board.push(move)
    print()

    info = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)[0]
    if "pv" in info:
        evalueringar.append([info["score"], info["pv"][0]])  # score & bästa drag
    else:
        evalueringar.append([info["score"], move])

    engine.quit()

    board = game.board()
    moves = list(game.mainline_moves())
    for i in range(len(moves)):
        if i+1 >= len(evalueringar): continue
        move = moves[i]
        played = move
        played_san = board.san(played)
        best = evalueringar[i][1]
        best_san = board.san(best)

        score_before = centipawn(evalueringar[i][0].white() if board.turn == chess.WHITE else evalueringar[i][0].black())
        score_after = centipawn(evalueringar[i+1][0].white() if board.turn == chess.WHITE else evalueringar[i+1][0].black())

        analys.append([played_san,score_before,best_san,score_after])
        board.push(played)

    with open('txt/' + pgnfile.replace('.pgn','.txt'), "w", encoding="utf-8") as txt:

        txt.write("##   White Black     Damage       Best moves\n")

        for i in range(0,len(analys),2):
            white = analys[i]
            if i+1 < len(analys):
                black = analys[i + 1]
                txt.write(pretty(1 + i // 2, white, black))
            else:
                txt.write(pretty(1 + i // 2, white))
            # if i%2==0: txt.write(pretty(analys[i], i%2) + ' ' + str(1 + i // 2).rjust(2))
            txt.write(' ' + header((i)//2)+'\n')

        txt.write("\n")
        txt.write("\n")
        titles = "x • •• ••• ••••".split(" ")
        txt.write("White: " + ' '.join([titles[i] + " " + str(whiteStats[i]) for i in [4,3,2,1]]) + '\n')
        txt.write("Black: " + ' '.join([titles[i] + " " + str(blackStats[i]) for i in [4,3,2,1]]) + '\n')

    # Exempel:
    with open('pgn/' + pgnfile, encoding="utf-8") as f:
        pgn_innehåll = f.read()

    renad_pgn = rensa_och_formattera_pgn(pgn_innehåll)

    with open('raw/' + pgnfile.replace('.pgn','.raw'), "w", encoding="utf-8") as f:
        f.write(renad_pgn)

# Gå igenom alla filer i aktuell katalog
start = time.time()
for filename in os.listdir('pgn'):
    txt_file = os.path.splitext('txt/' + filename)[0] + '.txt'
    if not os.path.exists(txt_file): process(filename)
print(time.time() - start)

def process_fen(fen):
    engine = chess.engine.SimpleEngine.popen_uci(STOCKFISH_PATH)
    engine.configure({
        "Skill Level": 20, "Hash": 512, "Threads": 4, "Move Overhead": 0})

    board = chess.Board(fen)
    info = engine.analyse(board, chess.engine.Limit(depth=22), multipv=5)
    for item in info:
        print([item["score"], item["pv"][0]])  # score & bästa drag

FEN = "r4rk1/1pp1pp2/p4bpp/3q2N1/3P2b1/2PB4/PP4PP/R1B1QRK1 w - - 0 17"

# start = time.time()
# process_fen(FEN)
# print(time.time() - start)


