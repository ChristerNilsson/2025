SIZE = 75
MAXTRAIL = 5
SPEED = 1

echo = console.log

games = {}
players = {}

chess = new Chess()
echo chess.ascii()
moveStr = 'e2e4'
chess.move { from: moveStr.slice(0, 2), to: moveStr.slice(2, 4) }
echo chess.ascii()

pgnA = """
[Event "2025: Capablanca - K"]
[Site "https://lichess.org/study/w7W4RA4b/u6BmzBKg"]
[Result "*"]
[Variant "Standard"]
[ECO "D02"]
[Opening "Queen's Pawn Game: London System"]
[Annotator "https://lichess.org/@/ChristerNilsson"]
[StudyName "2025"]
[ChapterName "Capablanca - K"]
[UTCDate "2025.01.04"]
[UTCTime "19:06:01"]

1. d4 { [%eval 0.17] } 1... d5 { [%eval 0.24] } 2. Nf3 { [%eval 0.08] } 2... Nf6 { [%eval 0.11] } 3. Bf4 { [%eval 0.04] } 3... e6 { [%eval 0.1] } 4. e3 { [%eval 0.08] } 4... c5 { [%eval 0.14] } 5. c3 { [%eval 0.0] } 5... Nc6 { [%eval 0.11] } 6. Bd3 { [%eval -0.21] } 6... Bd6 { [%eval 0.1] } (6... c4) 7. Bxd6 { [%eval -0.09] } 7... Qxd6 { [%eval -0.13] } 8. Nbd2 { [%eval -0.08] } 8... e5 { [%eval -0.01] } 9. dxe5 { [%eval -0.01] } 9... Nxe5 { [%eval -0.04] } 10. Nxe5 { [%eval -0.02] } 10... Qxe5 { [%eval -0.02] } 11. Bb5+ { [%eval -0.18] } 11... Bd7 { [%eval 0.1] } 12. Qa4 { [%eval 0.0] } 12... Qc7 { [%eval 0.05] } 13. O-O-O { [%eval -0.32] } 13... O-O { [%eval -0.28] } 14. Bxd7 { [%eval -0.27] } 14... Nxd7 { [%eval -0.63] } 15. Nf3 { [%eval -0.8] } 15... Qc6? { [%eval 0.37] } { Mistake. Rfe8 was best. } (15... Rfe8) 16. Qxc6 { [%eval 0.34] } 16... bxc6 { [%eval 0.33] } 17. Nd2 { [%eval -0.07] } 17... Ne5 { [%eval -0.12] } 18. Kc2 { [%eval -0.25] } (18. Nf3) 18... c4 { [%eval 0.15] } 19. Rhf1 { [%eval -0.06] } 19... f5 { [%eval 0.41] } 20. Nf3 { [%eval 0.0] } 20... Nxf3 { [%eval 0.0] } 21. gxf3 { [%eval 0.05] } 21... Rae8 { [%eval 0.28] } 22. Rd4 { [%eval 0.0] } 22... Rf6 { [%eval 0.05] } 23. b3 { [%eval 0.06] } 23... cxb3+ { [%eval 0.13] } 24. axb3 { [%eval 0.15] } 24... Kf7 { [%eval 0.34] } 25. Kd3 { [%eval 0.2] } 25... Re7 { [%eval 0.38] } 26. Ra1 { [%eval 0.47] } 26... Ke6 { [%eval 0.78] } 27. Ra6 { [%eval 0.8] } 27... Rc7 { [%eval 0.75] } 28. Rda4 { [%eval 0.27] } 28... g5 { [%eval 0.8] } 29. h4 { [%eval 1.17] } 29... g4 { [%eval 1.2] } 30. Ke2 { [%eval 1.25] } 30... gxf3+ { [%eval 1.67] } 31. Kxf3 { [%eval 1.76] } 31... Rff7 { [%eval 2.04] } 32. Ke2? { [%eval 0.84] } { Mistake. Kf4 was best. } (32. Kf4 Rg7 33. f3 h5 34. c4 Rgd7 35. R4a5 Rd8 36. cxd5+ Rxd5 37. Rxa7 Rxa7) 32... Kd6 { [%eval 0.73] } 33. b4?! { [%eval 0.12] } { Inaccuracy. Kd3 was best. } (33. Kd3 Rb7 34. b4 f4 35. e4 dxe4+ 36. Kxe4 f3 37. Ra2 Rbe7+ 38. Kd3 Re1) 33... Rb7?! { [%eval 0.99] } { Inaccuracy. f4 was best. } (33... f4 34. b5 fxe3 35. fxe3 Ke5 36. bxc6 Rf6 37. Rxa7 Rxa7 38. Rxa7 Rxc6 39. Kd3) 34. h5?! { [%eval 0.09] } { Inaccuracy. f4 was best. } (34. f4) 34... h6?? { [%eval 3.15] } { Blunder. f4 was best. } (34... f4) 35. f4 { [%eval 3.14] } 35... Rg7 { [%eval 3.07] } 36. Kd3 { [%eval 2.9] } 36... Rge7 { [%eval 3.49] } 37. Ra1 { [%eval 3.16] } 37... Rg7 { [%eval 3.05] } 38. Kd4 { [%eval 2.69] } 38... Rg2 { [%eval 2.23] } 39. R6a2? { [%eval 0.91] } { Mistake. Kd3 was best. } (39. Kd3) 39... Rbg7?? { [%eval 2.82] } { Blunder. Rg3 was best. } (39... Rg3) 40. Kd3 { [%eval 2.93] } 40... Rxa2 { [%eval 2.87] } 41. Rxa2 { [%eval 2.69] } 41... Re7?! { [%eval 3.68] } { Inaccuracy. Rg1 was best. } (41... Rg1 42. Ra6) 42. Rg2 { [%eval 4.3] } 42... Re6 { [%eval 4.23] } 43. Rg7 { [%eval 4.16] } 43... Re7 { [%eval 4.14] } (43... c5) 44. Rg8 { [%eval 4.14] } 44... c5 { [%eval 4.86] } 45. Rg6+ { [%eval 4.82] } 45... Re6 { [%eval 5.21] } 46. bxc5+ { [%eval 5.16] } 46... Kd7 { [%eval 5.09] } 47. Rg7+ { [%eval 4.61] } 47... Kc6 { [%eval 5.15] } 48. Rxa7 { [%eval 5.22] } 48... Kxc5 { [%eval 5.14] } 49. Rf7 { [%eval 5.05] } *
"""

pgnB="""
[Event "2025: Kjell Persson - CN (0-1)"]
[Site "https://lichess.org/study/w7W4RA4b/tfPR1SuA"]
[Date "2025-01-25"]
[White "Kjell Persson"]
[Black "Christer Nilsson"]
[Result "0-1"]
[WhiteElo "1715"]
[BlackElo "1631"]
[Variant "Standard"]
[ECO "C44"]
[Opening "King's Knight Opening: Normal Variation"]
[Annotator "https://lichess.org/@/ChristerNilsson"]
[StudyName "2025"]
[ChapterName "Kjell Persson - CN (0-1)"]

1. e4 { [%eval 0.18] } 1... e5 { [%eval 0.21] } 2. Nf3 { [%eval 0.13] } 2... Nc6 { [%eval 0.17] } 3. d3 { [%eval -0.14] } 3... d5 { [%eval 0.0] } 4. exd5 { [%eval 0.0] } 4... Qxd5 { [%eval 0.0] } 5. Nc3 { [%eval 0.0] } 5... Bb4 { [%eval 0.11] } 6. Bd2 { [%eval -0.1] } 6... Bxc3 { [%eval -0.06] } 7. Bxc3 { [%eval -0.14] } 7... Bg4 { [%eval 0.01] } 8. Be2 { [%eval 0.21] } 8... Nf6 { [%eval 0.2] } 9. O-O { [%eval 0.18] } 9... O-O-O { [%eval 0.13] } 10. h3 { [%eval 0.16] } 10... Bh5?? { [%eval 1.97] } { Blunder. Bd7 was best. } (10... Bd7) 11. Nd2?? { [%eval -0.42] } { Blunder. Nxe5 was best. } (11. Nxe5 Bxe2 12. Qxe2 Rhe8 13. f4 Nd7 14. Qf2 f6 15. Nxc6 Qxc6 16. Rae1 Nb6) 11... Bxe2 { [%eval -0.44] } 12. Qxe2 { [%eval -0.41] } 12... Nd4?! { [%eval 0.28] } { Inaccuracy. Rhe8 was best. } (12... Rhe8 13. Rfe1 Qe6 14. Nc4 Nd5 15. Ne3 Nxc3 16. bxc3 f5 17. a4 Qf7 18. Rab1) 13. Qd1 { [%eval -0.13] } 13... Rhe8 { [%eval -0.15] } 14. f3? { [%eval -1.34] } { Mistake. Re1 was best. } (14. Re1 Re6 15. Rb1 a6 16. a3 h6 17. b4 Nf5 18. Nf3 Nd7 19. Qe2 f6) 14... Qc5 { [%eval -0.99] } 15. Kh1?! { [%eval -1.64] } { Inaccuracy. Rf2 was best. } (15. Rf2) 15... Nf5 { [%eval -1.13] } 16. Qe2?? { [%eval -8.27] } { Blunder. Qe1 was best. } (16. Qe1 Nd5 17. Qf2 Qc6 18. Ne4 b6 19. Rac1 h5 20. Rfe1 f6 21. Ng3 Nxg3+) 16... Ng3+ { [%eval -8.33] } 17. Kh2 { [%eval -8.21] } 17... Nxe2 { [%eval -8.19] } 0-1
"""

pgnC="""
[Event "2025: CU2:17"]
[Site "https://lichess.org/study/w7W4RA4b/GPucDDSc"]
[Result "*"]
[Variant "Standard"]
[ECO "C80"]
[Opening "Ruy Lopez: Open"]
[Annotator "https://lichess.org/@/ChristerNilsson"]
[StudyName "2025"]
[ChapterName "CU2:17"]
[UTCDate "2025.01.21"]
[UTCTime "13:22:19"]

1. e4 { [%eval 0.18] } 1... e5 { [%eval 0.21] } 2. Nf3 { [%eval 0.13] } 2... Nc6 { [%eval 0.17] } 3. Bb5 { [%eval 0.08] } 3... a6 { [%eval 0.21] } 4. Ba4 { [%eval 0.27] } 4... Nf6 { [%eval 0.18] } 5. O-O { [%eval 0.13] } 5... Nxe4 { [%eval 0.17] } 6. d4 { [%eval 0.17] } 6... b5 { [%eval 0.2] } 7. Bb3 { [%eval 0.2] } 7... d6?? { [%eval 2.51] } { Blunder. d5 was best. } (7... d5 8. dxe5 Be6 9. c3 Bc5 10. Qe2 O-O 11. Be3 f6 12. exf6) 8. dxe5 { [%eval 2.9] } 8... dxe5?! { [%eval 4.18] } { Inaccuracy. Nc5 was best. } (8... Nc5 9. Bd5 Bb7 10. Ng5 Ne6 11. Nxf7 Kxf7 12. Qf3+ Ke7 13. Bxc6 Bxc6 14. Qxc6) 9. Qd5 { [%eval 4.05] } 9... Bb7?? { [%eval #1] } { Checkmate is now unavoidable. Qxd5 was best. } (9... Qxd5 10. Bxd5 Bd7 11. Bxe4 Bd6 12. a4 bxa4 13. Na3 f5 14. Bxc6 Bxc6 15. Re1) 10. Qxf7# *
"""

pgnD="""
[Event "2025: Christer Nilsson vs Mikael Helin"]
[Site "https://lichess.org/study/w7W4RA4b/etpuQVSc"]
[Date "2025-03-05"]
[White "Christer Nilsson"]
[Black "Mikael Helin"]
[Result "0-1"]
[WhiteElo "1639"]
[BlackElo "1863"]
[Variant "Standard"]
[ECO "B00"]
[Opening "Pirc Defense"]
[Annotator "https://lichess.org/@/ChristerNilsson"]
[StudyName "2025"]
[ChapterName "Christer Nilsson vs Mikael Helin"]

1. e4 { [%eval 0.18] } 1... d6 { [%eval 0.43] } 2. d4 { [%eval 0.43] } 2... Nf6 { [%eval 0.43] } 3. Nc3 { [%eval 0.38] } 3... Nc6 { [%eval 0.64] } 4. Bb5 { [%eval 0.31] } 4... a6 { [%eval 0.39] } 5. Ba4?! { [%eval -0.26] } { Inaccuracy. Bxc6+ was best. } (5. Bxc6+ bxc6 6. Nf3 Bb7 7. Bf4 e6 8. Qd3 a5 9. O-O-O Ba6) 5... b5 { [%eval -0.15] } 6. Bb3 { [%eval -0.3] } 6... Bd7?! { [%eval 0.57] } { Inaccuracy. Bb7 was best. } (6... Bb7 7. Nf3 Na5 8. Qe2 e6 9. d5 Nxb3 10. axb3 Qd7 11. dxe6) 7. h3 { [%eval 0.11] } (7. Nf3 b4 8. Nd5 Nxd5 9. Bxd5 e6 10. Bc4 Be7 11. O-O O-O 12. Bd2 a5 13. c3 bxc3 14. bxc3) 7... b4 { [%eval 0.25] } 8. Nd5 { [%eval 0.32] } 8... Nxe4 { [%eval 0.36] } 9. Qf3 { [%eval 0.08] } 9... f5 { [%eval 0.06] } 10. Ne2 { [%eval 0.26] } 10... g6 { [%eval 0.43] } 11. c3?! { [%eval -0.49] } { Inaccuracy. g4 was best. } (11. g4) 11... bxc3? { [%eval 0.88] } { Mistake. e6 was best. } (11... e6) 12. bxc3? { [%eval -0.67] } { Mistake. Ndxc3 was best. } (12. Ndxc3 Nxc3 13. Qxc3 Qb8 14. d5 Ne5 15. f4 Nf7 16. Be3 Bh6 17. g4 fxg4) 12... e6 { [%eval -0.43] } 13. Nb4? { [%eval -1.9] } { Mistake. Ndf4 was best. } (13. Ndf4 d5) 13... Na5 { [%eval -1.96] } 14. Bc2 { [%eval -1.89] } 14... d5 { [%eval -1.38] } 15. h4?! { [%eval -2.2] } { Inaccuracy. Nd3 was best. } (15. Nd3 Rc8) 15... c5 { [%eval -2.07] } 16. Nd3 { [%eval -2.31] } 16... cxd4 { [%eval -2.37] } 17. cxd4 { [%eval -2.32] } 17... Rc8 { [%eval -2.24] } 18. Bd1 { [%eval -2.78] } 18... Nc4 { [%eval -2.91] } 19. a3? { [%eval -5.45] } { Mistake. O-O was best. } (19. O-O Qxh4 20. Re1 (20. g3 Ned2 21. Qxd5 exd5 22. gxh4) 20... g5 21. Ng3 Nxg3 22. Qxg3 Qxg3 23. fxg3 g4 24. Bf4 Bg7) 19... Qa5+ { [%eval -5.41] } 0-1
"""

shrink = (a) ->
	a = a.replaceAll '.','•'
	a = a.replaceAll '| ',''
	a = a.replaceAll ' |',''
	a = a.replaceAll '1 ',''
	a = a.replaceAll '2 ',''
	a = a.replaceAll '3 ',''
	a = a.replaceAll '4 ',''
	a = a.replaceAll '5 ',''
	a = a.replaceAll '6 ',''
	a = a.replaceAll '7 ',''
	a = a.replaceAll '8 ',''
	a = a.split '\n'
	a = a.slice 1,9
	a.join '<br>'

window.setup = ->
	createCanvas 8 * SIZE, 8 * SIZE, document.getElementById "canvas"
	textAlign CENTER,CENTER

	games.A = new Game 'A', pgnA
	games.B = new Game 'B', pgnB 
	games.C = new Game 'C', pgnC
	games.D = new Game 'D', pgnD

	echo games.A.uci_moves
	echo games.B.uci_moves
	echo games.C.uci_moves
	echo games.D.uci_moves

	players.A = new Player 'A',2*SIZE,2*SIZE
	players.B = new Player 'B',6*SIZE,2*SIZE
	players.C = new Player 'C',2*SIZE,6*SIZE
	players.D = new Player 'D',6*SIZE,6*SIZE

	document.getElementById("A").addEventListener "click", -> games.A.initMove()
	document.getElementById("B").addEventListener "click", -> games.B.initMove()
	document.getElementById("C").addEventListener "click", -> games.C.initMove()
	document.getElementById("D").addEventListener "click", -> games.D.initMove()

window.draw = ->
	background 0
	noStroke()
	for i in [0...8]
		for j in [0...8]
			if (i+j) % 2 == 1 then fill 'green' else fill 'lightgreen'
			x = i * SIZE
			y = j * SIZE
			rect x, y, SIZE - 1, SIZE - 1
	for key of players
		player = players[key]
		player.draw()

class Player
	constructor : (@name,@tx,@ty) ->
		@speed = 1/SPEED
		@pos = createVector 4*SIZE,4*SIZE
		@target = new Square createVector @tx, @ty
		@home = @target
		@squares = [] # lista med Square som ej påbörjats
		@trail = []
		@n = 0
		@distance = 0

	closest : ->
		if @squares.length == 0 then return null
		bestDist = 99999
		bestSq = @squares[0]
		for square in @squares
			d = p5.Vector.dist square.pos, @pos
			if d < bestDist
				bestDist = d
				bestSq = square
		bestSq

	add : (sq) ->
		@squares.push sq
		@target = @closest()

	drawTail : ->
		if @n % (SPEED*10) == 0 then @trail.push createVector @pos.x, @pos.y
		@n += 1
		if @trail.length > MAXTRAIL then @trail.shift()
		stroke 'black'
		for i in [0...@trail.length]
			size = map i, 0, @trail.length - 1, 5,15
			noFill()
			ellipse @trail[i].x, @trail[i].y, size, size

	draw : () ->
		target = @target.pos
		dx = target.x - @pos.x
		dy = target.y - @pos.y
		d = sqrt dx*dx+dy*dy

		stroke 'black'
		line target.x, target.y, @pos.x, @pos.y

		step = p5.Vector.sub(target, @pos).setMag min @speed, d
		if d < @speed # target nådd
			if not @target.done
				@target.done = true
				@target.carrier = @name

				# Skicka draget om både start.done och slut.done
				for key of games
					g = games[key]
					if g.move and g.move.start.done and g.move.stopp.done
						if g.move.start.carrier == g.move.stopp.carrier
							carriers = g.move.start.carrier
						else 
							carriers = g.move.start.carrier + g.move.stopp.carrier
						echo g.name, g.move.uci, @name, g.move.start.carrier + g.move.stopp.carrier

						g.chess.move { from: g.move.uci.slice(0, 2), to: g.move.uci.slice(2, 4) }
						# g.chess.moveNumber()

						td = document.getElementById("SEL#{g.name}")
						td.innerHTML += "#{g.san_moves[g.chess.history().length-1]} by #{carriers}<br>"

						# g.chess.move g.move.san
						# echo g.chess.ascii()
						document.getElementById("board#{g.name}").innerHTML = shrink g.chess.ascii()

						g.queue.push g.move
						g.move = null
						g.initMove()


			@squares = _.filter @squares, (sq) -> sq.done == false 

			# hämta närmaste uppdrag om sådant finns
			if @squares.length > 0
				@target = @closest()
				d = p5.Vector.dist @pos,@target.pos
				@distance += d

		@pos.add step

		@drawTail()
	
		fill 'yellow'
		strokeWeight 1
		circle @pos.x,@pos.y,0.4*SIZE
		fill 'black'
		text @name, @pos.x, @pos.y

uci2pos = (uci) -> # t ex e2e4 => [[225,75],[225,175]]
	startx = uci[0]
	starty = uci[1]
	stoppx = uci[2]
	stoppy = uci[3]
	result = []
	x = "abcdefgh".indexOf startx
	y = 7 - "12345678".indexOf starty
	result.push createVector SIZE/2 + SIZE*x, SIZE/2 + SIZE*y
	x = "abcdefgh".indexOf stoppx
	y = 7 - "12345678".indexOf stoppy
	result.push createVector SIZE/2 + SIZE*x, SIZE/2 + SIZE*y
	result

class Game
	constructor : (@name,pgn) ->
		@chess = new Chess()
		@chess.load_pgn pgn
		@san_moves = @chess.history() # [Nf3, ...]
		@uci_moves = (move.from + move.to for move in @chess.history({ verbose: true })) # [g1f3, ...]
		@move = null
		@queue = []
		@chess.reset()

	initMove : ->
		if @uci_moves.length == 0 then return
		if @move != null 
			echo 'too quick!'
			return
		@move = new Move @uci_moves.shift()

		# Dela ut start och stopp till rätt spelare beroende på kvadrant
		if @move.uci[0] in "abcd" and @move.uci[1] in "1234" then players.C.add @move.start
		if @move.uci[0] in "abcd" and @move.uci[1] in "5678" then players.A.add @move.start
		if @move.uci[0] in "efgh" and @move.uci[1] in "1234" then players.D.add @move.start
		if @move.uci[0] in "efgh" and @move.uci[1] in "5678" then players.B.add @move.start

		if @move.uci[2] in "abcd" and @move.uci[3] in "1234" then players.C.add @move.stopp
		if @move.uci[2] in "abcd" and @move.uci[3] in "5678" then players.A.add @move.stopp
		if @move.uci[2] in "efgh" and @move.uci[3] in "1234" then players.D.add @move.stopp
		if @move.uci[2] in "efgh" and @move.uci[3] in "5678" then players.B.add @move.stopp

class Square 
	constructor : (@pos, @uci="", @carrier="") -> # Vector
		@done = false
	
class Move
	constructor : (@uci) -> # e2e4
		@pos = uci2pos @uci
		@start = new Square @pos[0], @uci
		@stopp = new Square @pos[1], @uci

