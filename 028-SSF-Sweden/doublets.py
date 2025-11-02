import json

# curl -X 'GET' \
#   'https://member.schack.se/public/api/v1/ratinglist/federation/date/2025-10-01/ratingtype/1/category/0' \
#   -H 'accept: */*'

with open('sweden.json','r', encoding="utf-8") as f:
	members = json.load(f)

arr = [[member['firstName'], member['lastName'], member['birthdate'], member['id']] for member in members]
arr.sort()
hash = {}

dubletter = {}
for i in range(len(arr)):
	a = arr[i]
	key = a[0] + ' ' + a[1] # + ' ' + a[2]
	if not key in dubletter: dubletter[key] = 0
	dubletter[key] += 1

for key in dubletter:
	antal = dubletter[key]
	if antal > 1: print(key, antal)
