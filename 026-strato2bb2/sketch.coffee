koppla = (typ, parent, attrs = {}) ->
	elem = document.createElement typ

	# if 'text' of attrs
	# 	elem.textContent = attrs.text
	# 	delete attrs.text

	# if 'html' of attrs
	# 	elem.innerHTML = attrs.html
	# 	delete attrs.html

	# for own key of attrs
	# 	elem.setAttribute key, attrs[key]

	parent.appendChild elem
	elem

iframe = koppla "iframe", body
iframe.src = "https://storage.googleapis.com/bildbank2/index.html" + location.search 
