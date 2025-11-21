params = new URLSearchParams window.location.search
FACTOR = if params.size == 0 then 1 else params.get "factor"

setHeadline = (text) ->	document.getElementById("headline").textContent = text or ""
setBody = (text) ->	document.getElementById("bodytext").innerHTML = text or ""
setFooter = (text) ->	document.getElementById("footer").textContent = text or ""

showScene = (opts) ->
  root   = document.getElementById "slideshow"
  visual = document.getElementById "visual"

  fadeOut root, ->
    # Byt bild
    visual.innerHTML = ""
    if opts.node?
      visual.appendChild opts.node

    # Byt texter
    setHeadline opts.headline or ""
    setBody opts.body or ""
    setFooter opts.footer or ""

    # Fada in allt tillsammans
    fadeIn root

fadeIn = (el) ->
	el.classList.add "fade"
	requestAnimationFrame ->
		el.classList.add "show"

fadeOut = (el, callback = ->) ->
	el.classList.remove "show"
	setTimeout callback, 600 * FACTOR	 # matchar CSS-transition

createGapChart = ->
  wrapper = document.createElement "div"
  wrapper.className = "gap-chart"

  swissGap = 400
  fairGap  = 40

  maxGap = 400  # högsta för att skala höjder

  createBar = (label, gap, isSwiss) ->
    col = document.createElement "div"
    col.className = "gap-col"

    bar = document.createElement "div"
    bar.className = "gap-bar"

    # höjd proportionellt
    pct = gap / maxGap
    bar.style.height = "#{pct * 60}vh"

    bar.style.background =
      if isSwiss then "linear-gradient(180deg,#fecaca,#991b1b)"
      else "linear-gradient(180deg,#bbf7d0,#166534)"

    lab = document.createElement "div"
    lab.className = "gap-label"
    lab.textContent = label

    val = document.createElement "div"
    val.className = "gap-value"
    val.textContent = "#{gap} Elo"

    col.appendChild bar
    col.appendChild lab
    col.appendChild val

    col

  wrapper.appendChild createBar "Swiss",    swissGap, true
  wrapper.appendChild createBar "FairPair", fairGap, false

  wrapper


createImage = (name) ->
	container = document.createElement "div"
	img = document.createElement "img"
	container.appendChild img

	frameMs = 1000 * FACTOR # 0.25 sek per bild (ändra vid behov)
	i = 0

	step = ->
		img.src = name	
		i++
		if i < 8 then setTimeout step, frameMs

	step()

	container

createPlayersAnimation = ->
	container = document.createElement "div"
	img = document.createElement "img"
	container.appendChild img

	players = [4,6,8,10,12,14,16,18,20,22]
	frameMs = 1000 * FACTOR
	i = 0

	step = ->
		img.src = "images/#{players[i]}.png"
		i++
		if i < players.length then setTimeout step, frameMs

	step()
	container

# -------------------------------

scenes = [
	# 1. Berger is nice! [Show n=8]
	duration: 4000
	setup: ->
		showScene 
			node: createImage "images/4.png"
			headline: "Round-robin tournaments are great!"
			body: ""
			footer: "" 

,
	# 2. scenen "Berger can't handle large tournaments"
	duration: 10000 
	setup: ->
		showScene 
			node: createPlayersAnimation()
			headline: "But Round-robin only handles small tournaments."
			body: "" 
			footer: ""

,
	# 3. Swiss can handle large tournaments!
	duration: 4000 
	setup: ->
		showScene 
			node: createImage "images/tyresö.png"
			headline: "Swiss handles large tournaments."
			body: ""
			footer: ""

,
	# 4. But, Swiss makes HUGE elo gaps.
	duration: 5000
	setup: ->
		showScene 
			node: createImage "images/mindthegap.webp" 
			headline: "But Swiss can be brutal…"
			body: "Swiss makes huge Elo gaps"
			footer: "" 

,
	# 5. [Show elo gaps comparing Swiss versus FairPair]
	duration: 5000
	setup: ->
		showScene 
			node: createGapChart()
			headline: "Swiss pairing is wide. FairPair is tight."
			body: ""
			footer: ""
,
	# 6. fairpair.se
	duration: 10000
	setup: ->
		showScene 
			node: createImage "images/tyresö_fp.png"
			headline: "fairpair.se"
			body: "Feels like Round-robin. Scales like Swiss."
			footer: "" 
]

# playScenes = ->
# 	i = 0

# 	nextScene = ->
# 		return if i >= scenes.length
# 		scene = scenes[i]
# 		scene.setup()

# 		setTimeout ->
# 			i++
# 			nextScene()
# 		, scene.duration * FACTOR

# 	nextScene()

playScenes = ->
	i = 0

	nextScene = ->
		if i >= scenes.length
			# --- LOOPA OM ---
			setTimeout ->
				playScenes()
			, 800			# kort paus innan restart
			return

		scene = scenes[i]
		scene.setup()
		setTimeout ->
			i++
			nextScene()
		, scene.duration * FACTOR

	nextScene()

window.addEventListener "load", ->
	playScenes()

