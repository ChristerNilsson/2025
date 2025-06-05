echo = console.log

state =
  letter: 0
  damage: 0
  best: 0 # visa bättre drag

params = null

moves = []
evals = []
best = []

byt = (san, a, b) ->
  for i in [0...a.length]
    san = san.replace a[i], b[i]
  san

figurine = (san) -> if state.letter == 1 then byt san, 'QRBN','DTLS' else byt san, 'DTLS','QRBN'

getParam = (name) ->
  params = new URLSearchParams window.location.search
  param = params.get(name)
  if name in "move eval best".split ' ' then return param?.split("_") or []
  param
 
klass = (value) -> 
  value = Math.abs value
  if value < 20  then return ""
  if value < 50  then return "•"
  if value < 100  then return "••"
  if value < 300  then return "•••"
  "••••"

parseMove = (moveStr, chess) ->
  allMoves = chess.moves({ verbose: true })
  for m in allMoves when m.san is moveStr
    return { from: m.from, to: m.to }
  null

add = (tr,text,alignment='right') ->
  td = document.createElement "td"
  td.style = "text-align: #{alignment};"
  td.textContent = text
  tr.appendChild td

addLink = (tr,href,text,alignment='right') ->
  td = document.createElement "td"
  td.style = "text-align: #{alignment};"
  td.innerHTML = "<a href='#{href}'>#{text}</a>"
  tr.appendChild td

calcDamage = (i) -> evals[i] + evals[i+1]

showDamage = (i) ->
  if state.damage == 0 then return klass evals[i] + evals[i+1]
  if state.damage == 1 then return "#{evals[i]} #{evals[i+1]} = #{evals[i] + evals[i+1]}"
  if state.damage == 2 then return evals[i] + evals[i+1]

showBest = (i) ->
  if state.best == 1 then return best[i]
  if best[i] != moves[i] and calcDamage(i) >= 20 then return best[i]
  return ''

makeTables = ->

  tbodypgn = document.querySelector("#pgnHeaders tbody")
  tbody = document.querySelector("#chessTable tbody")

  tbodypgn.innerHTML = ""
  tbody.innerHTML = ""

  keys = []
  for [key, value] in [...params.entries()]
    keys.push key 

  for key in keys
    if key in 'move eval best'.split ' ' then continue
    tr = document.createElement "tr"
    add tr, key, 'right'
    if key == 'Link'
      addLink tr, getParam(key), "Link", 'left'
    else
      add tr, getParam(key), 'left'
    tbodypgn.appendChild tr

  moves = getParam("move").map figurine
  evals = getParam("eval").map parseFloat
  best = getParam("best").map figurine

  # Fyll i tabellen
  for i in [0...moves.length] by 2
    tr = document.createElement "tr"
    add tr, showBest i
    add tr, showDamage i
    add tr, moves[i]

    add tr, (i // 2) + 1, 'center'

    add tr, moves[i+1], 'left'
    add tr, showDamage(i+1), 'left'
    add tr, showBest(i+1), 'left'

    tbody.appendChild tr

window.onload = ->
  params = new URLSearchParams(window.location.search)
  makeTables()

document.addEventListener 'keydown', (event) ->
  echo "Tangent nedtryckt:", event.key
  if event.key == 'l'
    state.letter = (state.letter + 1) % 2
    makeTables()

  if event.key == 'd'
    state.damage = (state.damage + 1) % 3
    makeTables()

  if event.key == 'b'
    state.best = (state.best + 1) % 2
    makeTables()
