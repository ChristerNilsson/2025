# Floating Berger

[Try it!](https://christernilsson.github.io/2025/013-FloatingBerger/)

Byt ut elos och namn mot de som ska gälla i din turnering

```
TITLE = Sommarturnering RIO 2025
GAMES = 1
ROUNDS = 11
SORT = 0
BALANCE = 1

1698 Onni Aikio
1558 Helge Bergström
1549 Jonas Hök
1679 Lars Johansson
1400 Per Eriksson

1653 Christer Nilsson
1673 Per Hamnström
1504 Thomas Paulin
1706 Abbas Razavi
1650 Jouko Liistamo

1677 Cesar

r1 = 0r10r
r2 = 0rx0r
r3 = 0r10r
r4 = 0r10r
```

Vid dubbelrond sätts GAMES = 2  

Skriv in VITS resultat i textrutan i den ordning Bordslistan anger  

Förklaring
```
r1 = rond 1

0 = vit förlust
r = remi
1 = vit vinst
x = partiet ej spelat
```

# Handhavande

* Rondnummerna är klickbara. Då visas Bordslistan för klickad rond
* Övriga kolumner sorteras när man klickar på dem
* 1 visar enbart Spelarlistan
* 2 visar enbart Bordslistan
* 3 visar båda listorna
* ctrl p skriver ut sidan
* ctrl + zoomar in
* ctrl - zoomar ut
* ctrl h visar tidigare ronder

# Skillnader gentemot andra turneringssystem

* Ratingen styr vilka som möts. Skillnaden minimeras
* Man behöver inte använda särskiljning
* Man lottar alla ronder direkt
* Man kan spela partierna i valfri ordning
* Turneringen behöver ej delas upp i flera Berger-grupper
* Alla spelare vet i vilken rond de ska möta varandra. Som Berger
* Enkel hantering av lottning, även dubbelrondigt
* Eftersom turneringens data finns i url:en, dvs länken, kan den enkelt publiceras

# Att tänka på

* När turneringen börjat får man bara modifiera resultaten. Dvs r1 = osv
* Man får EJ ändra elo, namn, SORT, ROUND eller GAMES under turneringens gång
	* Detta pga att lottningen kan påverkas
* Skriv alltid ut Bordslistorna! 
	* De fungerar som backup
* Historiken innehåller tidigare ronder

# Begränsningar

* URL:en bör vara mindre än cirka 8000 tecken lång. 
* Begränsningar finns dels i bläddraren, men även på servern, i detta fall chrome + github.com

250 spelare och tio ronder gav en url på 6700 tecken.  
400 spelare med sex tecken per namn krävde 7935 tecken.  

# Utveckling

ONE används för att visa noll- eller ett-baserade värden.  
