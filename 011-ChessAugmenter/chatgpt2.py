import chess.pgn
import chess.engine
import chess
import os
import time
from urllib.parse import quote, unquote

TIME = 0.1
MPV = 5

# HEADERS = "Date White WhiteElo Black BlackElo Result TimeControl ChapterURL".split(" ")
STOCKFISH_PATH = "C:\\Program Files\\stockfish\\stockfish-windows-x86-64-avx2.exe"

def centipawn(score):
    if score.is_mate():
        return 100000 if score.mate() > 0 else -100000
    return score.score()

def process(pgnfile):

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

    with open('url/' + pgnfile.replace('.pgn','.txt'), "w", encoding="utf-8") as url:

        headers = []
        moves = []
        evals = []
        bests = []

        for term in game.headers:
            headers.append(term + "=" + quote(game.headers[term]))

        headers.append(f'Seek= TIME={TIME} MPV={MPV}')

        for i in range(len(analys)):
            curr = analys[i]
            moves.append(curr[0].ljust(0))
            evals.append(str(curr[1]).ljust(0))
            bests.append(curr[2].ljust(0))

        headers = '&'.join(headers)
        moves = quote('_'.join(moves))
        evals = quote('_'.join(evals))
        bests = quote('_'.join(bests))

        url.write('http://127.0.0.1:5500/index.html?' + headers + '&move=' + moves + '&eval=' + evals + '&best=' + bests + '\n')

# Gå igenom alla filer i aktuell katalog
start = time.time()
for filename in os.listdir('pgn'):
    url_file = os.path.splitext('url/' + filename)[0] + '.txt'
    if not os.path.exists(url_file): process(filename)
print(time.time() - start)
