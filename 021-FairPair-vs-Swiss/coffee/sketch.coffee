echo = console.log

elos = [2416,2413,2366,2335,2272,2235,2213,2141,2113,2109,2108,2093,2076,2065,2048,2046,2039,2035,2031,2022,2001,1985,1977,1954,1944,1936,1923,1907,1897,1896,1893,1889,1886,1885,1880,1878,1871,1852,1848,1846,1835,1833,1828,1827,1818,1803,1800,1796,1794,1793,1787,1783,1778,1768,1763,1761,1748,1733,1733,1728,1726,1721,1709,1695,1691,1688,1680,1671,1650,1641,1624,1622,1579,1575,1524,1480,1417,1406]

LOW = 1400
HIGH = 2420

players = []
player = null
index = 0

class Player 
	constructor : (@name, @elo, @score, @swiss, @fairpair) ->

	lines : (elos, y) ->
		stroke 'black'
		strokeWeight 1
		for elo in elos
			x = map elo, LOW,HIGH, 0, width
			line x,100,x,y

	marks : (elos, y) ->
		for elo in elos
			t = round 100 * (1 - expected_score @elo, elo)
			x = map elo, LOW,HIGH, 0, width
			fill 'black'
			noStroke()
			text t,x,y

	draw : ->

		@lines @fairpair,80
		@marks [@fairpair[0], _.last(@fairpair)],75

		@lines @swiss,120
		@marks @swiss,140

setup = ->
	createCanvas window.innerWidth, window.innerHeight
	rectMode CENTER
	textSize 30
	textAlign CENTER

	players.push new Player 'Rånby', 1893, 4.0, [2335,2108,2046,1800,1778,1733,1641,1622], [1907,1897,1896,1889,1886,1885,1880,1878]
	players.push new Player 'Jakenberg', 2022, 4.5, [1728,1680,2213,1846,1871,2048,2039,2141], [2048,2046,2039,2035,2031,2001,1985,1977]
	players.push new Player 'Sörensen', 2416, 6.5, [1835,1985,2035,2108,2213,2113,2366,2235], [2413,2366,2335,2272,2235,2213,2141,2113]
	players.push new Player 'Gore', 1793, 5.5, [2108,1695,2046,2001,2093,2065,2035,2031], [1803,1800,1796,1794,1787,1783,1778,1768]

	player = players[index]
	index = 0
	xdraw()
	mouseMoved()

paint = (elos,color,size) ->
	fill color
	stroke color
	for elo in elos
		x = map elo, LOW, HIGH, 0, width
		circle x,100,size

expected_score = (rating, own_rating) -> 1 / (1 + 10**((rating - own_rating) / 400))

xdraw = ->
	background 'white'
	stroke 'black'

	line 0,100,width,100

	paint elos, 'black',4
	paint [player.elo],'red',6

	textSize 20

	player.draw()

	fill 'black'
	stroke 'black'
	
mouseMoved = ->
	xdraw()

	noStroke()

	text "FairPair vs Swiss (#{player.name} #{player.elo} #{player.score})",width/2,35

	elo = map mouseX, 0, width, LOW,HIGH
	# text int(elo),width/2,140

	text "#{round(elo)} Sannolik vinst #{round(100*(1 - expected_score(player.elo,elo)))}%",  width/2, 140+40
	text 'Tyresö Open 2024 (n=78)',width/2,140+80

keyPressed = (event) ->
	if event.key == ' ' 
		index = (index + 1) % players.length
		player = players[index]
	if event.key == 't' then window.location.href = "https://member.schack.se/ShowTournamentServlet?id=13664&listingtype=2"
	mouseMoved()
