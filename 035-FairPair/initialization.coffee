import {echo,global,range,settings} from './global.js'
import {Player} from './player.js'
import {makeURL} from './tournament.js'

koppla = (typ, parent, attrs = {}) ->
	elem = document.createElement typ

	if 'text' of attrs
		elem.textContent = attrs.text
		delete attrs.text

	if 'html' of attrs
		elem.innerHTML = attrs.html
		delete attrs.html

	for own key of attrs
		elem.setAttribute key, attrs[key]

	parent.appendChild elem
	elem

MINUTES = [1,2,3,4,5,10,15,25,30,45,60,90]
SECONDS = [0,1,2,3,4,5,10,15,20,25,30]
SPEED = 0 # 0=Classic 1=Rapid 2=Blitz

app = null
panel = null

title = null
city = null
fed = null # federation
arb = null # arbiter

bases = null
incrs = null
speed = null

rounds = null
double = null
estimation = null

player = null
ins = null
del = null
playerCount = null

players = null

export initialize = ->

	app = document.getElementById "app"
	app.style.display = "flex"
	app.style.flexDirection = "column"
	app.style.alignItems = "center"
	# app.style.gap = "8px"
	app.style.textAlign = "center"

	panel = koppla "div", app, class:'panel'

	div01 = koppla "div", panel
	title = koppla "input", div01, placeholder:'Title'
	title.style.width = "286px"

	city = koppla "input", panel, placeholder:'City'
	city.style.width = "244px"

	fed = koppla "input", panel, placeholder:'Fed'
	fed.style.width = "30px"

	div04 = koppla "div", panel
	arb = koppla "input", div04, placeholder:'Arbiter'
	arb.style.width = "286px"

	# bases
	div2 = koppla "div", panel
	bases = koppla "select", div2
	for base in MINUTES
		koppla "option", bases, text:"#{base} min"
	bases.addEventListener "change", -> update()

	# incrs
	incrs = koppla "select", div2
	for incr in SECONDS
		koppla "option", incrs, text:"#{incr} sec"
	incrs.addEventListener "change", -> update()

	speed = koppla "label", div2, text:"Classic"

	div3 = koppla "div", panel

	# rounds
	rounds = koppla "select", div3
	for r in range 21
		koppla "option", rounds, text:"#{r} rounds"
	rounds.addEventListener "change", -> update()

	# single / double
	double = koppla "select", div3
	double.style.width = "75px"
	koppla "option",double, text:"single"
	koppla "option",double, text:"double"
	double.addEventListener "change", -> update()

	estimation = koppla "label", div3 #, text: " 3 h 27 m"

	# input
	div4 = koppla "div", panel
	player = koppla "input", div4, placeholder:'FIDE id'
	player.style.width = "80px"
	player.addEventListener "keydown", (event) =>
		if event.key == "Enter" then ins.click()

	# Insert
	ins = koppla "button", div4, text:'Insert'
	ins.addEventListener 'click', -> 
		p = await transfer SPEED, player.value
		# Förhindra dublett
		if Array.from(players.options).some (o) -> -1 != o.text.indexOf player.value then return

		if p.length < 10 then return 
		koppla "option",players, text: p
		player.value = ""
		player.focus()
		players.selectedIndex = players.options?.length - 1
		update()

	# Delete
	del = koppla "button", div4, text:'Delete'
	del.addEventListener 'click', -> 
		if players.options?.length == 0 then return 
		i = players.selectedIndex
		players.remove i
		if i >= players.options?.length then i--
		players.selectedIndex = i
		update()

	playerCount = koppla "label", div4, text: "13"

	players = koppla "select", panel, size:20

	koppla "option", players, text: "1686|Aikio, Onni|1749781"
	koppla "option", players, text: "1693|Andersson, Lars Owe|1715208"
	koppla "option", players, text: "1699|Antonsson, Görgen|1747347"
	koppla "option", players, text: "1693|Eriksson, Roland|1799720"
	koppla "option", players, text: "1649|Hamnström, Per|1770063"
	koppla "option", players, text: "1679|Johansson, Lars|1726587"
	koppla "option", players, text: "1712|Karlsson, Magnus|1787454"
	koppla "option", players, text: "1675|Konstantinov, Dimiter|1719564"
	koppla "option", players, text: "1686|Nilsson, Christer|1786911"
	koppla "option", players, text: "1686|Razavi, Abbas|1774417"
	koppla "option", players, text: "1701|Stolov, Leonid|1766953"
	koppla "option", players, text: "1680|Stumpf, Friedemann|1774310"
	koppla "option", players, text: "1700|Öhman, Dick|1772937"

	players.style.width = "294px"
	players.selectedIndex = players.options?.length - 1

	bases.selectedIndex = MINUTES.length - 1
	incrs.selectedIndex = SECONDS.length - 1
	rounds.selectedIndex = 6
	double.selectedIndex = 0

	div5 = koppla "div", panel, class:'bar'

	koppla "button", div5, id:'help',     text:'Help'
	koppla "button", div5, id:'continue', text:'Continue'

	update()

fetchShard = (fidenumber) ->
	shard = "#{fidenumber}"
	n = shard.length
	if n < 7 then return ""
	shard = shard.slice 0,3

	try
		filename = "./shards/#{shard}.json"
		response = await fetch filename
		members = await response.json()
	catch error 
		console.error 'Fel vid hämtning:', error

	await members[fidenumber]

getRating = (member,speed) ->
	pref = [[0,1,2],[1,2,0],[2,1,0]][speed]
	for x in pref
		if member[x] > 0 then return member[x]
	return "0000"

transfer = (speed, fidenumber) ->
	fidenumber = fidenumber.trim()
	if fidenumber == "" then return ""
	member = await fetchShard fidenumber
	echo member
	if member == undefined then return fidenumber
	rating = getRating member,speed
	name = member[3]
	if rating == undefined or name == undefined then fidenumber else rating + '|' + name + '|' + fidenumber

update = ->
	updateSpeed()
	updateTimeEstimation()
	updateCount()

updateSpeed = ->
	base = parseInt bases.value
	incr = parseInt incrs.value
	total = base + incr
	SPEED = 0 # Classic
	if total < 60 then SPEED = 1 # Rapid
	if total < 10 then SPEED = 2 # Blitz
	speed.textContent = 'Classic Rapid Blitz'.split(' ')[SPEED]

updateTimeEstimation = ->
	base = parseInt bases.value
	incr = parseInt incrs.value
	total = base + incr
	count = parseInt rounds.value
	if double.value == 'double' then games = 2 else games = 1
	minutes = count * games * total * 2
	hours = minutes // 60
	minutes = minutes %% 60
	estimation.textContent = "#{hours} h #{minutes} m"

updateCount = ->
	playerCount.textContent = players.options?.length

export init = -> # läs initiala uppgifter om turneringen

	if title.value == null then return
	if city.value == null then return
	if fed.value == null then return
	if arb.value == null then return
	if players.options.length < 4 then return

	settings.TITLE = title.value
	settings.CITY = city.value
	settings.FED = fed.value
	settings.ARB = arb.value

	settings.GAMES = double.selectedIndex + 1
	settings.ROUNDS = rounds.selectedIndex

	echo settings

	global.rounds = null
	global.players = []
	persons = []

	for option in players.options
		persons.push option.text

	persons.sort().reverse()

	for person in persons
		global.players.push new Player global.players.length, person

	if global.players.length % 2 == 1
		global.frirond = global.players.length
		global.players.push '0000|BYE|0'
	else
		global.frirond = null

	if settings.ROUNDS > global.players.length / 2 then return

	if global.rounds == null then global.rounds = []

	url = makeURL()
	# echo url
	global.players = []
	global.rounds = []

	window.location.href = url
	# echo 'window.location.href = url'
