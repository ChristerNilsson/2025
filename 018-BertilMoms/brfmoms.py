import re
import time
from pathlib import Path

#SIE_FIL = "202206.sie4"
#SIE_FIL = "2022.sie4"
SIE_FIL = "2023.sie4"

UNDRE_MOMS_ANDEL = 13 # %
ÖVRE_MOMS_ANDEL = 16 # %

TILLGÅNGAR = '1'
EGET_KAPITAL_OCH_SKULDER = '2'
MOMS_KONTO = '2640'
INTÄKTER = '3'
INKöP_AV_VAROR_OCH_MATERIAL = '30'
VARUKOSTNADER = '4'
PERSONALKOSTNADER = '7'
FINANSIELLA_OCH_ÖVRIGA_INTÄKTER_O_KOSTNADER = '8'

VER_RE = re.compile(r'#VER\s+"(?P<serie>\d+)"\s+"(?P<id>\d+)"\s+(?P<datum>\d{8})\s+"(?P<text>[^"]*)"')
TRANS_RE = re.compile(r'#TRANS\s+(?P<konto>\d+)\s+{}\s+(?P<belopp>[-+]?\d+(?:[.,]\d+)?)')

ignorerade = []

def read_sie(infile):
	path = Path(infile)
	text = path.read_text(encoding="cp437")

	verifikat = None
	in_block = False
	konton = {}
	verifikationer = []

	for raw_line in text.splitlines():
		line = raw_line.strip()
		if not line: continue

		if line.startswith("#KONTO"):
			konto = line[7:11]
			namn = line[13:-1]
			konton[konto] = namn

		if line.startswith("#VER"):
			m = VER_RE.match(line)
			if not m: raise ValueError(f"Kunde inte tolka VER-raden: {line}")
			verifikat = {"serie": m.group("serie"),"id": m.group("id"),"datum": m.group("datum"),"text": m.group("text"),"transaktioner": []}
			continue

		if line == "{":
			if verifikat is None: raise ValueError("Hittade '{' utan föregående VER")
			in_block = True
			continue

		if line == "}":
			if not in_block: raise ValueError("Hittade '}' utan ett pågående block")
			verifikationer.append(verifikat)
			verifikat = None
			in_block = False
			continue

		if in_block:
			tm = TRANS_RE.match(line)
			if not tm: raise ValueError(f"Kunde inte tolka TRANS-rad: {line}")
			konto = tm.group("konto")
			belopp = float(tm.group("belopp").replace(",", "."))
			verifikat["transaktioner"].append({"konto": konto, "belopp": belopp})

	return konton,verifikationer

start = time.time()
konton,verifikationer = read_sie(SIE_FIL)
filtrerade = []

for verifikat in verifikationer:
	for transaktion in verifikat["transaktioner"]:
		konto = transaktion["konto"]
		belopp = transaktion["belopp"]
		if konto == MOMS_KONTO and belopp != 0: filtrerade.append(verifikat)

summaUtgiftSomBerörs = 0 # ören
for verifikat in filtrerade:
	ingåendeMoms = 0 # ören
	kontonPlus = 0 # ören
	print(verifikat["serie"], verifikat["id"], verifikat["datum"], verifikat["text"])
	for transaktion in verifikat["transaktioner"]:
		konto = transaktion["konto"]
		belopp = 100 * transaktion["belopp"] # pga avrundningsfel i python räknas i ören
		if konto == MOMS_KONTO: ingåendeMoms += belopp
		if konto[0] != EGET_KAPITAL_OCH_SKULDER: kontonPlus += belopp
		if belopp != 0: print('  ',konto,f"{belopp/100:.2f}", konton[konto])

	summaUtgiftInklMoms = kontonPlus + ingåendeMoms # ören
	if summaUtgiftInklMoms == 0:
		ignorerade.append(verifikat["id"])
		print("   *** DIV MED NOLL",summaUtgiftInklMoms)
	else:
		momsAndel = ingåendeMoms / summaUtgiftInklMoms / 0.2 * 100
		if UNDRE_MOMS_ANDEL < momsAndel < ÖVRE_MOMS_ANDEL:
			summaUtgiftSomBerörs += summaUtgiftInklMoms
			print(f"   momsAndel: {momsAndel:.2f}%")
		else:
			print(f"   momsAndel: {momsAndel:.2f}% summaUtgiftInklMoms: {summaUtgiftInklMoms/100:.2f}", kontonPlus/100, ingåendeMoms/100)
	print()

print("IGNORERADE VERIFIKAT:", len(ignorerade), '(', ' '.join(ignorerade), ')')
print('Antal verifikat:', len(verifikationer))
print('Antal filtrerade verifikat:', len(filtrerade))
print('summaUtgiftSomBerörs:',summaUtgiftSomBerörs/100)
print()

print(f'cpu: {time.time() - start:.6f}')
