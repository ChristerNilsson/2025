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

MINUTES = [1,2,3,4,5,6,7,8,9,10,15,25,30,45,60,90]
SECONDS = [0,1,2,3,4,5,6,7,8,9,10,15,20,25,30]
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

	fed = koppla "input", panel, placeholder:'Fed', value:"SWE"
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

	koppla "option", players, text: "1688|Anders Hillbur|1786911"
	koppla "option", players, text: "1827|Anders Kallin|1786911"
	koppla "option", players, text: "1748|André J Lindebaum|1786911"
	koppla "option", players, text: "1641|Anton Nordenfur|1786911"
	koppla "option", players, text: "2001|Aryan Banerjee|1786911"
	koppla "option", players, text: "1800|Björn Löfström|1786911"
	koppla "option", players, text: "1944|C Rose Mariano|1786911"
	koppla "option", players, text: "1907|Carina Wickström|1786911"
	koppla "option", players, text: "1579|Christer Carmegren|1786911"
	koppla "option", players, text: "1828|Christer Johansson|1786911"
	koppla "option", players, text: "1575|Christer Nilsson|1786911"
	koppla "option", players, text: "2213|D Vesterbaek Pedersen|1786911"
	koppla "option", players, text: "1417|David Broman|1786911"
	koppla "option", players, text: "1709|Eddie Parteg|1786911"
	koppla "option", players, text: "1977|Elias Kingsley|1786911"
	koppla "option", players, text: "2093|Erik Dingertz|1786911"
	koppla "option", players, text: "2113|Filip Björkman|1786911"
	koppla "option", players, text: "1848|Fredrik Möllerström|1786911"
	koppla "option", players, text: "2416|Hampus Sörensen|1786911"
	koppla "option", players, text: "1622|Hanns Ivar Uniyal|1786911"
	koppla "option", players, text: "1893|Hans Rånby|1786911"
	koppla "option", players, text: "1923|Herman Enholm|1786911"
	koppla "option", players, text: "1733|Hugo Hardwick|1786911"
	koppla "option", players, text: "1728|Hugo Sundell|1786911"
	koppla "option", players, text: "1400|Ivar Arnshav|1786911"
	koppla "option", players, text: "1624|Jens Ahlström|1786911"
	koppla "option", players, text: "1878|Jesper Borin|1786911"
	koppla "option", players, text: "1763|Joacim Hultin|1786911"
	koppla "option", players, text: "1886|Joar Berglund|1786911"
	koppla "option", players, text: "2366|Joar Ölund|1786911"
	koppla "option", players, text: "2335|Joar Östlund|1786911"
	koppla "option", players, text: "1897|Joel Åhfeldt|1786911"
	koppla "option", players, text: "1794|Jonas Sandberg|1786911"
	koppla "option", players, text: "1721|Jouni Kaunonen|1786911"
	koppla "option", players, text: "2022|Jussi Jakenberg|1786911"
	koppla "option", players, text: "1871|K Sergelenbaatar|1786911"
	koppla "option", players, text: "1833|Karam Masoudi|1786911"
	koppla "option", players, text: "1480|Karl-Oskar Rehnberg|1786911"
	koppla "option", players, text: "1846|Kenneth Fahlberg|1786911"
	koppla "option", players, text: "1787|Kjell Jernselius|1786911"
	koppla "option", players, text: "1400|Kristoffer Schultz|1786911"
	koppla "option", players, text: "1733|Lars Eriksson|1786911"
	koppla "option", players, text: "1761|Lars-Åke Pettersson|1786911"
	koppla "option", players, text: "2039|Lavinia Valcu|1786911"
	koppla "option", players, text: "2031|Lennart Evertsson|1786911"
	koppla "option", players, text: "2235|Leo Crevatin|1786911"
	koppla "option", players, text: "1936|Lo Ljungros|1786911"
	koppla "option", players, text: "2046|Lukas Willstedt|1786911"
	koppla "option", players, text: "1400|M de Lafonteyne|1786911"
	koppla "option", players, text: "1803|Martti Hamina|1786911"
	koppla "option", players, text: "2065|Matija Sakic|1786911"
	koppla "option", players, text: "2076|Michael Duke|1786911"
	koppla "option", players, text: "2048|Michael Mattsson|1786911"
	koppla "option", players, text: "2413|Michael Wiedenkeller|1786911"
	koppla "option", players, text: "1889|Mikael Blom|1786911"
	koppla "option", players, text: "1885|Mikael Helin|1786911"
	koppla "option", players, text: "1818|Morris Bergqvist|1786911"
	koppla "option", players, text: "1778|Mukhtar Jamshedi|1786911"
	koppla "option", players, text: "1524|Måns Nödtveidt|1786911"
	koppla "option", players, text: "1796|N Bychkov Zwahlen|1786911"
	koppla "option", players, text: "1768|Neo Malmquist|1786911"
	koppla "option", players, text: "2035|Oliver Nilsson|1786911"
	koppla "option", players, text: "1880|Olle Ålgars|1786911"
	koppla "option", players, text: "1650|Patrik Wiss|1786911"
	koppla "option", players, text: "1835|Peder Gedda|1786911"
	koppla "option", players, text: "1954|Per Isaksson|1786911"
	koppla "option", players, text: "2108|Pratyush Tripathi|1786911"
	koppla "option", players, text: "1783|Radu Cernea|1786911"
	koppla "option", players, text: "1793|Rohan Gore|1786911"
	koppla "option", players, text: "1852|Roy Karlsson|1786911"
	koppla "option", players, text: "1671|Salar Banavi|1786911"
	koppla "option", players, text: "1680|Sayak Raj Bardhan|1786911"
	koppla "option", players, text: "1695|Sid Van Den Brink|1786911"
	koppla "option", players, text: "1726|Simon Johansson|1786911"
	koppla "option", players, text: "1896|Stefan Nyberg|1786911"
	koppla "option", players, text: "1691|Svante Nödtveidt|1786911"
	koppla "option", players, text: "1985|Tim Nordenfur|1786911"
	koppla "option", players, text: "2141|Victor Muntean|1786911"
	koppla "option", players, text: "1406|Vida Radon|1786911"
	koppla "option", players, text: "2272|Vidar Grahn|1786911"
	koppla "option", players, text: "2109|Vidar Seiger|1786911"

	players.style.width = "294px"
	players.selectedIndex = players.options?.length - 1

	bases.selectedIndex = MINUTES.length - 1
	incrs.selectedIndex = SECONDS.length - 1
	rounds.selectedIndex = 8
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
