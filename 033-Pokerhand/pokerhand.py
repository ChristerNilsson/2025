# Sortera fem heltal

def h2(a,b): return a if a>b else b
def h5(a,b,c,d,e): return h2(a,h2(b,h2(c,h2(d,e))))

assert h2(2,3) == 3
assert h2(3,2) == 3

assert h5(1,2,3,4,5) == 5
assert h5(2,5,3,4,1) == 5
assert h5(1,2,5,4,1) == 5
assert h5(1,2,3,5,1) == 5
assert h5(5,2,5,4,1) == 5

def sortera(a,b,c,d,e): return [a,b,c,d,e]


assert sortera(5,4,1,2,3) == [5,4,3,2,1]


