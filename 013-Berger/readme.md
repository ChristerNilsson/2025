# Berger

[Try it!](https://christernilsson.github.io/2025/013-Berger/)

Skriv in namnen i en textfil

```
http://127.0.0.1:5500/?title=Joukos Sommar 2025
&GAMES=2
&p=1698 Onni Aikio
&p=1558 Helge Bergström
&p=1549 Jonas Hök
```

Markera allt i textfilen med ctrl-a

Gå till Chrome och klistra in med ctrl-v

Skriv ut sidan med ctrl-p

Skriv in de VITA resultaten i filen  

Observera: 
* 0 - 2 vit förlust
* 1 - 1 remi
* 2 - 0 vit vinst

Orsaken till detta är att även kunna hantera dubbelrond, GAMES=2:
* 0 - 4
* 1 - 3
* 2 - 2
* 3 - 1
* 4 - 0

Maximalt kan fyra partier per rond hanteras, GAMES=4

```
&r1=201x2
&r2=01202
```

Förklaring
```
r1 = rond 1

0 = vit förlust
1 = remi
2 = vit vinst
x = partiet ej spelat
```

# Handhavande

Rondnummerna är klickbara. Då visas bordslista för klickad rond.

# Skillnader gentemot andra turneringssystem

* Ratingen styr vilka som möts. Skillnaden minimeras.
* Man behöver inte använda särskiljning
* Man lottar alla ronder direkt. Inget strul med orapporterade resultat.
* Inget bekymmer med att dela upp turneringen i flera Berger-grupper.
* Alla spelare vet i vilken rond de ska möta varandra. Som Berger.
* Enkel hantering av lottning, även dubbelrondigt.
* Eftersom turneringens data finns i url:en, dvs länken, kan den enkelt publiceras.

# Att tänka på

* När turneringen börjat kan man inte lägga till eller ta bort spelare. 
* Man får inte ändra elo under turneringens gång.
* Skriv alltid ut Bordslistorna! De fungerar som backup.
* Frirond hanteras manuellt.
