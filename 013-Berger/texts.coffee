export helpText = """<h3>Introduktion</h3>Detta program hanterar två olika turneringsformat:
	* Berger 
		* alla möter alla
		* default
	* FairPair 
		* som Schweizer, fast spelarna möter spelare med minimal ratingskillnad, oavsett poäng)
		* FairPair väljs genom att sätta ROUNDS till ett lågt antal.

* Alla ronder lottas i förväg
* Hanterar upp till fyra partier per rond, t ex dubbelrond eller lagmatch
* Färghänsyn tas enbart för udda antal GAMES. 
* All nödvändig information skickas in som parametrar till adressfältet
<h3>Interaktioner</h3>* Klick på rond visar bordslistan
* Klick på annan kolumn sorterar

* ctrl p skriver ut
* ctrl + och ctrl - zoomar

* 1 visar enbart ställningen
* 2 visar enbart borden
* 3 visar både ställning och bord
<h3>Parametrar</h3>TITLE=Sommarturnering 2025
  Anger turneringens namn

GAMES=1
  Anger antal partier per rond. 1 (default), 2, 3 eller 4.

ROUNDS=9
  Anger antal ronder. (default: antal spelare minus 1)

1653 Christer Nilsson
  Alla deltagare anges med rating och namn
  Använd 0000 för deltagare utan rating 

r1=012x0 
  Vitspelarnas resultat för rond 1, i bordsordning
  Svartspelarnas resultat beräknas med hjälp av GAMES
  GAMES=1: (default)
    0 = Förlust
    1 = Remi
    2 = Vinst
    x = Ej spelat
  GAMES=2: 0 till 4 kan användas
  GAMES=3: 0 till 6 kan användas
  GAMES=4: 0 till 8 kan användas

"""
