# ½

# TODO: Change the name Berger to something better

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

RESULTS = []

alignLeft   = {style: "text-align:left"}
alignCenter = {style: "text-align:center"}
alignRight  = {style: "text-align:right"}

players = []
rounds = [] # vem möter vem? [w,b]. T ex [0,9], [1,8] ...]
results = [] # [[0,1,2,-1,2], [1,2,-1,0,2]] Vitspelarnas resultat i varje rond. -1 <=> x dvs ej spelad

display = 3 # both
frirond = null # ingen frirond. Annars index för frironden

sorteringsOrdning = {}	# Spara per kolumn

ass = (a,b) ->
	if _.isEqual a, b then return
	echo 'Assertion failed: (open the Assertion below to find the failing assertion)'
	echo '  ', JSON.stringify a 
	echo '  ', JSON.stringify b
	console.assert false # can be used to track the assert
ass 7, 3 + 4

# The Normal Form can be used to construct both the standings list and the table list
# rounds: produced by makeBerger and makeFairPair
# results: produced by the human
normalForm = (rounds, results) -> # produces the normal form for ONE round. If there is a BYE, put it last in the list
	if rounds.length > results.length then results += 'F'
	rounds[i].concat results[i] for i in range results.length
ass [[1,10,"0"], [2,9,"r"], [3,8,"1"], [4,7,"0"], [5,6,"r"], [0,11,"F"]], normalForm [[1,10], [2,9], [3,8], [4,7], [5,6], [0,11]], "0r10r"
ass [[1,10,"0"], [2,9,"r"], [3,8,"1"], [4,7,"0"], [5,6,"r"], [0,11,"x"]], normalForm [[1,10], [2,9], [3,8], [4,7], [5,6], [0,11]], "0r10rx"

listify = (s) -> ('0r1'.indexOf ch) for ch in s # omvandla "r01x1" till [1,0,2,-1,2] 
ass [0,1,2,-1,2], listify '0r1x1'

prettify = (ch) -> if ch == 'x' or ch == undefined then " - " else "#{'0½1'[ch]} - #{'0½1'[2 - ch]}" 
ass "0 - 1", prettify '0'
ass "½ - ½", prettify '1'
ass "1 - 0", prettify '2'
ass " - ", prettify 'x'

expand = (rounds) -> # make a double round from a single
	result = []
	for round in rounds
		result.push ([w,b] for [w,b] in round)
		result.push ([b,w] for [w,b] in round)
	result
ass [[[1,2],[3,4]],[[2,1],[4,3]],[[1,4],[2,3]],[[4,1],[3,2]]], expand [[[1,2],[3,4]], [[1,4],[2,3]]]

findNumberOfDecimals = (lst) ->
	best = 0
	for i in range 6
		unik = _.uniq (item.toFixed(i) for item in lst)
		if unik.length > best then [best,ibest] = [unik.length,i]
	ibest
ass 0, findNumberOfDecimals [1200,1200]
ass 0, findNumberOfDecimals [1200,1201]
ass 0, findNumberOfDecimals [1200.23,1200.23]
ass 1, findNumberOfDecimals [1200.23,1200.3]
ass 1, findNumberOfDecimals [1200.23,1200.3]
ass 3, findNumberOfDecimals [1200.23,1200.2345]
ass 0, findNumberOfDecimals [1200.12345,1200.12345]

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
	RESULTS = [0,1,2] # internt bruk

	players = []
	persons = params.getAll "p"
	persons.sort().reverse()
	echo persons.length
	for person in persons
		elo = parseInt person.slice 0,4
		name = person.slice(4).trim()
		echo elo,name
		players.push new Player players.length, name, elo

	if players.length % 2 == 1
		players.push new Player players.length, 'FRIROND', 0
		frirond = players.length - 1
	else
		frirond = null

	ROUNDS = parseInt safeGet params, "ROUNDS", "#{players.length-1}"
	echo {TITLE,GAMES,ROUNDS}
	N = players.length
	LOG2 = Math.ceil Math.log2 N
	if ROUNDS == N-1 then # Berger
	else if ROUNDS < LOG2 then alert "Too few ROUNDS! Minimum is #{LOG2}"
	# else if ROUNDS >= N then alert "Too many ROUNDS! Maximum is #{N-1}"

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
			key = key.trim()
			val = val.trim()
			if key == 'TITLE' then TITLE = val
			if key == 'GAMES' then GAMES = val
			if key == 'ROUNDS' then ROUNDS = val
			if key[0] == 'r' then rounds.push val
		else
			players.push line

	echo rounds

	#url = 'http://127.0.0.1:5501'
	url = '/'
	url += "?TITLE=#{TITLE}"
	if GAMES then url += "&GAMES=#{GAMES}"
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
	if frirond then lst.push lst.shift()
	lst

makeBerger = ->
	echo 'BERGER'

	n = players.length
	if n % 2 == 1 then n += 1
	half = n // 2 
	A = [0...n]
	rounds = []
	for i in range ROUNDS
		rounds.push savePairing i, A, half, n
		A.pop()
		A = A.slice(half).concat A.slice(0,half)
		A.push n-1
	echo 'BERGER',rounds
	rounds
 
makeFairPair = ->
	fairpair = new FairPair players, ROUNDS, GAMES

	echo "" 

	for i in range players.length
		line = fairpair.matrix[i]
		echo i%10 + '   ' + line.join('   ') + '  ' + players[i].elo

	echo 'summa', fairpair.summa
	echo 'FAIRPAIR', fairpair.rounds

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
			if i == b then result = 2 - result

			if result in [0,1,2] and players[opponent].elo != 0
				oppElos.push players[opponent].elo
				pointsPR += result
		else
			result = ""

		if frirond and opponent == frirond
			sOpponent = 'F'
			sResult = "1"
		else 
			sOpponent = opponent + 1
			sResult = "0½1"[result]

		if i == w then attr = "right:0px;" else attr = "left:0px;"
		cell = td {style: "position:relative;"},
			div {style: "position:absolute; top:0px;" + attr + "font-size:0.7em;"}, sOpponent
			div {style: "position:absolute; top:12px; transform: translate(-10%, -10%); font-size:1.1em;"}, sResult

		ronder.push cell

	ronder.push	td alignRight, points[i].toFixed 1
	ronder.push td {}, performance pointsPR/2, oppElos
	ronder.join ""

showPlayers = (points) ->

	rows = []

	for player, i in players
		if i == frirond then continue
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

showTables = (rounds, selectedRound) ->
	if rounds.length == 0 then return

	rows = ""
	bord = 0

	for i in range rounds.length
		[w, b] = rounds[i]
		echo frirond,w,b
		if frirond in [w,b] or selectedRound >= results.length then continue
		vit = players[w]?.name or ""
		svart = players[b]?.name or ""

		rows += tr {},
			td {}, bord+1
			td alignLeft, vit
			td alignLeft, svart
			td alignCenter, prettify results[selectedRound][bord]
		bord += 1

	result = div {},
		h2 {}, "Bordslista för rond #{selectedRound+1}"
		table {},
			thead {},
				th {}, "Bord"
				th {}, "Vit"
				th {}, "Svart"
				th {}, "Resultat" 
			rows

	result += "<br>(G#{GAMES} R#{ROUNDS} #{if ROUNDS == players.length - 1 then 'Berger' else 'FairPair'})"

	document.getElementById('tables').innerHTML = result

readResults = (params) ->
	results = []
	for r in range GAMES * ROUNDS
		lst = listify safeGet params, "r#{r+1}", "x".repeat players.length // 2 
		# echo rounds[r]
		res = []
		for i in range players.length // 2
			if lst[i] == -1
				[w,b] = rounds[r][i]
				# echo w,b
				if ROUNDS == players.length - 1
					if w == frirond then res.push 2*GAMES
					else if b == frirond then res.push 0
					else res.push lst[i]
				else # FairPair
					if b == frirond then res.push 2*GAMES
					else if w == frirond then res.push 0
					else res.push lst[i]
			else
				res.push lst[i]
		results.push res
	echo 'readResults', results

		# for ch in safeGet params, "r#{r+1}", "x".repeat players.length // 2 
		# if frirond == -1
		# 	s = 
		# 	results.push listify s
		# else
		# 	s = safeGet params, "r#{r+1}", "x".repeat players.length // 2
		# 	results.push listify s

progress = (points) ->
	antal = 0
	# echo 'progress',results
	for point in points
		antal += point
	" • #{antal} av #{ROUNDS * players.length}"

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

	if players.length < 4
		showInfo()
		return

	echo {ROUNDS,GAMES}
	if ROUNDS == players.length - 1
		rounds = makeBerger()
		if GAMES == 2 then rounds = expand rounds
	else 
		rounds = makeFairPair()
		if GAMES == 2 then rounds = expand rounds

	readResults params

	points = Array(players.length).fill(0)

	for i in range results.length
		res = results[i]
		round = rounds[i]
		for j, [w, b] of round
			if res[j] in RESULTS
				points[w] += 0.5 * parseInt res[j]
				points[b] += 0.5 * (2 - parseInt res[j])

	document.title = TITLE + progress points

	showPlayers points
	showTables rounds[0] or [], 0

	skapaSorteringsklick()

document.addEventListener 'keyup', (event) ->

	if event.key in '123' 
		document.getElementById("stallning").style.display = if event.key in "13" then "table" else "none"
		document.getElementById("tables").style.display = if event.key in "23" then "table" else "none"

main()
