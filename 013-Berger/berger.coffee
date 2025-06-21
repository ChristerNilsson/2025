import {Player} from './player.js'
import {FairPair} from './fairpair.js'
import {bergerText, fairpairText, helpText} from './texts.js'
import {performance} from './rating.js'
import {table,thead,th,tr,td,a,div,pre,p,h2} from './html.js'

echo = console.log
range = _.range

DOMAIN_LOCAL = "http://127.0.0.1:5500"
DOMAIN_GLOBAL = "https://christernilsson.github.io/2025/013-Berger"

TITLE = 'Bergerturnering'
GAMES = 2
RESULTS = '012'
TYPE = 'Berger'
R = 0

alignLeft   = {style: "text-align:left"}
alignCenter = {style: "text-align:center"}
alignRight  = {style: "text-align:right"}

players = []
rounds = [] # vem möter vem? [w,b]
results = [] # ['012xx', '22210'] Vitspelarnas resultat i varje rond

display = 3 # both

sorteringsOrdning = {}	# Spara per kolumn

findNumberOfDecimals = (lst) ->
	best = 0
	for i in range 6
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
	for person in persons
		elo = parseInt person.slice 0,4
		name = person.slice(4).trim()
		players.push new Player players.length, name, elo

	R = parseInt safeGet params, "R", players.length-1

	results = []
	for i in range R
		results.push safeGet params, "r#{i+1}", "x".repeat players.length / 2

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
	fairpair = new FairPair players, R, GAMES

	echo "" 

	for i in range players.length
		line = fairpair.matrix[i]
		echo i%10 + '   ' + line.join('   ') + '  ' + players[i].elo

	echo 'summa', fairpair.summa
	fairpair.rounds	


showHelp = ->

	result = div {},
		div {class:"help"}, pre {}, helpText
		p {}, a {href: DOMAIN_GLOBAL + bergerText},'Berger'
		p {}, a {href: DOMAIN_LOCAL + bergerText},'Berger dev'
		div {class:"help"}, pre {}, bergerText
		p {}, a {href: DOMAIN_GLOBAL + fairpairText},'FairPair'
		p {}, a {href: DOMAIN_LOCAL + fairpairText},'FairPair dev'
		div {class:"help"}, pre {}, fairpairText

	document.getElementById('berger').innerHTML = result

roundsContent = (points, i) -> # rondernas data + poäng + PR

	ronder = []

	oppElos = []
	pointsPR = 0

	for r in range rounds.length

		tableIndex = rounds[r].findIndex(([w, b]) -> w == i or b == i)
		if tableIndex == -1 then continue
		result = results[r]?[tableIndex]

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

		if i == w then attr = "right:0px;" else attr = "left:0px;"
		cell = td {style: "position:relative;"},
			div {style: "position:absolute; top:0px;" + attr + "font-size:0.7em;"}, opponent + 1
			div {style: "position:absolute; top:12px;           font-size:1.1em;"}, result

		ronder.push cell

	ronder.push	td alignRight, points[i]
	ronder.push td {}, performance pointsPR/(2*GAMES), oppElos
	ronder.join ""

showPlayers = (points) ->

	rows = []

	for player, i in players

		rows.push tr {},
			td {}, i + 1
			td alignLeft, player.name
			td {}, player.elo
			roundsContent points, i

	result = div {},
		h2 {}, TITLE
		table {},
			thead {},
				th {}, "#"
				th {}, "Namn"
				th {}, "Elo"
				(th {}, "#{i+1}" for i in range rounds.length).join ""
				th {}, "P"
				th {}, "PR"
			rows.join ""

	document.getElementById('bergertabell').innerHTML = result

	# Sätt antal decimaler för PR
	tbody = document.querySelector '#bergertabell tbody'
	rader = Array.from tbody.querySelectorAll 'tr'
	lst = (parseFloat rad.children[rad.children.length-1].textContent for rad in rader)
	decimals = findNumberOfDecimals lst
	for rad in rader
		value = parseFloat _.last(rad.children).textContent
		value = if value > 3999 then "" else value.toFixed decimals 
		_.last(rad.children).textContent = value

prettify = (ch) ->
	if ch in RESULTS then return "#{ch} - #{2*GAMES - ch}"
	"-"

showTables = (rounds, selectedRound) ->
	if rounds.length == 0 then return

	rows = ""

	for i in range rounds.length
		[w, b] = rounds[i]
		vit = players[w]?.name or ""
		svart = players[b]?.name or ""

		rows += tr {},
			td {}, i+1
			td alignLeft, vit
			td alignLeft, svart
			td alignCenter, prettify results[selectedRound][i]

	result = div {},
		h2 {}, "Bordslista för rond #{selectedRound+1}"
		table {},
			thead {},
				th {}, "Bord"
				th {}, "Vit"
				th {}, "Svart"
				th {}, "#{RESULTS}"
			rows

	document.getElementById('tables').innerHTML = result

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

	points = Array(players.length).fill(0)

	for i in range results.length
		res = results[i]
		round = rounds[i]
		for j, [w, b] of round
			if res[j] in RESULTS
				points[w] += parseInt res[j]
				points[b] += 2*GAMES - parseInt res[j]

	showPlayers points
	showTables rounds[0] or [], 0

	skapaSorteringsklick()

document.addEventListener 'keyup', (event) ->

	if event.key == '1' then display = 1
	if event.key == '2' then display = 2
	if event.key == '3' then display = 3

	document.getElementById("bergertabell").style.display = if display in [1,3] then "table" else "none"
	document.getElementById("tables").style.display = if display in [2,3] then "table" else "none"

main()
