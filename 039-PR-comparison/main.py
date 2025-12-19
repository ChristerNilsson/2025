from scipy.stats import norm
import math

# notera att expected_exact är ca 200 ggr långsammare än expected_horner

FACTOR = 200 * 1.4142135623730951
D = 0.1 # används vid beräkning av 0% och 100%.

def ass(a,b):
	if a!=b: print(a,b)

def f(elo_diff): return norm.cdf(elo_diff / FACTOR)
ass(f(0),0.5)
ass(f(100), 0.6381631950841185)
ass(f(-100), 0.36183680491588155)

def erf(x) : # Horner's method, ger 5-6 korrekta decimaler
	a = 1.0 / (1.0 + 0.5 * abs(x))
	b = 1.00002368+a*(0.37409196+a*(0.09678418+a*(-0.18628806+a*(0.27886807+a*(-1.13520398+a*(1.48851587+a*(-0.82215223+a*0.17087277)))))))
	res = 1 - a * math.exp( -x*x - 1.26551223 + a * b)
	return res if x >= 0 else -res
ass(0.5 * (1+erf( 100/400)), 0.6381631932475625)
ass(0.5 * (1+erf(-100/400)), 0.36183680675243746)

#def expected_score1(ratings, rating): return sum([1 / (1 + 10 ** ((r - rating) / 400)) for r in ratings])
def expected_exact(ratings, rating): return sum([f(rating - r) for r in ratings])
def expected_horner(ratings, rating): return sum([0.5 * (1 + erf((rating - r) / 400.0)) for r in ratings])

def search(pp, ratings, func):
	[lo,hi] = [0,4000]
	while abs(hi - lo) > 0.00000001:
		guess = (lo + hi) / 2
		[lo,hi] = [guess,hi] if pp > func(ratings, guess) else [lo,guess]
	return guess

def performance (pp,elos,func):
	n = len(elos)
	if pp == 0: pp += D
	if pp == n: pp -= D
	return search(pp, elos, func)

lst = [2000] * 10
lst = [1686,1693]
n = len(lst)
for i in range(0,n * 2+1):
	y = performance(i/2, lst, expected_exact)
	z = performance(i/2, lst, expected_horner)
	print(i/2,round(y,0),round(z,0),round(y-z,6))
