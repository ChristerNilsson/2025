import { Edmonds } from './blossom.js'  

range = _.range
echo = console.log

export class Floating
	constructor : (@players, @settings) ->
		@N = @players.length
		if @settings.sort==1 then @players.sort (a,b) -> a.elo - b.elo
		#echo @players
		@matrix = (("•" for i in range @N) for j in range @N)
		#echo @matrix
		@summa = 0
		@rounds = []

		for r in range @settings.ROUNDS
			edges = @makeEdges()
			#echo 'edges',edges
			edmonds = new Edmonds edges
			magic = edmonds.maxWeightMatching edges
			#echo 'magic',magic
			@rounds.push @updatePlayers magic,r

	makeEdges : ->
		edges = [] 
		for i in range @N
			a = @players[i]
			for j in range @N
				if i==j then @matrix[i][j] = ' '
				b = @players[j]
				diff = Math.abs a.elo - b.elo
				if @ok a,b then edges.push [i, j, 10000 - diff ** 1.01]
		edges

	# sortTables : (tables) -> # Blossom verkar redan ge en bra bordsplacering
	# 	tables.sort (x,y) -> y[2] - x[2]
	# 	table.slice 0,2 for table in tables

	ok : (a,b) -> 
		if a.id == b.id then return false
		if a.id in b.opp then return false
		# if not @settings.BALANS and @settings.GAMES % 2 == 0 then return true
		if @settings.BALANS == 0 then return true
		Math.abs(a.balans() + b.balans()) < 2

	updatePlayers : (magic,r) -> 
		tables = []
		#echo 'matrix',@matrix
		for id in magic
			i = id
			j = magic[id]
			if i == @matrix.length or j == @matrix[0].length then continue
			@matrix[i][j] = "#{r + @settings.ONE}"
			if i > j then continue
			#echo i + @settings.ONE, j + @settings.ONE, Math.abs @players[i].elo - @players[j].elo
			@summa += Math.abs @players[i].elo - @players[j].elo
			a = @players[i]
			b = @players[j]
			a.opp.push j
			b.opp.push i
			if a.balans() > b.balans()
				a.col += 'b'
				b.col += 'w'
				tables.push [j, i]
			else
				a.col += 'w'
				b.col += 'b'
				tables.push [i, j]

		#@sortTables tables
		#echo 'updatePlayers',tables
		tables
