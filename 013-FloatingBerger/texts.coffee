export helpText = """<h3>Floating Berger version 1.2</h3>TITLE   = turneringens namn
ROUNDS  = antal ronder
GAMES   = antal partier per rond • 1=enkelrond • 2=dubbelrond 
SORT    = spelarnas sorteras på elo • 0=utan sortering • 1=med sortering
BALANCE = färgbalans • 0=utan färgbalans • 1=med färgbalans

1653 Christer Nilsson: elo + namn. Ange 1400 om elo saknas

Programmet hanterar två olika turneringsformat:

* Berger: alla möter alla
* Floating: som Schweizer, fast spelarna möter spelare med samma rating istf poäng
* Formatet styrs mha ROUNDS

Namnet Floating kommer av att de flesta spelare upplever att de är i mitten av sin egen lilla virtuella Berger-grupp.
Delar man in en turnering i flera fysiska Berger-grupper, kommer färre deltagare att uppleva detta.
<h3>Handhavande</h3>* 0      • Vit Förlust
* space  • Remi
* 1      • Vit Vinst
* delete • tar bort ett resultat

* nedåtpil   • nästa bord
* uppåtpil   • förra bordet
* högerpil   • nästa rond
* vänsterpil • förra ronden

* # • sortering på spelarens id
* n • sortering på Namn
* e • sortering på Elo
* p • sortering på P (partipoäng)
* r • sortering på PR (performance rating)

* a • visar enbart ställning
* b • visar enbart bord
* c • visar både ställning och bord (default)

* m • PR: fler decimaler 
* l • PR: färre decimaler

* ctrl p • skriver ut
* ctrl + • zoomar in
* ctrl - • zoomar ut
<h3>Backup</h3>Kopiera urlen och spara på säker plats. T ex på en USB-sticka eller skicka ett mail. Länken finns även i historiken.

"""
