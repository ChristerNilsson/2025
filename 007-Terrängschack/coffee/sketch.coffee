SIZE = 60
MAXTRAIL = 5
SPEED = 0.5 # 1

FILES = 'abcdefgh'
RANKS = '12345678'

echo = console.log

games = {}
players = {}

startTime = Date.now()
stoppTime = null

pgnA = """1. d4 d5 2. c3 Nc6 3. b4 a5 4. b5 Na7 5. a4 c6 6. c4 cxb5 7. cxb5 b6 8. f3 Nf6 9. g4 g5 10. Bg2 e6 11. Bxg5 Bb4+ 12. Nd2 Bxd2+ 13. Qxd2 O-O 14. Qf4 Qc7 15. Qxc7 1-0"""
pgnB = """1. b4 e5 2. Bb2 d6 3. d4 exd4 4. Qxd4 Nc6 5. Qe4+ Nge7 6. a3 a6 7. Nc3 Bf5 8. Qh4 Bxc2 9. Nd5 Nxd5 10. Qc4 Ndxb4 11. axb4 Bg6 12. e4 Qe7 13. Bd3 Ne5 14. Bxe5 Qxe5 15. Rc1 O-O-O 1-0"""
pgnC = """1. e4 e5 2. Nf3 d6 3. Bc4 c6 4. Ng5 Nh6 5. Qh5 g6 6. Bxf7+ Kd7 7. Be6+ Ke7 8. Qh4 Na6 9. Nf7+ Ke8 10. Qxd8# 1-0"""
pgnD = """1. Nf3 d5 2. d4 e6 3. e3 Bb4+ 4. c3 Bd6 5. Ne5 Qf6 6. f4 Qh4+ 7. g3 Qf6 8. h4 Bxe5 9. dxe5 Qg6 10. Bd3 Qxg3+ 11. Kf1 Nh6 12. Qa4+ c6 13. Nd2 Ng4 14. Ke2 Qf2+ 15. Kd1 Nxe3# 0-1"""

# pgnA = """1. a3 e6 2. a4 e5 3. a5 e4 4. a6 e3"""
# pgnB = """1. b3 f6 2. b4 f5 3. b5 f4 4. b6 f3"""
# pgnC = """1. c3 g6 2. c4 g5 3. c5 g4 4. c6 g3"""
# pgnD = """1. d3 h6 2. d4 h5 3. d5 h4 4. d6 h3"""

shrink = (a) -> # tar bort indexes från chess.ascii()
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

updateInfo = (name,player) ->
	if name in 'ABCD'
		document.getElementById("info#{name}").innerHTML = "plies: #{games[name].chess.history().length}<br>assists: #{player.assists}<br>time: #{games[name].duration.toFixed()} s"

window.setup = ->
	createCanvas 8 * SIZE, 8 * SIZE, document.getElementById "canvas"
	textAlign CENTER,CENTER

	games.A = new Game 'A', pgnA, 'https://lichess.org/GjV0BK25'
	games.B = new Game 'B', pgnB, 'https://lichess.org/BxG8RTkh'
	games.C = new Game 'C', pgnC, 'https://lichess.org/QOFUafUP'
	games.D = new Game 'D', pgnD, 'https://lichess.org/l16tQWr3'

	document.getElementById("boardA").innerHTML = shrink games.A.chess.ascii()
	document.getElementById("boardB").innerHTML = shrink games.B.chess.ascii()
	document.getElementById("boardC").innerHTML = shrink games.C.chess.ascii()
	document.getElementById("boardD").innerHTML = shrink games.D.chess.ascii()

	echo games.A.uci_moves
	echo games.B.uci_moves
	echo games.C.uci_moves
	echo games.D.uci_moves

	players.A = new Player 'A'
	players.B = new Player 'B'
	players.C = new Player 'C'
	players.D = new Player 'D'

	players.E = new Player 'E'
	players.F = new Player 'F'
	players.G = new Player 'G'
	players.H = new Player 'H'

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
	for key in 'EFGHABCD'
		player = players[key]
		player.draw()
		updateInfo key,player

class Player
	constructor : (@name, @tx=4*SIZE, @ty=4*SIZE) ->
		@speed = SPEED
		@pos = createVector 4*SIZE,4*SIZE
		@target = new Square createVector @tx, @ty
		@home = @target
		@squares = [] # lista med Square som ej påbörjats
		@trail = []
		@n = 0
		@distance = 0
		@assists = 0

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
		if @n % (10/SPEED) == 0 then @trail.push createVector @pos.x, @pos.y
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

		# if @name in 'ABCD'
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
						duration = (15/SPEED * (performance.now() - g.move.start.time)/1000)

						if g.index % 2 == 0 then g.duration += duration
						if g.move.start.carrier == g.move.stopp.carrier
							carriers = g.move.start.carrier
						else 
							carriers = g.move.start.carrier + g.move.stopp.carrier

						if g.move.start.carrier in 'ABCD'
							echo 'assists: ',g.move.start.carrier,g.move.stopp.carrier
							players[g.move.start.carrier].assists += 1
							players[g.move.stopp.carrier].assists += 1
							echo g.name, g.move.uci, @name, g.move.start.carrier + g.move.stopp.carrier

						g.chess.move { from: g.move.uci.slice(0, 2), to: g.move.uci.slice(2, 4) }

						td = document.getElementById("SEL#{g.name}")
						td.innerHTML += "#{g.san_moves[g.chess.history().length-1]} by #{carriers} (#{duration.toFixed()} s)<br>"

						document.getElementById("board#{g.name}").innerHTML = shrink g.chess.ascii()
						updateInfo g.name, @

						g.queue.push g.move
						g.move = null
						if g.initMove() == false
							stoppTime = Date.now()
							echo 'done', (stoppTime-startTime)/1000

			@squares = _.filter @squares, (sq) -> sq.done == false

			# hämta närmaste uppdrag om sådant finns
			if @squares.length > 0
				@target = @closest()
				d = p5.Vector.dist @pos,@target.pos
				@distance += d

		@pos.add step

		for square in @squares
			if @name in 'ABCD'
				fill 'red'
			else
				fill 'black'
			circle square.pos.x, square.pos.y, 10

		# if @name in 'ABCD'
		@drawTail()
		if @name in 'ABCD' then fill 'yellow' else fill 'black'
		strokeWeight 1
		circle @pos.x,@pos.y,0.4*SIZE
		if @name in 'ABCD' then fill 'black' else fill 'yellow'
		noStroke()
		# fill 'black'
		text @name, @pos.x, @pos.y

uci2pos = (uci) -> # t ex e2e4 => [[225,75],[225,175]]
	startx = uci[0]
	starty = uci[1]
	stoppx = uci[2]
	stoppy = uci[3]
	result = []
	x = FILES.indexOf startx
	y = 7 - RANKS.indexOf starty
	result.push createVector SIZE/2 + SIZE*x, SIZE/2 + SIZE*y
	x = FILES.indexOf stoppx
	y = 7 - RANKS.indexOf stoppy
	result.push createVector SIZE/2 + SIZE*x, SIZE/2 + SIZE*y
	result

class Game
	constructor : (@name, pgn, @link) ->
		@chess = new Chess()
		@chess.load_pgn pgn
		@san_moves = @chess.history() # [Nf3, ...]
		@uci_moves = (move.from + move.to for move in @chess.history({ verbose: true })) # [g1f3, ...]
		@move = null
		@queue = []
		@duration = 0
		@chess.reset()
		@index = -1
		document.getElementById("link#{@name}").innerHTML = "<a href=\"#{@link}\" target=\"_blank\">Link</a>"

	initMove : ->
		if @index >= @uci_moves.length - 1 then return false
		@index += 1
		if @move != null 
			echo 'too quick!'
			return false
		@move = new Move @uci_moves[@index], @name

		start = @move.uci.slice 0,2
		stopp = @move.uci.slice 2,4

		antal = 'ABCD'.indexOf @name
		for i in [0...antal] 
			start = rotate start
			stopp = rotate stopp

		if @index % 2 == 0
			a = "1234"
			b = "5678"
			# Dela ut start och stopp till rätt spelare beroende på kvadrant
			if start[0] in "abcd" and start[1] in a then players.A.add @move.start
			if start[0] in "efgh" and start[1] in a then players.B.add @move.start
			if start[0] in "abcd" and start[1] in b then players.C.add @move.start
			if start[0] in "efgh" and start[1] in b then players.D.add @move.start

			if stopp[0] in "abcd" and stopp[1] in a then players.A.add @move.stopp
			if stopp[0] in "efgh" and stopp[1] in a then players.B.add @move.stopp
			if stopp[0] in "abcd" and stopp[1] in b then players.C.add @move.stopp
			if stopp[0] in "efgh" and stopp[1] in b then players.D.add @move.stopp

		else
			a = "1234"
			b = "5678"
			# Hantera motståndaren
			# Dela ut start och stopp till rätt spelare beroende på kvadrant
			if start[0] in "abcd" and start[1] in a then players.G.add @move.start
			if start[0] in "abcd" and start[1] in b then players.E.add @move.start
			if start[0] in "efgh" and start[1] in a then players.H.add @move.start
			if start[0] in "efgh" and start[1] in b then players.F.add @move.start

			if stopp[0] in "abcd" and stopp[1] in a then players.G.add @move.stopp
			if stopp[0] in "abcd" and stopp[1] in b then players.E.add @move.stopp
			if stopp[0] in "efgh" and stopp[1] in a then players.H.add @move.stopp
			if stopp[0] in "efgh" and stopp[1] in b then players.F.add @move.stopp
		true

class Square 
	constructor : (@pos, @uci="", @carrier="") -> # Vector
		@done = false
		@time = performance.now()
	
rotate = (sq) -> FILES[8-sq[1]] + String 1 + FILES.indexOf sq[0]
echo "g3" == rotate "c2"
echo "h1" == rotate "a1"
echo "h8" == rotate rotate "a1"
echo "a8" == rotate rotate rotate "a1"
echo "a1" == rotate rotate rotate rotate "a1"

coordinates = (sq) ->
	x = FILES.indexOf sq[0]
	y = RANKS.indexOf sq[1]
	[x, 7-y]
echo _.isEqual [4,4], coordinates "e4"
echo _.isEqual [0,7], coordinates "a1"

toVector = ([x,y]) ->
	createVector SIZE/2 + SIZE*x, SIZE/2 + SIZE*y
# echo toVector [3,4]

class Move
	constructor : (@uci, @name) -> # e2e4, B
		antal = "ABCD".indexOf @name
		start = @uci.slice 0,2
		stopp = @uci.slice 2,4
		for i in [0...antal]
			start = rotate start
			stopp = rotate stopp
		start = toVector coordinates start
		stopp = toVector coordinates stopp
		@pos = [start, stopp]
		@start = new Square start, @uci
		@stopp = new Square stopp, @uci
