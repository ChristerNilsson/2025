import chess.pgn
import chess.engine
import json
import time

#STOCKFISH_PATH = "/usr/local/bin/stockfish"

ENGINE = "C:\\Program Files\\stockfish\\stockfish-windows-x86-64-avx2.exe"
TIME = 1.0 # sek

def centipawn(score):
    if score.is_mate():
        return 100000 if score.mate() > 0 else -100000
    return score.score()

def klassificera(cp_diff):
    cp_diff = abs(cp_diff)
    if cp_diff < 20: return ''  # Utmärkt
    if cp_diff < 50: return 'ok'   # Bättre drag fanns
    if cp_diff < 100: return '•'   # Inaccuracy
    if cp_diff < 300: return '••'   # Mistake
    return '•••'   # Blunder

start = time.time()

with open("NMF1.pgn") as pgn:
    game = chess.pgn.read_game(pgn)

engine = chess.engine.SimpleEngine.popen_uci(ENGINE)
board = game.board()

def san(move): return board.san(chess.Move.from_uci(move.uci()))

analys = []

for i, move in enumerate(game.mainline_moves()):
#for i in range(25):
#    move = list(game.mainline_moves())[i]
    info_before = engine.analyse(board, chess.engine.Limit(time=TIME))
    best_move = info_before["pv"][0]
    best_score = centipawn(info_before["score"].white())

    board.push(move)

    info_after = engine.analyse(board, chess.engine.Limit(time=TIME))
    played_score = centipawn(info_after["score"].white())

    cp_diff = best_score - played_score
    klass = klassificera(cp_diff)
    if move.uci() == best_move.uci(): klass = ''
    if klass == '' : pass
    elif klass == 'ok': klass = best_move.uci()
    else: klass += ' ' + best_move.uci()

    # print(move.uci())

    # board = chess.Board()
    #draget = chess.Move.from_uci(move.uci())
    #best_draget = chess.Move.from_uci(best_move.uci())
    #print(draget)
    #draget = move #.uci()
    #print(board.san(draget))  # => Nf3

    analys.append([
        i + 1,                     # ply
        move.uci(),               # player
        best_score,
        played_score,
        best_move.uci(),          # best
        cp_diff,                  # cp_diff
        klass                     # klassificering
    ])

    #board.push(move)

engine.quit()


# print(json.dumps(analys, separators=(",", ":")))

for line in analys:
    print(line)

print(time.time()-start)