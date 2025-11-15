#!/usr/bin/env python3
"""
Mini TRF16/Tornelo-style validator.

Antaganden:

- Vertikalt rondformat:
	001 <id> <namn ...> <FED> <FIDE-ID> [rating]
		<rond> <motst> <färg> <resultat>
		<rond> <motst> <färg> <resultat>
  dvs rondraderna är indenterade och börjar INTE med 001.

- Vi försöker inte tolka Swiss-Managers horisontella "1111 1 1  2222 2 2 ..." layout.
"""

import sys
from collections import defaultdict, namedtuple

GameEntry = namedtuple("GameEntry", "player opp round color result_token lineno raw")

VALID_RESULTS = {"1", "0", "½", "0.5", "0,5", "-", "+", "=", "1/2"}

def invert_result_token(token: str) -> str:
	"""
	Spegla resultatkod:
	1 <-> 0, + -> 0, remi-varianter speglas till sig själva, '-' lämnas.
	"""
	t = token.strip()
	if t in {"1", "+"}:
		return "0"
	if t == "0":
		return "1"
	if t in {"½", "0.5", "0,5", "=", "1/2"}:
		return t
	if t == "-":
		return "-"
	# okänd kod – spegla inte, men låt validatorn klaga separat
	return t

def parse_trf(path: str):
	players = {}   # id -> {name, fed, fide_id, lineno}
	games = []     # list[GameEntry]
	errors = []
	warnings = []

	current_player = None

	with open(path, encoding="utf-8") as f:
		for lineno, line in enumerate(f, start=1):
			raw = line.rstrip("\n")
			stripped = raw.strip()

			if len(raw) >= 3 and raw[:3] in '012 022 032 042 052 062 121':
				print(raw)
				continue

			if not stripped:
				continue

			# Spelarrad
			if stripped.startswith("001"):
				tokens = stripped.split()
				if len(tokens) < 3:
					errors.append(f"L{lineno}: 001-rad med för få fält: {raw}")
					current_player = None
					continue
				# spelarnummer
				try:
					pid = int(tokens[1])
				except ValueError:
					errors.append(
						f"L{lineno}: Ogiltigt spelarnummer '{tokens[1]}' i 001-rad: {raw}"
					)
					current_player = None
					continue
				if pid in players:
					warnings.append(
						f"L{lineno}: Dubblett av spelare {pid} (tidigare definierad)."
					)

				# heuristik: FED = första token med exakt 3 versaler
				fed = None
				fide_id = None
				for i, tok in enumerate(tokens[2:], start=2):
					if len(tok) == 3 and tok.isalpha() and tok.isupper():
						fed = tok
						if i + 1 < len(tokens) and tokens[i + 1].isdigit():
							fide_id = tokens[i + 1]
						break

				if fed is not None:
					name_tokens = tokens[2:tokens.index(fed)]
				else:
					name_tokens = tokens[2:]
				name = " ".join(name_tokens) if name_tokens else f"Player_{pid}"

				players[pid] = {
					"name": name,
					"fed": fed,
					"fide_id": fide_id,
					"lineno": lineno,
				}
				current_player = pid
				continue

			# Resultatrad – måste ligga efter en 001-rad
			if current_player is None:
				warnings.append(
					f"L{lineno}: Rad med resultat utan föregående 001-spelare: {raw}"
				)
				continue

			tokens = stripped.split()
			if len(tokens) < 4:
				warnings.append(
					f"L{lineno}: Resultatrad med för få fält (förväntar 'rond motst färg resultat'): {raw}"
				)
				continue

			# rond
			try:
				rnd = int(tokens[0])
			except ValueError:
				warnings.append(
					f"L{lineno}: Ogiltigt rondnummer '{tokens[0]}': {raw}"
				)
				continue

			# motståndare
			try:
				opp = int(tokens[1])
			except ValueError:
				warnings.append(
					f"L{lineno}: Ogiltigt motståndar-id '{tokens[1]}': {raw}"
				)
				continue

			color = tokens[2].lower()
			res = tokens[3]

			if color not in {"w", "b"}:
				warnings.append(
					f"L{lineno}: Okänd färgkod '{color}' (förväntar 'w' eller 'b'): {raw}"
				)
			if res not in VALID_RESULTS:
				warnings.append(
					f"L{lineno}: Okänd resultatkod '{res}': {raw}"
				)

			games.append(
				GameEntry(current_player, opp, rnd, color, res, lineno, raw)
			)

	# --- Strukturkontroller ---

	# 1. Motståndare måste finnas (utom 0000 = bye) och inte vara spelaren själv.
	for g in games:
		if g.opp == 0:   # 0000-bye (om du använder det)
			continue
		if g.opp not in players:
			errors.append(
				f"L{g.lineno}: Motståndare {g.opp} finns inte som 001-spelare "
				f"(rad: {g.raw})"
			)
		if g.opp == g.player:
			errors.append(
				f"L{g.lineno}: Spelare {g.player} spelar mot sig själv (rad: {g.raw})"
			)

	# 2. Gruppér partierna per (rond, min(a,b), max(a,b)) för speglingskontroll
	from collections import defaultdict
	buckets = defaultdict(list)
	for g in games:
		if g.opp == 0:
			continue  # bye
		a, b = sorted((g.player, g.opp))
		key = (g.round, a, b)
		buckets[key].append(g)

	for key, entries in buckets.items():
		rnd, a, b = key
		if len(entries) == 1:
			g = entries[0]
			warnings.append(
				f"L{g.lineno}: Parti rond {rnd} mellan {a} och {b} "
				f"har bara rapporterats från en sida."
			)
		elif len(entries) == 2:
			g1, g2 = entries
			if g1.player == g2.player:
				errors.append(
					f"L{g1.lineno}/{g2.lineno}: Dubbla partiposter för samma spelare "
					f"i rond {rnd} mot {g1.opp}."
				)
				continue
			# färgkontroll
			if g1.color == g2.color:
				warnings.append(
					f"L{g1.lineno}/{g2.lineno}: Båda sidor anger samma färg "
					f"i parti rond {rnd} mellan {a} och {b}."
				)
			# resultatkontroll (speglade resultat)
			inv1 = invert_result_token(g1.result_token)
			inv2 = invert_result_token(g2.result_token)
			if inv1 != g2.result_token or inv2 != g1.result_token:
				warnings.append(
					f"L{g1.lineno}/{g2.lineno}: Inkonsekvent resultat i parti rond {rnd} "
					f"mellan {a} och {b}: '{g1.result_token}' vs '{g2.result_token}'."
				)
		else:
			lines = ", ".join(str(g.lineno) for g in entries)
			errors.append(
				f"Rond {rnd} mellan {a} och {b} rapporterad {len(entries)} gånger "
				f"(rader: {lines})."
			)

	return players, games, errors, warnings

def main(argv=None):
	if argv is None:
		argv = sys.argv[1:]
	if not argv:
		print("Användning: trf_validate.py <fil.trf>")
		return 1

	path = argv[0]
	players, games, errors, warnings = parse_trf(path)

	print()
	print(f"Antal spelare: {len(players)}")
	print(f"Antal resultatposter (radrader): {len(games)}")
	print()

	if errors:
		print("FEL:")
		for e in errors:
			print("  -", e)
	else:
		print("Inga kritiska fel hittades.")

	if warnings:
		print("\nVARNINGAR:")
		for w in warnings:
			print("  -", w)
	else:
		print("\nInga varningar.")

	# return 0 även vid varningar; 1 vid fel
	return 1 if errors else 0

if __name__ == "__main__":
	raise SystemExit(main())
