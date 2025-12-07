import {echo,global,range,settings} from './global.js'
import {Player} from './player.js'
import {makeURL} from './tournament.js'

# echo = console.log
# range = _.range

players = null

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

#export class Initialization
#	constructor : ->

MINUTES = [1,2,3,4,5,10,15,25,30,45,60,90]
SECONDS = [0,1,2,3,4,5,10,15,20,25,30]
SPEED = 0 # 0=Classic 1=Rapid 2=Blitz
members = {}

app = null
panel = null
title = null

# div2 = null
bases = null
incrs = null
speed = null

# div3 = null
rounds = null
double = null
estimation = null

# div4 = null
player = null
ins = null
del = null
playerCount = null

# div5 = null
# help = null
# cont = null

export initialize = ->

	# <div class="panel" id="panel">

	app = document.getElementById "app"
	app.style.display = "flex"
	app.style.flexDirection = "column"
	app.style.alignItems = "center"
	# app.style.gap = "8px"
	app.style.textAlign = "center"

	panel = koppla "div", app, class:'panel'

	# title
	title = koppla "input", panel, placeholder:'Title'
	title.style.width = "286px"

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
		if Array.from(players.options).some (o) -> o.text is p then return

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

	koppla "option", players, text: "1712 1787454 Karlsson, Magnus"
	koppla "option", players, text: "1701 1766953 Stolov, Leonid"
	koppla "option", players, text: "1700 1772937 Öhman, Dick"
	koppla "option", players, text: "1699 1747347 Antonsson, Görgen"
	koppla "option", players, text: "1693 1715208 Andersson, Lars Owe"
	koppla "option", players, text: "1693 1799720 Eriksson, Roland"
	koppla "option", players, text: "1686 1786911 Nilsson, Christer"
	koppla "option", players, text: "1686 1774417 Razavi, Abbas"
	koppla "option", players, text: "1686 1749781 Aikio, Onni"
	koppla "option", players, text: "1680 1774310 Stumpf, Friedemann"
	koppla "option", players, text: "1679 1726587 Johansson, Lars"
	koppla "option", players, text: "1675 1719564 Konstantinov, Dimiter"
	koppla "option", players, text: "1649 1770063 Hamnström, Per"

	players.style.width = "294px"
	players.selectedIndex = players.options?.length - 1

	bases.selectedIndex = MINUTES.length - 1
	incrs.selectedIndex = SECONDS.length - 1
	rounds.selectedIndex = 4
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
	if rating == undefined or name == undefined then fidenumber else rating + ' ' + fidenumber + ' ' + name

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

#	echo 'init', players.options?.length

#	for option in players.options
#		echo option.text

	settings.TITLE = title.value
	settings.GAMES = double.selectedIndex + 1
	settings.ROUNDS = rounds.selectedIndex

	global.rounds = null
	global.players = []
	persons = []

	for option in players.options
		persons.push option.text

	persons.sort().reverse()

	for person in persons
		elo = parseInt person.slice 0,4
		person = person.slice 4+1 #.trim()
		echo elo,person
		
		# hämta FIDE-id
		p    = person.indexOf ' '
		fide = person.slice 0,p
		name = person.slice p+1

		global.players.push new Player global.players.length, name, elo, fide

	echo global.players

	# n = global.players.length
	# if settings.A > n then settings.A = n
	# if settings.B > n then settings.B = n
	# if settings.C > n then settings.C = n

	if global.players.length % 2 == 1
		global.frirond = global.players.length
		global.players.push '0000 BYE' 
	else
		global.frirond = null

	#if settings.ROUNDS == 0 then settings.ROUNDS = global.players.length - 1

	if global.rounds == null then global.rounds = []

	#document.getElementById("help").style     = 'display: none'
	# document.getElementById("textarea").style = 'display: none'
	#document.getElementById("panel").style    = 'display: none'
	#document.getElementById("continue").style = 'display: none'

	url = makeURL()
	echo url
	global.players = []
	global.rounds = []

	window.location.href = url
	echo 'window.location.href = url'
