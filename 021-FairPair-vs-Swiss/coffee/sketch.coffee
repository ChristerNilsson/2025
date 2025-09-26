echo = console.log
range = _.range

startorder = [1,4,2,12,3,5,15,9,14,16,23,6,11,20,7,26,22,8,28,29,36,24,17,50,25,19,13,18,32,27,40,52,35,61,34,41,30,54,66,33,53,71,62,37,21,39,57,48,64,10,46,58,60,44,75,47,31,51,56,45,59,74,67,38,77,76,73,70,68,42,72,63,79,69,80,55,78,81,49,43,65,82]

players = []
player = null
index = 0
n = 0
currIndex = 0

class Player 
	constructor : (@idx, @name, @elo, @swissID, @fairpairID) ->
	makeLists : () ->
		@swissID = (startorder.indexOf id for id in @swissID)
		@fairpairID = (id - 1 for id in @fairpairID)

	lines : (ids, y0, y1, y2) ->
		strokeWeight 1
		fill 'black'
		for r in range ids.length
			i = ids[r]
			x = map i, -1,n, 0,width
			stroke 'black'
			line x,y1,x,y2
			noStroke()
			text r+1,x,y0

	dots : (size) ->
		textSize 14
		noStroke()
		for i in range n # players
			p = players[i]
			x = map i, -1, n, 0, width
			fill 'white'
			if i == currIndex
				stroke 'black'
			else 
				noStroke()
			circle x,100,size
			fill if i == index then 'red' else 'black'
			t = round 100 * (1 - expected_score @elo, p.elo)
			if t == 100 then t = "00"
			noStroke()
			text t,x,100+1

	summa : (ids) ->
		res = 0
		for id in ids
			elo = players[id].elo
			res += 1 - expected_score @elo, elo
		res.toFixed 2

	draw : ->

		@dots 20

		push()
		textSize 18
		@lines @fairpairID,60,70,90
		@lines @swissID,140,130,110
		pop()

setup = ->
	createCanvas window.innerWidth-5, 320
	rectMode CENTER
	textSize 30
	textAlign CENTER,CENTER

	players.push new Player 1, 'Hampus Sörensen',            2416, [53,24, 8,16,15,14, 2, 5], [2,3,4,6,5,7,11,8]
	players.push new Player 2, 'Michael Wiedenkeller',       2413, [71,36,70,61, 8,15,14, 2], [1,4,3,5,6,9,7,12]
	players.push new Player 3, 'Joar Ölund',                 2366, [62,50,28, 6,14, 5, 1, 4], [4,1,2,10,7,5,6,11]
	players.push new Player 4, 'Joar Östlund',               2335, [37,45,21, 9,62,40,17,20], [3,2,1,7,9,6,5,15]
	players.push new Player 5, 'Vidar Grahn',                2272, [21,19,46,54,28,18,16,11], [6,7,8,2,1,3,4,10]
	players.push new Player 6, 'Leo Cravatin',               2235, [39,17,25,22, 9, 2,23, 1], [5,8,7,1,2,4,3,9]
	players.push new Player 7, 'Daniel Vesterbaek Pedersen', 2213, [57,18,29,11, 1, 4,25, 7], [8,5,6,4,3,1,2,16]
	players.push new Player 8, 'Victor Muntean',             2141, [48,25,17,12, 5,28,11,29], [7,6,5,9,10,11,12,1]
	players.push new Player 9, 'Filip Björkman',             2113, [64,27,36, 7, 2, 1, 4, 6], [10,11,12,8,4,2,13,6]
	players.push new Player 10, 'Vidar Seiger',              2109, [46,52,60,56,13,38, 5,24], [9,12,11,3,8,13,14,5]
	players.push new Player 11, 'Pratyush Tripathi',         2108, [10,40,34, 1,19,11, 3,17], [12,9,10,14,13,8,1,3]
	players.push new Player 12, 'Erik Dingertz',             2093, [58,35,30, 2,10,17,34,14], [11,10,9,13,14,15,8,2]
	players.push new Player 13, 'Michael Duke',              2076, [60,61,19,15,35,16, 9, 3], [14,15,16,12,11,10,9,17]
	players.push new Player 14, 'Matija Sakic',              2065, [44,34,37,30,33,10,32,12], [13,16,15,11,12,17,10,19]
	players.push new Player 15, 'Michael Mattsson',          2048, [75,41,52,14,38,29,18,15], [16,13,14,18,17,12,19,4]
	players.push new Player 16, 'Lukas Willstedt',           2046, [47,30,10,75,70,33,38,40], [15,14,13,17,18,19,20,7]
	players.push new Player 17, 'Lavinia Valcu',             2039, [31,54,42, 5,18,35,29,34], [18,19,20,16,15,14,21,13]
	players.push new Player 18, 'Oliver Nilsson',            2035, [51,37, 1,34, 4,21,10,30], [17,20,19,15,16,21,23,22]
	players.push new Player 19, 'Lennart Evertsson',         2031, [56,33, 2,53, 3, 9,39,10], [20,17,18,22,21,16,15,14]
	players.push new Player 20, 'Jussi Jakenberg',           2022, [45,73,15,33,30, 7,22, 9], [19,18,17,21,22,23,16,24]
	players.push new Player 21, 'Aryan Banerjee',            2001, [59, 4,14,10,53,34,62,13], [22,23,24,20,19,18,17,25]
	players.push new Player 22, 'Tim Nordenfur',             1985, [74, 1,44,47,37,39,43,23], [21,24,23,19,20,25,26,18]
	players.push new Player 23, 'Elias Kingsley',            1977, [67, 5, 9,70,31, 6,12,16], [24,21,22,26,25,20,18,27]
	players.push new Player 24, 'Per Isaksson',              1954, [38, 2,75,31,64,60,13,21], [23,22,21,25,26,27,28,20]
	players.push new Player 25, 'Cristine Rose Mariano',     1944, [77, 9, 5,63,56,41,15,35], [26,27,28,24,23,22,29,21]
	players.push new Player 26, 'Lo Ljungros',               1936, [76, 3,11,44,16,31,35,41], [25,28,27,23,24,29,22,30]
	players.push new Player 27, 'Herman Enholm',             1923, [70,42,57,43,23,51,50,36], [28,25,26,30,29,24,31,23]
	players.push new Player 28, 'Carina Wickström',          1907, [68,15,47,51,22, 3, 7,37], [27,26,25,29,30,31,24,32]
	players.push new Player 29, 'Joel Åhlfeldt',             1897, [72,14,51,45,21,58,53,48], [30,31,32,28,27,26,25,33]
	players.push new Player 30, 'Stefan Nyberg',             1896, [42,43,31,46,59,48,20,33], [29,32,31,27,28,33,34,26]
	players.push new Player 31, 'Hans Rånby',                1893, [63,16,56,60,42,12,57,26], [32,29,30,34,33,28,27,35]
	players.push new Player 32, 'Mikael Blom',               1889, [79,23, 7,38,39,44,37,58], [31,30,29,33,34,35,36,28]
	players.push new Player 33, 'Joar Berglund',             1886, [69, 6,59,42,11,22,19,25], [34,35,36,32,31,30,37,29]
	players.push new Player 34, 'Mikael Helin',              1885, [80,11,67, 4,48,47,21,44], [33,36,35,31,32,37,30,38]
	players.push new Player 35, 'Olle Ålgars',               1880, [55,20,16, 8,63,36, 6,22], [36,33,34,38,37,32,39,31]
	players.push new Player 36, 'Jesper Borin',              1878, [78, 7,38,74,44,25,49,19], [35,34,33,37,38,39,32,40]
	players.push new Player 37, 'Khaschuluu Sergelenbaatar', 1871, [81,26, 6,20,29,64,31, 8], [38,39,40,36,35,34,33,41]
	players.push new Player 38, 'Roy Karlsson',              1852, [49,22,73, 3,51,43,45,72], [37,40,39,35,36,41,42,34]
	players.push new Player 39, 'Fredrik Möllerström',       1848, [43,70,63,59,76,56,48,42], [40,37,38,42,41,36,35,43]
	players.push new Player 40, 'Kenneth Fahlberg',          1846, [65,28,72,29,20,26,63,32], [39,38,37,41,42,43,44,36]
	players.push new Player 41, 'Peder Gedda',               1835, [ 1,74, 7,38,39,44,37,58], [42,43,44,40,39,38,45,37]
	players.push new Player 42, 'Karam Masoudi',             1833, [ 4,56,77,57,43,79,59,60], [41,44,43,39,40,45,38,46]
	players.push new Player 43, 'Christer Johansson',        1828, [ 2,38,76,72,12,67,36,47], [44,41,42,46,45,40,47,39]
	players.push new Player 44, 'Anders Kallin',             1827, [12, 8,20,73,24,77,52,18], [43,42,41,45,46,47,40,48]
	players.push new Player 45, 'Morris Bergqvist',          1818, [ 3,76,12,55,27, 8,61,50], [46,47,48,44,43,42,41,49]
	players.push new Player 46, 'Martti Hamina',             1803, [ 5,59,79,49,52,24,28,38], [45,48,47,43,44,49,50,42]
	players.push new Player 47, 'Björn Lövström',            1800, [15,68,13,71,72,42,40,51], [48,45,46,50,49,44,43,52]
	players.push new Player 48, 'Nicholas Bychkov Zwahlen',  1796, [ 9,67,69,65,61,32,66,27], [47,46,45,49,50,51,53,44]
	players.push new Player 49, 'Jonas Sandberg',            1794, [14,72,80,67,50,30,51,49], [50,51,52,48,47,46,54,45]
	players.push new Player 50, 'Rohan Gore',                1793, [16,77,26,36, 6,20, 8,28], [49,52,51,47,48,53,46,55]
	players.push new Player 51, 'Kjell Jernselius',          1787, [23,79, 3,32,68,49,74,63], [52,49,50,54,53,48,56,57]
	players.push new Player 52, 'Radu Cernea',               1783, [ 6,63,55,69,73,27,77,52], [51,50,49,53,54,56,55,47]
	players.push new Player 53, 'Mukhtar Jamshedi',          1778, [11,80,23,40,75,50,55,71], [54,55,56,52,51,50,48,59]
	players.push new Player 54, 'Neo Malmquist',             1768, [20,69,24,19,41,52,73,61], [53,56,55,51,52,57,49,58]
	players.push new Player 55, 'Joacim Hultin',             1763, [ 7,78,50,26,60,63,79,65], [56,53,54,57,58,61,52,50]
	players.push new Player 56, 'Lars-Åke Pettersson',       1761, [26,55,18,24,79,61,65,62], [55,54,53,59,57,52,51,60]
	players.push new Player 57, 'Andre Lindebaum',           1748, [22,49,32,50,17,19,30,55], [59,58,62,55,56,54,60,51]
	players.push new Player 58, 'Lars Eriksson',             1733, [ 8,81,27,18,54,13,64,57], [60,57,59,62,55,64,61,54]
	players.push new Player 59, 'Hugo Hardwick',             1733, [28,71,40,23,25,66,67,53], [57,61,58,56,60,62,63,53]
	players.push new Player 60, 'Hugo Sundell',              1728, [29,12,78,27,55,76,54,43], [58,62,61,65,59,63,57,56]
	players.push new Player 61, 'Simon Johansson',           1726, [36,39,35,66,32,53,71,74], [62,59,60,63,64,55,58,66]
	players.push new Player 62, 'Jouni Kaunonen',            1721, [24,53,81,41,49,78,46,59], [61,60,57,58,63,59,64,67]
	players.push new Player 63, 'Eddie Parteg',              1709, [17,48,61,64,65,62,56,73], [64,65,68,61,62,60,59,70]
	players.push new Player 64, 'Sid Van Den Brink',         1695, [25,10,71,68,81,37,58,82], [63,67,65,66,61,58,62,69]
	players.push new Player 65, 'Svante Nödtveit',           1691, [50,62,41,52, 7,23,26,39], [66,63,64,60,67,70,69,68]
	players.push new Player 66, 'Anders Hillbur',            1688, [19,21,62,78,66,45,81,69], [65,68,67,64,69,72,70,61]
	players.push new Player 67, 'Sayak Raj Bardhan',         1680, [82,29,54,37,58,81,44,67], [68,64,66,70,65,69,71,62]
	players.push new Player 68, 'Salar Banavi',              1671, [13,66, 4,17,26,55,42,80], [67,66,63,69,70,71,72,65]
	players.push new Player 69, 'Patrik Wiss',               1650, [18,57,43,77,46,65,78,79], [70,71,72,68,66,67,65,64]
	players.push new Player 70, 'Anton Nordefur',            1641, [32,13,22,35,40,57,70,66], [69,72,71,67,68,65,66,63]
	players.push new Player 71, 'Jens Ahlström',             1624, [27,64,33,62,57,69,80,54], [72,69,70,74,73,68,67,79]
	players.push new Player 72, 'Hanns Ivar Uniyal',         1622, [40,58,66,25,34,75,33,46], [71,70,69,73,74,66,68,77]
	players.push new Player 73, 'Christer Carmegren',        1579, [52,46,39,80,47,71,75,68], [74,75,76,72,71,80,78,82]
	players.push new Player 74, 'Christer Nilsson',          1575, [35,44,48,58,80,72,82,76], [73,76,75,71,72,78,79,81]
	players.push new Player 75, 'Måns Nödtveidt',            1524, [61,60,64,79,69,82,72,70], [76,73,74,77,81,79,82,80]
	players.push new Player 76, 'Karl-Oskar Rehnberg',       1480, [36,47,58,21,45,70,60,31], [75,74,73,82,77,81,80,78]
	players.push new Player 77, 'David Broman',              1417, [41,75,45,76,82,74,68,81], [78,80,79,75,76,82,81,72]
	players.push new Player 78, 'Vida Radon',                1406, [30,51,74,82,77,73,76,78], [77,79,81,80,82,74,73,76]
	players.push new Player 79, 'Maxime De Lafonteyne',      1400, [66,32,68,13,71,54,24,45], [82,78,77,81,80,75,74,71]
	players.push new Player 80, 'Ivar Arnshav',              1400, [54,31,82,39,74,46,41,64], [81,77,82,78,79,73,76,75]
	players.push new Player 81, 'Kristoffer Schultz',        1400, [33,82,53,48,67,68,47,75], [80,82,78,79,75,76,77,74]
	players.push new Player 82, 'BYE',                          0, [67,81,80,78,77,75,74,64], [79,81,80,76,78,77,75,73]

	n = players.length
	for player in players
		if player == null then continue
		player.makeLists()

	index = 0
	currIndex = index
	player = players[index]
	xdraw()

expected_score = (rating, own_rating) -> 1 / (1 + 10**((rating - own_rating) / 400))

xdraw = ->
	background 'yellow'
	stroke 'black'
	line 0,100,width,100

	player.draw()

	textSize 30

	fill 'black'
	noStroke()
	text "FairPair #{player.summa player.fairpairID}",width/2,35
	text "Swiss #{player.summa player.swissID}", width/2, 180
	fill 'red'
	text "#{player.elo} #{player.name}",width/2,220
	fill 'black'
	text "#{players[currIndex].elo} #{players[currIndex].name}",  width/2, 260
	text "Tyresö Open 2024 (n=#{n})",width/2,300

document.addEventListener 'keydown', (event) -> 
	# Hanterar alla tangenttryckningar och REPETERAR till skillnad från p5 keyDown
	echo event.key
	if event.key == 'ArrowUp'
		index = (index - 1) %% n
		player = players[index]
		currIndex = index 
	if event.key == 'ArrowDown'
		index = (index + 1) %% n
		player = players[index]
		currIndex = index
	if event.key == 'ArrowLeft' then currIndex = (currIndex - 1) %% n
	if event.key == 'ArrowRight' then currIndex = (currIndex + 1) %% n
	if event.key == 't' then window.location.href = "https://member.schack.se/ShowTournamentServlet?id=13664&listingtype=2"
	xdraw()
