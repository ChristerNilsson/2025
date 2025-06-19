import {Player} from './player.js'
import {FairPair} from './fairpair.js'

echo = console.log
range = _.range

DOMAIN_LOCAL = "http://127.0.0.1:5500"
DOMAIN_GLOBAL = "https://christernilsson.github.io/2025/013-Berger"

TITLE = 'Bergerturnering'
GAMES = 2
RESULTS = '012'
TYPE = 'Berger'
R = 0

players = []
rounds = [] # vem möter vem? [w,b]
results = [] # ['012xx', '22210'] Vitspelarnas resultat i varje rond

sorteringsOrdning = {}	# Spara per kolumn

findNumberOfDecimals = (lst) ->
	best = 0
	for i in [0..6]
		unik = _.uniq (item.toFixed(i) for item in lst)
		if unik.length > best then [best,ibest] = [unik.length,i]
	ibest

skapaSorteringsklick = ->

	ths = document.querySelectorAll '#bergertabell th'

	#echo ths
	index = -1
	for th in ths
		index += 1
		do (th,index) ->
			th.addEventListener 'click', (event) ->
				key = th.textContent
				if !isNaN parseInt key
					key = parseInt(key) - 1 
					showTables rounds[key] or [], key
					return

				tbody = document.querySelector '#bergertabell tbody'
				rader = Array.from tbody.querySelectorAll 'tr'
				stigande = key in "# Namn".split ' '

				rader.sort (a, b) ->
					cellA = a.children[index].textContent.trim()
					cellB = b.children[index].textContent.trim()

					# Försök jämföra som tal, annars som text
					numA = parseInt cellA
					numB = parseInt cellB
					if !isNaN(numA) and !isNaN(numB)
						return if stigande then numA - numB else numB - numA
					else
						return if stigande then cellA.localeCompare cellB else cellB.localeCompare cellA

				# Lägg tillbaka raderna i sorterad ordning
				for rad in rader
					tbody.appendChild rad

summa = (arr) ->
	res = 0
	for item in arr
		res += item
	res

expected_score = (ratings, own_rating) -> summa (1 / (1 + 10**((rating - own_rating) / 400)) for rating in ratings)

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
 
# Use two extreme values when calculating 0% or 100%
extrapolate = (a0, b0, elos) ->
	a = performance_rating a0,elos
	b = performance_rating b0,elos
	b + b - a

performance = (pp,elos) -> 
	n = elos.length
	if n == 1
		if pp == 0 then return extrapolate 0.50,0.25,elos
		if pp == n then return extrapolate 0.50,0.75,elos
	else
		if pp == 0 then return extrapolate   1,  0.5,elos
		if pp == n then return extrapolate n-1,n-0.5,elos
	performance_rating pp,elos

safeGet = (params,key,standard="") -> 
	if params.get key then return params.get key 
	if params.get ' ' + key then return params.get ' ' + key
	standard

parseQuery = ->
	params = new URLSearchParams window.location.search

	TITLE = safeGet params, "TITLE"
	GAMES = parseInt safeGet params, "GAMES", "1"
	RESULTS = '012345678'.slice 0, 2 * GAMES + 1
	TYPE = safeGet params, "TYPE", 'Berger'
	
	players = []
	persons = params.getAll "p"
	persons.sort().reverse()
	for p in persons
		elo = parseInt p.slice 0,4
		name = p.slice(4).trim()
		players.push new Player players.length, name, elo

	R = parseInt safeGet params, "R", players.length-1
	echo 'R',R

	results = []
	echo 'R',R
	for i in range R
		results.push safeGet params, "r#{i+1}", "x".repeat players.length / 2
	echo results

savePairing = (r, A, half, n) ->
	lst = if r % 2 == 1 then [[A[n - 1], A[0]]] else [[A[0], A[n - 1]]]
	for i in [1...half]
		lst.push [A[i], A[n - 1 - i]]
	lst

makeBerger = ->
	n = players.length
	if n % 2 == 1 then n += 1
	half = n // 2 
	A = [0...n]
	rounds = []
	for i in [0...n-1]
		rounds.push(savePairing(i, A, half, n))
		A.pop()
		A = A.slice(half).concat A.slice(0,half)
		A.push(n-1)
	rounds

makeFairPair = ->
	echo 'R',R
	fairpair = new FairPair players, R

	for p in fairpair.players
		echo p.opp,p.col,p.balans()

	echo "" 

	for i in range players.length
		line = fairpair.matrix[i]
		echo i%10 + '   ' + line.join('   ') + '  ' + players[i].elo

	echo 'summa', fairpair.summa
	echo fairpair.rounds
	fairpair.rounds	

showHelp = ->
	a = (s) -> url.push s
	bergerText = """?TITLE=Berger
	&GAMES=1
	&TYPE=Berger
	&R=9

	&p=1698 Onni Aikio
	&p=1558 Helge Bergström
	&p=1549 Jonas Hök
	&p=1679 Lars Johansson
	&p=0000 Per Eriksson
	&p=1653 Christer Nilsson
	&p=1673 Per Hamnström
	&p=1504 Thomas Paulin
	&p=1706 Abbas Razavi
	&p=1579 Jouko Liistamo

	&r1=01201
	&r2=01201
	&r3=01201
	&r4=01201
	&r5=11111
	&r6=00000
	&r7=22222
	&r8=01201
	&r9=01201
	"""

	fairpairText = """?TITLE=FairPair
	&GAMES=1
	&TYPE=FairPair
	&R=4

	&p=1698 Onni Aikio
	&p=1558 Helge Bergström
	&p=1549 Jonas Hök
	&p=1679 Lars Johansson
	&p=0000 Per Eriksson
	&p=1653 Christer Nilsson
	&p=1673 Per Hamnström
	&p=1504 Thomas Paulin
	&p=1706 Abbas Razavi
	&p=1579 Jouko Liistamo

	&r1=01201
	&r2=01201
	&r3=01201
	&r4=01201
	"""

	helpText = """<h3>Introduktion</h3>Detta program kan lotta och visa två olika turneringsformat:
	  * Berger (alla möter alla)
	  * FairPair (flytande Berger, typ)

	* Alla ronder lottas i förväg
	* Hanterar upp till fyra partier per rond, t ex dubbelrond eller lagmatch
	* All nödvändig information skickas in som parametrar
	<h3>Interaktioner</h3>* Klick på rond visar bordslistan
	* Klick på annan kolumn sorterar
	* ctrl p skriver ut
	* ctrl + och ctrl - zoomar
	<h3>Parametrar</h3>?TITLE=Sommarturnering 2025
		Anger turneringens namn

	&TYPE=Berger
		Anger Berger eller FairPair

	&GAMES=1
		Anger antal partier per rond. 1 till 4.

	&R=9
		Anger antal ronder (automatisk för Berger)

	&p=1653 Christer Nilsson
		Alla deltagare anges med rating och namn
		Använd 0000 för deltagare utan rating

	&r1=012x0 
		Vitspelarnas resultat för den första ronden, i bordsordning
		GAMES=1:
			0 = Förlust
			1 = Remi
			2 = Vinst

		GAMES=2: 0 till 4 kan användas
		GAMES=3: 0 till 6 kan användas
		GAMES=4: 0 till 8 kan användas
		x = Ej spelat

	"""

	# &p=1698 Onni Aikio
	# &p=1558 Helge Bergström
	# &p=1549 Jonas Hök
	# &p=1679 Lars Johansson
	# &p=0000 Per Eriksson
	# &p=1653 Christer Nilsson
	# &p=1673 Per Hamnström
	# &p=1504 Thomas Paulin
	# &p=1706 Abbas Razavi
	# &p=1579 Jouko Liistamo
	# &p=1798 Aikio
	# &p=1658 Bergström
	# &p=1649 Hök
	# &p=1779 Johansson
	# &p=0000 Eriksson
	# &p=1753 Nilsson
	# &p=1773 Hamnström
	# &p=1604 Paulin
	# &p=1806 Razavi
	# &p=1679 Liistamo

	# &r1=0120120120
	# &r2=0120120120
	# &r3=0120120120
	# &r4=0120120120
	# &r5=0120120120
	# &r6=0120120120
	# &r7=0120120120

	help = document.createElement 'div'
	help.className = 'help'
	help.innerHTML = "<pre>#{helpText}</pre>"
	document.getElementById('berger').appendChild help

	link = document.createElement 'a'
	link.href = DOMAIN_GLOBAL + bergerText
	link.text = "Berger"
	divnode = document.getElementById('berger').appendChild document.createElement 'p'
	divnode.appendChild link

	link = document.createElement 'a'
	link.href = DOMAIN_LOCAL + bergerText
	link.text = "Berger dev"
	divnode = document.getElementById('berger').appendChild document.createElement 'p' 
	divnode.appendChild link

	exempel = document.createElement 'div'
	exempel.className = 'help'
	exempel.innerHTML = "<pre>#{bergerText}</pre>"
	divnode = document.getElementById('berger').appendChild document.createElement 'p'
	divnode.appendChild exempel

	link = document.createElement 'a'
	link.href = DOMAIN_GLOBAL + fairpairText
	link.text = "FairPair"
	divnode = document.getElementById('berger').appendChild document.createElement 'p'
	divnode.appendChild link

	link = document.createElement 'a'
	link.href = DOMAIN_LOCAL + fairpairText
	link.text = "FairPair dev"
	divnode = document.getElementById('berger').appendChild document.createElement 'p'
	divnode.appendChild link

	exempel = document.createElement 'div'
	exempel.className = 'help'
	exempel.innerHTML = "<pre>#{fairpairText}</pre>"
	divnode = document.getElementById('berger').appendChild document.createElement 'p'
	divnode.appendChild exempel

showPlayers = (points) ->

	echo rounds

	h2 =  document.createElement 'h2'
	h2.textContent = TITLE
	document.getElementById('berger').appendChild h2

	tbl = document.getElementById('bergertabell')

	thead = document.createElement 'thead'
	tbl.appendChild thead
	echo tbl

	th = document.createElement 'th'
	th.textContent = "#"
	thead.appendChild th

	th = document.createElement 'th'
	th.textContent = "Namn"
	thead.appendChild th

	th = document.createElement 'th'
	th.textContent = "Elo"
	thead.appendChild th

	for i in [0...rounds.length]
		th = document.createElement 'th'
		th.textContent = "#{i+1}"
		thead.appendChild th

	th = document.createElement 'th'
	th.textContent = "Poäng"
	thead.appendChild th

	th = document.createElement 'th'
	th.textContent = "PR"
	thead.appendChild th

	for p, i in players
		row = tbl.insertRow()
		row.insertCell().textContent = i + 1

		cell = row.insertCell()
		cell.textContent = p.name
		cell.style.textAlign = 'left'

		oppElos = []
		pointsPR = 0
		row.insertCell().textContent = p.elo

		for r in range rounds.length
			cell = row.insertCell()
			tableIndex = rounds[r].findIndex(([w, b]) -> w == i or b == i)
			if tableIndex == -1 then continue
			result = results[r]?[tableIndex] # or ""
			#result = result.replace "x", ""

			[w, b] = rounds[r][tableIndex]
			opponent = if w == i then b else w

			if result in RESULTS
				if w == i
					result = parseInt result 
				else
					result = 2 * GAMES - parseInt result 

				if result.toString() in RESULTS and players[opponent].elo != 0
					oppElos.push players[opponent].elo
					pointsPR += parseInt result
			else
				result = ""
				# if i == b and result != "" then result = 2 * GAMES - parseInt result

			if i == w then a = "right:-7px" else a = "left:-7px"

			html = ""
			html += "<div style='position:absolute; top:-17px; #{a}; font-size:0.7em;'>#{opponent + 1}</div>"
			html += "<div style='position:absolute; top:-4px;        font-size:1.0em;'>#{result}</div>"
			cell.innerHTML = "<div style='position:relative;'>" + html + "</div>"

		echo i,oppElos,pointsPR,p.name
		cell = row.insertCell()
		cell.textContent = points[i]
		cell.style.textAlign = 'right'
		row.insertCell().textContent = performance pointsPR/(2*GAMES), oppElos

	# Sätt antal decimaler för PR
	tbody = document.querySelector '#bergertabell tbody'
	rader = Array.from tbody.querySelectorAll 'tr'
	lst = (parseFloat rad.children[rad.children.length-1].textContent for rad in rader)
	decimals = findNumberOfDecimals lst
	for rad in rader
		_.last(rad.children).textContent = parseFloat(_.last(rad.children).textContent).toFixed decimals

prettify = (ch) ->
	if ch in RESULTS then return "#{ch} - #{2*GAMES - ch}"
	"-"

showTables = (rounds, selectedRound) ->
	if rounds.length == 0 then return

	title = document.createElement 'h2'
	title.textContent = "Bordslista för rond #{selectedRound+1}"
	document.getElementById('tables').innerHTML = ''
	document.getElementById('tables').appendChild title

	table = document.createElement 'table'
	table.id = 'bordtabell'

	header = table.insertRow()
	header.innerHTML = "<th>Bord</th><th>Vit</th><th>Svart</th><th>#{RESULTS}</th>"

	for i in range rounds.length
		tr = document.createElement 'tr'
		[w, b] = rounds[i]
		vit = players[w]?.name or ""
		svart = players[b]?.name or ""

		td = document.createElement 'td'
		td.textContent = "#{i + 1}"
		tr.appendChild td

		td = document.createElement 'td'
		td.textContent = vit
		td.style.textAlign = 'left'
		tr.appendChild td

		td = document.createElement 'td'
		td.textContent = svart
		td.style.textAlign = 'left'
		tr.appendChild td

		td = document.createElement 'td'
		td.textContent = prettify results[selectedRound][i]
		td.style.align = 'center'
		tr.appendChild td

		table.appendChild tr
	document.getElementById('tables').appendChild table

main = ->
	parseQuery()
	document.title = TITLE

	if players.length < 4
		showHelp()
		return

	if TYPE == 'Berger'
		R = players.length-1
		rounds = makeBerger()
	else 
		rounds = makeFairPair()

	echo rounds
	points = Array(players.length).fill(0)

	echo 'results',results
	for i in range results.length
		res = results[i]
		round = rounds[i]
		for j, [w, b] of round
			if res[j] in RESULTS
				points[w] += parseInt res[j]
				points[b] += 2*GAMES - parseInt res[j]

	echo 'points',points

	showPlayers points
	showTables rounds[0] or [], 0

	skapaSorteringsklick()

main()
