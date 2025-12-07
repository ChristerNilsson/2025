echo = console.log 

export elo_formula = (gap) -> 1 / (1 + 10 ** (gap / 400))

# expected_score = (ratings, own_rating) -> summa ((elo_formula own_rating - rating) for rating in ratings)
expected_score = (ratings, own_rating) -> summa (1 / (1 + 10**((rating - own_rating) / 400)) for rating in ratings)


# Use two extreme values when calculating 0% or 100%
extrapolate = (a0, b0, elos) ->
	a = performance_rating a0,elos
	b = performance_rating b0,elos
	b + b - a

export performance = (pp,elos) -> 
	n = elos.length
	if pp == 0 then return extrapolate   0.5,  0.25,elos
	if pp == n then return extrapolate n-0.5,n-0.25,elos
	performance_rating pp,elos

performance_rating = (pp, ratings) ->
	lo = 0
	hi = 4000
	while Math.abs(hi - lo) > 0.001
		rating = (lo + hi) / 2
		if pp > expected_score ratings, rating
			lo = rating
		else
			hi = rating
	rating

summa = (arr) ->
	res = 0
	for item in arr
		res += item
	res

inv = (score) ->
	lo = -1000
	hi = 1000
	while Math.abs(hi - lo) > 0.001
		gap = (lo + hi) / 2
		if score > elo_formula gap
			lo = gap
		else
			hi = gap
	gap

####

# echo performance_rating 2, [2113,1986,2132,2057,1702,2085] # Rånby
# echo elo_formula -100
# echo elo_formula 100

# for x in [-200,-100,0,100,200]
# 	echo x,elo_formula x

# echo inv 0.36
# echo inv 0.64

# for i in _.range -1000,1000,100
# 	echo i,elo_formula i

echo ""

# for i in [0.01,0.1,0.2,0.3,0.4,0.5, 0.6, 0.7, 0.8, 0.9, 0.99]
# 	echo i,inv i

#rånby = [2113,1986,2132,2057,1702,2085]

#echo expected_score rånby, 1900 # 3.8839
#echo performance_rating 3.8839, rånby # 1900.000

# average är en grövre metod. Undvik om möjligt.
# avg = summa(rånby)/6
# echo avg
# echo 6 * elo_formula avg - 1900 # 3.9388
# echo performance_rating 3.9388, rånby # 1891.685

exec = (name,elo,elos,score,n) ->
	for i in _.range n - elos.length
		elos.push elo
	b = performance score, elos
	# echo name, score, b.toFixed 0
                                             #   QR Q 
exec "Silins ", 1800, [1613,1679,1799], 3, 3 # 2268 3.00
exec "Razavi ",	1799, [1679,1650,1800], 2, 3 # 1834 2.00
exec "Nilsson",	1650, [1607,1799,1679], 2, 3 # 1821 1.97
exec "Gordh  ",	1570, [1613,1513     ], 2, 3 # 1687 1.67
exec "Eldin  ",	1476, [1513          ], 1, 3 # 1368 0.93
exec "Johanss", 1679, [1799,1800,1650], 0, 3 # 1181 0.50
exec "Steiner",	1613, [1800,1570     ], 0, 3 # 1083 0.28
exec "Franzon",	1607, [1650          ], 0, 3 # 1067 0.24
exec "Granath",	1513, [1476,1570     ], 0, 3 #  962 0.00

###

1. Tag bort frironder, w.o. och ospelat. Sällan detta inträffar.
2. Lägg på EGET elo så alla har lika många elos. När det inträffar => "remi"
3. Beräkna performance
4. Linjärtransformera QR => Q
   Punkterna ovan, (3,2268) samt (0,962) används för att skapa denna linje.

###