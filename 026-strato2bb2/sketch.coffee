echo = console.log 

koppla = (typ, parent, attrs = {}) ->
	elem = document.createElement typ

	if 'text' of attrs
		elem.textContent = attrs.text
		delete attrs.text

	if 'html' of attrs
		elem.innerHTML = attrs.html
		delete attrs.html

	for own key of attrs
		elem.setAttribute key, attrs[key]

	parent.appendChild elem
	elem

iframe = koppla "iframe", document.getElementById "app"

# console.log 'path',window.location.path
# console.log 'search',window.location.search

path = window.location.path
if path == undefined then path = "/index.html"
console.log 'path', path

s = "https://storage.googleapis.com/bildbank2" + path + window.location.search

alert s

iframe.src = s


# export default 
# 	async fetch request
# 		url = new URL request.url
# 		# Skapa motsvarande URL på Google Storage
# 		target = "https://storage.googleapis.com/bildbank2" + 
# 			(url.pathname == "/" ? "/index.html" : url.pathname)

# 		response = await fetch target
# 		return new Response response.body, response


