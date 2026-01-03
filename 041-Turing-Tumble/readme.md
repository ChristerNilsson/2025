Jag har undersökt om Turing Tumble kan producera sekvensen
b rr bbb r bb rrr ...
(123123..)

Svaret är ja, men det går åt 6 till 8 bitar, och den upprepas inte.
CROSS_OVER används 1-3 gånger.

* Undersökningen gick till så att elementen RAMP_L, RAMP_R, BIT samt CROSS_OVER användes.
* Dvs GEAR och GEAR_BIT ingick inte.
* Körningen tog 108 sekunder.
* Jag placerade ut 12 element i en hjärtform och fångade upp dem så fort de lämnade hjärtat.
* De fyra vänstra kolumnerna går till blått, de fyra högra till rött.

* Är detta då en Turingmaskin? Svar: vet ej.
* Jag ville ha enbart sekvensen 123123 123123 ...
* men den dök inte upp.

Jag har tidigare uppnått
```
1 bbbb
21 bbr
2111  bbrrr
211111  bbrrrrr
3212 bbbrrbrr bbbrrbrr
```

* Sekvenser med längder 1,2,4,8,16 osv är triviala.
* Men även 3,5,7 förekommer.
* Dock har jag inte hittat sekvenser med längden 6.

```commandline
7 bbbbbrrbbbrbbrrrbbrbbbrrrbrbbbbrrbrrbbbrrbbrrbbrrbbbrrbrrbbbbrbrrrbbbr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 0, 13: 1, 15: 2, 17: 2, 19: 0, 25: 2, 27: 1, 29: 2, 37: 2, 39: 2, 49: 6}
7 bbbbbrrbbbrbbrrrbbrbbbrrrbrbbbbrrbrrbbbrrbbrrbbrrbbbrrbrrbbbbrbrrrbbbr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 0, 13: 1, 15: 2, 17: 2, 19: 1, 25: 2, 27: 1, 29: 2, 37: 2, 39: 2, 49: 6}
8 bbbbbrrbbbrbbrrrbbrbbbrrrbrbbbbrrbrrbbbrrbbrrbbrrbbbrrbrrbbbbrbrrrbbbr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 0, 13: 1, 15: 2, 17: 2, 19: 2, 25: 2, 27: 1, 29: 2, 37: 2, 39: 2, 49: 6}
6 bbbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 0, 13: 2, 15: 0, 17: 2, 19: 0, 25: 2, 27: 2, 29: 2, 37: 1, 39: 0, 49: 6}
6 bbbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 0, 13: 2, 15: 0, 17: 2, 19: 1, 25: 2, 27: 2, 29: 2, 37: 1, 39: 0, 49: 6}
7 bbbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 0, 13: 2, 15: 0, 17: 2, 19: 2, 25: 2, 27: 2, 29: 2, 37: 1, 39: 0, 49: 6}
7 bbbbbrrbbbrbbrrrbbrbbbrrrbrbbbbrrbrrbbbrrbbrrbbrrbbbrrbrrbbbbrbrrrbbbr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 1, 15: 2, 17: 0, 19: 0, 25: 2, 27: 1, 29: 2, 37: 2, 39: 2, 49: 6}
7 bbbbbrrbbbrbbrrrbbrbbbrrrbrbbbbrrbrrbbbrrbbrrbbrrbbbrrbrrbbbbrbrrrbbbr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 1, 15: 2, 17: 0, 19: 2, 25: 2, 27: 1, 29: 0, 37: 2, 39: 2, 49: 6}
8 bbbbbrrbbbrbbrrrrbbrrbbbrrbrrbbbbrrbrrrbbbrbbrrrrbbrrbbbrrbrrbbbbrrbrrrbbbr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 1, 15: 2, 17: 0, 19: 2, 25: 2, 27: 1, 29: 2, 37: 2, 39: 2, 49: 6}
7 bbbbbrrbbbrbbrrrbbrbbbrrrbrbbbbrrbrrbbbrrbbrrbbrrbbbrrbrrbbbbrbrrrbbbr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 1, 15: 2, 17: 0, 19: 2, 25: 2, 27: 1, 29: 6, 37: 2, 39: 2, 49: 6}
7 bbbbbrrbbbrbbrrrbbrbbbrrrbrbbbbrrbrrbbbrrbbrrbbrrbbbrrbrrbbbbrbrrrbbbr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 1, 15: 2, 17: 1, 19: 2, 25: 2, 27: 1, 29: 0, 37: 2, 39: 2, 49: 6}
7 bbbbbrrbbbrbbrrrbbrbbbrrrbrbbbbrrbrrbbbrrbbrrbbrrbbbrrbrrbbbbrbrrrbbbr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 1, 15: 2, 17: 1, 19: 2, 25: 2, 27: 6, 29: 0, 37: 2, 39: 2, 49: 6}
8 bbbbbrrbbbrbbrrrbbrbbbrrrbrbbbbrrbrrbbbrrbbrrbbrrbbbrrbrrbbbbrbrrrbbbr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 1, 15: 2, 17: 2, 19: 2, 25: 2, 27: 1, 29: 0, 37: 2, 39: 2, 49: 6}
7 bbrrbbbrbbrrrbbbrbbrrbrbbrbrrbbrbbrbrrbbrbrbbrrbbrbrbbrrbrbbrbbbrrrbbrb {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 1, 15: 2, 17: 2, 19: 2, 25: 2, 27: 2, 29: 0, 37: 1, 39: 0, 49: 6}
6 bbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrb {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 1, 15: 2, 17: 2, 19: 2, 25: 2, 27: 6, 29: 0, 37: 1, 39: 0, 49: 6}
6 bbbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 2, 15: 0, 17: 0, 19: 0, 25: 2, 27: 2, 29: 2, 37: 1, 39: 0, 49: 6}
6 bbbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 2, 15: 0, 17: 0, 19: 2, 25: 2, 27: 2, 29: 0, 37: 1, 39: 0, 49: 6}
7 bbbrrbbbrbbrrrrbbbrrrbbbrbbrrrrbbbrrrbbbrbbrrrrbbbrrrbbbrbbrrrrbbbrrrbbbrbbrrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 2, 15: 0, 17: 0, 19: 2, 25: 2, 27: 2, 29: 2, 37: 1, 39: 0, 49: 6}
6 bbbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 2, 15: 0, 17: 0, 19: 2, 25: 2, 27: 2, 29: 6, 37: 1, 39: 0, 49: 6}
6 bbbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 2, 15: 0, 17: 2, 19: 2, 25: 1, 27: 1, 29: 0, 37: 2, 39: 6, 49: 6}
6 bbbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 2, 15: 0, 17: 2, 19: 2, 25: 2, 27: 0, 29: 0, 37: 1, 39: 0, 49: 6}
6 bbbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 2, 15: 0, 17: 2, 19: 2, 25: 2, 27: 0, 29: 0, 37: 1, 39: 6, 49: 6}
6 bbbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 2, 15: 0, 17: 2, 19: 2, 25: 2, 27: 1, 29: 0, 37: 1, 39: 6, 49: 6}
6 bbbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 2, 15: 0, 17: 2, 19: 2, 25: 2, 27: 1, 29: 0, 37: 6, 39: 6, 49: 6}
7 bbbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 2, 15: 0, 17: 2, 19: 2, 25: 2, 27: 2, 29: 0, 37: 1, 39: 6, 49: 6}
6 bbbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 2, 15: 0, 17: 2, 19: 2, 25: 2, 27: 6, 29: 0, 37: 1, 39: 0, 49: 6}
6 bbbrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrrbbbrbbbrrrbbrbbbrrrbbbrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 2, 15: 0, 17: 2, 19: 2, 25: 2, 27: 6, 29: 0, 37: 1, 39: 6, 49: 6}
8 bbbbrbbrbrrbbbrbbrrrrbbrbrrbbbrbbrrrrbbrbrrbbbrbbrrrrbbrbrrbbbrbbrrrrbbrbrrb {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 2, 15: 1, 17: 2, 19: 0, 25: 2, 27: 2, 29: 2, 37: 6, 39: 6, 49: 2}
7 bbbbrbbrbrrbbbrbbrrrbbbrrbbbrrrbbrbbbrrbrbbrrrbbbbrbrbrrrbbrbbbbrrrbbrrr {23: 'b', 35: 'b', 47: 'b', 59: 'b', 31: 'r', 41: 'r', 51: 'r', 61: 'r', 3: 2, 7: 2, 13: 2, 15: 1, 17: 2, 19: 0, 25: 2, 27: 2, 29: 6, 37: 6, 39: 6, 49: 2}

```
