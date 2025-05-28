import chess.pgn
import chess.engine
import time

ENGINE = "C:\\Program Files\\stockfish\\stockfish-windows-x86-64-avx2.exe"
TIME = 0.1
MPV = 3
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
    if i==9: return "White columns: 0:Best   1:Damage 2:Actual"
    if i==11: return "Black columns: 4:Actual 5:Damage 6:Best"
    if i==13: return f"Seek time: {TIME} seconds"
    if i==15: return f"Limits: [•••] 300 [••] 100 [•] 50 [] 20 Ok (centipawns)"
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

# def san(move): return board.san(chess.Move.from_uci(move))

def diff(aa,bb):
    a = aa['score'].white()
    b = bb['score'].white()
    return [aa["pv"][0].uci(), centipawn(a), bb["pv"][0].uci(), centipawn(b)]

# def findMove0(move):
#     aitem = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)[0]
#
#     ma = chess.Move.from_uci(move)
# #    board.push(ma)
#
#     # print([x.uci() for x in board.move_stack])
#     bitem = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)[0]
#  #   board.pop()
#  #    print([x.uci() for x in board.move_stack])
#
#     result = diff(aitem,bitem)
#     #board.pop()
#
#     return result

# def findMove(move):
#     MPV = 2
#     while True:
#
#         info = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)
#         for item in info:
#             m = item["pv"][0]
#             if move == m.uci():
#                 return diff(item,info[0])
#         MPV *= 2
#         # print('MPV',MPV)

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

def getAllEvaluations(moves):
    print(TIME,MPV)
    move2 = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)[0]

    i = 0
    left = ""
    right = ""

    for i in range(len(moves)):
        move = moves[i]
        # aitem = lastAnalyse
        move1 = move2
        asan = board.san(chess.Move.from_uci(move))
        # print(move,'==>',asan)
        board.push(chess.Move.from_uci(move))

        move2 = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)[0]

        csan = board.san(move2["pv"][0])
        # print(move2["pv"][0].uci(),'==>',csan)

        ## bitem = binfo[0]
        lst = diff(move1,move2) #['score'].white()) - centipawn(aitem['score'].white())
        lst[0] = asan
        lst[2] = csan
        [a,b,c,d] = lst
        if i % 2 == 0:
            s = str(i//2).rjust(2)
            if i > 0: print(left + " " + s + " " + right + header(-1+i//2))
            left = pretty([a,b,c,d], i%2)
            right = ""
        else:
            right = pretty([a,b,c,d], i%2)

    s = str(i // 2).rjust(2)
    print(left + " " + s + " " + right + header(i))

start = time.time()

getAllEvaluations(moves)

# for move in moves:
#     if i % 2 == 0:
#         s = str(i//2).rjust(2)
#         if i > 0: print(left + " " + s + " " + right + header(-1+i//2))
#         left = pretty(findMove0(move), i % 2)
#         right = ""
#     else:
#         right = pretty(findMove0(move), i % 2)
#     board.push(chess.Move.from_uci(move))
#
#     #print([x.uci() for x in board.move_stack])
#     i += 1
#
# s = str(i // 2).rjust(2)
# print(left + " " + s + " " + right + header(i))

print("")
titles = "Glitches Inaccuracies Mistakes Blunders".split(" ")
print("White", ' '.join([titles[i] + ":" + str(whiteStats[i]) for i in [3,2,1,0]]))
print("Black", ' '.join([titles[i] + ":" + str(blackStats[i]) for i in [3,2,1,0]]))

print(time.time()-start)