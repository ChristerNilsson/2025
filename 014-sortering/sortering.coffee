sorteringsOrdning = []	# Spara per kolumn
echo = console.log
document.addEventListener 'DOMContentLoaded', ->

	ths = document.querySelectorAll '#minTabell th'
	for th in ths
		do (th) ->
			th.addEventListener 'click', (event) ->
				kolumnIndex = parseInt(th.dataset.kolumn)
				tbody = document.querySelector '#minTabell tbody'
				rader = Array.from tbody.querySelectorAll 'tr'

				stigande = !sorteringsOrdning[kolumnIndex]
				sorteringsOrdning[kolumnIndex] = stigande
				echo kolumnIndex
				echo sorteringsOrdning

				rader.sort (a, b) ->
					cellA = a.children[kolumnIndex].textContent.trim()
					cellB = b.children[kolumnIndex].textContent.trim()

					# Försök jämföra som tal, annars som text
					numA = parseFloat cellA
					numB = parseFloat cellB
					if !isNaN(numA) and !isNaN(numB)
						return if stigande then numA - numB else numB - numA
					else
						return if stigande then cellA.localeCompare cellB else cellB.localeCompare cellA

				# Lägg tillbaka raderna i sorterad ordning
				for rad in rader
					tbody.appendChild rad
