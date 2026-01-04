# FairPair

## Make TRF file

[Try it!](https://christernilsson.github.io/2025/035-FairPair/)

Add the players elo ratings and names 

```
TITLE = Summer tournament RIO 2025
GAMES = 1
ROUNDS = 4

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

```

If you are playing double rounds, set GAMES = 2

Enter the result for **white** in the Table list order  

Explanation
```
r1 = round 1

0 = white loss
1 = draw
2 = white win
x = game not played yet
```

# Usage

* Click on other columns, sorts the players

# Differences against other pairing systems

* The elo rating decides. The differences are minimized
* Tie breaks are seldom needed
* All rounds are paired initially
* You mey play the games in any order
* No need to divide the tournament in separate Berger groups
* All players know when they will meet whom. Like Berger
* Simple handling of the pairing process
* All information is stored in the url, ready to be published

# Mind this

* After starting the tournament, you are only allowed to edit the results
* Changing elos, SORT, ROUNDS, BALANCE or GAMES is not allowed
* Always print the Table lists. These are your backups

# BALANCE

* BALANCE == 0. Mainly double round
* BALANCE == 1. Mainly single round

# Standings

* n = Number of real games played. No byes or walkovers.  
* P = Real game points.  
* score = P / n.  
* avg = Average elo met.  
* PR = Performance Rating (iterative)  

# Fairness

Normally the PR order matches the score order.  
(If the score is the same, avg is used).  
Using the avg is an approximation used by FIDE.  

Consider winning 50% against  
* A: 1400, 1400 and 3200 => PR = 1591
* B: 1400, 2300 and 2300 => PR = 2116

The average is 2000 for both player A and B.  
But, as PR indicates, winning against 2300 is much harder than winning against 1400  

As elo variation using FairPair is tight, this should not be a problem.  

# Development

ONE is used to show zero or one based indexes


