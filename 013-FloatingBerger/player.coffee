export class Player
	constructor : (@id, @name, @elo, @PR=0) ->
		@opp = []
		@col = ""
	balans : ->
		result = 0
		for ch in @col 
			if ch == 'w' then result += 1
			if ch == 'b' then result -= 1
		result
	toString: -> "#{String(@elo).padStart 4, '0'} #{@name}"
