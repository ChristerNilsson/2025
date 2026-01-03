# ½ • ↑ ↓ ← →

import {Player} from './player.js'
import {FairPair} from './fairpair.js'
import {performance} from './rating.js'
import {echo,global,range,settings} from './global.js'
import {initialize, init, clear} from './initialization.js'

ALFABET = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890' # 100

BYE = "BYE"

KEYS = 
	'ABC' : "? GAP A B C GAP ArrowLeft ArrowRight GAP I K".split ' '
	'A' : "# N E P R GAP J L".split ' '
	'B' : "ArrowUp ArrowDown GAP - 0 _ 1 + Delete".split ' '
	'C' : "T".split ' '

TOOLTIPS =  
	'?' : "Help"
	'A' : "Standings"
	'B' : "Tables"
	'C' : "Names"
	'ArrowLeft' : "Previous Round"
	'J' : "Fewer PR decimals"
	'L' : "More PR decimals"
	'ArrowRight' : "Next Round"
	'I' : "Fewer Columns"
	'K' : "More Columns"
	'ArrowUp' : "Previous Table"
	'-' : "White unplayed loss"
	'0' : "White Loss"
	'_' : "Draw"
	'1' : "White Win"
	'+' : "White unplayed win"
	'Delete' : "Remove Result"
	'ArrowDown' : "Next Table"
	'#' : "Sort on id"
	'N' : "Sort on Name"
	'E' : "Sort on Elo"
	'P' : "Sort on Point"
	'R' : "Sort on PR"
	'T' : "Create ELO Report (TRF)"

## F U N K T I O N E R ##

addBord = (bord,res,c0,c1) ->
	vit = global.players[c0].name
	svart = global.players[c1].name
	vit_elo = global.players[c0].elo
	svart_elo = global.players[c1].elo
	tr = document.createElement 'tr'

	tr.addEventListener "click", ->
		global.currTable = bord
		setCursor() # global.currRound,global.currTable

	color = if bord == global.currTable then 'yellow' else 'white'

	koppla 'td', tr, {text : bord + settings.ONE}
	koppla 'td', tr, {style:"text-align:left", text : vit}
	koppla 'td', tr, {style:"text-align:left", text : vit_elo}
	koppla 'td', tr, {style:"text-align:center; background-color:#{color}", text : prettyResult res}
	koppla 'td', tr, {style:"text-align:left", text : svart_elo}
	koppla 'td', tr, {style:"text-align:left", text : svart}

	tr

changeGroupSize = (key,letter) ->
	if key == 'I' and settings[letter] > 1 then settings[letter]--
	if key == 'K' 
		if letter == 'B'
			echo settings.B, tableCount(), settings.B < tableCount()
			if settings.B < tableCount() then settings[letter]++
		else
			settings[letter]++
	if key in ['I', 'K']
		if letter == 'A' then showPlayers()
		if letter == 'B' then showTables()
		if letter == 'C' then showNames()

changeRound = (delta) -> # byt rond och uppdatera bordslistan
	global.currRound = (global.currRound + delta) %% global.rounds.length
	global.currTable = 0
	
	setScreen global.currScreen

changeTable = (delta) -> global.currTable = (global.currTable + delta) %% tableCount()

#clear = -> clearList()

convert = (input,a,b) -> # byt alla tecken i input som finns i a mot tecken med samma index i b
	if input in a then b[a.indexOf input] else input # a och b är strängar

createSortEvents = -> # Spelarlistan sorteras beroende på vilken kolumn man klickar på. # Name Elo P eller PR

	ths = document.querySelectorAll '#players th'

	for th in ths
		do (th) ->
			th.addEventListener 'click', (event) ->
				key = th.textContent

				for i in range settings.ROUNDS
					if key == "#{i + 1}"
						global.currRound = i
						setScreen 'A'
						setCursor()

				if key == '#'    then global.currSort = '#'
				if key == 'Name' then global.currSort = 'N'
				if key == 'Elo'  then global.currSort = 'E'
				if key == 'P'    then global.currSort = 'P'
				if key == 'PR'   then global.currSort = 'R'
				if key in ['#','Name','Elo','P','PR']
					history.replaceState {}, "", makeURL() # för att slippa omladdning av sidan
					setScreen 'A'
					setCursor()

createTRF = () ->
	one = settings.ONE
	echo global.longs

	lines = []
	lines.push "012 #{settings.TITLE}"
	lines.push "022 #{settings.CITY}"
	lines.push "032 #{settings.FED}"
	lines.push "092 swiss" # för att kunna visa korsvis i Swiss Manager
	lines.push "102 #{settings.ARB}"

	lines.push "DDD SSSS sTTT NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN RRRR FFF IIIIIIIIIII BBBB/BB/BB PPPP RRRR  1111 1 1  2222 2 2  3333 3 3  4444 4 4  5555 5 5  6666 6 6  7777 7 7  8888 8 8  9999 9 9"
	for i in range global.players.length		
		p = global.players[i]
		if p.name == 'BYE' then continue
		games = global.longs[i]
		s = "001 " 
		s += _.padStart p.id + one,4 
		s += " #{p.sex}"
		s += "#{p.title}"
		s += " " + _.padEnd p.name.slice(0,33),33
		s += " " + _.padStart p.elo,4
		s += " " + p.federation
		s += _.padStart p.fideid,12

		# s += " #{p.born}/00/00           "
		s += "                      "

		for [z,opp,col,res] in games
			if opp == global.frirond or res == 'x'
				s += "          "
			else
				s += " #{_.padStart(opp + one,4)}"
				s += " #{col}"
				s += " #{convert res, ['x','0','1','2', '-', '+'], [' ','0','=','1', '-', '+']} "
		lines.push s
	downloadFile "#{nowStr()} #{settings.TITLE}.trf", lines.join '\n'

# Skapar och laddar ner en fil (text/JSON/CSV/…)
downloadFile = (filename, content, mime = 'text/plain') ->
	blob = new Blob [content], { type: mime }
	url  = URL.createObjectURL blob
	a    = document.createElement 'a'
	a.href = url
	a.download = filename

	# Safari/ios gillar att länken finns i DOM
	document.body.appendChild a
	a.click()
	a.remove()

	# Städa upp objekt-URLen
	setTimeout (-> URL.revokeObjectURL url), 0

export expand = (games, rounds) -> # make a double round from a single round
	result = []
	for round in rounds
		result.push ([w,b] for [w,b] in round)
		if games == 2 then result.push ([b,w] for [w,b] in round)
	return result

# export findNumberOfDecimals = (lst) -> # leta upp minsta antal decimaler som krävs för unikhet i listan
# 	best = 0
# 	for i in range 6
# 		unik = _.uniq (item.toFixed(i) for item in lst)
# 		if unik.length > best then [best,ibest] = [unik.length,i]
# 	ibest

handleKey = (key) ->

	if key.length == 1 then key = key.toUpperCase()
	if key == '?' then showHelp()

	if key == 'ArrowLeft'  then changeRound -1
	if key == 'ArrowRight' then changeRound +1
	if key == 'ArrowUp'   and global.currScreen == 'B' then changeTable -1
	if key == 'ArrowDown' and global.currScreen == 'B' then changeTable +1

	del = 'Delete'
	if key == del and global.currScreen == 'B' then setResult key, 'x' # "  -  "
	if key == '0' and global.currScreen == 'B' then setResult key, '0' # "0 - 1"
	if key in ' _' and global.currScreen == 'B' then setResult key, '1' # "½ - ½"
	if key == '1' and global.currScreen == 'B' then setResult key, '2' # "1 - 0"
	if key == '-' and global.currScreen == 'B' then setResult key, '-' # 0 w 1
	if key == '+' and global.currScreen == 'B' then setResult key, '+' # 1 w 0

	if key == 'J' and global.currScreen == 'A' then setDecimals -1
	if key == 'L' and global.currScreen == 'A' then setDecimals +1

	if key == 'X' then showMatrix()
	if key == 'Y' then echo 'Dump', global
	
	if key == 'T' then createTRF()

	if global.currScreen == 'A' and key in '#NEPR' # then handleKey key
		global.currSort = key
		setScreen 'A'

	if global.currScreen == 'A' then changeGroupSize key,'A'
	if global.currScreen == 'B' then changeGroupSize key,'B'
	if global.currScreen == 'C' then changeGroupSize key,'C'

	if key == 'A' then setScreen 'A'
	if key == 'B' then setScreen 'B'
	if key == 'C' then setScreen 'C'

	setCursor() # global.currRound, global.currTable

	# if key in ' _' or key in 'Delete 0 1 + - # N E P R ArrowLeft ArrowRight'.split ' '
	if key == 'A' #in ' _' or key in 'Delete 0 1 + - # N E P R ArrowLeft ArrowRight'.split ' '
		history.replaceState {}, "", makeURL() # för att slippa omladdning av sidan

koppla = (typ, parent, attrs = {}) ->
	elem = document.createElement typ

	if 'text' of attrs
		elem.textContent = attrs.text
		delete attrs.text

	if 'html' of attrs
		elem.innerHTML = attrs.html
		delete attrs.html

	for own key of attrs
		elem.setAttribute key, attrs[key]

	parent.appendChild elem
	elem

export longForm = (rounds, results) -> # produces the long form for ONE round (spelarlistan). If there is a BYE, put it last in the list
	result = []
	for i in range rounds.length
		[w,b] = rounds[i]
		res = results[i]
		result.push [w,b,'w',res]
		result.push [b,w,'b',other res]

	result.sort (a,b) -> a[0] - b[0]
	result

makeFairPair = -> # lotta en hel fairpair-turnering
	global.fairpair = new FairPair global.players, settings
	global.fairpair.rounds

export makeURL = ->
	url = "./"

	url += "?TITLE=#{settings.TITLE}"
	url += "&CITY=#{settings.CITY}"
	url += "&FED=#{settings.FED}"
	url += "&ARB=#{settings.ARB}"

	url += "&GAMES=#{settings.GAMES}"
	url += "&ROUNDS=#{settings.ROUNDS}"
	url += "&currSort=#{global.currSort}".replace '#', '%23'
	url += "&currRound=#{global.currRound}"
	url += "&ONE=#{settings.ONE}"
	url += "&A=#{settings.A}"
	url += "&B=#{settings.B}"
	url += "&C=#{settings.C}"

	for player in global.players
		url += "&p=#{player}"

	for r in range global.rounds.length
		echo global.results[r]
		s = global.results[r].join ''
		s = _.trimEnd s, 'x'
		s = s.replace "+", "%2B" # plus översätts till mellanslag vid inläsning av parametrarna
		if s != '' then url += "&r#{r+1}=#{s}"

	url = url.replaceAll ' ', '+'
	url

myChunk = (items, groups) ->
	n = items.length
	size = n // groups
	if n % groups > 0 then size++
	_.chunk items,size

nowStr = ->
	pad = (n) -> String(n).padStart 2, '0'
	d  = new Date()
	y  = d.getFullYear()
	m  = pad d.getMonth() + 1
	day = pad d.getDate()
	h  = pad d.getHours()
	min = pad d.getMinutes()
	"#{y}-#{m}-#{day} #{h}-#{min}"

export other = (input) -> convert input, "012x-+","210x+-"

parseURL = -> 
	params = new URLSearchParams window.location.search

	settings.TITLE = safeGet params, "TITLE"

	settings.CITY = safeGet params, "CITY"
	settings.FED = safeGet params, "FED"
	settings.ARB = safeGet params, "ARB"

	settings.GAMES = parseInt safeGet params, "GAMES", "1"
	global.currSort = safeGet params, "currSort", "#"
	global.currRound = parseInt safeGet params, "currRound", "0"

	settings.ONE = parseInt safeGet params, "ONE", "1"

	settings.A = parseInt safeGet params, "A", "1"
	settings.B = parseInt safeGet params, "B", "1"
	settings.C = parseInt safeGet params, "C", "1"

	global.players = []
	persons = params.getAll "p"

	echo persons

	if window.location.href.includes BYE then global.frirond = persons.length - 1
	if settings.SORT == 1 then persons.sort().reverse()

	for person in persons #.slice 0, settings.P
		global.players.push new Player global.players.length, person

	settings.ROUNDS = parseInt safeGet params, "ROUNDS", "#{global.players.length-1}"

	# initialisera rounds med 'x' i alla celler
	n = global.players.length // 2
	global.rounds = []
	for i in range settings.GAMES * settings.ROUNDS
		global.rounds.push new Array(n).fill 'x'

	readResults params

export prettyResult = (ch) -> # översätt interna resultat till externa
	if ch == 'x' then return "-"
	if ch == '0' then return "0 - 1"
	if ch == '1' then return "½ - ½"
	if ch == '2' then return "1 - 0"
	if ch == '-' then return "0 w 1"
	if ch == '+' then return "1 w 0"

readResults = (params) -> # Resultaten läses från urlen
	global.results = []
	n = global.players.length
	if global.frirond then n -= 2
	n //= 2
	
	for r in range settings.GAMES * settings.ROUNDS
		result = safeGet params, "r#{r+1}", new Array(n).fill "x"
		echo result
		arr = []
		for ch in result 
			if ch=='0' then arr.push '0'
			if ch=='1' then arr.push '1'
			if ch=='2' then arr.push '2'
			if ch=='x' then arr.push 'x'
			if ch=='+' then arr.push '+'
			if ch=='-' then arr.push '-'
		global.results.push arr

roundsContent = (long, i, tr) -> # rondernas data + poäng + PR. i anger spelarnummer
	for [w,b,color,result] in long
		opponent = if w == i then b else w
		result = convert result, ['x','0','1','2','+','-'], [' ','0','½','1','1w','0w']
		if opponent == global.frirond then result = 'F' # ½
		attr = if color == 'w' then "right:0px;" else "left:0px;"
		cell = koppla 'td', tr, {style: "position:relative;"}
		koppla 'div', cell, {style: "position:absolute; top:0px; font-size:0.7em;" + attr, text: settings.ONE + opponent}
		koppla 'div', cell, {style: "position:relative; font-size:1.1em; top:6px", text: result}
		#koppla 'div', cell, {style: "position:relative; font-size:1.0em; top:6px", text: result}

safeGet = (params,key,standard="") -> # Hämta parametern given av key från urlen
	if params.get key then return params.get(key).trim()
	if params.get ' ' + key then return params.get(' ' + key).trim()
	standard

setByeResults = ->
	if global.frirond == null then return
	for r in range global.rounds.length
		round = global.rounds[r]
		for t in range round.length
			[w,b] = round[t]
			if w == global.frirond then global.results[r][t] = '0'
			if b == global.frirond then global.results[r][t] = '2'

setCursor = -> # Den gula bakgrunden uppdateras beroende på piltangenterna
	if global.currScreen == 'A'
		ths = document.querySelectorAll '#players th'
		for th,index in ths
			echo global.currSort, th.innerText
			highlite = false
			if index == global.currRound + 3 then highlite = true 

			if global.currSort == '#' and th.innerText == '#'    then highlite = true
			if global.currSort == 'N' and th.innerText == 'Name' then highlite = true
			if global.currSort == 'E' and th.innerText == 'Elo'  then highlite = true
			if global.currSort == 'P' and th.innerText == 'P'    then highlite = true
			if global.currSort == 'R' and th.innerText == 'PR'   then highlite = true

			if highlite
				bgColor = 'yellow'
				color = 'black'
			else
				bgColor = '2f4f6f'
				color = 'white'
			th.style = "background-color:#{bgColor}; color:#{color};"

	if global.currScreen == 'B'
		trs = document.querySelectorAll '#tables tr'
		for tr,index in trs
			color = if index == global.currTable + 0 then 'yellow' else 'white'
			tr.children[5-2].style = "background-color:#{color}"

setDecimals = (delta) ->
	decimals = settings.DECIMALS + delta
	if 0 <= decimals <= 6 then settings.DECIMALS = decimals
	showPlayers()

setMenuZone = (key,zone) ->
	for key in KEYS[key]
		skey = switch key
			when 'ArrowLeft' then skey = '←'
			when 'ArrowRight' then skey = '→'
			when 'ArrowUp' then skey = '↑'
			when 'ArrowDown' then skey = '↓'
			when 'Delete' then skey = 'Del'
			else key
		if key == 'GAP'
			koppla 'span', zone, {style: "display: inline-block; width: 0.5rem;"}
		else
			# echo 'xxx',key,global.currSort
			if key == global.currScreen or key == global.currSort
				koppla 'span', zone, class: 'pseudo-btn', text: skey
			else
				btn = koppla 'button', zone, text: skey, title: TOOLTIPS[key]
				do (key) ->
					btn.addEventListener 'click', () -> handleKey key
			if key == '_'
				btn.style = "color: transparent"
				key = ' '

setResult = (key, res) -> # Uppdatera results samt gui:t.
	old = global.results[global.currRound][global.currTable]
	[w,b] = global.rounds[global.currRound][global.currTable]
	if global.frirond and (w==global.frirond or b==global.frirond) then return

	cell = old + res # transition, 16 possibilities

	if cell in 'xx 00 11 22 -- ++'.split ' ' # lyckad kontrollinmatning, gå till nästa bord
		global.currTable = (global.currTable + 1) %% tableCount()
		return

	if cell in '01 02 10 12 20 21 0- 0+ 1- 1+ 2- 2+ -0 -1 -2 -+ +0 +1 +2 +-'.split ' '
		echo 'exit'
		return # inmatning stämmer ej, lämna

	# uppdatera och gå till nästa bord
	global.results[global.currRound][global.currTable] = res

	updateLongs()

	# Uppdatera GUI för tables kirurgiskt
	trs = document.querySelectorAll '#tables tr'
	tr = trs[global.currTable] # Ska vara NOLL!
	tr5 = tr.children[5-2]

	tr5.textContent = prettyResult res
	global.currTable = (global.currTable + 1) %% tableCount()

setScreen = (letter) ->
	global.currScreen = letter

	if letter == 'A' then showPlayers()
	if letter == 'B' then showTables()
	if letter == 'C' then showNames()

	hdr = document.getElementById 'hdr'
	hdr.innerHTML = ''

	menu = koppla 'header', hdr, {class: "menu no-print", style: "position:fixed"}
	
	# två underbehållare
	leftZone  = koppla 'div', menu, {class: 'zone left'}
	rightZone = koppla 'div', menu, {class: 'zone right'}

	setMenuZone "ABC", leftZone
	setMenuZone letter, rightZone

	spacer = koppla 'div', hdr, {class: "no-print", style: "height:1px;"}

	h3 = koppla 'h3', hdr
	if letter == 'A' then h3.textContent = "Standings for " + settings.TITLE
	if letter == 'B' then h3.textContent = "Tables round #{global.currRound + settings.ONE} for #{settings.TITLE}"
	if letter == 'C' then h3.textContent = "Names round #{global.currRound + settings.ONE} for #{settings.TITLE}"

	document.getElementById('players').style.display = if letter == 'A' then 'flex' else 'none'
	document.getElementById('tables').style.display  = if letter == 'B' then 'flex' else 'none'
	document.getElementById('names').style.display   = if letter == 'C' then 'flex' else 'none'

showHelp = -> window.open "help.html","_self"

showInfo = (message) -> # Visa helpText på skärmen
	pre = document.getElementById 'info'
	pre.className = "help"
	pre.innerHTML = message

showMatrix = -> # Visa matrisen Alla mot alla. Dot betyder: inget möte

	lines = []

	SPACING = ' '
	n = global.players.length
	if n > ALFABET.length then n = ALFABET.length
	if global.frirond then n -= 1

	lines.push '    ' + (ALFABET[i] for i in range n).join SPACING
	for i in range n
		line = global.fairpair.matrix[i].slice 0,n
		lines.push ALFABET[i] + '   ' + line.join(SPACING) + '   ' + global.players[i].elo  # + ' ' + Math.round global.players[i].summa

	content = lines.join "\n"

	downloadFile 'matrix.txt', content


showNames = ->
	persons = []
	for [w,b],i in global.rounds[global.currRound]
		pw = [global.players[w].name, "#{i + settings.ONE} • W"]
		pb = [global.players[b].name, "#{i + settings.ONE} • B"]
		if pw[0] == BYE 
			pb[1] = BYE
			persons.push pb
		else if pb[0] == BYE
			pw[1] = BYE
			persons.push pw
		else
			persons.push pw
			persons.push pb

	persons.sort()

	groups = myChunk persons,settings.C

	container = document.getElementById 'names'
	container.innerHTML = '' # rensa
	container.className = 'groups'

	groups.forEach (group) =>
		tabell = koppla 'table', container, {class:'group'}
		thead = koppla 'thead', tabell
		koppla 'th', thead, {text:"Name"}
		koppla 'th', thead, {text:"Table"}

		group.forEach (p) => 
			tr1 = koppla 'tr',tabell
			td1 = koppla 'td',tr1, {style: "text-align:left",   text:p[0]}
			td2 = koppla 'td',tr1, {style: "text-align:center", text:p[1]}

showPlayers = -> # Visa spelarlistan.

	for player,i in global.players
		player.update_P_and_PR global.longs,i

	sortedPlayers = _.clone global.players

	# Tag bort BYE om den finns.
	if global.frirond != null then memory = _.first _.remove sortedPlayers, (item) -> item.name == BYE

	sortedPlayers.sort (a, b) =>
		if global.currSort == '#' then return a.id - b.id
		if global.currSort == 'N' then return a.name.localeCompare b.name, "sv"
		if global.currSort == 'E' then return b.elo - a.elo
		if global.currSort == 'P' then return b.P - a.P 
		if global.currSort == 'R' then return b.PR - a.PR

	groups = myChunk sortedPlayers, settings.A
	# if _.last(groups).length == 1 and _.last(groups)[0].name == BYE then groups.pop()
	container = document.getElementById 'players'
	container.innerHTML = ''
	container.className = 'groups'

	offset = 0
	groups.forEach (group) =>
		tabell = koppla 'table', container, {class:'group'}
		thead = koppla 'thead', tabell
		koppla 'th', thead, {text:"#", class: 'clickableCols' }
		koppla 'th', thead, {text:"Name", class: 'clickableCols'}
		koppla 'th', thead, {text:"Elo", class: 'clickableCols'}

		for i in range global.rounds.length
			koppla 'th', thead, {text:"#{i + settings.ONE}", class: 'clickableCols'}

		koppla 'th', thead, {text:"P", class: 'clickableCols'}
		koppla 'th', thead, {text:"n"}
		koppla 'th', thead, {text:"sc"}
		koppla 'th', thead, {text:"avg"}
		koppla 'th', thead, {text:"PR", class: 'clickableCols'}

		group.forEach (player) =>
			n = player.elos.length
			if player.name == BYE then return
			tr = koppla 'tr', tabell, {style:"height: 28px"} # 27 ger ojämna höjder
			koppla 'td', tr, {text: player.id + settings.ONE}
			koppla 'td', tr, {style:"text-align:left", text: player.name} # .slice 0,20
			koppla 'td', tr, {text: player.elo}

			long = global.longs[player.id]
			roundsContent long, player.id, tr

			for i in range long.length, global.rounds.length
				koppla 'td', tr, {style:"text-align:left" , 'x'}

			koppla 'td', tr, {style:"text-align:right", text: player.P.toFixed 1}
			koppla 'td', tr, style:"text-align:center", text: n
			if n > 0
				koppla 'td', tr, {style:"text-align:right" , text: (player.P / n).toFixed 3}
				koppla 'td', tr, {style:"text-align:right" , text: player.avg.toFixed 1}
				koppla 'td', tr, {style:"text-align:right" , text: player.PR.toFixed settings.DECIMALS}
			else
				koppla 'td', tr, {style:"text-align:right" , text: ""}
				koppla 'td', tr, {style:"text-align:right" , text: ""}
				koppla 'td', tr, {style:"text-align:right" , text: ""}

		offset += group.length # settings.A

	createSortEvents()

showTables = -> # Visa bordslistan
	if global.rounds.length == 0 then return
	round = global.rounds[global.currRound]

	groups = myChunk round, settings.B

	container = document.getElementById 'tables'
	container.innerHTML = ''
	container.className = 'groups'

	offset = 0
	groups.forEach (group) =>
		tabell = koppla 'table', container, {class:'group clickableRows'}
		thead = koppla 'thead', tabell
		for rubrik in "Table White Elo Result Elo Black".split ' '
			koppla 'th', thead, {text:rubrik}

		group.forEach ([w,b],iTable) =>
			tabell.appendChild addBord offset + iTable, global.results[global.currRound][offset + iTable], w,b
		offset += group.length #settings.B

tableCount = -> global.players.length // 2 # Beräkna antal bord

updateLongs = -> # Uppdaterar longs utifrån rounds och results
	global.longs = (longForm global.rounds[r],global.results[r] for r in range global.rounds.length)
	global.longs = _.zip ...global.longs # transponerar matrisen

main = -> # Hämta urlen i första hand, textarean i andra hand.

	params = new URLSearchParams window.location.search

	if params.size == 0 
		initialization = new initialize()
		document.getElementById("clear").addEventListener "click", clear
		document.getElementById("help").addEventListener "click", showHelp
		document.getElementById("continue").addEventListener "click", init
		return

	parseURL()

	if global.players.length < 4
		showInfo "You must have four or more players!"
		return

	fairpairFlag = settings.ROUNDS <= global.players.length // 2
	global.rounds = makeFairPair()
	global.rounds = expand settings.GAMES, global.rounds

	for i in range settings.ROUNDS
		global.results.push Array(tableCount()).fill 'x'

	readResults params
	setByeResults()
	updateLongs()
	setScreen 'A'
	setCursor() # global.currRound,global.currTable
	document.title = settings.TITLE

	document.addEventListener 'keydown', (event) -> # Hanterar alla tangenttryckningar
		return if event.ctrlKey or event.metaKey or event.altKey # förhindrar att ctrl p sorterar på poäng
		if event.key in ['ArrowDown','ArrowUp',' '] then event.preventDefault()
		handleKey event.key

		# tvinga bordet att synas
		if global.currScreen == 'B'
			rad = document.querySelectorAll("#tables table tr")[global.currTable]
			rad.scrollIntoView { behavior: "smooth", block: "center" }

main()
