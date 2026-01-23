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
	player = koppla "input", div4, placeholder:'FIDE id', type:"text", inputmode:"numeric", oninput:"this.value = this.value.replace(/[^0-9]/g, '')" 

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
	del = koppla "button", div4, text:'Delete'
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

	# handleSpace = (lastName, firstName, fideid, elo) -> 
	handleSpace = (name, fideid, elo) -> 
		#name = lastName.toUpperCase() + " " + firstName
		if name.length > NAME_LEN then name = name.slice 0,NAME_LEN # 21
		name = name.padEnd NAME_LEN,' '
		"#{name} #{elo} #{fideid}".replaceAll " ", NBSP

	playerCount = koppla "label", div4, text: "13"

	players = koppla "select", panel, size:20, style:"font-family: monospace; font-size: 14px;"

	# koppla "option", players, text: handleSpace "Muntean", "Victor", 2141, 1786911
	# koppla "option", players, text: handleSpace "Radon", "Vida",1406,1786911
	# koppla "option", players, text: handleSpace "Grahn", "Vidar",2272,1786911
	# koppla "option", players, text: handleSpace "Seiger", "Vidar",2109,1786911
	# koppla "option", players, text: handleSpace "Hillbur", "Anders",1688,1786911
	# koppla "option", players, text: handleSpace "Kallin", "Anders",1827,1786911
	# koppla "option", players, text: handleSpace "Lindebaum", "André J",1748,1786911
	# koppla "option", players, text: handleSpace "Nordenfur", "Anton",1641,1786911
	# koppla "option", players, text: handleSpace "Banerjee", "Aryan",2001,1786911
	# koppla "option", players, text: handleSpace "Lofstrom", "Bjorn",1800,1786911
	# koppla "option", players, text: handleSpace "Isurina Mariano", "Cristine Rose",1944,5201071
	# koppla "option", players, text: handleSpace "Wickstrom", "Carina",1907,1786911
	# koppla "option", players, text: handleSpace "Carmegren", "Christer",1579,1786911
	# koppla "option", players, text: handleSpace "Johansson", "Christer",1828,1786911
	# koppla "option", players, text: handleSpace "Nilsson", "Christer",1575,1786911
	# koppla "option", players, text: handleSpace "Vesterbaek Pedersen", "Daniel",2213,1402161
	# koppla "option", players, text: handleSpace "Broman", "David",1417,1786911
	# koppla "option", players, text: handleSpace "Parteg", "Eddie",1709,1786911
	# koppla "option", players, text: handleSpace "Kingsley", "Elias",1977,1786911
	# koppla "option", players, text: handleSpace "Dingertz", "Erik",2093,1786911
	# koppla "option", players, text: handleSpace "Bjorkman", "Filip",2113,1786911
	# koppla "option", players, text: handleSpace "Mollerstrom", "Fredrik",1848,1786911
	# koppla "option", players, text: handleSpace "Sorensen", "Hampus",2416,1786911
	# koppla "option", players, text: handleSpace "Uniyal Hanns", "Ivar",1622,1786911
	# koppla "option", players, text: handleSpace "Ranby", "Hans",1893,1786911
	# koppla "option", players, text: handleSpace "Enholm", "Herman",1923,1786911
	# koppla "option", players, text: handleSpace "Hardwick", "Hugo",1733,1786911
	# koppla "option", players, text: handleSpace "Sundell", "Hugo",1728,1786911
	# koppla "option", players, text: handleSpace "Arnshav", "Ivar",1400,1786911
	# koppla "option", players, text: handleSpace "Ahlstrom", "Jens",1624,1786911
	# koppla "option", players, text: handleSpace "Borin", "Jesper",1878,1786911
	# koppla "option", players, text: handleSpace "Hultin", "Joacim",1763,1786911
	# koppla "option", players, text: handleSpace "Berglund", "Joar",1886,1786911
	# koppla "option", players, text: handleSpace "Olund", "Joar",2366,1786911
	# koppla "option", players, text: handleSpace "Ostlund", "Joar",2335,1786911
	# koppla "option", players, text: handleSpace "Ahfeldt", "Joel",1897,1786911
	# koppla "option", players, text: handleSpace "Sandberg", "Jonas",1794,1786911
	# koppla "option", players, text: handleSpace "Kaunonen", "Jouni",1721,1786911
	# koppla "option", players, text: handleSpace "Jakenberg", "Jussi",2022,1786911
	# koppla "option", players, text: handleSpace "Khaschuluu","Sergelenbaatar",1871,4920929
	# koppla "option", players, text: handleSpace "Masoudi", "Karam",1833,1786911
	# koppla "option", players, text: handleSpace "Rehnberg", "Karl-Oskar",1480,1786911
	# koppla "option", players, text: handleSpace "Fahlberg", "Kenneth",1846,1786911
	# koppla "option", players, text: handleSpace "Jernselius", "Kjell",1787,1786911
	# koppla "option", players, text: handleSpace "Schultz", "Kristoffer",1400,1786911
	# koppla "option", players, text: handleSpace "Eriksson", "Lars",1733,1786911
	# koppla "option", players, text: handleSpace "Pettersson", "Lars-Ake",1761,1786911
	# koppla "option", players, text: handleSpace "Valcu", "Lavinia",2039,1786911
	# koppla "option", players, text: handleSpace "Evertsson", "Lennart",2031,1786911
	# koppla "option", players, text: handleSpace "Crevatin", "Leo",2235,1786911
	# koppla "option", players, text: handleSpace "Ljungros", "Lo",1936,1786911
	# koppla "option", players, text: handleSpace "Willstedt", "Lukas",2046,1786911
	# koppla "option", players, text: handleSpace "De Lafonteyne", "Maxime",1400,1785133
	# koppla "option", players, text: handleSpace "Hamina", "Martti",1803,1786911
	# koppla "option", players, text: handleSpace "Sakic", "Matija",2065,1786911
	# koppla "option", players, text: handleSpace "Duke", "Michael",2076,1786911
	# koppla "option", players, text: handleSpace "Mattsson", "Michael",2048,1786911
	# koppla "option", players, text: handleSpace "Wiedenkeller", "Michael",2413,1786911
	# koppla "option", players, text: handleSpace "Blom", "Mikael",1889,1786911
	# koppla "option", players, text: handleSpace "Helin", "Mikael",1885,1786911
	# koppla "option", players, text: handleSpace "Bergqvist", "Morris",1818,1786911
	# koppla "option", players, text: handleSpace "Jamshedi", "Mukhtar",1778,1786911
	# koppla "option", players, text: handleSpace "Nodtveidt", "Mans",1524,1786911
	# koppla "option", players, text: handleSpace "Bychkov", "Nicholas Zwahlen",1796,1786911
	# koppla "option", players, text: handleSpace "Malmquist", "Neo",1768,1786911
	# koppla "option", players, text: handleSpace "Nilsson", "Oliver",2035,1786911
	# koppla "option", players, text: handleSpace "Algars", "Olle",1880,1786911
	# koppla "option", players, text: handleSpace "Wiss", "Patrik",1650,1786911
	# koppla "option", players, text: handleSpace "Gedda", "Peder",1835,1786911
	# koppla "option", players, text: handleSpace "Isaksson", "Per",1954,1786911
	# koppla "option", players, text: handleSpace "Tripathi", "Pratyush",2108,1786911
	# koppla "option", players, text: handleSpace "Cernea", "Radu",1783,1786911
	# koppla "option", players, text: handleSpace "Gore", "Rohan",1793,1786911
	# koppla "option", players, text: handleSpace "Karlsson", "Roy",1852,1786911
	# koppla "option", players, text: handleSpace "Banavi", "Salar",1671,1786911
	# koppla "option", players, text: handleSpace "Bardhan", "Sayak Raj",1680,1786911
	# koppla "option", players, text: handleSpace "Van Den Brink", "Sid",1695,1779940
	# koppla "option", players, text: handleSpace "Johansson", "Simon",1726,1786911
	# koppla "option", players, text: handleSpace "Nyberg", "Stefan",1896,1786911
	# koppla "option", players, text: handleSpace "Nodtveidt", "Svante",1691,1786911
	# koppla "option", players, text: handleSpace "Nordenfur", "Tim",1985,1786911

	koppla "option", players, text: handleSpace "Gunnar Hedin",1786911,2092
	koppla "option", players, text: handleSpace "IM Axel Ornstein",1786911,2062
	koppla "option", players, text: handleSpace "Henrik Strömbäck",1786911,2010
	koppla "option", players, text: handleSpace "Stefan Engström",1786911,1977
	koppla "option", players, text: handleSpace "Tomas Lindblad",1786911,1977
	koppla "option", players, text: handleSpace "Lennart B Johansson",1786911,1949
	koppla "option", players, text: handleSpace "Bo Ländin",1786911,1947
	koppla "option", players, text: handleSpace "Andrzej Kamiński",1786911,1932
	koppla "option", players, text: handleSpace "Rado Jovic",1786911,1930
	koppla "option", players, text: handleSpace "Rune Evertsson",1786911,1915
	koppla "option", players, text: handleSpace "Kjell Häggvik",1786911,1913
	koppla "option", players, text: handleSpace "WFM Susanna Berg Laachiri",1786911,1899
	koppla "option", players, text: handleSpace "Olle Ålgars",1786911,1896
	koppla "option", players, text: handleSpace "Peter Silins",1786911,1894
	koppla "option", players, text: handleSpace "Leif Lundquist",1786911,1865
	koppla "option", players, text: handleSpace "Lars-Åke Pettersson",1786911,1848
	koppla "option", players, text: handleSpace "Sven-Åke Karlsson",1786911,1842
	koppla "option", players, text: handleSpace "Ove Hartzell",1786911,1824
	koppla "option", players, text: handleSpace "Dick Viklund",1786911,1821
	koppla "option", players, text: handleSpace "Björn Löwgren",1786911,1820
	koppla "option", players, text: handleSpace "Bo Franzén",1786911,1806
	koppla "option", players, text: handleSpace "Hans Weström",1786911,1798
	koppla "option", players, text: handleSpace "Johan Sterner",1786911,1791
	koppla "option", players, text: handleSpace "Lars Ring",1786911,1785
	koppla "option", players, text: handleSpace "Veine Gustavsson",1786911,1753
	koppla "option", players, text: handleSpace "Lars Cederfeldt",1786911,1752
	koppla "option", players, text: handleSpace "Sten Hellman",1786911,1729
	koppla "option", players, text: handleSpace "Christer Johansson",1786911,1729
	koppla "option", players, text: handleSpace "Magnus Karlsson",1786911,1724
	koppla "option", players, text: handleSpace "Leonid Stolov",1786911,1695
	koppla "option", players, text: handleSpace "Christer Nilsson",1786911,1694
	koppla "option", players, text: handleSpace "Abbas Razavi",1786911,1688
	koppla "option", players, text: handleSpace "Friedemann Stumpf",1786911,1670
	koppla "option", players, text: handleSpace "Kent Sahlin",1786911,1660
	koppla "option", players, text: handleSpace "Lars-Ivar Juntti",1786911,1588
	koppla "option", players, text: handleSpace "Helge Bergström",1786911,1540
	koppla "option", players, text: handleSpace "Arne Jansson",1786911,1539
	koppla "option", players, text: handleSpace "Jouko Liistamo",1786911,1531
	koppla "option", players, text: handleSpace "Ali Koç",1786911,1500
	koppla "option", players, text: handleSpace "Mikael Lundberg",1786911,1600

	sortSelect players

	players.style.width = "360px"
	players.selectedIndex = players.options?.length - 1

	bases.selectedIndex = MINUTES.length - 1
	incrs.selectedIndex = SECONDS.length - 1
	rounds.selectedIndex = 8
	double.selectedIndex = 0

	div5 = koppla "div", panel, class:'bar'

	koppla "button", div5, id:'clear',    text:'Clear'
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

	if settings.ROUNDS > global.players.length / 2 then return

	if global.rounds == null then global.rounds = []

	url = makeURL()
	# echo url
	global.players = []
	global.rounds = []

	window.location.href = url
	# echo 'window.location.href = url'
