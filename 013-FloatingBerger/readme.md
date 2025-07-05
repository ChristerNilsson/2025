# Floating Berger

[Try it!](https://christernilsson.github.io/2025/013-FloatingBerger/)

Byt ut elos och namn mot de som ska gälla i din turnering

```
TITLE = Sommarturnering RIO 2025
GAMES = 1
ROUNDS = 11

1698 Onni Aikio
1558 Helge Bergström
1549 Jonas Hök
1679 Lars Johansson
1400 Per Eriksson

1653 Christer Nilsson
1673 Per Hamnström
1504 Thomas Paulin
1706 Abbas Razavi
1650 Ture Turesson

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

* När turneringen börjat kan man inte lägga till eller ta bort spelare
* Man får inte ändra elo under turneringens gång
* Skriv alltid ut Bordslistorna! De fungerar som backup
* Historiken innehåller tidigare ronder

# Begränsningar

* URL:en bör vara mindre än cirka 5600 tecken lång. 
* Begränsningar finns dels i bläddraren, men även på servern, i detta fall chrome + github.com

200 spelare och tio ronder gav en url på 5600 tecken.  
400 spelare gav felmeddelandet: URL too long. (11000 tecken)  