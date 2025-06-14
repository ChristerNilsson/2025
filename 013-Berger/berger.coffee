echo = console.log

# Bergerturnering - CoffeeScript

rotate = (arr, n = 1) ->
	len = arr.length
	n = ((n % len) + len) % len
	arr.slice(n).concat arr.slice(0, n)

parseQuery = ->
	params = new URLSearchParams window.location.search
	players = []
	for i in [1..20]
		p = params.get("p#{i}")
		break unless p?
		match = p.match(/(\d+)\s*(.*)/)
		if match
			elo = parseInt(match[1])
			name = match[2].trim()
			players.push {elo, name, index: i - 1}
	results = []
	for i in [1..players.length - 1]
		r = params.get("r#{i}")
		break unless r?
		results.push r
	selectedRound = parseInt(params.get("r")) - 1 or 0
	{players, results, selectedRound}

makeBerger = (n) ->
	rounds = []
	list = [0...n]
	if n % 2 == 1
		list.push null
		n += 1
	fixed = list[0]
	rotating = list[1..]
	for r in [0...n - 1]
		current = [fixed].concat rotate(rotating, r)
		round = []
		half = n / 2
		for i in [0...half]
			a = current[i]
			b = current[n - 1 - i]
			if a? and b?
				if i == 0
					if r % 2 == 0 then round.push [a, b] else round.push [b, a]
				else
					if i % 2 == 0 then round.push [a, b] else round.push [b, a]
		rounds.push round
	echo 'makeBerger', rounds
	rounds

showHelp = ->
	url  = "?p1=1698 Onni Aikio"
	url += "&p2=1558 Helge Bergström"
	url += "&p3=1549 Jonas Hök"
	url += "&p4=1679 Lars Johansson"
	url += "&p5=0000 Per Eriksson"
	url += "&p6=1653 Christer Nilsson"
	url += "&p7=1673 Per Hamnström"
	url += "&p8=1504 Thomas Paulin"
	url += "&p9=1706 Abbas Razavi"
	url += "&p10=1579 Jouko Liistamo"
	url += "&r1=11111"
	url += "&r2=00000"
	url += "&r3=rrrrr"

	help = document.createElement 'div'
	help.className = 'help'
	help.innerHTML = "<p>Exempel:</p><code>#{url}</code>"
	document.getElementById('berger').appendChild help

	link = document.createElement 'a'
	link.href = url
	link.text = "Exempel"
	document.getElementById('berger').appendChild link

showBerger = (players, rounds, results, points) ->
	tbl = document.createElement 'table'
	header = tbl.insertRow()
	header.innerHTML = '<th>#</th><th>Namn</th><th>Elo</th>'
	for i in [0...rounds.length]
		cell = document.createElement 'th'
		cell.textContent = "#{i+1}"
		do (i) ->
			cell.addEventListener 'click', ->
				echo "Du klickade på rond #{i+1}"
				showTables rounds[i] or [], players, i

		header.appendChild cell
	cell = document.createElement 'th'
	cell.textContent = "Poäng"
	header.appendChild cell

	for p, i in players
		row = tbl.insertRow()
		row.insertCell().textContent = i + 1
		
		cell = row.insertCell()
		cell.textContent = p.name
		cell.style.textAlign = 'left'

		row.insertCell().textContent = p.elo
		for r in [0...rounds.length]
			cell = row.insertCell()
			tableIndex = rounds[r].findIndex(([w, b]) -> w == i or b == i)
			if tableIndex == -1 then continue
			[w, b] = rounds[r][tableIndex]
			opponent = if w == i then b else w
			#color = if w == i then '' else '*'
			result = results[r]?[tableIndex] or ""
			result = result.replace "r", "½"
			result = result.replace "x", ""

			if i == b and result != "" and result != "½"
				result = if result=='0' then '1' else '0'

			if i == w then a = "right:-7px" else a = "left:-7px"

			html = ""
			html += "<div style='position:absolute; top:-17px;      #{a}; font-size:0.7em;'>#{opponent + 1}</div>"
			html += "<div style='position:absolute; top:-4px;  left:-2px; font-size:1.0em;'>#{result}</div>"
			cell.innerHTML = "<div style='position:relative;'>" + html + "</div>"

		row.insertCell().textContent = points[i]
	document.getElementById('berger').appendChild tbl

showTables = (rounds, players, selectedRound) ->
	if rounds.length == 0 then return

	title = document.createElement 'h2'
	title.textContent = "Bordslista för rond #{selectedRound+1}"
	document.getElementById('tables').innerHTML = ''
	document.getElementById('tables').appendChild title

	table = document.createElement 'table'
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
		td.textContent = "-"
		td.style.align = 'center'
		td.width = "50px"
		tr.appendChild td

		table.appendChild tr
	document.getElementById('tables').appendChild table

main = ->
	document.title = "Joukos sommarturnering 2025"

	{players, results, selectedRound} = parseQuery()

	echo players
	echo results
	echo selectedRound

	if players.length < 4
		showHelp()
		return
	rounds = makeBerger(players.length)
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

	showBerger players, rounds, results, points
	showTables rounds[selectedRound] or [], players, selectedRound
	
main()
