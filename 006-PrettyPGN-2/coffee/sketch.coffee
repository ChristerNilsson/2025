import { Chess } from 'https://cdn.jsdelivr.net/npm/chess.js@0.13.4/+esm'

echo = console.log

chess = new Chess()
	
chess.load_pgn("1. c4 { [%eval 0.12] [%eval 0.12] } 1... e5 { [%eval 0.12] [%eval 0.12] } 2. Nc3 { [%eval 0.04] [%eval 0.04] } 2... Nf6 { [%eval 0.12] [%eval 0.12] } 3. Nf3 { [%eval 0.1] [%eval 0.1] } 3... e4 { [%eval 0.47] [%eval 0.47] } 4. Ng5 { [%eval 0.32] [%eval 0.32] } 4... d5?! { [%eval 0.94] } { Inaccuracy. c6 was best. } { Inaccuracy. c6 was best. } { [%eval 0.94] } (4... c6 5. Qa4 Qe7 6. Qc2 b5 7. cxb5 d5 8. e3 h6 9. Nh3) 5. cxd5 { [%eval 0.96] [%eval 0.96] } 5... Nxd5 { [%eval 0.94] [%eval 0.94] } 6. Qa4+ { [%eval 1.0] [%eval 1.0] } 6... c6 { [%eval 0.92] [%eval 0.92] } 7. Nxd5 { [%eval 0.69] [%eval 0.69] } 7... Qxd5 { [%eval 0.77] [%eval 0.77] } 8. Qxe4+ { [%eval 0.84] [%eval 0.78] } 8... Qxe4 { [%eval 0.85] [%eval 0.97] } 9. Nxe4 { [%eval 0.9] [%eval 0.92] } 9... f5 { [%eval 0.94] [%eval 0.94] } 10. Ng5 { [%eval 0.96] [%eval 0.87] } 10... Be7 { [%eval 0.99] [%eval 1.03] } 11. Nf3 { [%eval 0.73] [%eval 0.65] } 11... Bf6 { [%eval 0.98] [%eval 1.01] } 12. d4 { [%eval 0.92] [%eval 1.05] } 12... Be6?! { [%eval 1.5] } { Inaccuracy. c5 was best. } { [%eval 1.51] } (12... c5) 13. Bg5 { [%eval 1.44] [%eval 1.48] } 13... Rf8 { [%eval 1.72] [%eval 1.74] } 14. e3 { [%eval 1.62] [%eval 1.64] } 14... Nd7 { [%eval 1.71] [%eval 1.84] } 15. Bd3 { [%eval 1.51] [%eval 1.55] } 15... h6 { [%eval 1.7] [%eval 1.77] } 16. Bxf6 { [%eval 1.7] [%eval 1.77] } 16... Rxf6 { [%eval 1.57] [%eval 1.72] } 17. b3 { [%eval 1.39] [%eval 1.5] } 17... Ke7 { [%eval 1.42] [%eval 1.69] } 18. O-O-O { [%eval 1.25] [%eval 1.4] } 18... g5 { [%eval 1.43] [%eval 1.42] } 19. Nd2 { [%eval 1.41] [%eval 1.46] } 19... b5 { [%eval 1.5] [%eval 1.6] } 20. Rhe1 { [%eval 1.52] [%eval 1.72] } 20... Bd5 { [%eval 1.56] [%eval 1.67] } 21. f3 { [%eval 1.58] [%eval 1.72] } 21... Kf8 { [%eval 2.03] [%eval 2.08] } 22. e4 { [%eval 1.97] [%eval 2.11] } 22... Be6 { [%eval 2.02] [%eval 2.03] } 23. Kb2 { [%eval 1.89] [%eval 1.93] } 23... Nb6?! { [%eval 2.84] } { Inaccuracy. Rd8 was best. } { Inaccuracy. Rd8 was best. } { [%eval 2.95] } (23... Rd8 24. Nf1 (24. exf5)) 24. Rc1 { [%eval 2.73] [%eval 2.92] } 24... Bd7?! { [%eval 3.88] } { Inaccuracy. Rc8 was best. } { Inaccuracy. Rc8 was best. } { [%eval 4.09] } (24... Rc8 25. exf5 Bxf5 26. Bxf5 Rxf5 27. Re6 Rf4 28. Rxh6 Rh4 29. Rg6 Nd5 30. Rxg5) 25. e5 { [%eval 3.81] [%eval 4.15] } 25... Rg6 { [%eval 4.27] [%eval 4.19] } 26. g4 { [%eval 4.15] [%eval 4.34] } 26... Re8?! { [%eval 5.16] } { Inaccuracy. Rg8 was best. } { [%eval 5.61] } (26... Rg8 27. gxf5 Nd5 28. Be4 Nf4 29. b4 a5 30. bxa5 Rxa5 31. Nb3 Ra8 32. f6) 27. gxf5 { [%eval 5.11] [%eval 5.67] } 27... Rg8 { [%eval 5.14] [%eval 5.71] } 28. e6 { [%eval 5.12] [%eval 5.73] } 1-0
")

echo chess
echo chess.moves()

moves = chess.history()
document.getElementById('output').textContent = """
	Läst PGN framgångsrikt!
	Antal drag: #{moves.length}
	Drag: #{moves.join(', ')}
"""
console.log "Schackhistorik:", moves
console.log "Slutposition (FEN):", chess.fen()

echo = console.log

# import {parse} from "https://cdn.jsdelivr.net/npm/@mliebelt/pgn-parser/+esm";

html = (tag, first, args...) ->
	if typeof first is 'object' and not Array.isArray first
		attrs = Object.entries(first).map(([k, v]) -> "#{k}='#{v}'").join ' '
		content = args.join ''
	else
		attrs = ''
		content = [first, args...].join ''
	openTag = if attrs then "<#{tag} #{attrs}>" else "<#{tag}>"
	"#{openTag}#{content}</#{tag}>"

pgnText = ""

table = (args...) -> html 'table', args...
tr    = (args...) -> html 'tr',    args...
td    = (args...) -> html 'td',    args...
span  = (args...) -> html "span",  args...
table = (args...) -> html "table", args...
th    = (args...) -> html "th",    args...
a     = (args...) -> html "a",     args...
strong= (args...) -> html "strong",args...
div   = (args...) -> html "div",   args...

makePly = (ply) ->
	if ply is undefined then return ''
	echo 'in',ply
	s = {}
	s.san = ply.notation.notation
	diag = ply.commentDiag
	s.eval = diag.eval
	s.clk = diag.clk
	s.betyg = 0
	s.best = ''
	comment = diag.comment
	# s.comment = comment
	if comment == undefined then return s
	if comment.includes "Inaccuracy" then s.betyg = 1
	if comment.includes "Mistake" then s.betyg = 2
	if comment.includes "Blunder" then s.betyg = 3
	if comment.includes "Checkmate" then s.betyg = 2
	p = comment.indexOf 'was best'
	if p >= 0
		arr = comment.split ' '
		s.best = arr.slice(-4,-3)[0]
	s

formatPGN = ->
	pgnText = document.getElementById("pgn-input").value
	echo pgnText

document.getElementById("knapp").addEventListener("click", formatPGN);
# document.getElementById("knapp").onclick = formatPGN()"

games = parse pgnText
echo games
# game = games[0]
# if game.tags.FEN == undefined then game.tags.FEN = ""
# echo typeof game.tags.Date
# if typeof game.tags.Date == 'string'
# else
# 	game.tags.Date = game.tags.Date.value

# echo game

# echo game.tags.White
# echo game.tags.WhiteElo
# echo game.tags.Black
# echo game.tags.BlackElo
# echo game.tags.Site
# echo game.tags.Date
# echo game.tags.FEN
# echo game.tags.Result
# # echo game.tags.TimeControl[0].value

# plies = (makePly ply for ply in game.moves)
# echo plies

# container = document.getElementById "output"
# rows = ""
# rows += th {}, "nr"
# rows += th {}, "best"
# rows += th {}, "eval"
# rows += th {}, "white"
# rows += th {}, "black"
# rows += th {}, "eval"
# rows += th {}, "best"
# rows = tr {}, rows

# arrBetyg = ['','•','••','•••']
# for i in [0..plies.length/2]
# 	w = plies[2*i]
# 	b = plies[2*i+1]
# 	s = td {}, i+1
# 	if w != undefined
# 		s += td {}, w.best
# 		s += td {}, arrBetyg[w.betyg]
# 		s += td {}, w.san
# 		# s += td {}, w.clk
# 	if b != undefined
# 		s += td {}, b.san
# 		s += td {}, arrBetyg[b.betyg]
# 		s += td {}, b.best
# 		# s += td {}, b.clk
# 	if w and b then rows += tr {}, s
# rows = table {}, rows
# header = ""
# header += 'White: ' + game.tags.Result[0] + ' ' + game.tags.WhiteElo + ' ' + game.tags.White + '<br>'
# header += 'Black: ' + game.tags.Result[2] + ' ' + game.tags.BlackElo + ' ' + game.tags.Black + '<br>'
# header += "#{game.tags.Date} <a href='#{game.tags.Site}'>#{game.tags.Site}</a>" #<br>" 
# if game.tags.FEN then header += game.tags.FEN  + '<br>'

# container.innerHTML = header + '<br>' + rows
# # container.innerHTML = rows
# echo rows


