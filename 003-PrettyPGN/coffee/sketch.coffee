echo = console.log

span  = (s,attrs="") -> "<span #{attrs}>#{s}</span>"
table = (s,attrs="") -> "<table #{attrs}>\n#{s}</table>"
tr    = (s,attrs="") -> "<tr #{attrs}>#{s}</tr>\n"
td    = (s,attrs="") -> "<td #{attrs}>#{s}</td>"
th    = (s,attrs="") -> "<th #{attrs}>#{s}</th>"
a     = (s,attrs="") -> "<a #{attrs}>#{s}</a>"
strong= (s) -> "<strong>#{s}</strong>"

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

removeParenthesis = (pgn) ->
	result = ""
	level = 0
	for ch in pgn
		if ch == '(' then level++
		else if ch == ')' then level--
		else if level == 0 then result += ch
	result

removeEval = (pgn) ->
	result = ""
	level = 0
	for ch in pgn
		if ch=='[' then level = level + 1
		else if ch==']' then level = level - 1
		else if level == 0 then result += ch
	result

tabell = (arr,start,stopp) ->
	s = ""
	n = arr.length # antal ply
	echo n,start,stopp
	if start >= n then return ''
	for i in [start/2...stopp/2]
		index = 2*i
		[c,b,a] = if index   < n then arr[index]   else ['','','']
		[d,e,f] = if index+1 < n then arr[index+1] else ['','','']
		t = tr td(a) + td(b) + td(c) + td(strong(1+i)) + td(d) + td(e) + td(f)
		echo i,t
		s += t
	table s, 'class="inner-table"'

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

	site = a "Lichess","href=#{attrs.Site}"
	"#{attrs.Event} #{attrs.Date}<br>#{site}<br> FEN: #{attrs.FEN}<br> White: #{attrs.WhiteElo} #{attrs.White}<br>Black: #{attrs.BlackElo} #{attrs.Black}<br>#{attrs.Result}"

parsePGN = (pgn) -> 
	header = getHeader pgn
	echo header
	pgn = removeParenthesis(pgn)
	pgn = removeEval pgn
	pgn = pgn.replaceAll '{  }',''
	pgn = pgn.replaceAll '??',''
	pgn = pgn.replaceAll '?!',''
	pgn = pgn.replaceAll '?',''
	pgn = pgn.replaceAll '0-1',''
	pgn = pgn.replaceAll '1/2-1/2',''
	pgn = pgn.replaceAll '1-0',''
	pgn = pgn.replaceAll '*',''
	arr = splitMoves pgn
	echo 'arr',arr

	a0 = tabell arr, 0,80  # klarar 40 drag
	if arr.length > 80 then a1 = tabell arr, 80,160 else a1 = ""
	a2 = tabell arr, 160,240 # klarar 40 till

	echo 'a0',a0
	echo 'a1',a1
	echo 'a2',a2

	gap = td "", 'style="width:10px"'

	table(tr(td(header, 'colspan="5" style="text-align:left"')) + tr(td(a0) + gap + td(a1) + gap + td(a2)), 'class="outer-table"')