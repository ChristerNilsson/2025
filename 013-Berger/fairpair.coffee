import { Edmonds } from './blossom.js'  

range = _.range
echo = console.log

export class FairPair 
	constructor : (@players, @R) ->
		echo 'constructor',@R
		@N = @players.length
		@matrix = (("•" for i in range @N) for j in range @N)
		@summa = 0
		@rounds = []

		for r in range @R
			edges = @makeEdges()
			edmonds = new Edmonds edges
			magic = edmonds.maxWeightMatching edges
			@rounds.push @updatePlayers magic,r

	makeEdges : ->
		edges = [] 
		for i in range @N
			a = @players[i]
			for j in range @N
				if i==j then @matrix[i][j] = ' '
				b = @players[j]
				if @ok a,b then edges.push [i, j, 10000 - Math.abs a.elo - b.elo]
		edges

	# sortTables : (tables) -> # Blossom verkar redan ge en bra bordsplacering
	# 	tables.sort (x,y) -> y[2] - x[2]
	# 	table.slice 0,2 for table in tables

	updatePlayers : (magic,r) ->
		tables = []
		for id in magic
			i = id
			j = magic[id]
			@matrix[i][j] = (r + 1).toString()
			if i > j then continue
			@summa += Math.abs @players[i].elo - @players[j].elo
			a = @players[i]
			b = @players[j]
			a.opp.push j
			b.opp.push i
			if a.balans() > b.balans()
				a.col += 'b'
				b.col += 'w'
				tables.push [j, i] #, a.elo + b.elo]
			else
				a.col += 'w'
				b.col += 'b'
				tables.push [i, j] #, a.elo + b.elo]

		#@sortTables tables
		echo 'updatePlayers',tables
		tables

	ok : (a,b) -> 
		if a.id == b.id then return false
		if a.id in b.opp then return false
		Math.abs(a.balans() + b.balans()) < 2
