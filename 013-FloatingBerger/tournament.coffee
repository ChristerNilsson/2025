# ½ •

import {Player} from './player.js'
import {Floating} from './floating.js'
import {helpText} from './texts.js'
import {performance} from './rating.js'
import {table,thead,th,tr,td,a,div,pre,p,h2} from './html.js'

echo = console.log
range = _.range

ALIGN_LEFT   = {style: "text-align:left"}
ALIGN_CENTER = {style: "text-align:center"}
ALIGN_RIGHT  = {style: "text-align:right"}

## V A R I A B L E R ##

settings = {TITLE:'', GAMES:0, ROUNDS:0, SORT:1, ONE:1, BALANCE:1} # ONE = 1 # 0=dev 1=prod

# Tillståndet ges av dessa fem variabler:
players = []
rounds = []  # vem möter vem? [w,b]. T ex [[0,9], [1,8] ...]
results = [] # [['0','1','2','x'], ['0','1','2','x'] ...] Vitspelarnas resultat i varje rond.
currRound = 0
currTable = 0

frirond = null # ingen frirond. Annars index för frironden

longs = [] # underlag för showPlayers
shorts = [] # underlag för showTables

## F U N K T I O N E R ##

changeRound = (delta) -> # byt rond och uppdatera bordslistan
	currRound = (currRound + delta) %% rounds.length
	updateLongsAndShorts()
	showTables shorts, currRound

changeTable = (delta) -> # byt bord
	currTable = (currTable + delta) %% tableCount()

convert = (input,a,b) -> # byt alla tecken i input som finns i a mot tecken med samma index i b
	if input in a then b[a.indexOf input] else input # a och b är strängar

convertLong = (input,a,b) -> # byt alla tecken i input som finns i a mot sträng med samma index i b. b är separerad med |
	i = a.indexOf input
	b = b.split '|'
	if input in a then b[i] else input

createSortEvents = -> # Spelarlistan sorteras beroende på vilken kolumn man klickar på. # Namn Elo P eller PR

	ths = document.querySelectorAll '#stallning th'

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

export expand = (rounds) -> # make a double round from a single
	result = []
	for round in rounds
		result.push ([w,b] for [w,b] in round)
		result.push ([b,w] for [w,b] in round)
	result

export findNumberOfDecimals = (lst) -> # leta upp minsta antal decimaler som krävs för unikhet i listan
	best = 0
	for i in range 6
		unik = _.uniq (item.toFixed(i) for item in lst)
		if unik.length > best then [best,ibest] = [unik.length,i]
	ibest

invert = (lst) ->
	result = _.clone lst
	for i in range lst.length
		item = lst[i]
		result[item] = i
	result

export longForm = (rounds, results) -> # produces the long form for ONE round (spelarlistan). If there is a BYE, put it last in the list
	if rounds.length > results.length #then results += 'F'
		[w,b] = rounds[0]
		results = if w==frirond or b==frirond then 'F' + results else results + 'F'
	result = []
	for i in range rounds.length
		[w,b] = rounds[i]
		res = results[i]
		result.push [w,b,'w',res]
		result.push [b,w,'b',other res]

	result.sort (a,b) -> a[0] - b[0]
	# echo 'longForm',rounds,results,result
	result

makeBerger = -> # lotta en hel berger-turnering.
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

makeFloating = -> # lotta en hel floating-turnering
	floating = new Floating players, settings
	showMatrix floating
	floating.rounds

makeURL = ->
	url = "./"

	url += "?TITLE=#{settings.TITLE}"
	url += "&GAMES=#{settings.GAMES}"
	url += "&ROUNDS=#{settings.ROUNDS}"
	url += "&SORT=#{settings.SORT}"
	url += "&ONE=#{settings.ONE}"
	url += "&BALANCE=#{settings.BALANCE}"

	for player in players
		url += "&p=#{player}"

	for r in range rounds.length
		s = results[r].join ''
		s = _.trimEnd s, 'x'
		if s != '' then url += "&r#{r+1}=#{s}"

	url = url.replaceAll ' ', '+'
	url

export other = (input) -> convert input, "012FG","21022"

parseTextarea = -> # läs in initiala uppgifter om spelarna
	echo 'parseTextArea'
	raw = document.getElementById "textarea"
	echo 'textarea',raw.value

	lines = raw.value
	lines = lines.split "\n"

	rounds = null

	for line in lines 
		if line.length == 0 or line[0] == '#' then continue
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

	echo settings
	echo window.location.href

	if rounds == null then rounds = []

	url = makeURL()

	players = []
	rounds = []
	window.location.href = url
	echo 'url',url

parseURL = -> 
	#echo window.location.search
	params = new URLSearchParams window.location.search

	settings.TITLE = safeGet params, "TITLE"
	settings.GAMES = parseInt safeGet params, "GAMES", "1"
	settings.SORT = parseInt safeGet params, "SORT", "1"
	settings.ONE = parseInt safeGet params, "ONE", "1"
	settings.BALANCE = parseInt safeGet params, "BALANCE", "1"

	players = []
	persons = params.getAll "p"

	if settings.SORT == 1 then persons.sort().reverse()

	i = 0
	#echo ""
	for person in persons
		i += 1
		elo = parseInt person.slice 0,4
		name = person.slice(4).trim()
		#echo i, elo,name
		players.push new Player players.length, name, elo

	if players.length % 2 == 1
		players.push new Player players.length, 'FRIROND', 0
		frirond = players.length - 1
	else
		frirond = null

	settings.ROUNDS = parseInt safeGet params, "ROUNDS", "#{players.length-1}"

	#echo 'settings', settings

	# initialisera rounds med 'x' i alla celler
	n = players.length // 2
	rounds = []
	for i in range settings.GAMES * settings.ROUNDS
		rounds.push new Array(n).fill 'x'

	#echo 'rounds',rounds
	readResults params
	#echo 'parseURL',results

export prettyResult = (ch) -> # översätt interna resultat till externa
	if ch == 'x' then return "-"
	if ch == '0' then return "0 - 1"
	if ch == '1' then return "½ - ½"
	if ch == '2' then return "1 - 0"

readResults = (params) -> # Resultaten läses från urlen
	results = []
	n = players.length
	if frirond then n -= 2
	n //= 2
	
	for r in range settings.GAMES * settings.ROUNDS
		result = safeGet params, "r#{r+1}", new Array(n).fill "x"
		#echo 'result',result
		arr = []
		for ch in result 
			if ch=='0' then arr.push '0'
			if ch=='1' then arr.push '1'
			if ch=='2' then arr.push '2'
			if ch=='x' then arr.push 'x'
		results.push arr
		#echo 'readResults', results,results.length

roundsContent = (long, i) -> # rondernas data + poäng + PR. i anger spelarnummer

	# echo {long}
	ronder = []
	oppElos = []

	for [w,b,color,result] in long
		opponent = settings.ONE + if w == i then b else w
		# echo {w,b,color,result,opponent,frirond}
		if frirond and opponent == frirond + settings.ONE then opponent = 'F'
		result = convert result, 'x201FG', ' 10½11'

		attr = if color == 'w' then "right:0px;" else "left:0px;"
		cell = td {style: "position:relative;"},
			div {style: "position:absolute; top:0px;  font-size:0.7em;" + attr}, opponent
			div {style: "position:absolute; top:12px; font-size:1.1em; transform: translate(-10%, -10%)"}, result

		ronder.push cell

	ronder.push	td ALIGN_RIGHT, ""
	ronder.push td {}, ""
	ronder.join ""

safeGet = (params,key,standard="") -> # Hämta parametern given av key från urlen
	if params.get key then return params.get(key).trim()
	if params.get ' ' + key then return params.get(' ' + key).trim()
	standard

savePairing = (r, A, half, n) -> # skapa en bordslista utifrån berger.
	lst = if r % 2 == 1 then [[A[n - 1], A[0]]] else [[A[0], A[n - 1]]]
	for i in [1...half]
		lst.push [A[i], A[n - 1 - i]]
	if frirond then lst.push lst.shift()
	lst.sort()

setCursor = (round, table) -> # Den gula bakgrunden uppdateras beroende på piltangenterna
	ths = document.querySelectorAll '#stallning th'
	index = -1
	for _th in ths
		index++
		color = if index == currRound + 3 then 'yellow' else 'white'
		_th.style = "background-color:#{color}"

	trs = document.querySelectorAll '#tables tr'
	index = -1
	for _tr in trs
		index++
		color = if index == currTable + 1 then 'yellow' else 'white'
		_tr.children[3].style = "background-color:#{color}"

set_P_PR = (trs, index, translator) ->
	scores = []
	elos = []
	for r in range settings.GAMES * settings.ROUNDS
		ch = longs[index][r][3]
		value = '012'.indexOf ch
		if value != -1 
			opp = longs[index][r][1]
			elo = players[opp].elo
			scores.push value
			elos.push Math.round elo 

	_tdP  = trs[translator[index] + 1].children[3 + settings.GAMES * settings.ROUNDS]
	_tdPR = trs[translator[index] + 1].children[4 + settings.GAMES * settings.ROUNDS]

	_tdP.textContent = (_.sum(scores)/2).toFixed 1

	# kalkylera performance rating mha vinstandel och elo-tal
	andel = _.sum(scores)/2
	perf = performance andel, elos
	_tdPR.textContent = perf.toFixed 3

setResult = (key, res) -> # Uppdatera results samt gui:t.

	trs = document.querySelectorAll '#stallning tr'

	translator = []
	for i in range 1, trs.length
		translator.push Math.round(trs[i].children[0].textContent) - 1
	translator = invert translator

	[w,b] = rounds[currRound][currTable]
	echo "key #{key} res #{res} w #{w} b #{b}"
	echo "rounds",rounds
	echo "translator",translator
	results[currRound][currTable] = res

	one = settings.ONE
	document.title = "#{currRound+one}:#{currTable+one} #{w+one}-#{b+one} #{settings.TITLE}"

	url = makeURL()
	updateLongsAndShorts()

	_td = trs[translator[w] + 1].children[3 + currRound].children[1]
	_td.textContent = "0½1"[res]

	_td = trs[translator[b] + 1].children[3 + currRound].children[1]
	_td.textContent = "1½0"[res]

	set_P_PR trs, b, translator
	set_P_PR trs, w, translator

	# Sätt tables
	trs = document.querySelectorAll '#tables tr'
	_tr = trs[currTable + 1]
	tr3 = _tr.children[3]

	success = false
	if key == 'Delete' then success = true
	else success = tr3.textContent == '-' or tr3.textContent == res
	if success
		tr3.textContent = prettyResult res
		currTable = (currTable + 1) %% tableCount()

	#history.pushState {}, "", url # för att slippa omladdning av sidan

export shortForm = (rounds, results) -> # produces the short form for ONE round (bordslistan). If there is a BYE, put it last in the list
	# The short Form is used to render the table list
	# rounds: produced by makeBerger and makeFloating
	# results: produced by the human
	if rounds.length > results.length then results += 'F'
	rounds[i].concat results[i] for i in range results.length

showInfo = -> # Visa helpText på skärmen
	document.getElementById('info').innerHTML = div {},
		div {class:"help"}, pre {}, helpText

showMatrix = (floating) -> # Visa matrisen Alla mot alla. Dot betyder: inget möte
	if players.length > 20 then return 
	#echo "" 
	for i in range players.length
		line = floating.matrix[i]
		echo (i + settings.ONE) % 10 + '   ' + line.join('   ') + '  ' + players[i].elo
	#echo 'Summa', floating.summa
	#echo 'Floating', floating.rounds

showPlayers = (longs) -> # Visa spelarlistan. (longs lagrad som lista av spelare)

	rows = []

	for long, i in longs
		player = players[i]
		if player.name == 'FRIROND' then continue
		rows.push tr {},
			td {}, i + settings.ONE
			td ALIGN_LEFT, player.name
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

showTables = (shorts, selectedRound) -> # Visa bordslistan
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
			hash = {style : "background-color:red"}
			# hash = {style : "background-color:#{bord == currTable ? 'yellow' : 'white'}" }
			echo hash 
		rows += tr hash,
			td {}, bord + settings.ONE
			td ALIGN_LEFT, vit
			td ALIGN_LEFT, svart
			td ALIGN_CENTER, prettyResult res # prettify
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

	result += "<br>G#{settings.GAMES} • R#{settings.ROUNDS} • S#{settings.SORT} • B#{settings.BALANCE} • #{if settings.ROUNDS == players.length - 1 then 'Berger' else 'Floating'} #{message}"

	document.getElementById('tables').innerHTML = result

tableCount = -> # Beräkna antal bord
	(players.length + 1) // 2

updateLongsAndShorts = -> # Uppdaterar longs och shorts utifrån rounds och results
	# echo ''
	# echo 'updateLongsAndShorts:rounds',rounds
	# echo 'updateLongsAndShorts:results',results
	longs = [] # innehåller alla ronderna
	for r in range rounds.length
		longs.push longForm rounds[r],results[r]

	shorts = longs # _.cloneDeep
	longs = _.zip ...longs # transponerar matrisen
	# echo 'longs',longs
	# echo 'shorts',shorts

main = -> # Hämta urlen i första hand, textarean i andra hand.

	params = new URLSearchParams window.location.search

	if params.size == 0 
		document.getElementById("button").addEventListener "click", parseTextarea 
		showInfo()
		return

	document.getElementById("textarea").style = 'display: none'
	document.getElementById("button").style = 'display: none'

	parseURL()

	if players.length < 4
		showInfo()
		return

	rounds = if settings.ROUNDS == players.length - 1 then makeBerger() else makeFloating()
	if settings.GAMES == 2 then rounds = expand rounds

	for i in range settings.ROUNDS
		results.push Array(tableCount()).fill 'x'

	#echo 'results',results
	readResults params
	#echo 'results',results

	updateLongsAndShorts()
	
	echo {longs}

	showPlayers longs
	showTables shorts, 0

	createSortEvents()
	setCursor currRound,currTable

	document.title = settings.TITLE

	document.addEventListener 'keydown', (event) -> # Hanterar alla tangenttryckningar

		if event.key in 'abc' 
			document.getElementById("stallning").style.display = if event.key in "ac" then "table" else "none"
			document.getElementById("tables").style.display = if event.key in "bc" then "table" else "none"
		
		if event.key == 'ArrowLeft'  then changeRound -1
		if event.key == 'ArrowRight' then changeRound +1
		if event.key == 'ArrowUp'    then changeTable -1
		if event.key == 'ArrowDown'  then changeTable +1

		del = 'Delete'
		key = event.key
		if key == del then setResult key, 'x' # "  -  "
		if key == '0' then setResult key, '0' # "0 - 1"
		if key == ' ' then setResult key, '1' # "½ - ½"
		if key == '1' then setResult key, '2' # "1 - 0"

		setCursor currRound,currTable

main()
