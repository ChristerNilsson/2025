echo = console.log

html = (tag, first, args...) ->
	if typeof first is 'object' and not Array.isArray first
		attrs = Object.entries(first).map(([k, v]) -> "#{k}='#{v}'").join ' '
		content = args.join ''
	else
		attrs = ''
		content = [first, args...].join ''

	openTag = if attrs then "<#{tag} #{attrs}>" else "<#{tag}>"
	"#{openTag}#{content}</#{tag}>"

table = (args...) -> html 'table', args...
tr    = (args...) -> html 'tr',    args...
td    = (args...) -> html 'td',    args...
span  = (args...) -> html "span",  args...
table = (args...) -> html "table", args...
th    = (args...) -> html "th",    args...
a     = (args...) -> html "a",     args...
strong= (args...) -> html "strong",args...
div   = (args...) -> html "div",   args...

formatPGN = ->
	ctrlA = document.getElementById "pgn-input"
	ctrlB = document.getElementById "knapp"
	ctrlC = document.getElementById "output"
	ctrlA.hidden = true
	ctrlB.hidden = true
	input = ctrlA.value
	ctrlC.innerHTML = parsePGN input 

pretty = (raw) ->
	if "{" not in raw then return [raw.trim(),'','']
	arr = raw.split ' '
	move = arr[0]
	if "Inaccuracy." == arr[3] then return [move, ' • ',   arr[4]]
	if "Mistake."    == arr[3] then return [move, ' •• ',  arr[4]]
	if "Blunder."    == arr[3] then return [move, ' ••• ', arr[4]]
	if "Checkmate"   == arr[3] then return [move, ' ••• ', arr[7]]
	if "checkmate"   == arr[5] then return [move, ' ••• ', arr[7]]
	[move,'','']
# echo ["d5",""], pretty "d5  "
# pretty "Bh5  { Inaccuracy. Bxf3 was best. }  " => ["Bh5","• (Bxf3)"]

fetch = (pgn, move, offset, start, stopp) ->
	a = offset + move.toString().length
	p = pgn.indexOf start
	q = pgn.indexOf stopp
	if p == -1 then return ['','','']
	if q == -1 then q = pgn.length
	result = pretty pgn.substring p+a,q
	echo result
	result

splitMoves = (pgn) ->
	arr = []
	move = 1 
	while true
		w = fetch pgn, move, 2, move + '.', move + '...'
		if w.join('').length == 0 then break
		arr.push w

		b = fetch pgn, move, 4, move + '...', (move+1) + '.'
		if b.join('').length == 0 then break
		arr.push b

		move++
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
	s = ""
	n = arr.length # antal ply
	for i in [0...n/2]
		index = 2*i
		[c,b,a] = if index   < n then arr[index]   else ['','','']
		[d,e,f] = if index+1 < n then arr[index+1] else ['','','']
		s += tr {}, td a, td b, td c, td strong 1+i, td d, td e, td f
	table {class:"inner-table"}, s

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

	site = a {href:attrs.Site}, "Lichess"
	"#{attrs.Event} #{attrs.Date}<br>#{site}<br> FEN: #{attrs.FEN}<br> White: #{attrs.WhiteElo} #{attrs.White}<br>Black: #{attrs.BlackElo} #{attrs.Black}<br>#{attrs.Result}<br><br>"

parsePGN = (pgn) -> 
	header = getHeader pgn
	pgn = removeParenthesis pgn,'(',')'
	pgn = removeParenthesis pgn,'[',']'
	pgn = pgn.replaceAll '{  }',''
	pgn = pgn.replaceAll '??',''
	pgn = pgn.replaceAll '?!',''
	pgn = pgn.replaceAll '?',''
	pgn = pgn.replaceAll '0-1',''
	pgn = pgn.replaceAll '1/2-1/2',''
	pgn = pgn.replaceAll '1-0',''
	pgn = pgn.replaceAll '*',''
	div {}, header, tabell splitMoves pgn
