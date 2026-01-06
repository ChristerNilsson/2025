import {echo,global,range,settings} from './global.js'
import {elo_formula,performance} from './rating.js'

export class Player

	constructor : (@id, @name, @elo, @fideid) ->

#		[@elo, @name, @fideid] = @eloNameFide.split '|'
#		echo @elo, @name, @fideid

		@born = "0000"
		@federation = "   "
		@sex = " "
		@title = "   "
		@opp = [] # används endast av Floating
		@col = "" # används endast av Floating
		@summa = 0
		@P = 0
		@PR = 0

	balance : ->
		b = 0
		for c in @col
			if c == 'w' then b++
			if c == 'b' then b--
		b

	toString : -> "#{String(@elo).padStart 4, '0'}|#{@name}|#{@fideid}"

	getElos : (long) ->
		@P = 0
		@PR = 0
		@elos = [@elo, ':']
		# for r in range settings.GAMES * settings.ROUNDS
		for r in range settings.GAMES * (global.currRound+1)
			ch = long[r][3]
			value = '012'.indexOf ch
			opp = long[r][1]
			if value != -1
				elo = global.players[opp].elo
				@P += value/2
				if elo != 0
					@PR += value/2
					@elos.push Math.round elo
			else
				@elos.push '    '
			
		@elos.push @PR
		@elos.join ' '

	# update_P_and_PR : (longs,i) ->
	# 	long = longs[i]
	# 	#echo 'longs',longs
	# 	@P = 0
	# 	@PR = 0
	# 	@elos = []
	# 	for r in range settings.GAMES * settings.ROUNDS
	# 		ch = long[r][3]
	# 		value = '012'.indexOf ch
	# 		opp = long[r][1]
	# 		if value != -1
	# 			elo = global.players[opp].elo
	# 			@P += value/2
	# 			if elo != 0
	# 				@PR += value/2
	# 				@elos.push Math.round elo

	# 	# kalkylera performance rating mha vinstandel och elo-tal
	# 	if @elos.length == 0 
	# 		@PR = 0
	# 	else
	# 		andel = @PR
	# 		perf = performance andel, @elos
	# 		@PR = perf

	update_P_and_PR : (longs,i) ->
		long = longs[i]
		#echo 'longs',longs
		@P = 0
		@Q = 0
		@PR = 0
		@elos = []
		points = []
		@avg = 0
		antal = settings.GAMES * (global.currRound+1) # settings.ROUNDS
		for r in range antal
			ch = long[r][3]
			value = '012'.indexOf ch
			opp = long[r][1]
			if ch in '012' and opp != global.frirond
				elo = global.players[opp].elo
				if elo == 0 then elo = 1400
				@elos.push Math.round elo
				@avg += parseFloat elo
				p = value/2
				@P += p
				points.push p
		#echo points
		if @elos.length > 0
			@avg /= @elos.length
			@score = @P / @elos.length
		else
			@avg = 0
			@score = 0
		#echo @elos

		# kalkylera performance rating mha vinstandel och elo-tal
		@PR = if @elos.length < (global.currRound + 1) / 2 then 0 else performance @P, @elos

		#echo 'A', @name, @elo, @P.toFixed(3), @PR #, global.average
		@Q = settings.GAMES * settings.ROUNDS * elo_formula global.average - @PR
		# echo 'B', @elo, settings.GAMES * settings.ROUNDS, @Q, elo_formula global.average - @PR

