echo = console.log

elos = [2416,2413,2366,2335,2272,2235,2141,2113,,2109,2108,2093,2076,2065,2048,2046,2039,2035,2031,2022,2001,1985,1977,1954,1944,1936,1923,1907,1897,1896,1893,1889,1886,1885,1880,1878,1871,1852,1848,1846,1835,1833,1828,1827,1818,1803,1800,1796,1794,1793,1787,1783,1778,1768,1763,1761,1748,1733,1733,1728,1726,1721,1709,1695,1691,1688,1680,1671,1650,1641,1622,1579,1575,1524,1480,1417,1406]

LOW = 1400
HIGH = 2420

setup = ->
	createCanvas window.innerWidth, window.innerHeight
	rectMode CENTER
	textSize 30
	textAlign CENTER
	xdraw()

paint = (elos,color,size) ->
	fill color
	stroke color
	for elo in elos
		x = map elo, LOW, HIGH, 0, width
		circle x,100,size

lines = (elos,y) ->
	stroke 'black'
	strokeWeight 1
	for elo in elos
		x = map elo, LOW,HIGH, 0, width
		line x,100,x,y

expected_score = (rating, own_rating) -> 1 / (1 + 10**((rating - own_rating) / 400))

mark = (elo, t, y) ->
	x = map elo, LOW,HIGH, 0, width
	fill 'black'
	noStroke()
	text t,x,y

xdraw = ->
	background 'white'
	stroke 'black'

	line 0,100,width,100

	paint elos, 'black',4
	paint [1893],'red',6

	lines [2335,2108,2046,1800,1778,1733,1641,1622],120
	lines [1907,1897,1896,1889,1886,1885,1880,1878],80

	textSize 20
	mark 1622,"83%",140
	mark 1800,"63%",140
	mark 1878,"52%",75
	mark 1907,"48%",75
	mark 2046,"29%",140
	mark 2335,"7%",140
		
	fill 'black'
	stroke 'black'
	
mouseMoved = ->
	xdraw()

	noStroke()

	text 'FairPair vs Swiss',width/2,35

	elo = map mouseX, 0, width, LOW,HIGH
	text int(elo),width/2,140

	text 'Sannolik vinst ' + round(100*(1 - expected_score(1893,elo)))+'%',  width/2, 140+40
	text 'Tyresö Open 2024 (n=78)',width/2,140+80

mousePressed = ->
	window.location.href = "https://member.schack.se/ShowTournamentServlet?id=13664&listingtype=2"