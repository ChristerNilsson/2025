SIZE = 50
MAXTRAIL = 5
games = []
players = []

echo = console.log

setup = ->
	createCanvas 8 * SIZE, 8 * SIZE
	textAlign CENTER,CENTER

	games.push new Game 'A',"e2e4 d7d6 d2d4 g8f6 b1c3 b8c6 f1b5 a7a6 b5a4 b7b5 a4b3 c8d7 h2h3 b5b4 c3d5 f6e4 d1f3 f7f5 g1e2 g7g6 c2c3 b4c3 b2c3 e7e6 d5b4 c6a5 b3c2 d6d5 h3h4 c7c5 b4d3 c5d4 c3d4 a8c8 c2d1 a5c4 a2a3 d8a5"
	games.push new Game 'B',"d2d4 d7d5 c1f4 g7g6"
	games.push new Game 'C',"g1f3 e7e5 a1h8 d7d5"
	games.push new Game 'D',"g1f3 e7e5 a8h1 d7d5"

	players = []
	players.push new Player 'A',2*SIZE,2*SIZE
	players.push new Player 'B',6*SIZE,2*SIZE
	players.push new Player 'C',2*SIZE,6*SIZE
	players.push new Player 'D',6*SIZE,6*SIZE

	document.getElementById("A").addEventListener "click", -> games[0].initMove()
	document.getElementById("B").addEventListener "click", -> games[1].initMove()
	document.getElementById("C").addEventListener "click", -> games[2].initMove()
	document.getElementById("D").addEventListener "click", -> games[3].initMove()

draw = ->
	background 0
	noStroke()
	for i in [0...8]
		for j in [0...8]
			if (i+j) % 2 == 1 then fill 'green' else fill 'lightgreen'
			x = i * SIZE
			y = j * SIZE
			rect x, y, SIZE - 1, SIZE - 1
	for player in players
		player.draw()

class Player
	constructor : (@name,@tx,@ty) ->
		@speed = 1
		@pos = createVector 4*SIZE,4*SIZE
		@target = new Square createVector @tx, @ty
		@home = @target
		# echo 'home',@home
		@squares = [] # lista med Square
		@trail = []
		@n = 0

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
		# echo 'add',sq
		@squares.push sq
		@target = @closest()

	draw : () ->
		target = @target.pos
		dx = target.x - @pos.x
		dy = target.y - @pos.y
		d = sqrt dx*dx+dy*dy
		# echo 'draw', @pos, @speed, d, target
		step = p5.Vector.sub(target, @pos).setMag min @speed, d
		if d < @speed # target nådd
			if not @target.done
				@target.done = true
				echo 'target done',@name,@target #.san

				# Skicka draget om både start.done och slut.done
				for g in games

					temp = _.filter g.queue, (move) -> move.start.done and move.stopp.done
					if temp.length > 0 then echo 'delivered',temp[0].san
					g.queue = _.filter g.queue, (move) -> not (move.start.done and move.stopp.done)

			@squares = _.filter @squares, (sq) -> sq.done == false 

			# hämta närmaste uppdrag om sådant finns
			if @squares.length > 0 then @target = @closest()

		@pos.add step

		# Lägg till ny position i svansen
		if @n % 10 == 0 then @trail.push createVector @pos.x, @pos.y
		@n += 1
		if @trail.length > MAXTRAIL then @trail.shift()
		# Rita svansen
		stroke 'black'
		for i in [0...@trail.length]
			size = map i, 0, @trail.length - 1, 5,15
			noFill()
			ellipse @trail[i].x, @trail[i].y, size, size
	
		fill 'yellow'
		# if @free then stroke 'white' else 
		strokeWeight 1
		circle @pos.x,@pos.y,0.4*SIZE
		fill 'black'
		text @name, @pos.x, @pos.y

san2pos = (san) -> # t ex e2e4 => [[225,75],[225,175]]
	startx = san[0]
	starty = san[1]
	stoppx = san[2]
	stoppy = san[3]
	result = []
	x = "abcdefgh".indexOf startx
	y = 7 - "12345678".indexOf starty
	result.push createVector SIZE/2 + SIZE*x, SIZE/2 + SIZE*y
	x = "abcdefgh".indexOf stoppx
	y = 7 - "12345678".indexOf stoppy
	result.push createVector SIZE/2 + SIZE*x, SIZE/2 + SIZE*y
	result

class Game
	constructor : (@name,s) ->
		@moves = s.split ' '
		@nr = 0
		@queue = []

	initMove : ->
		if @nr >= @moves.length then return
		move = new Move @moves[@nr]
		@nr += 1
		@queue.push move

		# Dela ut start och stopp till rätt spelare beroende på kvadrant
		if move.san[0] in "abcd" and move.san[1] in "1234" then players[2].add move.start
		if move.san[0] in "abcd" and move.san[1] in "5678" then players[0].add move.start
		if move.san[0] in "efgh" and move.san[1] in "1234" then players[3].add move.start
		if move.san[0] in "efgh" and move.san[1] in "5678" then players[1].add move.start

		if move.san[2] in "abcd" and move.san[3] in "1234" then players[2].add move.stopp
		if move.san[2] in "abcd" and move.san[3] in "5678" then players[0].add move.stopp
		if move.san[2] in "efgh" and move.san[3] in "1234" then players[3].add move.stopp
		if move.san[2] in "efgh" and move.san[3] in "5678" then players[1].add move.stopp

		echo 'initMove',@name, (move for move in @queue)

	exitMove : ->

class Square 
	constructor : (@pos, @san="") -> # Vector
		@done = false
	
class Move
	constructor : (@san) -> # e2e4
		@pos = san2pos @san
		@start = new Square @pos[0], @san
		@stopp = new Square @pos[1], @san
