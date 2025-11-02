import urllib.request
import json
import time
from datetime import date

DISTRICT       = 5821 # Stockholm
EXCEPTIONS     = "member_photos/exceptions.txt"
BILDER         = 'public/json/bilder.json'
MISSING_PEOPLE = "member_photos/missing_people.txt"
MEMBERS        = "public/json/members.json"

exceptions = {}
start = time.time()

def fetchDistrict(id,month):
	url = f"https://member.schack.se/public/api/v1/ratinglist/district/{id}/date/{month}-01/ratingtype/1/category/0"
	with urllib.request.urlopen(url) as response:
		return json.loads(response.read().decode('utf-8'))

with open(EXCEPTIONS, encoding = 'utf-8') as f	:
	lines = f.readlines()
	for line in lines:
		arr = line.strip().split(' ')
		exceptions[arr[0]] = arr[1]

def loadCache():
	with open(BILDER, 'r', encoding="utf8") as f:
		return json.loads(f.read())

def flatten(node, res={}, path=''):
	for key in node:
		path1 = path + "\\" + key
		if type(node[key]) is list:
			res[node[key][-1]] = path1
		else:
			flatten(node[key],res, path1)
	return res

try:
	current_month = date.today().strftime("%Y-%m")
	members = fetchDistrict(DISTRICT,current_month)
except:
	members = []

print()
print('month:', current_month)

if len(members) > 0:

	bilder = loadCache()

	photos = flatten(bilder)
	arr = []
	for key in photos:
		arr.append([key,photos[key]])
	arr.sort()
	arr.reverse() # börja med de nyaste bilderna
	photos = arr

	missing_people = [] # personer som inte finns på bild

	new_members = {}

	for member in members:
		ssfid = str(member['id'])
		name = member['firstName'] + ' ' + member['lastName']
		name = name.replace(' ','_')
		found = False
		if ssfid in exceptions:
			target = exceptions[ssfid]
			if target == 'nix': missing_people.append(name)
			new_members[member['id']] = target
			continue

		for photo in photos:
			target = photo[0]
			path = photo[1]
			if name in path:
				new_members[member['id']] = target
				found = True
				break

		if not found: missing_people.append(name)

	missing_people.sort()
	with open(MISSING_PEOPLE, 'w', encoding = 'utf-8') as g:
		for p in missing_people:
			g.write(p.replace('_',' ') + "\n")

	with open(MEMBERS, 'w', encoding = 'utf-8') as g:
		json.dump(new_members, g, ensure_ascii=False, indent = 2)

	print('members:', len(new_members))
	print('missing_people:',len(missing_people))
	print(round(time.time() - start,3),'seconds')

else:
	print('Month not available')
