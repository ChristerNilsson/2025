def expected_score(ratings, own_rating):
	return sum([1 / (1 + 10**((rating - own_rating) / 400)) for rating in ratings])

def performance_rating(pp, ratings):
	lo = 0
	hi = 4000
	while abs(hi - lo) > 0.001:
		rating = (lo + hi) / 2
		if pp > expected_score(ratings, rating):
			lo = rating
		else:
			hi = rating
	return rating

# Use two extreme values when calculating 0% or 100%
def extrapolate (a0, b0, elos) :
	a = performance_rating(a0,elos)
	b = performance_rating(b0,elos)
	return b + b - a

def performance (pp,elos):
	n = len(elos)
	if pp == 0: return extrapolate (0.5,  0.25,elos)
	if pp == n: return extrapolate (n-0.5,n-0.25,elos)
	return performance_rating(pp,elos)

def perf_fide (elos, score, average) :
	if score < 0 or len(elos) < score : return ""

	dp = [0, 7, 14, 21, 29, 36, 43, 50, 57, 65,
		72, 80, 87, 95, 102, 110, 117, 125, 133, 141,
		149, 158, 166, 175, 184, 193, 202, 211, 220, 230,
		240, 251, 262, 273, 284, 296, 309, 322, 336, 351,
		366, 383, 401, 422, 444, 470, 501, 538, 589, 677, 800]

	percentage = round(100 * score / len(elos))

	diff = dp[percentage - 50] if percentage >= 50  else -dp[50 - percentage]
	return average + diff

def calculate():
	data = "1400 1450 1500 1550 1600 1650 1700 1750 1800".split(' ')
	elos = [float(item) for item in data]
	average = sum(elos) / len(elos)
	for pp in range(0, 19):
		pp /= 2
		print(pp, round(performance(pp, elos),3), round(perf_fide(elos, pp, average)))

calculate()

