import time

NIX = -1

RAMP_L = 0
RAMP_R = 1
BIT = 2
CROSS_OVER = 6

types = [0,1,2,6]

BLUE = 3
RED = 7

typ = {}
bits= [False] * 120
history = []

code = "C2C1CB0A0C0BA1A1C0A2AB1A1A0DC1A6ED0A1DC0C1CB0E1BA0G1A1I0K_II"
code = "C2C0CD1A0DE6EKKKKKKKK_II"

index = 0

def build(code):
	global index,typ,bits
	index = 0
	current = 'b'
	typ = [NIX] * 120
	bits = [False] * 120

	for ch in code:
		if   ch == '0': typ[index] = RAMP_L
		elif ch == '1': typ[index] = RAMP_R
		elif ch == '2':
			typ[index] = BIT
			bits[index] = False
		elif ch == '3':
			typ[index] = BIT
			bits[index] = True
		elif ch == '6': typ[index] = CROSS_OVER
		elif ch == "_":
			break
		else:
			index += "ABCDEFGHIJK".index(ch)
		index += 1

def push(ix):
	global index
	index = ix
	history.append(index)

def go(ix):
	global index
	global history
	index = ix
	current = 'b'

	result = ""
	push(index)
	blueballs = ['b'] * 40
	redballs =  ['r'] * 40
	blueballs.pop()
	history = [BLUE]
	while True:
		if typ[index] == RAMP_L: push(index + 10)
		elif typ[index] == RAMP_R: push(index + 12)
		elif typ[index] == CROSS_OVER: push(index + history[-1] - history[-2])
		elif typ[index] == BIT:
			if bits[index]: # RIGHT
				bits[index] = False
				push(index+12)
			else:
				bits[index] = True
				push(index+10)
		elif typ[index] == 'b':
			result = result + current
			current = 'b'
			push(BLUE)
			if len(blueballs) == 0: return result
			else: history = [BLUE]
			blueballs.pop()
		elif typ[index] == 'r':
			result = result + current
			current = 'r'
			push(RED)
			if len(redballs) == 0: return result
			else: history = [RED]
			redballs.pop()
		# elif typ[index] in 'br':
		# 	result += typ[index]
		# 	return result
		else:
			print('oops')
	return result

# start = time.time()
# for i in range(100000):
# 	build(code)
# 	print(go(BLUE))
# print(time.time() - start)
def antal(typ):
	res = 0
	for key in typ:
		if typ[key]==2: res+=1
	return res

def execute(typ):
	global bits
	bits = [False] * 120
	result = go(BLUE)
	if 'brrbbbrbbrrr' in result:
		print(antal(typ),result,typ)

indexes = [3,7, 13,15,17,19, 25,27,29, 37,39, 49]

typ[23] = 'b'
typ[35] = 'b'
typ[47] = 'b'
typ[59] = 'b'

typ[31] = 'r'
typ[41] = 'r'
typ[51] = 'r'
typ[61] = 'r'

start = time.time()
for a in [0,1,2]:
	typ[indexes[0]] = a
	for b in [0,1,2]:
		typ[indexes[1]] = b
		for c in [0,1,2]:
			typ[indexes[2]] = c
			for d in [0,1,2]:
				typ[indexes[3]] = d
				for e in [0,1,2]:
					typ[indexes[4]] = e
					for f in [0,1,2]:
						typ[indexes[5]] = f
						for g in types:
							typ[indexes[6]] = g
							for h in types:
								typ[indexes[7]] = h
								for i in types:
									typ[indexes[8]] = i
									for j in types:
										typ[indexes[9]] = j
										for k in types:
											typ[indexes[10]] = k
											for l in types:
												typ[indexes[11]] = l
												execute(typ)

print(time.time()-start)
