import {echo,global,range,settings} from './global.js'
import {Player} from './player.js'
import {makeURL} from './tournament.js'
import {render, tag} from './fasthtml.js'
import {Select} from './select.js'

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
	if name.length > NAME_LEN then name = name.slice 0,NAME_LEN
	name = name.padEnd NAME_LEN,' '
	"#{name} #{elo} #{fideid}".replaceAll " ", NBSP

initialPlayers = [
	add "Gunnar Hedin",1786911,2092
	add "Axel Ornstein",1786911,2062
	add "Henrik Strömbäck",1786911,2010
	add "Stefan Engström",1786911,1977
	add "Tomas Lindblad",1786911,1977
	add "Lennart B Johansson",1786911,1949
	add "Bo Ländin",1786911,1947
	add "Andrzej Kamiński",1786911,1932
	add "Rado Jovic",1786911,1930
	add "Rune Evertsson",1786911,1915
	add "Kjell Häggvik",1786911,1913
	add "Susanna Berg Laachiri",1786911,1899
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
]

export clear = -> players.length = 0

export initialize = ->

	app = document.getElementById "app"
	app.style.display = "flex"
	app.style.flexDirection = "column"
	app.style.alignItems = "left"
	# app.style.gap = "8px"
	app.style.textAlign = "center"

	styleEl = document.getElementById 'fairpair-form-colors'
	if not styleEl
		styleEl = document.createElement 'style'
		styleEl.id = 'fairpair-form-colors'
		styleEl.textContent = """
			input, select, button {
				border: 1px solid #000;
				color: #000;
			}

			input::placeholder {
				color: #000;
				opacity: 1;
			}
		"""
		document.head.appendChild styleEl

	players = new Select 
		items: initialPlayers

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
			playerCount = label "0 players"

		players.element
		
		div class:'bar',
			btnClear = button id:'clear',    'Clear'
			btnHelp = button id:'help',     'Help'
			btnContinue = button id:'continue', 'Continue'

	players.onCountChange = (count) -> playerCount.textContent = "#{count} players"
	players.onCountChange players.element.children.length

	player.addEventListener "keydown", (event) => if event.key == "Enter" then ins.click()
	bases.addEventListener "change", -> update()
	incrs.addEventListener "change", -> update()
	rounds.addEventListener "change", -> update()
	double.addEventListener "change", -> update()

	# Insert
	ins.addEventListener 'click', -> 
		p = await transfer SPEED, player.value
		if p.length < 4 then return 
		if Array.from(players.element.children).some (child) -> -1 != child.innerText.indexOf player.value then return
		players.add p

		# Sök upp rätt FIDE id och sätt selectedIndex
		for i in range players.element.children.length
			line = players.element.children[i].innerText
			if line.indexOf(player.value) >= 0 # .innerText
				players.setSelectedIndex i

		player.value = ""
		player.focus()

		update()

	del.addEventListener 'click', -> players.removeSelected()
	btnClear.addEventListener 'click', -> players.clear()

	players.setSelectedIndex players.element.children.length - 1
	bases.selectedIndex = MINUTES.length - 1
	incrs.selectedIndex = SECONDS.length - 1
	rounds.selectedIndex = 8
	double.selectedIndex = 0

	update()

	render app,result

fetchShard = (fidenumber) ->
	shard = "#{fidenumber}"
	n = shard.length
	if n < 4 then return ""
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
	# echo member
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

export init = -> # läs initiala uppgifter om turneringen

	if title.value == null then return
	if city.value == null then return
	if fed.value == null then return
	if arb.value == null then return
	if players.element.children.length < 4 then return

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

	for option in players.element.children
		persons.push option.textContent

	persons.sort().reverse()

	for person in persons
		name = person.slice 0,NAME_LEN
		name = name.replaceAll NBSP, ' '
		name = name.trim()
		elo = person.slice NAME_LEN+1, NAME_LEN+5
		fideid = person.slice NAME_LEN+6
		echo name,elo,fideid
		global.players.push new Player global.players.length, name, elo, fideid

	global.frirond = null

	maxRounds = if global.players.length % 2 == 0 then global.players.length - 1 else global.players.length
	if settings.ROUNDS > maxRounds then return # / 2 then return

	if global.rounds == null then global.rounds = []

	url = makeURL()
	global.players = []
	global.rounds = []

	window.location.href = url
	# echo 'window.location.href = url'
