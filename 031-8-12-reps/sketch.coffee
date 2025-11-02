echo = console.log 

W = 20
INCW = 2

R = 8
MINR = 8
MAXR = 12

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

show = (w,r) ->
	if w >= 0 then W = w
	R = r
	div.innerHTML = "#{W} kg <br> #{R} reps"

app = document.getElementById "app"
div = koppla "div", app
show W,R

ok  = koppla 'button', app, {'html':'Ok'}
nix = koppla 'button', app, {'html':'Nix'}

nix.addEventListener "click", -> if R == MINR then show W-INCW,R    else show W,R-1
ok.addEventListener  "click", -> if R == MAXR then show W+INCW,MINR else show W,R+1
