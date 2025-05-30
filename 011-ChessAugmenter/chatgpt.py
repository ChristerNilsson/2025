import chess.pgn
import chess.engine
import chess
import os
import time

TIME = 1
MPV = 5

HEADERS = "Date White WhiteElo Black BlackElo Result TimeControl ChapterURL".split(" ")
STOCKFISH_PATH = "C:\\Program Files\\stockfish\\stockfish-windows-x86-64-avx2.exe"

whiteStats = [0,0,0,0,0]
blackStats = [0,0,0,0,0]

def centipawn(score):
    if score.is_mate():
        return 100000 if score.mate() > 0 else -100000
    return score.score()

def klassificera(cp_diff):
    if cp_diff < 20: return 0  # utmärkt
    elif cp_diff < 50: return 1   # bättre drag fanns
    elif cp_diff < 100: return 2   # inaccuracy
    elif cp_diff < 300: return 3   # mistake
    else: return 4   # blunder

def dots(n):
    return "•" * n

def dump(b,d): return f"{b} {d} {abs(b-d)} {klassificera(b-d)}"

def pretty(lst, remainder):
    [a,b,c,d] = lst
    filler = " " * 12

    klass = klassificera(b - d)
    if remainder == 0: # White
        if a==c or klass == 0:
            return filler + a.rjust(7)
        # if klass == 0 : return filler + a.rjust(7)
        whiteStats[klass] += 1
        return c.rjust(7) + dots(klass).rjust(5) + a.rjust(7)

    else:
        if a==c or klass==0:
            return a.ljust(7) + filler
        blackStats[klass] += 1
        return a.ljust(7) + dots(klass).ljust(5) + c.ljust(7)

# def pretty(lst, remainder):
#     [a,b,c,d] = lst
#     # filler = " " * 12
#
#     klass = klassificera(b - d)
#     if remainder == 0: # White
#         # if a==c or klass == 0:
#         #     return str(b).rjust(12) + a.rjust(7)
#         whiteStats[klass] += 1
#         return c.rjust(7) + str(b-d).rjust(5) + a.rjust(7)
#
#     else:
#         # if a==c or klass==0:
#         #     return a.ljust(7) + str(b).ljust(12)
#         blackStats[klass] += 1
#         return a.ljust(7) + str(b-d).ljust(5) + c.ljust(7)

def process(pgnfile):

    def header(i):
        if i == 9: return f"Seek time: {TIME} seconds MPV: {MPV}"
        if i == 10: return f"Damage: •••• 300 ••• 100 •• 50 • 20 (centipawns)"
        if i >= len(HEADERS): return ""
        term = HEADERS[i]
        if term in game.headers:
            return term + ": " + game.headers[term]
        else:
            return ""

    with open(pgnfile, encoding='utf8') as pgn:
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
        # info = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)[0]
        info = engine.analyse(board, chess.engine.Limit(depth=21), multipv=5)[0]
        evalueringar.append([info["score"], info["pv"][0]])  # score & bästa drag
        board.push(move)
    print()

    #info = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)[0]
    info = engine.analyse(board, chess.engine.Limit(depth=21), multipv=5)[0]
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
        cp_diff = score_before - score_after
        klass = klassificera(cp_diff)

        analys.append([played_san,score_before,best_san,score_after])
        board.push(played)

    with open(pgnfile.replace('.pgn','.txt'), "w", encoding="utf-8") as txt:

        txt.write("   Best Damag White ## Black Damag Best\n")

        for i in range(len(analys)):
            if i%2==0: txt.write(pretty(analys[i], i%2) + ' ' + str(1 + i // 2).rjust(2))
            if i%2==1: txt.write(' ' + pretty(analys[i], i%2) + header((i-1)//2)+'\n')

        txt.write("\n")
        txt.write("\n")
        titles = "x • •• ••• ••••".split(" ")
        txt.write("White: " + ' '.join([titles[i] + " " + str(whiteStats[i]) for i in [4,3,2,1]]) + '\n')
        txt.write("Black: " + ' '.join([titles[i] + " " + str(blackStats[i]) for i in [4,3,2,1]]) + '\n')

# Gå igenom alla filer i aktuell katalog
start = time.time()
for filename in os.listdir():
    txt_file = os.path.splitext(filename)[0] + '.txt'
    if filename.endswith(".pgn") and not os.path.exists(txt_file): process(filename)
print(time.time() - start)

def process_fen(fen):
    engine = chess.engine.SimpleEngine.popen_uci(STOCKFISH_PATH)
    engine.configure({
        "Skill Level": 20,
        "Hash": 512,  # gärna 512 eller 1024 MB om du har RAM
        "Threads": 4,  # eller fler, beroende på CPU
        "Move Overhead": 0,
    })

    board = chess.Board(fen)
    info = engine.analyse(board, chess.engine.Limit(depth=22), multipv=5)
    for item in info:
        print([item["score"], item["pv"][0]])  # score & bästa drag

FEN = "r4rk1/1pp1pp2/p4bpp/3q2N1/3P2b1/2PB4/PP4PP/R1B1QRK1 w - - 0 17"

# start = time.time()
# process_fen(FEN)
# print(time.time() - start)