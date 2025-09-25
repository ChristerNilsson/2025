# Har man någon nytta av att summera förväntade vinster?

echo = console.log
range = _.range

ELOS = [2416,2413,2366,2335,2272,2235,2213,2141,2113,2109,2108,2093,2076,2065,2048,2046,2039,2035,2031,2022,2001,1985,1977,1954,1944,1936,1923,1907,1897,1896,1893,1889,1886,1885,1880,1878,1871,1852,1848,1846,1835,1833,1828,1827,1818,1803,1800,1796,1794,1793,1787,1783,1778,1768,1763,1761,1748,1734,1733,1728,1726,1721,1709,1695,1691,1688,1680,1671,1650,1641,1624,1622,1579,1575,1524,1480,1417,1406]
n = ELOS.length

players = []
player = null
index = 0

currIndex = -1

class Player 
	constructor : (@name, @elo, @score, @swiss, @fairpair) ->

	lines : (elos, y0, y1, y2) ->
		strokeWeight 1
		fill 'black'
		for r in range elos.length
			elo = elos[r]
			i = ELOS.indexOf elo
			x = map i, -1,n, 0,width
			stroke 'black'
			line x,y1,x,y2
			noStroke()
			text r+1,x,y0

	dots : (elos,color,size) ->
		textSize 14
		noStroke()
		for elo in elos
			i = ELOS.indexOf elo
			x = map i, -1, n, 0, width
			fill 'white'
			if i == currIndex 
				stroke 'black' 
			else 
				noStroke()
			circle x,100,size
			if elo == @elo 
				fill 'red'
			else
				fill 'black'
			t = round 100 * (1 - expected_score @elo, elo)
			noStroke()
			text t,x,100+1

	summa : (elos) ->
		res = 0
		for elo in elos
			res += 1 - expected_score @elo, elo
		res.toFixed 2

	draw : ->

		@dots ELOS,'black',20

		push()
		textSize 18
		@lines @fairpair,60,70,90
		@lines @swiss,140,130,110
		pop()

setup = ->
	createCanvas window.innerWidth-5, 320
	rectMode CENTER
	textSize 30
	textAlign CENTER,CENTER

	players.push new Player 'Sörensen',  2416, '6.5', [1835,1985,2035,2108,2213,2113,2366,2235], [2413,2366,2335,2235,2272,2213,2141,2113]
	players.push new Player 'Valcu',     2039, '5.0', [1748,1852,1641,2235,1907,1886,2022,1880], [2035,2031,2022,2046,2048,2065,2108,1977]
	players.push new Player 'Jakenberg', 2022, '4.5', [1728,1680,2213,1846,1871,2048,2039,2141], [2031,2035,2039,2001,1985,1977,2046,1954]
	players.push new Player 'Rånby',     1893, '4.0', [1622,2108,1733,1778,1641,2335,1800,2046], [1889,1897,1896,1885,1886,1907,1880,1923]
	players.push new Player 'Gore',      1793, '5.5', [2108,1695,2046,2001,2093,2065,2035,2031], [1794,1783,1787,1800,1796,1778,1803,1748]
	players.push new Player 'Radon',     1406, '0.0', [1871,1733,1721,1695,1680,1688,1417     ], [1417,1480,1524,1579,1575,1624,1650,1680]

	player = players[index]
	index = 0
	currIndex = ELOS.indexOf player.elo
	xdraw()

expected_score = (rating, own_rating) -> 1 / (1 + 10**((rating - own_rating) / 400))

xdraw = ->
	echo 'draw'
	background 'yellow'
	stroke 'black'
	line 0,100,width,100

	player.draw()

	textSize 30

	fill 'black'
	noStroke()
	text "FairPair #{player.summa player.fairpair}",width/2,35
	elo = ELOS[currIndex]
	text "Swiss #{player.summa player.swiss}", width/2, 180
	text "#{player.name} #{player.elo} #{player.score}",width/2,220
	text "#{elo}",  width/2, 260
	text "Tyresö Open 2024 (n=#{n})",width/2,300
	
keyPressed = (event) ->
	echo event.key
	if event.key == 'ArrowUp'
		index = (index - 1) %% players.length
		player = players[index]
		currIndex = ELOS.indexOf player.elo
	if event.key == 'ArrowDown'
		index = (index + 1) %% players.length
		player = players[index]
		currIndex = ELOS.indexOf player.elo
	if event.key == 'ArrowLeft' then currIndex = (currIndex - 1) %% n
	if event.key == 'ArrowRight' then currIndex = (currIndex + 1) %% n
	if event.key == 't' then window.location.href = "https://member.schack.se/ShowTournamentServlet?id=13664&listingtype=2"
	xdraw()
