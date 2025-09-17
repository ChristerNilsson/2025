export class Player
	constructor : (@id, @name, @elo) ->
		@opp = [] # används endast av Floating
		@col = "" # används endast av Floating
	balans : ->
		b = 0
		for c in @col
			if c=='w' then b++
			if c=='b' then b--
		b

	toString: -> "#{String(@elo).padStart 4, '0'} #{@name}"
