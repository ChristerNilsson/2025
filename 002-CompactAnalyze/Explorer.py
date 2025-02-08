import chess
import chess.pgn
import chess.engine
import time

ENGINE = "C:\\Program Files\\stockfish\\stockfish-windows-x86-64-avx2.exe"

MULTIPV = 20
TIME = 1000 # ms
COLOR = 1

engine = chess.engine.SimpleEngine.popen_uci(ENGINE)
engine.configure({"Skill Level":20}) # Verkar inte ha någon effekt, 0 ska ge non randomness

#fen = "3r2k1/2pq1rp1/pp5p/4p3/3n1P1P/B1NP1p1b/PPPQ1P1K/R3R2B b - - 0 23"
#fen = "3r2k1/2pq2p1/pp5p/4p3/3nRr1P/B1NP1p1b/PPPQ1P1K/R6B b - - 1 24"
#fen = "8/3P3k/n2K3p/2p3n1/1b4N1/2p1p1P1/8/3B4 w - - 0 1" # https://www.chess.com/forum/view/more-puzzles/the-hardest-chess-puzzle-if-you-can-solve-you-are-genius-53653596
#fen = "6k1/6p1/8/1p2R3/3P4/pPPK1PP1/Pq1Q2P1/4r3 b - - 0 1"
#fen = "r1b2bnr/p2pk1p1/np2N2p/1Pp1Q3/5pP1/B3P2B/P1PP1PqP/RN2K2R w - - 0 1"
# fen = "8/8/8/4k3/8/8/8/2B1KB2 w - - 0 1"
fen = "r1b1k1nr/ppp2ppp/2n5/3qp3/1b6/2NP1N2/PPP2PPP/R1BQKB1R w KQkq - 2 6"

board = chess.Board(fen)
fullmove_number = board.fullmove_number
cLines = 0
cNodes = 0
lastRow = []
filename = f"{fullmove_number} {MULTIPV} {TIME}ms"

def analyze(g,moves=[]):
	level = len(moves)
	global cLines
	global cNodes
	global lastRow
	n = 1 if level % 2 != COLOR else MULTIPV
	info = engine.analyse(board, chess.engine.Limit(time=TIME/1000), multipv=MULTIPV)
	if len(info) == 1 and info[0]['depth'] == 0:
		output = []
		i = 0
		while i < len(lastRow) and lastRow[i] == moves[i]:
			output.append("|")
			i += 1
		for i in range(i,len(moves)):
			s = '|' if i < len(lastRow) and lastRow[i] == moves[i] else moves[i]
			output.append(s)

		output = [move.ljust(6,' ') for move in output]
		pr("".join(output))
		cLines += 1
		lastRow = moves
		return
	cNodes += 1

	for move in info:
		if move['depth'] > 0:
			pv = move['pv'][0]
			san = board.san(chess.Move.from_uci(pv.uci()))
			board.push(pv)
			analyze(g,moves + [san])
			board.pop()
		n -= 1
		if n == 0: break

def pr(s):
	g.write(s+"\n")
	print(s)

start = time.time_ns()
with open(f"{filename}.txt", "w") as g:
	pr(fen)
	s = ""
	for i in range(17):
		letter = 'B' if (i+fullmove_number) % 2 == COLOR else 'W'
		s += f"{(2*fullmove_number + i)//2}{letter}".ljust(6," ")
	pr(s)
	analyze(g)
	pr("")
	pr(f"{cLines} lines and {cNodes} nodes in {int((time.time_ns()-start)/10**6)} ms")

engine.quit()