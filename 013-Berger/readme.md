# Berger

[Try it!](https://christernilsson.github.io/2025/013-Berger/)

Skriv in namnen i en textfil

```
http://127.0.0.1:5500/?title=Joukos Sommar 2025
&MAX=2
&p1=1698 Onni Aikio
&p2=1558 Helge Bergström
&p3=1549 Jonas Hök
```

Markera allt i textfilen med ctrl-a

Gå till Chrome och klistra in med ctrl-v

Skriv ut sidan med ctrl-p

Skriv in de VITA resultaten i filen  

Observera: 
* 0 - 2 vit förlust
* 1 - 1 remi
* 2 - 0 vit vinst

Orsaken till detta är att även kunna hantera dubbelrond, MAX=4:
* 0 - 4
* 1 - 3
* 2 - 2
* 3 - 1
* 4 - 0

Maximalt kan fyra partier per rond hanteras, MAX=8

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

# Strul

När man kopierar den flerradiga urlen genom att markera alla rader, kan det stoppas in ett mellanslag (%20) efter ? och &  
Detta är orsaken till att safeGet används.
