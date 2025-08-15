import re
import time
from pathlib import Path

MOMS_KONTO = 2640
UNDRE_KONTO = 2000
ÖVRE_KONTO = 3000
UNDRE_MOMS_ANDEL = 13
ÖVRE_MOMS_ANDEL = 16
SIE_FIL = "2206.sie4"

VER_RE = re.compile(r'#VER\s+"(?P<serie>\d+)"\s+"(?P<id>\d+)"\s+(?P<datum>\d{8})\s+"(?P<text>[^"]*)"')
TRANS_RE = re.compile(r'#TRANS\s+(?P<konto>\d+)\s+{}\s+(?P<belopp>[-+]?\d+(?:[.,]\d+)?)')

def read_sie(infile):
	path = Path(infile)
	text = path.read_text(encoding="cp437")

	lines = iter(text.splitlines())
	konton = {}
	verifikationer = []

	for line in lines:
		line = line.strip()
		if line.startswith("#KONTO"):
			konto = int(line[7:11])
			namn = line[13:-1]
			konton[konto] = namn

		if line.startswith("#VER"):
			m = VER_RE.match(line)
			if not m: raise ValueError(f"Kunde inte tolka VER-raden: {line}")

			serie = int(m.group("serie"))
			vid = int(m.group("id"))
			datum = int(m.group("datum"))
			vtext = m.group("text")

			for brace_line in lines:
				brace_line = brace_line.strip()
				if brace_line == "{": break
				if brace_line: raise ValueError(f"Förväntade '{{' efter VER, fick: {brace_line}")
			else: raise ValueError("Fil slut innan transaktionsblock började.")

			transaktioner = []
			for tline in lines:
				tline = tline.strip()
				if tline == "}": break
				if not tline: continue
				tm = TRANS_RE.match(tline)
				if not tm: raise ValueError(f"Kunde inte tolka TRANS-rad: {tline}")
				konto = int(tm.group("konto"))
				belopp = float(tm.group("belopp"))
				transaktioner.append({"konto": konto, "belopp": belopp})
			else:
				raise ValueError("Fil slut innan '}' för transaktionsblock hittades.")

			verifikationer.append({"serie": serie,"id": vid,"datum": datum,"text": vtext,"transaktioner": transaktioner})

	return konton,verifikationer

start = time.time()

konton,verifikationer = read_sie(SIE_FIL)

filtrerade = []
for verifikat in verifikationer:
	for transaktion in verifikat["transaktioner"]:
		konto = transaktion["konto"]
		belopp = transaktion["belopp"]
		if konto == MOMS_KONTO and belopp != 0: filtrerade.append(verifikat)

summaUtgiftSomBerörs = 0
for verifikat in filtrerade:
	ingåendeMoms = 0
	kontonPlus = 0
	print(verifikat["serie"], verifikat["id"], verifikat["datum"], verifikat["text"])
	for transaktion in verifikat["transaktioner"]:
		konto = transaktion["konto"]
		belopp = transaktion["belopp"]
		if konto == MOMS_KONTO: ingåendeMoms += belopp
		if konto >= ÖVRE_KONTO or konto < UNDRE_KONTO: kontonPlus += belopp
		if belopp != 0: print('  ',konto,f"{belopp:.2f}", konton[konto])

	summaUtgiftInklMoms = kontonPlus + ingåendeMoms
	momsAndel = ingåendeMoms / summaUtgiftInklMoms / 0.2 * 100
	verifikat["momsAndel"] = momsAndel
	if UNDRE_MOMS_ANDEL < momsAndel < ÖVRE_MOMS_ANDEL: summaUtgiftSomBerörs += summaUtgiftInklMoms
	print(f"   momsAndel: {momsAndel:.2f}%")
	print()

print('Antal verifikationer:', len(verifikationer))
print('Antal filtrerade verifikationer:', len(filtrerade))
print('summaUtgiftSomBerörs:',summaUtgiftSomBerörs)
print()
print(f'cpu: {time.time() - start:.6f}')
