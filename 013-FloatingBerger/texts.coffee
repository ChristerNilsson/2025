export helpText = """<h3>Floating Berger version 1.2</h3>TITLE:   Turneringens namn
ROUNDS:  antal ronder
GAMES:   antal partier per rond • 1=enkelrond • 2=dubbelrond 
SORT:    spelarnas sorteras på elo • 0=utan sortering • 1=med sortering
BALANCE: färgbalans • 0=utan färgbalans • 1=med färgbalans

1653 Christer Nilsson: elo + namn. Ange 1400 om elo saknas

Programmet hanterar två olika turneringsformat:

* Berger 
  * alla möter alla

* Floating
  * som Schweizer, fast spelarna möter spelare med samma rating istf poäng
  * alla ronder lottas i förväg
  * vinnare utses mha Performance Rating istf poäng

* Formatet styrs mha ROUNDS

Namnet Floating kommer av att de flesta spelare upplever att de är i mitten av sin egen lilla virtuella Berger-grupp.
Delar man in en turnering i flera fysiska Berger-grupper, kommer färre deltagare att uppleva detta.
<h3>Handhavande</h3>* Klick på kolumn sorterar

* ctrl p • skriver ut
* ctrl + • zoomar in
* ctrl - • zoomar ut

* a • visar enbart ställning
* b • visar enbart bord
* c • visar både ställning och bord (default)

* 0      • Vit Förlust
* space  • Remi
* 1      • Vit Vinst
* delete • tar bort ett resultat

* nedåtpil   • nästa bord
* uppåtpil   • förra bordet
* högerpil   • nästa rond
* vänsterpil • förra ronden

Sortering:
Klicka på ett kolumnhuvud eller tryck på ett av dessa tecken:

* # • spelarens id
* n • Namn
* e • Elo
* p • P
* r • PR

* m • PR: fler decimaler 
* l • PR: färre decimaler
<h3>Backup</h3>Kopiera urlen och spara på säker plats. T ex på en USB-sticka eller skicka ett mail.

<h3>URL</h3>
r7 • resultat för rond 7 i bordsordning. T ex 012x för fyra bord
  0 • Vit Förlust
  1 • Remi
  2 • Vit Vinst
  x • Resultat saknas

"""
