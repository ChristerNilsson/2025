import {Player} from './player.js'
import {FairPair} from './fairpair.js'
import {helpText} from './texts.js'
import {performance} from './rating.js'
import {table,thead,th,tr,td,a,div,pre,p,h2} from './html.js'

echo = console.log
range = _.range

TITLE = ''
GAMES = 0
ROUNDS = 0

RESULTS = ''

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

	ths = document.querySelectorAll '#stallning th'

	#echo ths
	index = -1
	for _th in ths
		index += 1
		do (_th,index) ->
			_th.addEventListener 'click', (event) ->
				key = _th.textContent
				if !isNaN parseInt key
					key = parseInt(key) - 1 
					showTables rounds[key] or [], key
					return

				tbody = document.querySelector '#stallning tbody'
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
	if params.get key then return params.get(key).trim()
	if params.get ' ' + key then return params.get(' ' + key).trim()
	standard

parseQuery = ->
	echo window.location.search
	params = new URLSearchParams window.location.search

	TITLE = safeGet params, "TITLE"
	GAMES = parseInt safeGet params, "GAMES", "1"
	RESULTS = '012345678'.slice 0, 2 * GAMES + 1
	# TYPE = safeGet params, "TYPE", 'Berger'
	players = []
	persons = params.getAll "p"
	persons.sort().reverse()
	for person in persons
		elo = parseInt person.slice 0,4
		name = person.slice(4).trim()
		echo elo,name
		players.push new Player players.length, name, elo

	ROUNDS = parseInt safeGet params, "ROUNDS", players.length-1
	echo {TITLE,GAMES,ROUNDS}
	N = players.length
	LOG2 = Math.ceil Math.log2 N
	if ROUNDS == N-1 then # Berger
	else if ROUNDS < LOG2 then alert "Too few ROUNDS! Minimum is #{LOG2}"
	else if ROUNDS >= N then alert "Too many ROUNDS! Maximum is #{N-1}"

	results = []
	for i in range ROUNDS
		results.push safeGet params, "r#{i+1}", "x".repeat players.length / 2

parseTextarea = ->
	echo 'parseTextArea'
	raw = document.getElementById "textarea"
	echo raw.value

	lines = raw.value
	lines = lines.split "\n"

	for line in lines 
		if line == "" then continue
		if line.includes '='
			[key, val] = line.split '='
			if key == 'TITLE' then TITLE = val
			if key == 'GAMES' then GAMES = val
			if key == 'ROUNDS' then ROUNDS = val
			if key[0] == 'r' then rounds.push val
		else
			players.push line

	url = 'http://127.0.0.1:5501'
	url += "?TITLE=#{TITLE}"
	url += "&GAMES=#{GAMES}"
	url += "&ROUNDS=#{ROUNDS}"
	for player in players
		url += "&p=#{player}"
	for r in range rounds.length
		url += "&r#{r+1}=#{rounds[r]}"

	url = url.replaceAll ' ', '+'

	echo url
	window.location.href = url

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
	fairpair = new FairPair players, ROUNDS, GAMES

	echo "" 

	for i in range players.length
		line = fairpair.matrix[i]
		echo i%10 + '   ' + line.join('   ') + '  ' + players[i].elo

	echo 'summa', fairpair.summa
	fairpair.rounds

showInfo = ->
	document.getElementById('info').innerHTML = div {},
		div {class:"help"}, pre {}, helpText

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

	document.getElementById('stallning').innerHTML = result

	# Sätt antal decimaler för PR
	tbody = document.querySelector '#stallning tbody'
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

	params = new URLSearchParams window.location.search
	echo params

	if params.size == 0 
		document.getElementById("button").addEventListener "click", parseTextarea 
		showInfo()
		return

	document.getElementById("textarea").style = 'display: none'
	document.getElementById("button").style = 'display: none'

	parseQuery()

	document.title = TITLE

	if players.length < 4
		showInfo()
		return

	if ROUNDS == players.length - 1
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

	if event.key in '123' 
		document.getElementById("stallning").style.display = if event.key in "13" then "table" else "none"
		document.getElementById("tables").style.display = if event.key in "23" then "table" else "none"

main()
