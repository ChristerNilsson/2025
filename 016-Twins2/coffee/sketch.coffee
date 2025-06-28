# Internt används talen 1..100. Externt visas de som 0..99
# Då ett tal plockats bort negeras det. Dessa visas gråa och förminskade.
# Ramens celler innehåller 0.

echo = console.log

ALFABET = "abcdefghijklmnopqrstuvwxyz"
# SIZE = 12
TILE = 60
FREE = 0
COLORS = '#fff #f00 #0f0 #ff0 #f0f #0ff #880 #f88 #088 #8f8'.split ' '
KEY = '016-Twins2'

Size = null
level = null
maxLevel=null
numbers = null

b = null
selected = []
message = ''
buttons = []
path = []
pathTimestamp = null
deathTimestamp = null
hearts = null
milliseconds0 = null
milliseconds1 = null
state = 'halted' # 'running' 'halted'
delta = 0
found = null
showLittera = false
showShadow = true
showHint = false
hints0 = []
hints1 = []
latestPair = []
counter = {}
keys = ''
released = true
margin = 0
diagonal = 0

class Hearts
	constructor : (@x,@y,@count=12,@maximum=24) -> 

	draw : ->
		if width < height # portrait
			for i in range @maximum
				x = @x + TILE*i
				if i < @count
					@drawHeart x,@y,TILE,'red'
				else
					@drawHeart x,@y,TILE,'gray'
		else # landscape
			for i in range @maximum
				y = @y + TILE*i + TILE*0.3
				@drawHeart @x,y,TILE,if i < @count then 'red' else 'gray'

	drawHeart : (x,y,tile,col) ->
			fill col
			stroke col
			sw tile*0.3
			dx = 0.2*tile
			y1 = y + 0.1*tile
			y2 = y + 0.4*tile
			line x-dx, y1, x, y2
			line x+dx, y1, x, y2
			line x,    y1, x, y2
			sc()
			circle x-0.2*tile, y, 0.2*tile
			circle x+0.2*tile, y, 0.2*tile

class Button
	constructor : (@x,@y,@txt,@click) -> @r=0.025 * diagonal
	inside : (x,y) -> @r > dist @x,@y,x,y
	draw : ->
		fc 0.5
		if level == maxLevel then sc 1 else sc()
		sw 2
		circle @x,@y,@r
		fc 0
		textSize 0.03 * diagonal
		sc()
		text @txt,@x,@y

newGame = (n) ->
#	if n in [0,maxLevel+1] then return 
	if n in [0,maxLevel+2] then return 
	level = constrain n,2,maxLevel
	makeGame()
	showMoves()

saveStorage = -> localStorage[KEY] = maxLevel
loadStorage = -> maxLevel = if KEY of localStorage then parseInt localStorage[KEY] else maxLevel = 2

setup = ->
	canvas = createCanvas window.innerWidth, window.innerHeight

	rectMode CENTER
	textAlign CENTER,CENTER
	loadStorage()
	level = maxLevel
	dx = width/8
	dy = height/8
	w2 = dx
	diagonal = sqrt width * width + height * height

	if width < height # portrait
		margin = (height-width)/2
		y = height - margin/2
		buttons.push new Button w2,        y,level, ->
		buttons.push new Button w2+1*dx,   y,'?', -> window.open 'https://github.com/ChristerNilsson/2025/tree/main/016-Twins2#readme'

		buttons.push new Button w2+2*dx,   y,'-', -> newGame level - 1
		buttons.push new Button w2+3*dx,   y,'+', -> newGame level + 1

		buttons.push new Button w2+4*dx,   y,'<', -> newGame 1
		buttons.push new Button w2+5*dx,   y,'>', -> newGame maxLevel

		hearts = new Hearts 0.35*TILE, 0.4*TILE
	else # landscape
		margin = (width-height)/2
		x = width - margin/2
		buttons.push new Button x, 1*dy, level, ->
		buttons.push new Button x, 2*dy,  '?', -> window.open 'https://github.com/ChristerNilsson/2025/tree/main/016-Twins2#readme'

		buttons.push new Button x, 3*dy, '<', -> newGame 1
		buttons.push new Button x, 4*dy, '>', -> newGame maxLevel

		buttons.push new Button x, 5*dy, '-', -> newGame level - 1
		buttons.push new Button x, 6*dy, '+', -> newGame level + 1
		hearts = new Hearts margin/2, 0

	if -1 != window.location.href.indexOf 'level'
		urlGame()
	else
		makeGame()
	showMoves()

urlGame = ->
	params = getParameters()
	level = parseInt params.level
	b = JSON.parse params.b
	Size = 4 + level // 4 
	if Size > 12 then Size=12
	hearts.count   = constrain 1+level//8,0,12
	hearts.maximum = constrain 1+level//8,0,12 
	numbers = (Size-2)*(Size-2)
	if numbers%2==1 then numbers -= 1
	milliseconds0 = millis()
	state = 'running'	

makeGame = ->
	hints0 = []
	hints1 = []

	latestPair = []

	if level == maxLevel
		maxLevel = constrain maxLevel+delta,2,100
	level = constrain level+delta,2,100
	delta = 0
	saveStorage()

	Size = 4+level//4 
	if Size>12 then Size=12
	hearts.count   = constrain 1+level//8,0,12 
	hearts.maximum = constrain 1+level//8,0,12 

	numbers = (Size-2)*(Size-2)
	if numbers%2==1 then numbers -= 1

	candidates = []
	for i in range numbers/2
		candidates.push 1 + i % level
		candidates.push 1 + level-1 - i % level
	candidates = _.shuffle candidates

	b = new Array Size
	for i in range Size
		b[i] = new Array Size
		for j in range Size
			if i in [0,Size-1] or j in [0,Size-1] then b[i][j] = FREE
			else 
				if Size % 2 == 0
					b[i][j] = candidates.pop()
				else
					if i == Size//2 and j == Size//2
						b[i][j] = FREE
					else
						b[i][j] = candidates.pop()
	milliseconds0 = millis()
	state = 'running'

drawRect = (i,j) ->
	fc 0
	sc 0.25
	sw 1
	rect TILE*i,TILE*j,TILE,TILE

drawNumber = (cell,i,j) ->
	cell -= 1 
	sw 3
	c1 = COLORS[cell%%COLORS.length]
	c2 = COLORS[cell//COLORS.length]
	if c1==c2 then c1='#000'
	fill   c1
	stroke c2
	text cell,TILE*i,TILE*j + if showHint then 10 else 0

drawHint  = (hints,r,g,b) -> 
	if showHint 
		sw 1
		fc r,g,b
		sc()
		textSize 0.05 * diagonal
		for [[i0,j0],[i1,j1]],index in hints
			drawHintHelp ALFABET[index],i0,j0
			drawHintHelp ALFABET[index],i1,j1

drawHintHelp = (cell,i,j) ->
		key = "#{i}-#{j}"
		if key not of counter then counter[key] = 0
		dx = [-20,0,20][counter[key] %% 3]
		dy = [-20,0,20][counter[key] // 3]
		text cell,TILE*i+dx,TILE*j+dy
		counter[key]++

drawShadow = (i,j) ->
	if showShadow
		sw 3
		fill 48
		stroke 48 
		for [x,y] in latestPair
			if i==x and j==y 
				text -b[i][j]-1, TILE*i,TILE*j

draw = ->
	bg 0.25
	sw 1
	buttons[0].txt = level-1

	for button in buttons
		button.draw()
	hearts.draw()

	if width < height 
		TILE = width/Size
	else
		TILE = height/Size

	textAlign CENTER,CENTER
	textSize 0.8 * TILE

	push()
	translate (width-TILE*Size)/2+TILE/2, (height-TILE*Size)/2+TILE/2 
	fc 1
	sc 0
	for i in range Size
		for j in range Size
			drawRect i,j
			cell = b[i][j]
			if state == 'halted'
				if cell != FREE then drawNumber abs(cell),i,j
			else
				if cell > 0 then drawNumber cell,i,j
				else if cell != FREE then drawShadow i,j
			# if i in [0,Size-1] or j in [0,Size-1] then drawLittera i,j
	for [i,j] in selected
		fc 1,1,0,0.5
		sc()
		circle TILE*i,TILE*j,TILE/2-3
	drawPath()

	counter = {}

	drawHint hints0,0,1,0
	drawHint hints1,1,0,0

	pop()

	if state=='halted'
		fc 1,1,0,0.5
		x = width/2 
		y = height/2 
		w = Size*TILE
		h = Size*TILE
		rect x,y,w,h
		# ms = round((milliseconds1-milliseconds0)/100)/10
		# if ms > 0
		# 	y = Size*TILE-10
		# 	fc 1
		# 	sc()
		# 	textSize 30
			# text ms,width-2.5*TILE,height-30

	if millis() < deathTimestamp
		x = width/2 
		y = height/2 
		hearts.drawHeart x,y,Size*TILE/5,1,0,0

	drawHints()

drawHints = ->
	if width < height # portrait
		dx = width/8
		margin = (height-width)/2
		x = width - margin/2	
		y = height - margin/2
		if hints0.length > 0 
			fill 'green' 
			circle x, y, 0.025 * diagonal
		if hints1.length > 0 
			fill 'red'
			circle x, y, 0.025 * diagonal
	else
		margin = (width-height)/2
		x = width - margin/2	
		dy = height/8
		if hints0.length > 0 
			fill 'green'
			circle x, 7*dy, 0.025 * diagonal
		if hints1.length > 0 
			fill 'red'
			circle x, 7*dy, 0.025 * diagonal

within = (i,j) -> 0 <= i < Size and 0 <= j < Size

keyPressed = ->
	keys += key 
	if keys.endsWith 'QPZM'
		keys = '' 
		showHint = not showHint

# === För iPad och mobiler ===
touchStarted = ->
	handlePress()
	false
	
touchEnded = ->
	handleRelease()
	false

# === För PC med mus ===
mousePressed = -> handlePress()
mouseReleased = -> handleRelease()

handleRelease = -> released = true

handlePress = ->

	if not released then return 
	released = false

	if state=='halted' 
		newGame level
		return
	for button in buttons
		if button.inside mouseX,mouseY then button.click()

	x = mouseX - (width-TILE*Size)/2 
	y = mouseY - (height-TILE*Size)/2 
	[i,j] = [x//TILE,y//TILE]
	if not within i,j then return

	if i in [0,Size-1] or j in [0,Size-1] 
		showLittera = false # not showLittera
		return

	if b[i][j] < 0
		showShadow = not showShadow 
		return

	if selected.length == 0
		if b[i][j] > 0 then selected.push [i,j]
	else
		[i1,j1] = selected[0]
		if i==i1 and j==j1 then return selected.pop()
		if b[i][j]-1 + b[i1][j1]-1 != level-1
			hearts.count -= 1 # Punish one, wrong sum
			deathTimestamp = 200 + millis()
			selected.pop()
		else
			path = legal false,i1,j1,i,j
			if path.length == 0
				path = legal true,i1,j1,i,j
				if path.length == 0
					hearts.count -= 2 # Punish two, anything goes
				else
					hearts.count -= 1 # Punish one, wrap
				deathTimestamp = 200 + millis()
			latestPair = [[i,j],[i1,j1]]
			b[i][j] = -b[i][j] 
			b[i1][j1] = -b[i1][j1] 
			numbers -= 2
			selected.pop()
			if numbers==0
				milliseconds1 = millis()
				state = 'halted'
				if hearts.count >= 0 then delta = 1 else delta = -1
			else
				if level == maxLevel 
					if hearts.count < 0 
						state = 'halted'
						delta = -1
	showMoves()

makeMove = (wrap,x,y) -> if wrap then [x %% Size, y %% Size] else [x,y]

makePath = (wrap,reached,i,j) ->
	res = []
	key = "#{i},#{j}"
	[turns0,i0,j0,indexes0] = reached[key]
	[i,j] = [i0,j0]
	res.push [i,j]
	pathTimestamp = millis()
	indexes0.reverse()
	for index in indexes0
		[di,dj] = [[1,0],[-1,0],[0,1],[0,-1]][index]
		[i,j] = makeMove wrap,i+di,j+dj
		res.push [i,j]
	res

drawPath = ->
	if path.length == 0 then return 
	sw 3
	sc 1,1,0
	[i1,j1] = path[0]
	for [i2,j2] in path
		if 1 == dist i1,j1,i2,j2
			line TILE*i1,TILE*j1,TILE*i2,TILE*j2
		[i1,j1] = [i2,j2]
	if millis() > 500 + pathTimestamp then path = []

# A*
legal = (wrap,i0,j0,i1,j1) ->
	start = [0,i0,j0,[]] # turns,x,y,move
	cands = []
	cands.push start
	reached = {}
	reached[[i0,j0]] = start
	while cands.length > 0
		front = cands
		front.sort (a,b) -> a[0]-b[0]
		cands = []
		for [turns0,x0,y0,indexes0] in front
			for [dx,dy],index in [[-1,0],[1,0],[0,-1],[0,1]]
				[x,y] = makeMove wrap,x0+dx,y0+dy
				key = "#{x},#{y}"
				turns = turns0
				if indexes0.length > 0 and index != _.last(indexes0) then turns++
				next = [turns,x,y,indexes0.concat [index]]
				if x==i1 and y==j1 and turns<=2
					reached[key] = next
					return makePath wrap,reached,i1,j1
				if within x,y
					if b[x][y] <= 0
						if key not of reached or reached[key][0] >= next[0]
							if next[0] < 3
								reached[key] = next
								cands.push next
	[]

showMoves = -> 
	hints0 = showMoves1 false
	hints1 = if hints0.length > 0 then [] else showMoves1 true

showMoves1 = (wrap) ->
	res = []
	for i0 in range 1,Size-1
		for j0 in range 1,Size-1
			if b[i0][j0] > 0 
				for i1 in range 1,Size-1
					for j1 in range 1,Size-1
						if b[i1][j1] > 0 
							if b[i0][j0]-1 + b[i1][j1]-1 == level-1
								if b[i0][j0] <= b[i1][j1] and (i0!=i1 or j0!=j1)
									p = legal wrap,i0,j0,i1,j1 
									if p.length > 0
										ok = true
										p0 = [i0,j0]
										p1 = [i1,j1]
										for [q0,q1] in res
											if _.isEqual(p0,q0) and _.isEqual(p1,q1) then ok = false
											if _.isEqual(p0,q1) and _.isEqual(p1,q0) then ok = false
										if ok then res.push [[i0,j0],[i1,j1]]
	res # innehåller koordinaterna för paren.
