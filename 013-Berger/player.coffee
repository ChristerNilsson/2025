export class Player
	constructor : (@id, @name, @elo) ->
		@opp = []
		@col = ""
	balans : ->
		result = 0
		for ch in @col 
			if ch == 'w' then result += 1
			if ch == 'b' then result -= 1
		result
