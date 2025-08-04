ROWS = 100
COLS = 8

matrix = []
for y in [0...ROWS]
	row = []
	for x in [0...COLS]
		row.push 0
	matrix.push row

activeRow = 0
activeCol = 0

render = ->
	container = document.getElementById 'matrix'
	container.innerHTML = ''
	table = document.createElement 'table'

	for y in [0...ROWS]
		tr = document.createElement 'tr'
		for x in [0...COLS]
			td = document.createElement 'td'
			td.textContent = matrix[y][x]
			td.dataset.row = y
			td.dataset.col = x
			if y is activeRow and x is activeCol
				td.classList.add 'active'
			td.addEventListener 'click', (event) ->
				activeRow = parseInt event.target.dataset.row
				activeCol = parseInt event.target.dataset.col
				render()
			tr.appendChild td
		table.appendChild tr

	container.appendChild table

	# Scrolla så att aktiv cell alltid syns
	activeCell = table.querySelector '.active'
	activeCell?.scrollIntoView
		behavior: 'smooth'
		block: 'nearest'
		inline: 'nearest'

move = (dy, dx) ->
	activeRow = Math.max 0, Math.min ROWS - 1, activeRow + dy
	activeCol = Math.max 0, Math.min COLS - 1, activeCol + dx
	render()

document.addEventListener 'keydown', (e) ->
	switch e.key
		when 'ArrowUp' then move -1, 0
		when 'ArrowDown' then move 1, 0
		when 'ArrowLeft' then move 0, -1
		when 'ArrowRight' then move 0, 1
		when '0', '1', '2', '3'
			matrix[activeRow][activeCol] = parseInt e.key
			activeRow = (activeRow + 1) % ROWS	# wrap neråt
			render()

render()
