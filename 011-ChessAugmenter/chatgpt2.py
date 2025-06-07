import chess.pgn
import chess.engine
import chess
import os
import time
from urllib.parse import quote

YEAR = 2025
VIEWER = "https://christernilsson.github.io/2025/012-ChessViewer/"

TIME = .1
MPV = 5

STOCKFISH_PATH = "C:\\Program Files\\stockfish\\stockfish-windows-x86-64-avx2.exe"

def calcDiff(p_eval, b_eval):

	if p_eval.is_mate() and b_eval.is_mate():	# Båda matt
		pNum = p_eval.mate()
		bNum = b_eval.mate()
		diff = abs(pNum - bNum)
		if diff <= 1: return 0
		elif diff == 2: return 50
		else: return 100
	elif p_eval.is_mate() or b_eval.is_mate(): 	# Exakt en matt
		return 300
	else: # Ingen matt
		d = abs(b_eval.score() - p_eval.score())
		return d


def eval_board(engine, board, time_limit=TIME):
	info = engine.analyse(board, chess.engine.Limit(time=time_limit),multipv=MPV)[0]
	return info["score"].white()

def process(pgnfile):

	def header(name):
		if name in game.headers:
			return game.headers[name]
		else:
			return ''

	with open('pgn/' + pgnfile, encoding='utf8') as pgn:
		game = chess.pgn.read_game(pgn)

	engine = chess.engine.SimpleEngine.popen_uci(STOCKFISH_PATH)
	engine.configure({"Skill Level": 20, "Hash": 1024, "Threads": 4, "Move Overhead": 0})

	board = game.board()

	movesx = list(game.mainline_moves())

	moves = []
	evals = []
	bests = []

	print(f"{filename} {len(movesx)}",'', end='')
	for move in movesx:

		print('.', end='')

		best_info = engine.analyse(board, chess.engine.Limit(time=TIME), multipv=MPV)
		best_score = best_info[0]["score"].white() # .score(mate_score=100000)
		best_move = best_info[0]["pv"][0]  # Första draget i bästa variant

		played_move = move
		best_san = board.san(best_move)
		played_san = board.san(played_move)
		board.push(played_move)
		actual_score = eval_board(engine, board, TIME)
		loss = calcDiff(actual_score, best_score)

		moves.append(played_san)
		evals.append(str(loss))
		bests.append(best_san)

	engine.quit()

	print()

	with open(year + '/' + pgnfile.replace('.pgn','.txt'), "w", encoding="utf-8") as url:

		headers = []
		headers.append(f"Date={header('Date')} Result:{header('Result')}")
		headers.append(f"White={header('WhiteElo')} {header('White')}")
		headers.append(f"Black={header('BlackElo')} {header('Black')}")
		headers.append(f'Link={header('ChapterURL')}')
		headers.append(f'Seek=TIME:{TIME} MPV:{MPV}')


		headers = '&'.join(headers)
		moves = quote('_'.join(moves))
		evals = quote('_'.join(evals))
		bests = quote('_'.join(bests))

		url.write(VIEWER + "index.html?" + headers.replace(" ","_") + '&move=' + moves + '&eval=' + evals + '&best=' + bests + '\n')

# Gå igenom alla filer i aktuell katalog
start = time.time()
years = set()
for filename in os.listdir('pgn'):
	year = filename[0:4]
	year_file = year + "\\" + filename.replace('.pgn','.txt')
	if not os.path.exists(year_file):
		process(filename)
		years.add(year)

data = []
for year in years:
	with open(f"{year}/_index.md", 'w', encoding="utf-8") as md:
		md.write(f"---\ntitle: {year}\nauto: true\n---\n")
		for filename in os.listdir(str(year)):
			if not filename.endswith('.txt'): continue
			with open(f"{year}/{filename}", encoding="utf-8") as url:
				md.write(f"[{filename.replace('.txt','')}]({url.read()})  \n")

print(time.time() - start)
