echo = console.log

# stats = (elos) ->
# 	summa = 0
# 	sumSq = 0
# 	for elo in elos
# 		summa += elo
# 		sumSQ += elo * elo

stddev = (arr) ->
  n = arr.length
  mean = arr.reduce(((a, b) -> a + b), 0) / n
  variance = arr.reduce(((a, b) -> a + Math.pow(b - mean, 2)), 0) / n
  [mean,Math.sqrt variance]

medeldiff = (elos) ->
  result = []
  for elo in elos
    summa = 0
    for item in elos
      summa += elo-item
    result.push Math.round summa / elos.length
  result

echo medeldiff [1812,1742,1732,1730,1722,1712,1705,1701,1700,1699,1681,1654] # Klass 1
echo medeldiff [1637,1636,1636,1621,1618,1617,1609,1592,1585,1585,1580,1600] # Klass 2
echo medeldiff [1873,1574,1574,1569,1569,1554,1551,1546,1544,1531,1527] # Klass 3


echo stddev [0.05,0.02,0.02,0.02,0.00,0.01,0.01,0.02] # fairpair p 1835
echo stddev [0.47,0.27,0.01,0.05,0.07,0.10,0.16,0.10] # swiss    p

echo stddev [0,0.07,0.11,0.2,0.24,0.26,0.33,0.35] # fairpair p 2416
echo stddev [0.07,0.24,0.26,0.35,0.4,0.42,0.47] # swiss    p

#echo stddev [1701,1742,1732,1730,1681,1705,1812,1722,1699,1712,1654,1700]