export helpText = """<h3>Floating Berger version 1.2</h3>TITLE:   Turneringens namn
ROUNDS:  Anger antal ronder. Default Berger
GAMES:   1 (default) = antal partier per rond. 2 = dubbelrond
SORT:    1 (default) = spelarnas ursprungliga ordning sorteras på fallande elo-tal. 0 = ingen sortering
BALANCE: 1 (default) = färgbalans används. 0 = ingen färgbalans
1653 Christer Nilsson: elo + namn. 0000 om elo saknas
r7 = x0r1: resultat för rond 7 i bordsordning.
  x = Resultat saknas
  0 = Vit Förlust
  r = Remi
  1 = Vit Vinst

Programmet hanterar två olika former:

  * Berger 
    * alla möter alla
  
  * Floating
    * som Schweizer, fast spelarna möter spelare med samma rating istf poäng
    * ronderna lottas i förväg
    * vinnare utses mha Performance Rating istf poäng
    * Floating väljs genom att minska ROUNDS

Namnet Floating Berger kommer av att de flesta spelare upplever att de är i mitten av sin egen lilla virtuella Berger-grupp.
Delar man in en turnering i flera fysiska Berger-grupper, kommer färre deltagare att uppleva detta.
<h3>Handhavande</h3>* Klick på rond visar bordslistan
* Klick på annan kolumn sorterar

* ctrl p skriver ut
* ctrl + och ctrl - zoomar

* 1 visar enbart ställning
* 2 visar enbart bord
* 3 visar både ställning och bord

"""
