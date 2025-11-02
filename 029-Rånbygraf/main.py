import urllib.request
import json

def fetchCountry(month):
	url = f"https://member.schack.se/public/api/v1/ratinglist/federation/date/{month}-01/ratingtype/1/category/0"
	with urllib.request.urlopen(url) as response: return json.loads(response.read().decode('utf-8'))

def fetchTournament(id):
	url = f"https://member.schack.se/public/api/v1/tournamentresults/team/roundresults/id/{id}"
	with urllib.request.urlopen(url) as response: return json.loads(response.read().decode('utf-8'))

def showPlayer(id):
	s = members[id][0]
	for game in games:
		p1 = str(game[1])
		p2 = str(game[2])
		if id==p1 or id==p2:
			print(p1,p2)
			elo1 = members[p1][1]
			elo2 = members[p2][1]
			s += str(elo1 - elo2)
	print(s)

patches = {
	'612036': 1803, # Hamina
	'646346': 2246, # Pedersen
	'693181': 2076, # Duke
	'725343': 1721, # Kaunonen
	'667116': 0,    # Nolla
	'691642': 0,
	'713415': 0,
	'-100': 0,
}


members = {}

for m in fetchCountry('2024-05'):
	members[str(m['id'])] = [m['firstName'] + ' ' + m['lastName'],m['elo']['rating'] ]

games = {}
for t in fetchTournament(13664):
	homeId = str(t['homeId'])
	awayId = str(t['awayId'])

	homeName = members[homeId][0] if homeId in members else 'Unknown'
	awayName = members[awayId][0] if awayId in members else 'Unknown'

	if homeId not in games: games[homeId] = [homeName]
	if awayId not in games: games[awayId] = [awayName]
#
# 	print()
# 	# print(awayId)
# 	if awayId not in members: print(awayId, members[homeId])
# 	if homeId not in members: print(homeId, members[awayId])
# 	# print(homeId)
# 	# print(members[homeId])
# #	print(members[awayId])
	homeElo = patches[homeId] if homeId not in members else members[homeId][1]
	awayElo = patches[awayId] if awayId not in members else members[awayId][1]

	if awayElo==0:
		games[homeId].append('x')
	else:
		games[homeId].append(homeElo - awayElo)

	if homeElo==0:
		games[awayId].append('x')
	else:
		games[awayId].append(homeElo - homeElo)


	# games[homeId].append([awayId, homeElo - awayElo])
	# games[awayId].append([awayId, homeElo - awayElo])

# = [[t['roundNr'], t['homeId'], t['awayId'], t['homeResult'], t['awayResult'], t['date']] ]

# showPlayer('376158')


z = 99
