echo = console.log

# html = (tag, first, args...) ->
# 	if typeof first is 'object' and not Array.isArray first
# 		attrs = Object.entries(first).map(([k, v]) -> "#{k}='#{v}'").join ' '
# 		content = args.join ''
# 	else
# 		attrs = ''
# 		content = [first, args...].join ''
# 	openTag = if attrs then "<#{tag} #{attrs}>" else "<#{tag}>"
# 	"#{openTag}#{content}</#{tag}>"

# table = (args...) -> html 'table', args...
# tr    = (args...) -> html 'tr',    args...
# td    = (args...) -> html 'td',    args...
# span  = (args...) -> html "span",  args...
# table = (args...) -> html "table", args...
# th    = (args...) -> html "th",    args...
# a     = (args...) -> html "a",     args...
# strong= (args...) -> html "strong",args...
# div   = (args...) -> html "div",   args...

formatPGN = ->
	ctrlA = document.getElementById "pgn-input"
	ctrlB = document.getElementById "knapp"
	ctrlA.hidden = true
	ctrlB.hidden = true
	createChessTables parsePGN ctrlA.value

fetch = (pgn, move, offset, start, stopp) ->
	a = offset + move.toString().length
	p = pgn.indexOf start
	q = pgn.indexOf stopp
	if p == -1 then return {} #['','','']
	if q == -1 then q = pgn.length
	pretty pgn.substring p+a,q

extract = (raw, result, start, stopp) -> 
	p = raw.indexOf start
	q = raw.indexOf stopp
	result.eval = raw.substring p+start.length,q
	echo result.eval
	# echo 'left',raw.substring(0,p)
	# echo 'right',raw.substring(q+3)
	return raw.substring(0,p) + raw.substring(q+stopp.length)

pretty = (raw) ->
	result = {}
	# echo raw
	raw = extract raw, result, "{ [%eval ","] }"

	# if "{" not in raw
	# 	return [raw.trim(),'','']

	arr = raw.split ' '
	echo arr
	move = arr[0]
	if "Inaccuracy." == arr[3] 
		result.drag = arr[0]
		result.betyg = ' • '
		result.best = arr[4]
		return result
		# return [move, ' • ',   arr[4]]
	if "Mistake."    == arr[3]
		result.drag = arr[0]
		result.betyg = ' •• '
		result.best = arr[4]
		return result
		# return [move, ' •• ',  arr[4]]
	if "Blunder."    == arr[3] 
		result.drag = arr[0]
		result.betyg = ' ••• '
		result.best = arr[4]
		return result
		# return [move, ' ••• ', arr[4]]
	if "Checkmate"   == arr[3] 
		result.drag = arr[0]
		result.betyg = ' ••• '
		result.best = arr[7]
		return result
		# then return [move, ' ••• ', arr[7]]
	if "checkmate"   == arr[5] 
		result.drag = arr[0]
		result.betyg = ' ••• '
		result.best = arr[7]
		return result
		# then return [move, ' ••• ', arr[7]]

	result.drag = arr[0]
	result.betyg = ''
	result.best = ''
	result

# echo ["d5",""], pretty "d5  "
# pretty "Bh5  { Inaccuracy. Bxf3 was best. }  " => ["Bh5","• (Bxf3)"]

fetch = (pgn, move, offset, start, stopp) ->
	a = offset + move.toString().length
	p = pgn.indexOf start
	q = pgn.indexOf stopp
	if p == -1 then return {} #['','','']
	if q == -1 then q = pgn.length
	pretty pgn.substring p+a,q

splitMoves = (pgn) ->
	arr = []
	move = 1
	while move < 20
		w = fetch pgn, move, 2, move + '.', move + '...'
		if w.length == 0 then break else arr.push w

		b = fetch pgn, move, 4, move + '...', (move+1) + '.'
		if b.length == 0 then break else arr.push b

		echo 'splitMoves',w

		move++
	echo arr
	arr

removeParenthesis = (pgn, left,right) ->
	result = ""
	level = 0
	for ch in pgn
		if ch == left then level++
		else if ch == right then level--
		else if level == 0 then result += ch
	result

tabell = (arr) ->

	n = arr.length
	
	for i in [0...160 - n % 160]
		arr.push ['','','']

	result = []
	n = arr.length # antal ply
	echo n
	for i in [0...n/2]
		index = 2*i
		[c,b,a] = if index   < n then arr[index]   else ['','','']
		[d,e,f] = if index+1 < n then arr[index+1] else ['','','']
		result.push [a,b,c,1+i,d,e,f]
	result

getHeader = (pgn) ->
	arr = pgn.split '\n'
	attrs = {}
	result = ""
	attrs.Event = ""
	attrs.Date = ""
	attrs.Site = ""
	attrs.TimeControl = ""
	attrs.FEN = ""
	attrs.WhiteElo = ""
	attrs.White = ""
	attrs.BlackElo = ""
	attrs.Black = ""
	attrs.Result = ""

	for i in [0...arr.length]
		line = arr[i].trim()
		if line == '' then break
		p = line.indexOf ' '
		name = line.substring 1,p
		value = line.substring p+2,line.length-2
		attrs[name] = value

	site = "<a href=#{attrs.Site}>Lichess</a>"
	"#{attrs.Event} #{attrs.Date} #{site} #{attrs.FEN} #{attrs.White} #{attrs.WhiteElo} vs #{attrs.BlackElo} #{attrs.Black} #{attrs.Result}<br><br>"

createChessTables = (arr) ->
	rowsPerTable = 40  # Antal rader per tabell
	totalRows = arr.length # Totalt antal rader
	headers = ["Nr", "Eval", "Vit", "W", "B", "Svart", "Eval"]

	tableCount = Math.ceil(totalRows / rowsPerTable)
	echo 'tableCount',tableCount

	container = document.createElement "div"
	container.className = "table-container"

	for t in [0...tableCount]
		table = document.createElement "table"
		table.border = "1"
		table.className = "chessTable"

		# Skapa rubrikrad
		headerRow = document.createElement "tr"
		for header in headers
			th = document.createElement "th"
			th.innerText = header
			headerRow.appendChild th
			table.appendChild headerRow

		# Skapa rader
		for i in [0...rowsPerTable]
			rowIndex = t * rowsPerTable + i
			continue if rowIndex >= totalRows # return

			tr = document.createElement "tr"
			move = arr[rowIndex % arr.length] or ["", "", "", "", "", "", ""]

			newMove = [move[3],move[1],move[2],move[0],move[6],move[4],move[5]]

			for j in [0...headers.length]
				td = document.createElement "td"
				td.innerText = newMove[j]
				tr.appendChild td
			table.appendChild tr

		container.appendChild table

	document.body.appendChild container

parsePGN = (pgn) -> 
	div  = document.createElement "div"
	div.innerHTML = getHeader pgn
	document.body.appendChild div

	pgn = removeParenthesis pgn,'(',')'
	# pgn = removeParenthesis pgn,'[',']'
	pgn = pgn.replaceAll '{  }',''
	pgn = pgn.replaceAll '??',''
	pgn = pgn.replaceAll '?!',''
	pgn = pgn.replaceAll '?',''
	pgn = pgn.replaceAll '0-1',''
	pgn = pgn.replaceAll '1/2-1/2',''
	pgn = pgn.replaceAll '1-0',''
	pgn = pgn.replaceAll '*',''

	echo pgn

	tabell splitMoves pgn
