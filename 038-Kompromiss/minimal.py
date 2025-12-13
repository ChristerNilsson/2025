from mwmatching import maxWeightMatching
import math

rond = 0
#elos = [1825,1697,1684,1681,1644,1600,1598,1583,1561,1559,1539,1535,1532,1400]

elos = [1688,
	1827,
	1748,
	1641,
	2001,
	1800,
	1944,
	1907,
	1579,
	1828,
	1575,
	2213,
	1417,
	1709,
	1977,
	2093,
	2113,
	1848,
	2416,
	1622,
	1893,
	1923,
	1733,
	1728,
	1624,
	1878,
	1763,
	1886,
	2366,
	2335,
	1897,
	1794,
	1721,
	2022,
	1871,
	1833,
	1480,
	1846,
	1787,
	1400,
	1733,
	1761,
	2039,
	2031,
	2235,
	1936,
	2046,
	1400,
	1803,
	2065,
	2076,
	2048,
	2413,
	1889,
	1885,
	1818,
	1778,
	1524,
	1796,
	1768,
	2035,
	1880,
	1650,
	1835,
	1954,
	2108,
	1783,
	1793,
	1852,
	1671,
	1680,
	1695,
	1726,
	1896,
	1691,
	1985,
	2141,
	1406,
	2272,
	2109
]

elos.sort()
elos.reverse()

players = None

def f(diff): return 1 / (1 + 10 ** (diff / 400))

def half(x):
	return round(2*x)/2

def expected_score(ratings, own_rating):
	return sum([ f(rating - own_rating) for rating in ratings])

def performance_rating (pp, ratings):
	lo = 0
	hi = 4000
	while abs(hi - lo) > 0.001:
		rating = (lo + hi) / 2
		if pp > expected_score(ratings, rating):
			lo = rating
		else:
			hi = rating
	return rating

class Player:
	def __init__(self,id,elo):
		self.id = id
		self.elo = elo
		self.opp = []
		self.res = []
		self.score = 0.0

	def __str__(self):
		return f"{self.id:2} {self.elo:.1f} {self.opp} {''.join(self.col)} {self.res}"

def ok(pa,pb): return not pa.id in pb.opp

def	unscramble (solution): # [5,3,4,1,2,0] => [[0,5],[1,3],[2,4]]
	result = []
	for i in range(len(solution)):
		if solution[i] != -1:
			j = solution[i]
			result.append([i,j]) #[@players[i].id,@players[j].id]
			solution[j] = -1
			solution[i] = -1
	return result

def exec():

	global rond,players

	n = len(elos)

	def solutionCost(pair):
		[a, b] = pair
		pa = players[a]
		pb = players[b]
		# r = rond
		da = pa.elo  # (r)
		db = pb.elo  # (r)
		diff = abs(da - db)
		return diff ** 1.01 # g.EXPONENT

	def solutionCosts(pairs):
		return sum(solutionCost(pair) for pair in pairs)

	edges = []
	for a in range(n):
		scorediff = 5
		elodiff = 1000
		pa = players[a]
		for b in range(a+1,n):
			pb = players[b]
			if ok(pa,pb):
				cost = 1 * abs(pa.score - pb.score)/scorediff + 10 * abs(pa.elo - pb.elo) / elodiff
				# print(abs(pa.score - pb.score), abs(pa.elo - pb.elo) / elodiff)
				cost = cost ** 1.01
				edges.append([a,b,9999-cost])
			else:
				z=99

	solution = maxWeightMatching(edges, maxcardinality=False)
	print()
	print('solution',solution)
	pairs = unscramble(solution)
	# print('solutionCosts',solutionCosts(pairs))

	for pair in pairs:
		a,b = pair
		pa = players[a]
		pb = players[b]
		pa.opp.append(b)
		pb.opp.append(a)
		diff = pb.elo - pa.elo
		pa.res.append((f(diff)))
		pb.res.append((f(-diff)))
		print(abs(pa.score - pb.score), pa.id,pb.id)
		pa.score += (f(diff))
		pb.score += (f(-diff))
	z=99

def matrix(n):
	print()
	s=""
	for i in range(n):
		s += f"{(i+1)%10:2}"
	print(s)
	for i in range(n):
		p = players[i]
		s = ''
		for j in range(n):
			if j in p.opp:
				s += ' ' + str(1+p.opp.index(j))
			else:
				s += '  '

		elos = []
		for opp in p.opp:
			elos.append(players[opp].elo)

		pr = round(performance_rating((p.score),elos))
		avg = sum([players[id].elo for id in p.opp])/len(p.opp)
		print(s, round(p.score,3), p.elo, pr, p.elo - pr, round(avg), [round(r,2) for r in p.res])

players = []
for i in range(len(elos)):
	players.append(Player(i, elos[i]))

for i in range(8):
	exec()

matrix(len(elos))

z=99

