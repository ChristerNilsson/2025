echo = console.log

state =
  letter: 0
  losses: 0
  bests: 0 # visa bättre drag

params = null

moves = []
losses = []
bests = []

byt = (san, a, b) ->
  for i in [0...a.length]
    san = san.replace a[i], b[i]
  san

figurine = (san) -> if state.letter == 1 then byt san, 'QRBN','DTLS' else byt san, 'DTLS','QRBN'

getParam = (name) ->
  params = new URLSearchParams window.location.search
  param = params.get(name)
  if name in "moves losses bests".split ' ' then return param?.split("_") or []
  param
 
klass = (loss,move,best) -> 
  loss = Math.abs loss
  if move == best then return ""
  if loss < 20  then return ""
  if loss < 50  then return "•"
  if loss < 100  then return "••"
  if loss < 300  then return "•••"
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

calcLoss = (i) -> losses[i]

showLoss = (i) ->
  if state.losses == 0 then return klass losses[i],moves[i],bests[i]
  if state.losses == 1 then return losses[i]

showBest = (i) ->
  if state.bests == 1 then return bests[i]
  if bests[i] != moves[i] and calcLoss(i) >= 20 then return bests[i]
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
    if key in 'moves losses bests'.split ' ' then continue
    tr = document.createElement "tr"
    add tr, key, 'right'
    if key == 'Link'
      addLink tr, getParam(key), "Link", 'left'
    else
      add tr, getParam(key).replaceAll("_"," "), 'left'
    tbodypgn.appendChild tr

  moves = getParam("moves").map figurine
  losses = getParam("losses").map parseFloat
  bests = getParam("bests").map figurine

  for i in [0...moves.length]
    if i % 2 == 0 # white
      tr = document.createElement "tr"
      add tr, showBest i
      add tr, showLoss i
      href = getParam('Link') + "##{i+1}"
      addLink tr, href, moves[i]
      add tr, (i // 2) + 1, 'center'
    else # black
      href = getParam('Link') + "##{i+1}"
      addLink tr, href, moves[i], 'left'
      add tr, showLoss(i), 'left'
      add tr, showBest(i), 'left'
    tbody.appendChild tr

window.onload = ->
  params = new URLSearchParams(window.location.search)
  makeTables()

document.addEventListener 'keydown', (event) ->
  echo "Tangent nedtryckt:", event.key
  if event.key == 'l'
    state.letter = 1 - state.letter
    makeTables()

  if event.key == 'd'
    state.losses = 1 - state.losses
    state.bests = 1 - state.bests
    makeTables()
