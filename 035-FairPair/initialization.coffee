import {echo,global,range,settings} from './global.js'
import {Player} from './player.js'
import {makeURL} from './tournament.js'
import {render, tag} from './fasthtml.js'

div = tag "div"
input = tag "input"
div = tag "div"
select = tag "select"
option = tag "option"
label = tag "label"
button = tag "button"

NBSP = '\u00A0'
NAME_LEN = 30

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

add = (name, fideid, elo) -> 
	#name = lastName.toUpperCase() + " " + firstName
	if name.length > NAME_LEN then name = name.slice 0,NAME_LEN # 21
	name = name.padEnd NAME_LEN,' '
	option "#{name} #{elo} #{fideid}".replaceAll " ", NBSP

export clear = ->
	players.length = 0
	update()

export initialize = ->

	app = document.getElementById "app"
	app.style.display = "flex"
	app.style.flexDirection = "column"
	app.style.alignItems = "center"
	# app.style.gap = "8px"
	app.style.textAlign = "center"

	result = div class:'panel',
		div {},
			title = input placeholder:'Title', style: "width:286px"
		city = input placeholder:'City', style: "width:244px"
		fed = input placeholder:'Fed', value:"SWE", style:"width:30px"
		div {},
			arb = input placeholder:'Arbiter', style: "width:286px"
		div {},
			bases = select {}, 
				option "#{base} min" for base in MINUTES
			incrs = select {},
				option "#{incr} sec" for incr in SECONDS					
			speed = label "Classic"
		div {},
			rounds = select {},
				option "#{r} rounds" for r in range 39
			double = select {},
				option "single"
				option "double"
			estimation = label " 3 h 27 m"
		div {},
			player = input placeholder:'FIDE id', type:"text", inputmode:"numeric", oninput:"this.value = this.value.replace(/[^0-9]/g, '')", style:"width:80px"
			ins = button 'Insert'
			del = button 'Delete'
			playerCount = label "13"

		players = select {size:20, style:"font-family: monospace; font-size: 14px; width:360px"},
			add "Gunnar Hedin",1786911,2092
			add "IM Axel Ornstein",1786911,2062
			add "Henrik Strömbäck",1786911,2010
			add "Stefan Engström",1786911,1977
			add "Tomas Lindblad",1786911,1977
			add "Lennart B Johansson",1786911,1949
			add "Bo Ländin",1786911,1947
			add "Andrzej Kamiński",1786911,1932
			add "Rado Jovic",1786911,1930
			add "Rune Evertsson",1786911,1915
			add "Kjell Häggvik",1786911,1913
			add "WFM Susanna Berg Laachiri",1786911,1899
			add "Olle Ålgars",1786911,1896
			add "Peter Silins",1786911,1894
			add "Leif Lundquist",1786911,1865
			add "Lars-Åke Pettersson",1786911,1848
			add "Sven-Åke Karlsson",1786911,1842
			add "Ove Hartzell",1786911,1824
			add "Dick Viklund",1786911,1821
			add "Björn Löwgren",1786911,1820
			add "Bo Franzén",1786911,1806
			add "Hans Weström",1786911,1798
			add "Johan Sterner",1786911,1791
			add "Lars Ring",1786911,1785
			add "Veine Gustavsson",1786911,1753
			add "Lars Cederfeldt",1786911,1752
			add "Sten Hellman",1786911,1729
			add "Christer Johansson",1786911,1729
			add "Magnus Karlsson",1786911,1724
			add "Leonid Stolov",1786911,1695
			add "Christer Nilsson",1786911,1694
			add "Abbas Razavi",1786911,1688
			add "Friedemann Stumpf",1786911,1670
			add "Kent Sahlin",1786911,1660
			add "Lars-Ivar Juntti",1786911,1588
			add "Helge Bergström",1786911,1540
			add "Arne Jansson",1786911,1539
			add "Jouko Liistamo",1786911,1531
			add "Ali Koç",1786911,1500
			add "Mikael Lundberg",1786911,1600

		div class:'bar',
			button id:'clear',    'Clear'
			button id:'help',     'Help'
			button id:'continue', 'Continue'

	player.addEventListener "keydown", (event) => if event.key == "Enter" then ins.click()
	bases.addEventListener "change", -> update()
	incrs.addEventListener "change", -> update()
	rounds.addEventListener "change", -> update()
	double.addEventListener "change", -> update()

	# Insert
	ins.addEventListener 'click', -> 
		p = await transfer SPEED, player.value
		# Förhindra dublett
		if Array.from(players.options).some (o) -> -1 != o.text.indexOf player.value then return

		if p.length < 10 then return 
		players.add option p

		sortSelect players

		# Sök upp rätt FIDE id och sätt selectedIndex
		for i in range players.options.length
			line = players.options[i].innerText
			echo i,player.value,line
			if line.indexOf(player.value) >= 0 # .innerText
				players.selectedIndex = i

		player.value = ""
		player.focus()

		update()

	# Delete
	del.addEventListener 'click', -> 
		if players.options?.length == 0 then return 
		i = players.selectedIndex
		players.remove i
		if i >= players.options?.length then i--
		players.selectedIndex = i
		update()

###
Sorterar en befintlig <select>.

- Behåller valt värde (om möjligt)
- Sorterar inom optgroup om sådana finns
- Standard: sortering på option-text, svenska regler, numerisk

	@param selectEl [HTMLSelectElement]
	@param opts [Object]
###
	sortSelect = (selectEl, opts = {}) ->

		locale          = opts.locale ? "sv"
		numeric         = opts.numeric ? true
		caseInsensitive = opts.caseInsensitive ? true
		xby              = opts.by ? "text"   # "text" eller "value"

		collator = new Intl.Collator locale,
			numeric: numeric
			sensitivity: if caseInsensitive then "base" else "variant"

		prevValue = selectEl.value

		sortContainer = (container) ->
			options = Array.from container.querySelectorAll ":scope > option"

			options.sort (a, b) ->
				aKey = if xby is "value" then a.value else a.text
				bKey = if xby is "value" then b.value else b.text
				collator.compare aKey, bKey

			for opt in options
				opt.remove()

			container.append ...options

		groups = Array.from selectEl.querySelectorAll ":scope > optgroup"

		if groups.length > 0
			sortContainer g for g in groups
		else
			sortContainer selectEl

		# återställ val om möjligt
		for opt in selectEl.options when opt.value is prevValue
			selectEl.value = prevValue
			break

	sortSelect players

	players.selectedIndex = players.options?.length - 1
	bases.selectedIndex = MINUTES.length - 1
	incrs.selectedIndex = SECONDS.length - 1
	rounds.selectedIndex = 8
	double.selectedIndex = 0

	update()

	render app,result

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
	if rating == undefined or name == undefined
		fidenumber
	else
		arr = name.split ","
		name = arr[0].toUpperCase() + arr[1]
		name = name.slice 0,NAME_LEN
		name.padEnd(NAME_LEN,NBSP) + " " + rating + " " + fidenumber

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
		name = person.slice 0,NAME_LEN
		name = name.replaceAll NBSP, ' '
		name = name.trim()
		elo = person.slice NAME_LEN+1, NAME_LEN+5
		fideid = person.slice NAME_LEN+6
		echo name,elo,fideid
		global.players.push new Player global.players.length, name, elo, fideid

	if global.players.length % 2 == 1
		global.frirond = global.players.length
		global.players.push '0000|BYE|0'
	else
		global.frirond = null

	if settings.ROUNDS > global.players.length - 1 then return # / 2 then return

	if global.rounds == null then global.rounds = []

	url = makeURL()
	global.players = []
	global.rounds = []

	window.location.href = url
	# echo 'window.location.href = url'
