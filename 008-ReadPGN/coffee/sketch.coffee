import { Chess } from 'https://cdn.jsdelivr.net/npm/chess.js@0.13.4/+esm'

chess = new Chess()
	
chess.load_pgn("1. e4 e5")
moves = chess.history()
document.getElementById('output').textContent = """
	Läst PGN framgångsrikt!
	Antal drag: #{moves.length}
	Drag: #{moves.join(', ')}
"""
console.log "Schackhistorik:", moves
console.log "Slutposition (FEN):", chess.fen()

