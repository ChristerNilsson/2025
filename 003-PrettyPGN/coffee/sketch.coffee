echo = console.log

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
		b = fetch pgn, move, 4, move + '...', (move+1) + '.'
		arr.push w
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
	#arr = arr.slice start,stopp
	i = start/2
	while i < stopp/2 # moves
		[a,b,c] = ['','','']
		[d,e,f] = ['','','']
		if 2*i < n then [c,b,a] = arr[2*i]
		if 2*i+1 < n then [d,e,f] = arr[2*i+1]
		s += "<tr><td>#{a}</td><td>#{b}</td><td>#{c}</td><td><strong>#{1+i}</strong></td><td>#{d}</td><td>#{e}</td><td>#{f}</td></tr>"
		i++ 
	'<table class="inner-table">' + s + '</table>'

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
	"#{attrs.Event} #{attrs.Date}<br>Site: #{attrs.Site}<br> FEN: #{attrs.FEN}<br> White: #{attrs.WhiteElo} #{attrs.White}<br>Black: #{attrs.BlackElo} #{attrs.Black}<br>#{attrs.Result}"

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

	a = tabell arr, 0,80
	b = tabell arr, 80,160
	
	"<table class=\"outer-table\"><tr><td style=\"text-align:left\">#{header}</td></tr><tr><td>#{a}</td><td style=\"width:20px\"></td><td>#{b}</td></tr></table>"
