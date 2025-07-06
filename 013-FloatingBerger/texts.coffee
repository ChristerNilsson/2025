export helpText = """<h3>Floating Berger version 1.0</h3>Detta program hanterar två olika turneringsformat:

	* Berger 
	  * alla möter alla
	* FairPair 
	  * som Schweizer, fast spelarna möter spelare med minimal ratingskillnad, oavsett poäng
	  * FairPair väljs genom att sätta ROUNDS till ett lågt antal.

Namnet Floating Berger kommer av att de flesta spelare upplever att de är i mitten av sin egen lilla virtuella Berger-grupp.
Delar man in en turnering i flera fysiska Berger-grupper, kommer färre deltagare att uppleva detta.

* Alla ronder lottas i förväg
* Hanterar enkelrond (GAMES=1) eller dubbelrond (GAMES=2)
* Färgbalans anges med BALANS=1 (Ej aktuellt för Berger)
* Dubbelrond behöver bara färgbalanseras om man tillåter att dubbelronden körs som enkelrond (anvancerad)
* All nödvändig information skickas in som parametrar till adressfältet
<h3>Interaktioner</h3>* Klick på rond visar bordslistan
* Klick på annan kolumn sorterar

* ctrl p skriver ut
* ctrl + och ctrl - zoomar

* 1 visar enbart ställningen
* 2 visar enbart borden
* 3 visar både ställning och bord
<h3>Parametrar</h3>TITLE = Sommarturnering 2025
  Anger turneringens namn

GAMES = 1
  Anger antal partier per rond. 1 (default) eller 2 (dubbelrond)

ROUNDS = 9
  Anger antal ronder

SORT = 1
  Anger att spelarnas ursprungliga ordning ska vara sorterad på fallande elo-tal

BALANS = 1
  Anger att färgbalans ska användas.
  Behövs normalt inte då GAMES är jämnt.
  Färgbalanskrav kan ge större elodiffar.

1653 Christer Nilsson
  Alla deltagare anges med rating och namn
  Använd 0000 för deltagare utan rating 

r1 = 0r1x0 
  Vitspelarnas resultat för rond 1, i bordsordning, fem partier
  Svartspelarnas resultat sätts automatiskt
  Totalt 5 + 5 = 10 spelare
  0 = Förlust
  r = Remi
  1 = Vinst
  x = Ej spelat

"""
