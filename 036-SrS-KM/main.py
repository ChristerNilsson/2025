from rating import performance
rounds = 8

class Player:
	def __init__(self, id, name, elo, score, ids):
		self.id = id
		self.name = name
		self.elo = elo
		self.score = score
		self.ids = ids
		self.elos = []
		self.pr = 0

def average(arr):
	return sum(arr) / len(arr)

def read_players():

	with open("km.txt", "r", encoding="utf-8") as f:
		lines = f.readlines()

	players = []

	for line in lines:
		line = line.strip()
		line = line.replace('\t',' ')
		for i in range(3):
			line = line.replace("  "," ")
		arr = line.split(' ')

		id = int(arr[0])
		name = arr[1] + ' ' + arr[2]
		elo = int(arr[3])
		ids = []
		score = 0

		for r in arr[5:]:
			r = r.replace('w','b')
			if 'b' in r:
				pair = r.split('b')
				if pair[1] in '0½1':
					ids.append(int(pair[0]))
					if pair[1] == '1': score += 1.0
					if pair[1] == '½': score += 0.5
					if pair[1] == '0': score += 0.0
		players.append(Player(id, name, elo, score, ids))

	# byt ut id mot elo
	for player in players:
		if player.elo == 0: player.elo = 1400
		player.elos = []
		for id in player.ids:
			if id not in ['-½','0','-1']:
				elo = players[id-1].elo
				if elo == 0: elo = player.elo # 1400
				player.elos.append(elo)
		player.pr = round(performance(player.score,player.elos),3)

	players.sort(key=lambda player: -player.pr)
	return players

def f():
	xmax = 0
	for p in players:
		if len(p.elos) < rounds / 2: continue
		if xmax == 0:
			xmax = p.pr
			ymax = p.score
		xmin = p.pr
		ymin = p.score

	dy = ymax - ymin
	for player in players:
		x = player.pr
		player.q = ymin + dy * (x - xmin)/(xmax-xmin)

players = read_players()
f()
i = 0
for p in players:
	if len(p.elos) < rounds / 2: continue
	i += 1
	print(f"{i:2} {p.id:2d} {len(p.elos)} {p.elo:4} {p.pr:.3f} {p.score} {p.q:.3f} {(p.score-p.q):6.3f} {p.name:17} {average(p.elos):.2f} {' '.join([str(r) for r in p.elos])}")

# https://s1.chess-results.com/tnr1247798.aspx?lan=6&art=4&fed=SWE&turdet=YES&SNode=S0
# Kolumner:

# placering baserad på PR eller Q
# placering baserad på P + fiktiva motståndare
# antal verkliga motståndare
# elo
# PR
# P
# Q
# P-Q
# namn
# medelvärde av motståndarnas elo
# motståndarnas elo
