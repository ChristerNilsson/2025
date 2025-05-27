import chess.pgn
import chess.engine
import time

ENGINE = "C:\\Program Files\\stockfish\\stockfish-windows-x86-64-avx2.exe"
TIME = 1
HEADERS = "Date White WhiteElo Black BlackElo Result TimeControl ChapterURL".split(" ")
#FILENAME = "NMF1.pgn"
#FILENAME = "lichess_study_lll_jouko-liistamo-vs-cn_by_ChristerNilsson_2025.05.19.pgn"
#FILENAME = "lichess_study_hhh_per-hamnstrom_by_ChristerNilsson_2025.04.21.pgn"
FILENAME = "lichess_study_hhh_per-hamnstrom-vs-cn_by_ChristerNilsson_2025.05.26.pgn"

def centipawn(score):
    if score.is_mate():
        if score.mate() > 0:
            return 100000 - score.moves
        else:
            return -100000 - score.moves
    return score.score()

def header(i):
    if i==9: return "White columns: 0:Best   1:Level 2:Actual"
    if i==10: return "Black columns: 4:Actual 5:Level 6:Best"
    if i==11: return f"Seek time: {TIME} seconds"
    if i==12: return f"Limits: [•••] 300 [••] 100 [•] 50 [] 20 Ok (centipawns)"
    if i >= len(HEADERS): return ""
    term = HEADERS[i]
    if term in game.headers:
        return term + ": " + game.headers[term]
    else:
        return ""

whiteStats = [0,0,0,0]
blackStats = [0,0,0,0]

with open(FILENAME, encoding='utf8') as pgn:
    game = chess.pgn.read_game(pgn)

board = game.board()
vars = game.variations
moves = []
while len(vars) > 0:
    moves.append(vars[0].move.uci())
    vars = vars[0].variations

engine = chess.engine.SimpleEngine.popen_uci(ENGINE)

def san(move): return board.san(chess.Move.from_uci(move))

def diff(aa,bb):
    b = bb['score'].white()
    a = aa['score'].white()
    return [aa["pv"][0].uci(), centipawn(a), bb["pv"][0].uci(), centipawn(b)]


 # # Eval före draget
 #    info_before = engine.analyse(board, chess.engine.Limit(time=0.1))
 #    best_move = info_before["pv"][0]
 #    best_score = centipawn(info_before["score"].white())
 #
 #    # Gör draget
 #    board.push(move)
 #
 #    # Eval efter draget
 #    info_after = engine.analyse(board, chess.engine.Limit(time=0.1))
 #    played_score = centipawn(info_after["score"].white())
 #
 #    cp_diff = best_score - played_score
 #    feltyp = klassificera_fel(cp_diff)
 #
 #    print(f"\n{i+1}. {move}")
 #    if feltyp:
 #        print(f"  {feltyp}: Försämring {cp_diff} cp")
 #        if cp_diff > 20:
 #            print(f"  Bästa draget: {best_move}")
 #    else:
 #        print(f"  OK drag (cp diff: {cp_diff})")



def findMove0(move):
    MPV = 4
    info_before = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)
    aitem = info_before[0]
    a = centipawn(aitem['score'].white())
    ma = chess.Move.from_uci(move)
    board.push(ma)

    info_after = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)
    bitem = info_after[0]
    b = centipawn(bitem['score'].white())

    board.pop()

    result = diff(aitem,bitem)

    return result # [aitem,a,bitem,b]

def findMove(move):
    MPV = 4
    while True:

        info = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)
        for item in info:
            m = item["pv"][0]
            if move == m.uci():
                return diff(item,info[0])
        MPV *= 2
        print('MPV',MPV)

def klassificera(cp):
    cp = abs(cp)
    if cp <  20: return -1 # Utmärkt
    if cp <  50: return 0  # Bättre drag finns
    if cp < 100: return 1  # Inaccuracy
    if cp < 300: return 2  # Mistake
    return 3               # Blunder

def dots(n): return "•" * n

def dump(b,d):
    return f"{b} {d} {abs(b-d)} {klassificera(b-d)}"

def pretty(lst,remainder):
    EXTRA = 12 #0 # 12
    [a,b,c,d] = lst
    filler = " " * (EXTRA+5+7)

    if remainder == 1:
        if a==c: return san(a).ljust(7) + filler
        klass = klassificera(b-d)
        if klass == -1 : return san(a).ljust(7) + filler
        blackStats[klass] += 1
        if EXTRA == 0:
            return san(a).ljust(7) + dots(klass).ljust(5) + san(c).ljust(7)
        else:
            return san(a).ljust(7) + dump(b,d).ljust(EXTRA+5) + san(c).ljust(7)
    else:
        if a==c: return filler + san(a).rjust(7)
        klass = klassificera(b-d)
        if klass == -1 : return filler + san(a).rjust(7)
        whiteStats[klass] += 1
        if EXTRA == 0:
            return san(c).rjust(7) + dots(klass).rjust(5) + san(a).rjust(7)
        else:
            return san(c).rjust(7) + dump(b,d).rjust(EXTRA+5) + san(a).rjust(7)

start = time.time()

s = ""
i = 0
left = ""
right = ""

for move in moves:
    if i % 2 == 0:
        s = str(i//2).rjust(2)
        if i > 0: print(left + " " + s + " " + right + header(-1+i//2))
        left = pretty(findMove0(move), i % 2)
        right = ""
    else:
        right = pretty(findMove0(move), i % 2)
    board.push(chess.Move.from_uci(move))
    i += 1

s = str(i // 2).rjust(2)
print(left + " " + s + " " + right + header(i))

print("")
titles = "Glitches Inaccuracies Mistakes Blunders".split(" ")
print("White", ' '.join([titles[i] + ":" + str(whiteStats[i]) for i in [3,2,1,0]]))
print("Black", ' '.join([titles[i] + ":" + str(blackStats[i]) for i in [3,2,1,0]]))

print(time.time()-start)