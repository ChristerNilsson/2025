# ½

import {Player} from './player.js'
import {FairPair} from './fairpair.js'
import {helpText} from './texts.js'
import {performance} from './rating.js'
import {table,thead,th,tr,td,a,div,pre,p,h2} from './html.js'

echo = console.log
range = _.range

settings = {TITLE:'', GAMES:0, ROUNDS:0, SORT:1, ONE:1, BALANCE:1} # ONE = 1 # 0=dev 1=prod

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

longs = [] # underlag för showPlayers
shorts = [] # underlag för showTables

ass = (a,b) ->
	if _.isEqual a, b then return
	echo 'Assertion failed: (open the Assertion below to find the failing assertion)'
	echo '  expect', JSON.stringify a 
	echo '  actual', JSON.stringify b
	console.assert false # can be used to track the assert
ass 7, 3 + 4

# The short Form is used to render the table list
# rounds: produced by makeBerger and makeFairPair
# results: produced by the human
shortForm = (rounds, results) -> # produces the short form for ONE round (bordslistan). If there is a BYE, put it last in the list
	if rounds.length > results.length then results += 'F'
	rounds[i].concat results[i] for i in range results.length
ass [[1,10,"0"], [2,9,"r"], [3,8,"1"], [4,7,"0"], [5,6,"r"], [0,11,"F"]], shortForm [[1,10], [2,9], [3,8], [4,7], [5,6], [0,11]], "0r10r"
ass [[1,10,"0"], [2,9,"r"], [3,8,"1"], [4,7,"0"], [5,6,"r"], [0,11,"x"]], shortForm [[1,10], [2,9], [3,8], [4,7], [5,6], [0,11]], "0r10rx"

# listify = (s) -> ('0r1'.indexOf ch) for ch in s # omvandla "r01x1" till [1,0,2,-1,2] 
# ass [0,1,2,-1,2], listify '0r1x1'

convert = (input,a,b) -> if input in a then b[a.indexOf input] else input # a och b är strängar

convertLong = (input,a,b) -> # b är separerad med |
	i = a.indexOf input
	b = b.split '|'
	if input in a then b[i] else input

other = (input) -> convert input, "01FG","1011"
ass '1', other '0'
ass 'r', other 'r'
ass '0', other '1'
ass '1', other 'F'
ass '1', other 'G'
ass 'x', other 'x'

longForm = (rounds, results) -> # produces the long form for ONE round (spelarlistan). If there is a BYE, put it last in the list
	if rounds.length > results.length then results += 'F'
	result = []
	for i in range rounds.length
		[w,b] = rounds[i]
		res = results[i]
		result.push [w,b,'w',res]
		result.push [b,w,'b',other res]
	result.sort (a,b) -> a[0] - b[0]
ass [
	[ 0,11,'w','F']
	[ 1,10,'w','0']
	[ 2, 9,'w','r']
	[ 3, 8,'w','1']
	[ 4, 7,'w','0']
	[ 5, 6,'w','r']
	[ 6, 5,'b','r']
	[ 7, 4,'b','1']
	[ 8, 3,'b','0']
	[ 9, 2,'b','r']
	[10, 1,'b','1']
	[11, 0,'b','1']
], longForm [[1,10], [2,9], [3,8], [4,7], [5,6], [0,11]], "0r10r"
# ass [[1,10,"0"], [2,9,"r"], [3,8,"1"], [4,7,"0"], [5,6,"r"], [0,11,"x"]], longForm [[1,10], [2,9], [3,8], [4,7], [5,6], [0,11]], "0r10rx"

prettify = (ch) -> if ch == undefined then return " - " else convertLong ch, "xF0r1","-|-|0 - 1|½ - ½|1 - 0"
ass "0 - 1", prettify '0'
ass "½ - ½", prettify 'r'
ass "1 - 0", prettify '1'
ass "-", prettify 'x'

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
		index++
		do (_th,index) ->
			_th.addEventListener 'click', (event) ->
				key = _th.textContent
				if !isNaN parseInt key
					key = parseInt(key) - settings.ONE
					showTables shorts, key
					return

				tbody = document.querySelector '#stallning tbody'
				rader = Array.from tbody.querySelectorAll 'tr'
				stigande = key in "# Namn".split ' '

				rader.sort (a, b) ->
					cellA = a.children[index].textContent.trim()
					cellB = b.children[index].textContent.trim()

					# Försök jämföra som tal, annars som text
					numA = parseFloat cellA
					numB = parseFloat cellB
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

	settings.TITLE = safeGet params, "TITLE"
	settings.GAMES = parseInt safeGet params, "GAMES", "1"
	settings.SORT = parseInt safeGet params, "SORT", "1"
	settings.ONE = parseInt safeGet params, "ONE", "1"
	settings.BALANCE = parseInt safeGet params, "BALANCE", "1"

	RESULTS = [0,1,2] # internt bruk

	players = []
	persons = params.getAll "p"

	if settings.SORT == 1 then persons.sort().reverse()

	i = 0
	echo ""
	for person in persons
		i += 1
		elo = parseInt person.slice 0,4
		name = person.slice(4).trim()
		echo i, elo,name
		players.push new Player players.length, name, elo

	if players.length % 2 == 1
		players.push new Player players.length, 'FRIROND', 0
		frirond = players.length - 1
	else
		frirond = null

	settings.ROUNDS = parseInt safeGet params, "ROUNDS", "#{players.length-1}"
	echo settings

parseTextarea = ->
	echo 'parseTextArea'
	raw = document.getElementById "textarea"
	echo 'textarea',raw.value

	lines = raw.value
	lines = lines.split "\n"

	rounds = null

	for line in lines 
		if line == "" then continue
		if line.includes '='
			[key, val] = line.split '='
			key = key.trim()
			val = val.trim()
			if key == 'TITLE' then settings.TITLE = val
			if key == 'GAMES' then settings.GAMES = val
			if key == 'ROUNDS' then settings.ROUNDS = val
			if key == 'SORT' then settings.SORT = val
			if key == 'ONE' then settings.ONE = val
			if key == 'BALANCE' then settings.BALANCE = val
			if key[0] == 'r'
				n = players.length // 2
				if rounds == null then rounds = new Array(settings.GAMES * settings.ROUNDS).fill "x".repeat n
				rounds[key.slice(1) - 1] = val
		else
			players.push line

	echo rounds
	echo window.location.href

	if rounds == null then rounds = []

	if window.location.href.includes "github" then url = "https://christernilsson.github.io/2025/013-FloatingBerger/" else url = '/'

	url += "?TITLE=#{settings.TITLE}"
	url += "&GAMES=#{settings.GAMES}"
	url += "&ROUNDS=#{settings.ROUNDS}"
	url += "&SORT=#{settings.SORT}"
	url += "&ONE=#{settings.ONE}"
	url += "&BALANCE=#{settings.BALANCE}"

	for player in players
		url += "&p=#{player}"

	for r in range rounds.length
		if '' == rounds[r].replaceAll 'x','' then continue
		url += "&r#{r+1}=#{rounds[r]}"

	url = url.replaceAll ' ', '+'

	echo url
	players = []
	rounds = []
	window.location.href = url

savePairing = (r, A, half, n) ->
	lst = if r % 2 == 1 then [[A[n - 1], A[0]]] else [[A[0], A[n - 1]]]
	for i in [1...half]
		lst.push [A[i], A[n - 1 - i]]
	if frirond then lst.push lst.shift()
	lst.sort()

makeBerger = ->
	echo 'BERGER'

	n = players.length
	if n % 2 == 1 then n += 1
	half = n // 2 
	A = [0...n]
	rounds = []
	for i in range settings.ROUNDS
		rounds.push savePairing i, A, half, n
		A.pop()
		A = A.slice(half).concat A.slice(0,half)
		A.push n-1
	echo 'BERGER',rounds
	rounds

showMatrix = (fairpair) ->
	if players.length > 20 then return 
	echo "" 
	for i in range players.length
		line = fairpair.matrix[i]
		echo (i + settings.ONE) % 10 + '   ' + line.join('   ') + '  ' + players[i].elo
	echo 'summa', fairpair.summa
	echo 'FAIRPAIR', fairpair.rounds

makeFairPair = ->
	fairpair = new FairPair players, settings
	showMatrix fairpair
	fairpair.rounds

showInfo = ->
	document.getElementById('info').innerHTML = div {},
		div {class:"help"}, pre {}, helpText

roundsContent = (long, i) -> # rondernas data + poäng + PR. i anger spelarnummer

	ronder = []
	oppElos = []

	for [w,b,color,result] in long
		opponent = settings.ONE + if w == i then b else w
		if frirond and opponent == frirond + settings.ONE then opponent = 'F'
		result = convert result, 'x10rFG', ' 10½11'

		if color == 'w' then attr = "right:0px;" else attr = "left:0px;"
		cell = td {style: "position:relative;"},
			div {style: "position:absolute; top:0px;  font-size:0.7em;" + attr}, opponent
			div {style: "position:absolute; top:12px; font-size:1.1em; transform: translate(-10%, -10%)"}, result

		ronder.push cell

	ronder.push	td alignRight, ""
	ronder.push td {}, ""
	ronder.join ""

showPlayers = (longs) -> # longs lagrad som lista av spelare

	rows = []

	for long, i in longs
		player = players[i]
		if player.name == 'FRIROND' then continue
		rows.push tr {},
			td {}, i + settings.ONE
			td alignLeft, player.name
			td {}, player.elo
			roundsContent long, i

	result = div {},
		h2 {}, settings.TITLE
		table {},
			thead {},
				th {}, "#"
				th {}, "Namn"
				th {}, "Elo"
				(th {}, "#{i + settings.ONE}" for i in range rounds.length).join ""
				th {}, "P"
				th {}, "PR"
			rows.join ""

	document.getElementById('stallning').innerHTML = result

showTables = (shorts, selectedRound) ->
	if rounds.length == 0 then return

	rows = ""
	bord = 0
	message = ""

	for short in shorts[selectedRound]
		[w, b, color, res] = short
		if color == 'b' then continue

		vit = players[w].name
		svart = players[b].name

		if vit == 'FRIROND'
			message = " • #{svart} har frirond"
			continue
		if svart == 'FRIROND'
			message = " • #{vit} har frirond"
			continue
		rows += tr {},
			td {}, bord + settings.ONE
			td alignLeft, vit
			td alignLeft, svart
			td alignCenter, prettify res
		bord++

	result = div {},
		h2 {}, "Bordslista för rond #{selectedRound + settings.ONE}"
		table {},
			thead {},
				th {}, "Bord"
				th {}, "Vit"
				th {}, "Svart"
				th {}, "Resultat" 
			rows

	result += "<br>G#{settings.GAMES} • R#{settings.ROUNDS} • S#{settings.SORT} • B#{settings.BALANCE} • #{if settings.ROUNDS == players.length - 1 then 'Berger' else 'FairPair'} #{message}"

	document.getElementById('tables').innerHTML = result

readResults = (params) ->
	results = []
	n = players.length
	if frirond then n -= 2
	n //= 2
	
	for r in range settings.GAMES * settings.ROUNDS
		results.push safeGet params, "r#{r+1}", "x".repeat n
	echo 'readResults', results

progress = (points) ->
	antal = 0
	for point in points
		antal += point
	if frirond 
		" • #{antal} av #{settings.GAMES * settings.ROUNDS * (players.length - 2) // 2}"
	else
		" • #{antal} av #{settings.GAMES * settings.ROUNDS * players.length / 2}"

calcPoints = -> # Hämta cellerna från GUI:t
	tbody = document.querySelector '#stallning tbody'
	rader = Array.from tbody.querySelectorAll 'tr'

	PS = []
	PRS = []
	performances = [] 

	for rad in rader
		points = 0
		pointsPR = 0
		elos = []
		for i in range settings.GAMES * settings.ROUNDS
			cell = rad.children[3+i]
			opp = cell.children[0].textContent
			val = cell.children[1].textContent
			value = 0
			if val == '½' then value = 0.5
			if val == '1' then value = 1
			points += value

			if val in '0½1' and opp != 'F' and players[opp-1].elo > 0
				pointsPR += value
				elos.push players[opp-1].elo

		PS.push points
		PRS.push pointsPR
		performances.push performance pointsPR, elos

	decimals = findNumberOfDecimals performances
	for i in range rader.length
		rad = rader[i]
		rad.children[settings.GAMES * settings.ROUNDS + 3].textContent = PS[i].toFixed 1
		rad.children[settings.GAMES * settings.ROUNDS + 4].textContent = if performances[i] > 3999 then "" else performances[i].toFixed decimals

	PRS

main = ->

	params = new URLSearchParams window.location.search

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

	rounds = if settings.ROUNDS == players.length - 1 then makeBerger() else makeFairPair()
	if settings.GAMES == 2 then rounds = expand rounds

	readResults params
	
	longs = [] # innehåller alla ronderna
	for r in range rounds.length
		longs.push longForm rounds[r],results[r]

	shorts = longs # _.cloneDeep
	longs = _.zip ...longs # transponerar matrisen

	showPlayers longs
	showTables shorts, 0

	skapaSorteringsklick()

	PRS = calcPoints()
	document.title = settings.TITLE + progress PRS

document.addEventListener 'keyup', (event) ->

	if event.key in '123' 
		document.getElementById("stallning").style.display = if event.key in "13" then "table" else "none"
		document.getElementById("tables").style.display = if event.key in "23" then "table" else "none"

main()
