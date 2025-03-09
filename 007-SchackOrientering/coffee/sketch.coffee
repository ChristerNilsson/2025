SIZE = 60
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
1. d4 { [%clk 0:15:00] } 1... d5 { [%clk 0:15:00] } { D00 Queen's Pawn Game } 2. c3 { [%clk 0:15:06] } 2... Nc6 { [%clk 0:15:13] } 3. b4 { [%clk 0:15:15] } 3... a5 { [%clk 0:15:23] } 4. b5 { [%clk 0:15:20] } 4... Na7 { [%clk 0:15:28] } 5. a4 { [%clk 0:15:31] } 5... c6 { [%clk 0:15:40] } 6. c4 { [%clk 0:15:21] } 6... cxb5 { [%clk 0:15:52] } 7. cxb5 { [%clk 0:15:30] } 7... b6 { [%clk 0:16:05] } 8. f3 { [%clk 0:15:30] } 8... Nf6 { [%clk 0:16:17] } 9. g4 { [%clk 0:15:26] } 9... g5 { [%clk 0:16:28] } 10. Bg2 { [%clk 0:15:33] } 10... e6 { [%clk 0:16:40] } 11. Bxg5 { [%clk 0:15:36] } 11... Bb4+ { [%clk 0:16:34] } 12. Nd2 { [%clk 0:15:37] } 12... Bxd2+ { [%clk 0:16:47] } 13. Qxd2 { [%clk 0:15:49] } 13... O-O { [%clk 0:16:56] } 14. Qf4 { [%clk 0:15:37] } 14... Qc7 { [%clk 0:16:44] } 15. Qxc7 { [%clk 0:15:43] } { Black resigns. } 1-0
"""

pgnB="""
1. b4 e5 2. Bb2 d6 3. d4 exd4 4. Qxd4 Nc6 5. Qe4+ Nge7 6. a3 a6 7. Nc3 Bf5 8. Qh4 Bxc2 9. Nd5 Nxd5 10. Qc4 Ndxb4 11. axb4 Bg6 12. e4 Qe7 13. Bd3 Ne5 14. Bxe5 Qxe5 15. Rc1 O-O-O 1-0
"""

pgnC="""
1. e4 e5 2. Nf3 d6 3. Bc4 c6 4. Ng5 Nh6 5. Qh5 g6 6. Bxf7+ Kd7 7. Be6+ Ke7 8. Qh4 Na6 9. Nf7+ Ke8 10. Qxd8# 1-0
"""

pgnD="""
1. Nf3 d5 2. d4 e6 3. e3 Bb4+ 4. c3 Bd6 5. Ne5 Qf6 6. f4 Qh4+ 7. g3 Qf6 8. h4 Bxe5 9. dxe5 Qg6 10. Bd3 Qxg3+ 11. Kf1 Nh6 12. Qa4+ c6 13. Nd2 Ng4 14. Ke2 Qf2+ 15. Kd1 Nxe3# 0-1
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

updateInfo = (name,player) ->
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
		updateInfo key,player

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
						duration = (30 * (performance.now() - g.move.start.time)/1000)
						g.duration += duration
						if g.move.start.carrier == g.move.stopp.carrier
							carriers = g.move.start.carrier
						else 
							carriers = g.move.start.carrier + g.move.stopp.carrier
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
	constructor : (@name, pgn, @link) ->
		@chess = new Chess()
		@chess.load_pgn pgn
		@san_moves = @chess.history() # [Nf3, ...]
		@uci_moves = (move.from + move.to for move in @chess.history({ verbose: true })) # [g1f3, ...]
		@move = null
		@queue = []
		@duration = 0
		@chess.reset()
		document.getElementById("link#{@name}").innerHTML = "<a href=\"#{@link}\" target=\"_blank\">Link</a>"

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
		@time = performance.now()
		echo @time
	
class Move
	constructor : (@uci) -> # e2e4
		@pos = uci2pos @uci
		@start = new Square @pos[0], @uci
		@stopp = new Square @pos[1], @uci

