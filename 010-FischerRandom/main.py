# Q: Kan man uppnå alla 960 positioner genom att byta två pjäser flera gånger.
# A: Ja, det krävs sex byten

a = ["RNBQKBNR"]
hash = {}

def bishops(pos):
	s = []
	for k in range(8):
		if pos[k] == 'B': s.append(k)
	return s[0] % 2 != s[1] % 2

def rooks(pos):
	s = ""
	for ch in pos:
		if ch == 'K' or ch == 'R': s += ch
	return s == 'RKR'

def ok(pos,i,j): return i != j and pos[i] != pos[j] and bishops(pos) and rooks(pos)

def process(a):
	b = []
	for q in a:
		pos = list(q)
		for i in range(8):
			for j in range(i+1,8):
				pos[i], pos[j] = pos[j], pos[i]
				key = ''.join(pos)
				if ok(pos,i,j) and key not in hash:
					b.append(key)
					hash[key] = q
				pos[i], pos[j] = pos[j], pos[i]
	return b

b = process(a)
c = process(b)
d = process(c)
e = process(d)
f = process(e)
g = process(f)

keys = list(hash.keys())
keys.sort()
for key in keys:
	print(key,hash[key])

print(len(hash))