import chess.pgn
import chess.engine

STOCKFISH_PATH = "C:\\Program Files\\stockfish\\stockfish-windows-x86-64-avx2.exe"
TIME = 1
MPV = 3

HEADERS = "Date White WhiteElo Black BlackElo Result TimeControl ChapterURL".split(" ")

whiteStats = [0,0,0,0]
blackStats = [0,0,0,0]

def centipawn(score):
    if score.is_mate():
        return 100000 if score.mate() > 0 else -100000
    return score.score()

def klassificera(cp_diff):
    # if cp_diff == 0:
    if cp_diff < 20: return -1  # utmärkt
    elif cp_diff < 50: return 0   # bättre drag fanns
    elif cp_diff < 100: return 1   # inaccuracy
    elif cp_diff < 300: return 2   # mistake
    else: return 3   # blunder

def header(i):
    if i==9:  return "White columns: 0:Best   1:Damage 2:Actual"
    if i==10: return "Black columns: 4:Actual 5:Damage 6:Best"
    if i==11: return f"Seek time: {TIME} seconds MPV: {MPV}"
    if i==12: return f"Limits: [•••] 300 [••] 100 [•] 50 [] 20 Ok (centipawns)"
    if i >= len(HEADERS): return ""
    term = HEADERS[i]
    if term in game.headers:
        return term + ": " + game.headers[term]
    else:
        return ""

def dots(n): return "•" * n

def dump(b,d):
    return f"{b} {d} {abs(b-d)} {klassificera(b-d)}"

def pretty(lst, remainder):
    EXTRA = 0 # 12
    [a,b,c,d] = lst
    filler = " " * (EXTRA+5+7)

    if remainder == 0: # White
        if a==c: return filler + a.rjust(7)
        klass = klassificera(b-d)
        if klass == -1 : return filler + a.rjust(7)
        whiteStats[klass] += 1
        if EXTRA == 0:
            return c.rjust(7) + dots(klass).rjust(5) + a.rjust(7)
        else:
            return c.rjust(7) + dump(b,d).rjust(EXTRA+5) + a.rjust(7)
    else:
        if a==c: return a.ljust(7) + filler
        klass = klassificera(b-d)
        if klass == -1 : return a.ljust(7) + filler
        blackStats[klass] += 1
        if EXTRA == 0:
            return a.ljust(7) + dots(klass).ljust(5) + c.ljust(7)
        else:
            return a.ljust(7) + dump(b,d).ljust(EXTRA+5) + c.ljust(7)

with open("lichess_study_hhh_per-hamnstrom-vs-cn_by_ChristerNilsson_2025.05.26.pgn",encoding='utf8') as pgn:
    game = chess.pgn.read_game(pgn)

engine = chess.engine.SimpleEngine.popen_uci(STOCKFISH_PATH)
board = game.board()

analys = []
evalueringar = []

# Gör en analys per ställning (före varje drag)
for move in game.mainline_moves():
    info = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)[0]
    evalueringar.append([info["score"], info["pv"][0]])  # score & bästa drag
    board.push(move)

info = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)[0]
evalueringar.append([info["score"], info["pv"][0]])  # score & bästa drag

engine.quit()

# För att jämföra behöver vi alla utom sista analysen (som inte har något "efter")
board = game.board()
#for i, move in enumerate(game.mainline_moves()):
moves = list(game.mainline_moves())
for i in range(len(moves)):
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

for i in range(len(analys)):
    print(pretty(analys[i], i%2), end='')
    if i%2==0:
        print(' ' + str(1 + i // 2).rjust(2) + ' ', end='')
    if i%2==1:
        print(header((i-1)//2))

print()
print()
titles = "Glitches Inaccuracies Mistakes Blunders".split(" ")
print("White", ' '.join([titles[i] + ":" + str(whiteStats[i]) for i in [3,2,1,0]]))
print("Black", ' '.join([titles[i] + ":" + str(blackStats[i]) for i in [3,2,1,0]]))
