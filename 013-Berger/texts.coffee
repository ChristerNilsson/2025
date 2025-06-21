export bergerText = """?TITLE=Berger
&GAMES=1
&TYPE=Berger
&R=9

&p=1698 Onni Aikio
&p=1558 Helge Bergström
&p=1549 Jonas Hök
&p=1679 Lars Johansson
&p=1400 Per Eriksson
&p=1653 Christer Nilsson
&p=1673 Per Hamnström
&p=1504 Thomas Paulin
&p=1706 Abbas Razavi
&p=1579 Jouko Liistamo

&r1=01201
&r2=01201
&r3=01201
&r4=01201
&r5=11111
&r6=00000
&r7=22222
&r8=01201
&r9=01201
"""

export fairpairText = """?TITLE=FairPair
&GAMES=2
&TYPE=FairPair
&R=5

&p=1698 Onni Aikio
&p=1558 Helge Bergström
&p=1549 Jonas Hök
&p=1679 Lars Johansson
&p=0000 Per Eriksson
&p=1653 Christer Nilsson
&p=1673 Per Hamnström
&p=1504 Thomas Paulin
&p=1706 Abbas Razavi
&p=1579 Jouko Liistamo
&p=1798 Aikio
&p=1658 Bergström
&p=1649 Hök
&p=1779 Johansson
&p=0000 Eriksson
&p=1753 Nilsson
&p=1773 Hamnström
&p=1604 Paulin
&p=1806 Razavi
&p=1679 Liistamo

&r1=0120120120
&r2=0120120120

"""

# &r1=0120120120
# &r2=0120120120
# &r3=0120120120
# &r4=0120120120
# &r5=0120120120

# export fairpairText = """?TITLE=FairPair
# &GAMES=2
# &TYPE=FairPair
# &R=5

# &p=1419 Onni Aikio
# &p=1418 Helge Bergström
# &p=1417 Jonas Hök
# &p=1416 Lars Johansson
# &p=1415 Per Eriksson
# &p=1414 Christer Nilsson
# &p=1413 Per Hamnström
# &p=1412 Thomas Paulin
# &p=1411 Abbas Razavi
# &p=1410 Jouko Liistamo
# &p=1409 Aikio
# &p=1408 Bergström
# &p=1407 Hök
# &p=1406 Johansson
# &p=1405 Eriksson
# &p=1404 Nilsson
# &p=1403 Hamnström
# &p=1402 Paulin
# &p=1401 Razavi
# &p=1400 Liistamo

# &r1=0120120120
# &r2=0120120120
# &r3=0120120120
# &r4=0120120120
# &r5=0120120120
# """


# &p=1698 Onni Aikio
# &p=1558 Helge Bergström
# &p=1549 Jonas Hök
# &p=1679 Lars Johansson
# &p=1400 Per Eriksson
# &p=1653 Christer Nilsson
# &p=1673 Per Hamnström
# &p=1504 Thomas Paulin
# &p=1706 Abbas Razavi
# &p=1579 Jouko Liistamo
# &p=1600 Adam
# &p=1700 Bertil

# &r1=012010
# &r2=012010
# &r3=012010
# &r4=012010

export helpText = """<h3>Introduktion</h3>Detta program kan lotta och visa två olika turneringsformat:
	* Berger (alla möter alla)
	* FairPair (flytande Berger, typ)

* Alla ronder lottas i förväg
* Hanterar upp till fyra partier per rond, t ex dubbelrond eller lagmatch
* All nödvändig information skickas in som parametrar
<h3>Interaktioner</h3>* Klick på rond visar bordslistan
* Klick på annan kolumn sorterar
* ctrl p skriver ut
* ctrl + och ctrl - zoomar
<h3>Parametrar</h3>?TITLE=Sommarturnering 2025
	Anger turneringens namn

&TYPE=Berger
	Anger Berger eller FairPair

&GAMES=1
	Anger antal partier per rond. 1 till 4.

&R=9
	Anger antal ronder (automatisk för Berger)

&p=1653 Christer Nilsson
	Alla deltagare anges med rating och namn
	Använd 0000 för deltagare utan rating 

&r1=012x0 
	Vitspelarnas resultat för den första ronden, i bordsordning
	GAMES=1:
		0 = Förlust
		1 = Remi
		2 = Vinst

	GAMES=2: 0 till 4 kan användas
	GAMES=3: 0 till 6 kan användas
	GAMES=4: 0 till 8 kan användas
	x = Ej spelat

"""

