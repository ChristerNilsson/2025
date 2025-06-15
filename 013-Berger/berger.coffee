echo = console.log

#DOMAIN = "http://127.0.0.1:5500"
DOMAIN = "https://christernilsson.github.io/2025/013-Berger"

MAX = 2
RESULTS = '012'

players = []
rounds = []
results = []

sorteringsOrdning = {}	# Spara per kolumn

skapaSorteringsklick = ->

	ths = document.querySelectorAll '#bergertabell th'

	echo ths 
	index = -1
	for th in ths
		index += 1
		do (th,index) ->
			th.addEventListener 'click', (event) ->
				key = th.textContent
				if key in '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20'.split ' '
					key = parseInt(key) - 1 
					showTables rounds[key] or [], key
					return

				tbody = document.querySelector '#bergertabell tbody'
				rader = Array.from tbody.querySelectorAll 'tr'
				if key of sorteringsOrdning
					sorteringsOrdning[key] = -sorteringsOrdning[key]	
				else
					sorteringsOrdning[key] = index + 1
				stigande = sorteringsOrdning[key] > 0

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

	title = safeGet params, "title"
	MAX = parseInt safeGet params, "MAX", "2"
	RESULTS = '012345678'.slice 0, MAX + 1
	
	players = []
	for i in [1..20]
		p = safeGet params, "p#{i}", ""
		if p == "" then break
		elo = parseInt p.slice 0,4
		name = p.slice(4).trim()
		players.push {elo, name, index: i - 1}
	echo players

	results = []
	for i in [1..players.length - 1]
		results.push safeGet params, "r#{i}", "x" * players.length / 2

	{players, results, title}

savePairing = (r, A, half, n) ->
	lst = if r % 2 == 1 then [[A[n - 1], A[0]]] else [[A[0], A[n - 1]]]
	for i in [1...half]
		lst.push [A[i], A[n - 1 - i]]
	lst

makeBerger = (n) ->
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

showHelp = ->
	url = []
	url.push "#{DOMAIN}/?title=Joukos Sommar 2025"
	url.push "&MAX=2"
	url.push "&p1=1698 Onni Aikio"
	url.push "&p2=1558 Helge Bergström"
	url.push "&p3=1549 Jonas Hök"
	url.push "&p4=1679 Lars Johansson"
	url.push "&p5=0000 Per Eriksson"
	url.push "&p6=1653 Christer Nilsson"
	url.push "&p7=1673 Per Hamnström"
	url.push "&p8=1504 Thomas Paulin"
	url.push "&p9=1706 Abbas Razavi"
	url.push "&p10=1579 Jouko Liistamo"
	url.push "&r1=202x2"
	url.push "&r2=01020"
	url.push "&r3=20022"
	url.push "&r4=20002"
	url.push "&r5=02222"
	url.push "&r7=xx2xx"

	help = document.createElement 'div'
	help.className = 'help'
	help.innerHTML = "<p>Exempel:</p><pre>#{url.join "\n"}</pre>"
	document.getElementById('berger').appendChild help

	link = document.createElement 'a'
	link.href = url.join ''
	link.text = "Exempel"
	document.getElementById('berger').appendChild link

showBerger = (title, points) ->
	h2 =  document.createElement 'h2'
	h2.textContent = title
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
		row.insertCell().textContent = p.elo

		for r in [0...rounds.length]
			cell = row.insertCell()
			tableIndex = rounds[r].findIndex(([w, b]) -> w == i or b == i)
			if tableIndex == -1 then continue
			result = results[r]?[tableIndex] or ""
			result = result.replace "x", ""

			[w, b] = rounds[r][tableIndex]
			opponent = if w == i then b else w
			if result in RESULTS and players[opponent].elo != 0 then oppElos.push players[opponent].elo

			if i == b and result != "" then result = MAX - parseInt result

			if i == w then a = "right:-7px" else a = "left:-7px"

			html = ""
			html += "<div style='position:absolute; top:-17px; #{a}; font-size:0.7em;'>#{opponent + 1}</div>"
			html += "<div style='position:absolute; top:-4px;        font-size:1.0em;'>#{result}</div>"
			cell.innerHTML = "<div style='position:relative;'>" + html + "</div>"

		cell = row.insertCell()
		cell.textContent = points[i]
		cell.style.textAlign = 'right'

		row.insertCell().textContent = performance(points[i]/MAX, oppElos).toFixed 0

prettify = (ch) ->
	if ch in RESULTS then return "#{ch} - #{MAX - ch}"
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

	for i in [0...rounds.length]
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
	{players, results, title} = parseQuery()
	document.title = title

	if players.length < 4
		showHelp()
		return
	rounds = makeBerger(players.length)
	echo rounds
	points = Array(players.length).fill(0)

	for i in [0...results.length]
		res = results[i]
		round = rounds[i]
		for j, [w, b] of round
			if res[j] in RESULTS
				points[w] += parseInt res[j]
				points[b] += MAX - parseInt res[j]

	showBerger title, points
	showTables rounds[0] or [], 0

	skapaSorteringsklick()

main()
