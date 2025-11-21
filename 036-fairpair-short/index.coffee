setHeadline = (text) ->
	document.getElementById("headline").textContent = text or ""

setBody = (text) ->
	document.getElementById("bodytext").innerHTML = text or ""

setFooter = (text) ->
	document.getElementById("footer").textContent = text or ""

# showScene = (node) ->
# 	visual = document.getElementById "visual" # "visual"
# 	fadeOut visual, ->
# 		visual.innerHTML = ""
# 		visual.appendChild node
# 		fadeIn visual

# showScene = (node) ->
# 	root   = document.getElementById "slideshow"
# 	visual = document.getElementById "visual"

# 	fadeOut root, ->
# 		visual.innerHTML = ""	
# 		visual.appendChild node if node?
# 		fadeIn root

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
	setTimeout callback, 600	 # matchar CSS-transition

createGapChart = ->
	wrapper = document.createElement "div"
	wrapper.className = "gap-chart"

	# Fiktiva värden för “typisk max-elo-gap efter 8 ronder”
	swissGap = 300
	fairGap	= 30

	createBar = (label, gap, isSwiss) ->
		bar = document.createElement "div"
		bar.className = "gap-bar"

		height = (if isSwiss then 60 else 15)	# bara relativt
		bar.style.height = height + "vh"
		bar.style.background = if isSwiss then "linear-gradient(180deg,#fecaca,#991b1b)" else "linear-gradient(180deg,#bbf7d0,#166534)"

		val = document.createElement "div"
		val.className = "gap-bar-value"
		val.textContent = gap + " Elo"

		lab = document.createElement "div"
		lab.className = "gap-bar-label"
		lab.textContent = label

		bar.appendChild val
		bar.appendChild lab
		bar

	wrapper.appendChild createBar("Swiss", swissGap, true)
	wrapper.appendChild createBar("FairPair", fairGap, false)
	wrapper

createImage = (name) ->
	container = document.createElement "div"
	img = document.createElement "img"
	container.appendChild img

	frameMs = 250 + 250 + 250 # 0.25 sek per bild (ändra vid behov)
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
	frameMs = 500
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
	duration: 6000
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
	duration: 15000
	setup: ->
		showScene 
			node: createImage "images/fairpair.png"
			headline: "fairpair.se"
			body: "Feels like Round-robin. Scales like Swiss."
			footer: "" 
]

playScenes = ->
	i = 0

	nextScene = ->
		return if i >= scenes.length
		scene = scenes[i]
		scene.setup()

		setTimeout ->
			i++
			nextScene()
		, scene.duration

	nextScene()

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
		, scene.duration

	nextScene()

window.addEventListener "load", ->
	playScenes()

####

# createPlayersGrid = (n) ->
# 	container = document.createElement "div"
# 	container.style.display = "flex"
# 	container.style.flexWrap = "wrap"
# 	container.style.justifyContent = "center"
# 	container.style.maxWidth = "80vw"
# 	container.style.maxHeight = "70vh"

# 	for i in [0...n]
# 		dot = document.createElement "div"
# 		dot.className = "player-dot"
# 		container.appendChild dot

# 	container

# createWarningSign = (text) ->
# 	box = document.createElement "div"
# 	box.className = "warning-sign"
# 	box.textContent = text
# 	box

# createFairpairGrow = ->
# 	container = document.createElement "div"
# 	container.style.display = "flex"
# 	container.style.flexDirection = "column"
# 	container.style.alignItems = "center"

# 	title = document.createElement "div"
# 	title.id = "fairpair-grow"
# 	title.textContent = "fairpair.se"

# 	count = document.createElement "div"
# 	count.id = "fairpair-count"
# 	count.textContent = "Handles ~8 players"

# 	container.appendChild title
# 	container.appendChild count

# 	# Liten “räknare” från 8 till 100
# 	start = 8
# 	target = 100
# 	steps = 30
# 	cur = 0

# 	stepFn = ->
# 		t = cur / steps
# 		value = Math.round start + (target - start) * t
# 		count.textContent = "Handles ~#{value} players"
# 		cur++
# 		if cur <= steps
# 			setTimeout stepFn, 80

# 	stepFn()
# 	container


	# 2. But, Berger can't handle large tournaments. [Grow to n=24]
	# duration: 5000
	# setup: ->
	# 	setVisual createPlayersGrid 24
	# 	setHeadline "But Berger breaks down…"
	# 	setBody "When you try to scale to larger events."
	# 	setFooter "n = 24 players is already tough"
	# 	fadeIn()


	# 7. FairPair feels like Berger… (slutskylt)
	# duration: 6000
	# setup: ->
	# 	# setVisual createImage "berger/fairpair.png"
	# 	setVisual() # createPlayersGrid 16
	# 	setHeadline "FairPair feels like Berger"
	# 	setBody """
	# 		…handles large tournaments<br>
	# 		…and keeps Elo gaps very small!
	# 	"""
	# 	setFooter "Try it on fairpair.se today!"
	# 	fadeIn()
