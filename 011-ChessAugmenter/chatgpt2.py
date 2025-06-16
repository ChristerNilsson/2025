import chess.pgn
import chess.engine
import chess
import os
from urllib.parse import quote

VIEWER = "https://christernilsson.github.io/2025/012-ChessViewer/"

TIME = 1
MPV = 5

STOCKFISH_PATH = "C:\\Program Files\\stockfish\\stockfish-windows-x86-64-avx2.exe"

def calcDiff(p_loss, b_loss):
	if p_loss.is_mate() and b_loss.is_mate():	# Båda matt
		diff = abs(p_loss.mate() - b_loss.mate())
		if diff <= 1: return 0
		if diff == 2: return 50
		return 100
	if p_loss.is_mate() or b_loss.is_mate(): return 300	# Exakt en matt
	return abs(b_loss.score() - p_loss.score()) # Ingen matt

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
	losses = []
	bests = []

	print(f"{pgnfile} {len(movesx)}",'', end='')
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
		losses.append(str(loss))
		bests.append(best_san)

	engine.quit()

	print()

	with open('txt/' + pgnfile.replace('.pgn','.txt'), "w", encoding="utf-8") as url:

		headers = []
		headers.append(f"Date={header('Date')} Result:{header('Result')}")
		headers.append(f"White={header('WhiteElo')} {header('White')}")
		headers.append(f"Black={header('BlackElo')} {header('Black')}")
		headers.append(f'Link={header('ChapterURL') or header('Link') or header('Site')}')
		headers.append(f'Seek=TIME:{TIME} MPV:{MPV}')

		headers = '&'.join(headers)
		moves = quote('_'.join(moves))
		losses = quote('_'.join(losses))
		bests = quote('_'.join(bests))

		url.write(VIEWER + "index.html?" + headers.replace(" ","_") + '&moves=' + moves + '&losses=' + losses + '&bests=' + bests + '\n')

dir_stack = []

def pushdir(new_dir):
	dir_stack.append(os.getcwd())
	os.chdir(new_dir)

def popdir():
	os.chdir(dir_stack.pop())

def hantera(katalog, title='', indexmd=''):
	pushdir(katalog)
	# Skapa txt-filer
	for filename in os.listdir('pgn'):
		if not os.path.exists('txt\\' + filename.replace('.pgn','.txt')):
			process(filename)

	# Skapa _index.md
	with open(indexmd, 'w', encoding="utf-8") as md:

		md.write("---\n")
		md.write(f"title: {title}\n")
		md.write("auto: false\n")
		md.write("---\n")
		md.write("\n")

		# if bild:
		# 	md.write(f"![]({bild})\n")
		# 	md.write("\n")

		for filename in os.listdir('txt'):
			if not filename.endswith('.txt'): continue
			with open("txt\\" + filename, encoding="utf-8") as url:
				md.write(f"[{filename.replace('.txt','')}]({url.read()})  \n")

	print('skapade ' + katalog +  "\\_index.md")
	popdir()

print("TIME:",TIME, "MPV:",MPV)
hantera("C:\\github\\HugoLab\\content\\klubben\\medlemmar\\jan-christer-nilsson\\Turneringar\\Joukos Sommar 2025", "Joukos Sommar 2025", "Partier\\_index.md")
hantera("C:\\github\\HugoLab\\content\\klubben\\medlemmar\\jan-christer-nilsson\\Partier\\2025","2025", "_index.md")
hantera("C:\\github\\HugoLab\\content\\klubben\\medlemmar\\jan-christer-nilsson\\Partier\\2024","2024", "_index.md")
