echo = console.log

import * as pgnParser from "https://cdn.jsdelivr.net/npm/@mliebelt/pgn-parser/+esm";

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

pgnText = """
[Event "2025: Lars-Ivar Juntti vs Christer Nilsson"]
[Site "https://lichess.org/study/w7W4RA4b/eYjhftdT"]
[Date "2025-03-06"]
[White "Lars-Ivar Juntti"]
[Black "Christer Nilsson"]
[Result "1-0"]
[WhiteElo "1551"]
[BlackElo "1639"]
[Variant "Standard"]
[ECO "B00"]
[Opening "Pirc Defense"]
[Annotator "https://lichess.org/@/ChristerNilsson"]
[StudyName "2025"]
[ChapterName "Lars-Ivar Juntti vs Christer Nilsson"]

1. e4 { [%eval 0.18] } 1... d6 { [%eval 0.43] } 2. d4 { [%eval 0.43] } 2... Nf6 { [%eval 0.43] } 3. Nc3 { [%eval 0.38] } 3... Nc6 { [%eval 0.64] } 4. Nf3 { [%eval 0.51] } 4... a6 { [%eval 0.68] } 5. a3 { [%eval 0.37] } 5... Bg4 { [%eval 0.45] } 6. Be2 { [%eval 0.63] } 6... e5 { [%eval 0.61] } 7. b4?? { [%eval -1.24] } { Blunder. d5 was best. } (7. d5) 7... Bxf3 { [%eval -1.27] } 8. Bxf3 { [%eval -1.23] } 8... Nxd4 { [%eval -1.27] } 9. Be3 { [%eval -1.18] } 9... c5?! { [%eval -0.55] } { Inaccuracy. Nxf3+ was best. } (9... Nxf3+) 10. Nd5 { [%eval -1.01] } 10... Nxd5 { [%eval -0.95] } 11. exd5 { [%eval -1.05] } 11... Qf6?! { [%eval -0.49] } { Inaccuracy. Be7 was best. } (11... Be7) 12. Be4 { [%eval -0.92] } 12... Qh4 { [%eval -0.84] } 13. Qd3?? { [%eval -3.22] } { Blunder. Bd3 was best. } (13. Bd3 c4) 13... g6?? { [%eval -0.82] } { Blunder. c4 was best. } (13... c4 14. g3 cxd3 15. gxh4 Nxc2+ 16. Kd2 Nxa1 17. Rxa1 g6 18. Rc1 Kd7 19. Bxd3) 14. Bxd4?? { [%eval -3.07] } { Blunder. g3 was best. } (14. g3 Qg4 15. h3 Qd7 16. O-O Rc8 17. Qd2 f5 18. Bg2 Bg7 19. bxc5 dxc5) 14... exd4?? { [%eval -0.08] } { Blunder. cxd4 was best. } (14... cxd4 15. Qe2 Bg7 16. O-O f5 17. Bd3 e4 18. g3 Qg5 19. h4 Qe7 20. Rfe1) 15. O-O { [%eval -0.19] } 15... Bh6?! { [%eval 0.42] } { Inaccuracy. b6 was best. } (15... b6) 16. g3 { [%eval 0.01] } 16... Qf6 { [%eval -0.02] } 17. Rad1?! { [%eval -0.92] } { Inaccuracy. bxc5 was best. } (17. bxc5) 17... O-O { [%eval -0.98] } 18. Qf3? { [%eval -2.24] } { Mistake. bxc5 was best. } (18. bxc5) 18... Qe5?? { [%eval -0.28] } { Blunder. Qxf3 was best. } (18... Qxf3) 19. Rfe1 { [%eval -0.29] } 19... Rae8 { [%eval -0.02] } 20. Kg2 { [%eval 0.0] } 20... f5?! { [%eval 0.72] } { Inaccuracy. Bd2 was best. } (20... Bd2 21. Rxd2 f5 22. Rde2 fxe4 23. Qxe4 Qxe4+ 24. Rxe4 Rxe4 25. Rxe4 Rc8 26. bxc5) 21. Bd3 { [%eval 0.55] } 21... Qxe1? { [%eval 1.75] } { Mistake. Qf6 was best. } (21... Qf6 22. bxc5 dxc5 23. a4 Kh8 24. h4 a5 25. Rb1 b6 26. Rxe8 Rxe8 27. Bb5) 22. Rxe1 { [%eval 1.57] } 22... Rxe1 { [%eval 1.48] } 23. h4?? { [%eval -1.11] } { Blunder. bxc5 was best. } (23. bxc5 Re7 24. h4 dxc5 25. d6 Rd7 26. Qd5+ Kh8 27. Qxc5 Rfd8 28. Qb6 Bg7) 23... Bd2?? { [%eval 1.95] } { Blunder. cxb4 was best. } (23... cxb4 24. axb4) 24. bxc5 { [%eval 1.9] } 24... dxc5? { [%eval 3.65] } { Mistake. h5 was best. } (24... h5 25. cxd6 Rf7 26. Be2 Bh6 27. Qd3 Rd7 28. c4 b6 29. c5 bxc5 30. Qxa6) 25. d6 { [%eval 3.68] } 25... b5 { [%eval 4.19] } 26. Qd5+ { [%eval 4.09] } 26... Kg7 { [%eval 4.13] } 27. Qxc5 { [%eval 3.97] } 27... Bc3 { [%eval 4.58] } 28. d7 { [%eval 4.55] } 28... Ba5 { [%eval 4.29] } 29. Qxd4+ { [%eval 4.35] } 29... Kf7 { [%eval 4.63] } 30. c4 { [%eval 4.56] } 30... Re7?! { [%eval 7.14] } { Inaccuracy. Re6 was best. } (30... Re6 31. cxb5 axb5 32. Bxb5 Rf6 33. Bc4+ Kg7 34. Qe5 Bd8 35. a4 h5 36. a5) 31. cxb5 { [%eval 6.98] } 31... axb5 { [%eval 6.94] } 32. Bxb5 { [%eval 6.83] } 32... Rd8 { [%eval 9.58] } 33. Qd5+?! { [%eval 5.59] } { Inaccuracy. Bc4+ was best. } (33. Bc4+ Re6 34. Qe5 Bc7 35. Bxe6+ Ke7 36. Qxc7 h6 37. a4 h5 38. a5 f4) 33... Kf8 { [%eval 6.48] } 34. Bc6?! { [%eval 4.96] } { Inaccuracy. Qd6 was best. } (34. Qd6 h5 35. a4 Bc3 36. Qc7 Rdxd7 37. Bxd7 Bf6 38. Qc8+ Kf7 39. a5 Re5) 34... Bc3 { [%eval 4.98] } 35. a4 { [%eval 4.6] } 35... Re5?! { [%eval 6.63] } { Inaccuracy. Bf6 was best. } (35... Bf6 36. a5 Kg7 37. a6 Re5 38. Qb3 Ra5 39. Qb6 Ra2 40. Kh3 h5 41. a7) 36. Qd6+ { [%eval 6.43] } 36... Re7 { [%eval 7.0] } 37. Qc7 { [%eval 6.62] } 1-0

"""

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

games = pgnParser.parse pgnText
game = games[0]
if game.tags.FEN == undefined then game.tags.FEN = ""
echo typeof game.tags.Date
if typeof game.tags.Date == 'string'
else
	game.tags.Date = game.tags.Date.value

echo game

echo game.tags.White
echo game.tags.WhiteElo
echo game.tags.Black
echo game.tags.BlackElo
echo game.tags.Site
echo game.tags.Date
echo game.tags.FEN
echo game.tags.Result
# echo game.tags.TimeControl[0].value

plies = (makePly ply for ply in game.moves)
echo plies

container = document.getElementById "output"
rows = ""
rows += th {}, "nr"
rows += th {}, "best"
rows += th {}, "eval"
rows += th {}, "white"
rows += th {}, "black"
rows += th {}, "eval"
rows += th {}, "best"
rows = tr {}, rows

arrBetyg = ['','•','••','•••']
for i in [0..plies.length/2]
	w = plies[2*i]
	b = plies[2*i+1]
	s = td {}, i+1
	if w != undefined
		s += td {}, w.best
		s += td {}, arrBetyg[w.betyg]
		s += td {}, w.san
		# s += td {}, w.clk
	if b != undefined
		s += td {}, b.san
		s += td {}, arrBetyg[b.betyg]
		s += td {}, b.best
		# s += td {}, b.clk
	if w and b then rows += tr {}, s
rows = table {}, rows
header = ""
header += 'White: ' + game.tags.Result[0] + ' ' + game.tags.WhiteElo + ' ' + game.tags.White + '<br>'
header += 'Black: ' + game.tags.Result[2] + ' ' + game.tags.BlackElo + ' ' + game.tags.Black + '<br>'
header += "#{game.tags.Date} <a href='#{game.tags.Site}'>#{game.tags.Site}</a>" #<br>" 
if game.tags.FEN then header += game.tags.FEN  + '<br>'

container.innerHTML = header + '<br>' + rows
# container.innerHTML = rows
echo rows


