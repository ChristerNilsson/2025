
def elo_formula(gap): return 1 / (1 + 10 ** (gap / 400))

def expected_score(ratings, own_rating):
	return summa([1 / (1 + 10**((rating - own_rating) / 400)) for rating in ratings])

# Use two extreme values when calculating 0% or 100%
def extrapolate(a0, b0, elos):
	a = performance_rating(a0,elos)
	b = performance_rating(b0,elos)
	return b + b - a

def performance(pp,elos):
	n = len(elos)
	if pp == 0 : return extrapolate(   0.5,  0.25,elos)
	if pp == n : return extrapolate( n-0.5,n-0.25,elos)
	return performance_rating(pp,elos)

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

def summa (arr):
	res = 0
	for item in arr:
		res += item
	return res

def inv(score):
	lo = -1000
	hi = 1000
	while abs(hi - lo) > 0.001:
		gap = (lo + hi) / 2
		if score > elo_formula(gap):
			lo = gap
		else:
			hi = gap
	return gap

# print(summa([2,3]))
# print(elo_formula(-100))
# print(elo_formula(100))
# print(expected_score([1700],1600))
# print(expected_score([1700],1800))
# print(performance(1,[1600,1700]))
# print(performance(1,[1600]))
