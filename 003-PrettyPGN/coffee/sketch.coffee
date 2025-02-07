echo = console.log

formatPGN = ->
	input = document.getElementById("pgn-input").value
	output = parsePGN(input)
	document.getElementById("xoutput").innerHTML = output

pretty = (raw) ->
	if "{" not in raw then return [raw.trim(),""]
	arr = raw.split ' '
	move = arr[0]
	echo arr
	if "Inaccuracy." == arr[3] then return [move, '• ' + arr[4]]
	if "Mistake." == arr[3] then return [move, '•• ' + arr[4]]
	if "Blunder." == arr[3] then return [move, '••• ' + arr[4]]
	if "Checkmate" == arr[3] then return [move, '••• ' + arr[7]]
	if "checkmate" == arr[5] then return [move, '••• ' + arr[7]]
	[move,'']
# echo ["d5",""], pretty "d5  "
# pretty "Bh5  { Inaccuracy. Bxf3 was best. }  " => ["Bh5","• (Bxf3)"]

splitMoves = (pgn) ->
	arr = []
	move = 1 
	while move < 71
		a = 2 + move.toString().length
		p = pgn.indexOf move + '. '
		q = pgn.indexOf move + '... '
		r = pgn.indexOf (move+1) + '. '
		b = 4 + (move+1).toString().length
		araw = pgn.substring(p+a,q)
		braw = pgn.substring(q+b,r)
		if '{' not in araw then ax = ""
		if '{' not in braw then bx = ""
		arr.push [move].concat(pretty(araw)).concat(pretty(braw))
		move += 1
	arr

removeParenthesis = (pgn, left, right) ->
	result = ""
	level = 0
	for ch in pgn
		if ch==left then level = level + 1
		else if ch==right then level = level - 1
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

parsePGN = (pgn) -> 
	pgn = removeParenthesis(pgn,'(', ')')
	pgn = removeEval pgn
	pgn = pgn.replaceAll '{  }',''
	pgn = pgn.replaceAll '??',''
	pgn = pgn.replaceAll '?!',''
	pgn = pgn.replaceAll '?',''
	arr = splitMoves pgn
	s = ""
	for [a,b,c,d,e] in arr
		s += "<tr><td>#{a}</td><td>#{b}</td><td>#{c}</td><td>#{d}</td><td>#{e}</td></tr>"
	'<table>' + s + "</table>"
