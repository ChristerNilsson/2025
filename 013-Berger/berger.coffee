echo = console.log

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

safeGet = (params,key) -> if params.get key then params.get key else params.get ' ' + key

parseQuery = ->
	params = new URLSearchParams window.location.search

	# echo params.toString()
	# echo window.location.search

	title = safeGet params, "title"
	
	players = []
	for i in [1..20]
		p = safeGet params, "p#{i}"
		if not p? then break
		elo = parseInt p.slice 0,4
		name = p.slice(4).trim()
		players.push {elo, name, index: i - 1}

	results = []
	for i in [1..players.length - 1]
		r = safeGet params, "r#{i}"
		results.push if r? then r else "x" * players.length / 2
	{players, results, title}

savePairing = (r, A, half, n) ->
	lst = if r % 2 == 1 then [[A[n - 1], A[0]]] else [[A[0], A[n - 1]]]
	for i in [1...half]
		lst.push [A[i], A[n - 1 - i]]
	lst

makeKarpidisBerger = (n) ->
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
	url.push "http://127.0.0.1:5500/?title=Joukos Sommar 2025"
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
	url.push "&r1=101x1"
	url.push "&r2=0r010"
	url.push "&r3=10011"
	url.push "&r4=10001"
	url.push "&r5=01111"
	url.push "&r7=xx1xx"

	help = document.createElement 'div'
	help.className = 'help'
	help.innerHTML = "<p>Exempel:</p><pre>#{url.join "\n"}</pre>"
	document.getElementById('berger').appendChild help

	link = document.createElement 'a'
	link.href = url.join ''
	link.text = "Exempel"
	document.getElementById('berger').appendChild link

showBerger = (title, players, rounds, results, points) ->
	h2 =  document.createElement 'h2'
	h2.textContent = title
	document.getElementById('berger').appendChild h2

	tbl = document.createElement 'table'
	header = tbl.insertRow()
	header.innerHTML = '<th>#</th><th>Namn</th><th>Elo</th>'
	for i in [0...rounds.length]
		cell = document.createElement 'th'
		cell.textContent = "#{i+1}"
		do (i) ->
			cell.addEventListener 'click', ->
				echo "Du klickade på rond #{i+1}"
				showTables rounds[i] or [], players, i, results

		header.appendChild cell
	cell = document.createElement 'th'
	cell.textContent = "Poäng"
	header.appendChild cell

	cell = document.createElement 'th'
	cell.textContent = "PR"
	header.appendChild cell

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
			#color = if w == i then '' else '*'
			result = results[r]?[tableIndex] or ""
			result = result.replace "r", "½"
			result = result.replace "x", ""

			[w, b] = rounds[r][tableIndex]
			opponent = if w == i then b else w
			if result in '0½1' and players[opponent].elo != 0 then oppElos.push players[opponent].elo

			if i == b and result != "" and result != "½"
				result = if result=='0' then '1' else '0'

			if i == w then a = "right:-7px" else a = "left:-7px"

			html = ""
			html += "<div style='position:absolute; top:-17px;			#{a}; font-size:0.7em;'>#{opponent + 1}</div>"
			html += "<div style='position:absolute; top:-4px;	left:-2px; font-size:1.0em;'>#{result}</div>"
			cell.innerHTML = "<div style='position:relative;'>" + html + "</div>"

		row.insertCell().textContent = points[i].toFixed 1
		row.insertCell().textContent = performance(points[i], oppElos).toFixed 0
	document.getElementById('berger').appendChild tbl

prettify = (ch) ->
	if ch=='1' then return "1 - 0"
	if ch=='0' then return "0 - 1"
	if ch=='r' then return "½ - ½"
	"-"

showTables = (rounds, players, selectedRound, results) ->
	if rounds.length == 0 then return

	title = document.createElement 'h2'
	title.textContent = "Bordslista för rond #{selectedRound+1}"
	document.getElementById('tables').innerHTML = ''
	document.getElementById('tables').appendChild title

	table = document.createElement 'table'

	header = table.insertRow()
	header.innerHTML = '<th>Bord</th><th>Vit</th><th>Svart</th><th>Resultat</th>'

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
	rounds = makeKarpidisBerger(players.length)
	echo rounds
	points = Array(players.length).fill(0)

	for i in [0...results.length]
		res = results[i]
		round = rounds[i]
		for j, [w, b] of round
			val = res[j] or ''
			switch val
				when '1' then points[w] += 1
				when '0' then points[b] += 1
				when 'r' then points[w] += 0.5; points[b] += 0.5

	showBerger title, players, rounds, results, points
	showTables rounds[0] or [], players, 0, results

main()
