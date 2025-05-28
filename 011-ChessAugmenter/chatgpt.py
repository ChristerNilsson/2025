import chess.pgn
import chess.engine

TIME = 0.1
MPV = 3
DEBUG = False

#FILENAME = "lichess_study_hhh_per-hamnstrom-vs-cn_by_ChristerNilsson_2025.05.26.pgn"
#FILENAME = "lichess_study_rrr_vida-radon_by_ChristerNilsson_2025.04.03.pgn"
#FILENAME = "lichess_study_rrr_vida-radon-vs-cn_by_ChristerNilsson_2025.05.10.pgn"
FILENAME = "lichess_study_lll_jouko-liistamo-vs-cn_by_ChristerNilsson_2025.05.19.pgn"

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

def header(i):
    if i==9: return f"Seek time: {TIME} seconds MPV: {MPV}"
    if i==10: return f"Damage: •••• 300 ••• 100 •• 50 • 20 (centipawns)"
    if i >= len(HEADERS): return ""
    term = HEADERS[i]
    if term in game.headers:
        return term + ": " + game.headers[term]
    else:
        return ""

def dots(n):
    return "•" * n

def dump(b,d): return f"{b} {d} {abs(b-d)} {klassificera(b-d)}"

def pretty(lst, remainder):
    [a,b,c,d] = lst
    filler = " " * 12

    klass = klassificera(b - d)
    if remainder == 0: # White
        if a==c or klass == 0:
            if DEBUG:
                return str(b).rjust(12) + a.rjust(7)
            else:
                return filler + a.rjust(7)
        # if klass == 0 : return filler + a.rjust(7)
        whiteStats[klass] += 1
        if DEBUG:
            return c.rjust(7) + str(b).rjust(5) + a.rjust(7)
        else:
            return c.rjust(7) + dots(klass).rjust(5) + a.rjust(7)

    else:
        if a==c or klass==0:
            if DEBUG:
                return a.ljust(7) + str(b).ljust(12)
            else:
                return a.ljust(7) + filler
        blackStats[klass] += 1
        if DEBUG:
            return a.ljust(7) + str(b).ljust(5) + c.ljust(7)
        else:
            return a.ljust(7) + dots(klass).ljust(5) + c.ljust(7)

with open(FILENAME, encoding='utf8') as pgn:
    game = chess.pgn.read_game(pgn)

engine = chess.engine.SimpleEngine.popen_uci(STOCKFISH_PATH)
board = game.board()

analys = []
evalueringar = []
moves = list(game.mainline_moves())
print(len(moves),'', end='')
for i in range(len(moves)):
    move = moves[i]
    print(i % 10, end='')
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
    cp_diff = score_before - score_after
    klass = klassificera(cp_diff)

    analys.append([played_san,score_before,best_san,score_after])
    board.push(played)

print("   Best Damag White ## Black Damag Best")

for i in range(len(analys)):
    print(pretty(analys[i], i%2), end='')
    if i%2==0: print(' ' + str(1 + i // 2).rjust(2) + ' ', end='')
    if i%2==1: print(header((i-1)//2))

print()
print()
titles = "x • •• ••• ••••".split(" ")
print("White:", ' '.join([titles[i] + " " + str(whiteStats[i]) for i in [4,3,2,1]]))
print("Black:", ' '.join([titles[i] + " " + str(blackStats[i]) for i in [4,3,2,1]]))
