# Filtrera ut verifikationser som refererar till konto  2640 (ingående moms)
# från SIE-fil konverterad till UTF-8

# Exempel:
# python filter.py "2022-01-01_2022-12-31.txt" "2022-01-01_2022-12-31-filtrerad.txt"

# Exempel verifikation efter filtrering och tillägg av kontonamn:
# In:
# #VER "49" "220492" 20220404 "Stockholm Exergi (SIE)"
# {
# #TRANS 2440 {} -194116 20220404
# #TRANS 2640 {} 0 20220404
# #TRANS 2640 {} 8741.95 20220404
# #TRANS 4620 {} 194116 20220404
# #TRANS 4620 {} -8741.95 20220404
# }
# 
# Ut:
# #VER "49" "220492" 20220404 "Stockholm Exergi (SIE)"
# {
# #TRANS 2440 {} -194116 20220404 "Leverantörsskulder"
# #TRANS 2640 {} 8741.95 20220404 "Ingående moms"
# #TRANS 4620 {} 194116 20220404 "Uppvärmning"
# #TRANS 4620 {} -8741.95 20220404 "Uppvärmning"
# }



import sys
import os
import ctypes
import re

def filtrera(inFil: object, utFil: object) -> None:
   # Filtrera SIE-fil (konverterad til UTF-8)
   # Läs verifikationer och skriv de som refererar till 
   # Ingående moms (2640).
   # Undantag: Om verifikationen bara har referens till 2640 belopp 0
   #    så tas den inte heller med.

   # Lägg till (frivillig) transtext = "Kontonamn", t ex "Ingående moms"

   # Exempel input:
   # #VER "49" "220492" 20220404 "Stockholm Exergi (SIE)"
   # {
   # #TRANS 2440 {} -194116 20220404
   # #TRANS 2640 {} 0 20220404
   # #TRANS 2640 {} 8741.95 20220404
   # #TRANS 4620 {} 194116 20220404
   # #TRANS 4620 {} -8741.95 20220404
   # }
   # 
   # Ut:
   # #VER "49" "220492" 20220404 "Stockholm Exergi (SIE)"
   # {
   # #TRANS 2440 {} -194116 20220404 "Leverantörsskulder"
   # #TRANS 2640 {} 8741.95 20220404 "Ingående moms"
   # #TRANS 4620 {} 194116 20220404 "Uppvärmning"
   # #TRANS 4620 {} -8741.95 20220404 "Uppvärmning"
   # }


   print("Filtrerar en text-fil konverterad från SIE4 ")
   print('Läser från "' + inFil + '".')

   # Öppna infil och spara i lista
   with open(inFil, 'r') as f:
      inRadTab = f.read().splitlines()

   utRader = ''
   antalVerifikationer = 0
   level = 1
   nr= 1
   kontoNamnTab = {}

   for radNr in range(len(inRadTab)):

      inRad = inRadTab[radNr]

      # Exempel: #VER "49" "220046" 20220101 "Storholmen Förvaltning AB (SIE)"

      if level == 1:
         # Startnivå: Letar efter kontouppgifter och verifikationer.

         # Kontouppgifter. Exempel: "#KONTO 4620 "Uppvärmning""
         match = re.search(r'^#KONTO (\d\d\d\d) "([^\"]*)".*$', inRad)

         if match:
            # Spara kontonamn i kontoNamnTab
            kontoNr = int(match.group(1))
            kontoNamnTab[kontoNr] = match.group(2)

         # Verifikationer. Exempel:  = '#VER "49" "220046" 20220101'
         match = re.search("^#VER .*$", inRad)

         if match:
            level = 2
            verifTitel = inRad # (För felmeddelanden)
            verif = inRad + '\n' # Lägg till första raden i en verifikation
            sparaVerif = False # Var pessimistisk tills konto 2640 hittats

      elif level == 2:
         # Verifikationsnivå: Har läst titelrad till verifikation och inledande krullparentes
         # Exempel: {
         match = re.search("^{$", inRad)
         if match:
            level = 3
            verif = verif + '{' + '\n' # Lägg till {-parentes
         else:
            print('*** Filter(rad ' + int(radNr) + '): Förväntade "{" efter verifikationstitel "' + 
               verifTitel + '" men fann istället "' + inRad + '".')
            level = 10
      
      elif level == 3:
         # Verifikationsnivå: Har läst titelrad till verifikation och inledande krullparentes {
         # Förväntar transaktioner.
         # Exempel: #TRANS 2440 {} -34823 20220101
         #          #TRANS 2640 {} 0 20220101
         #          ...
         match = re.search(r"^#TRANS (\d\d\d\d) (\{[^\}]*\}) (-?\d+).*$",inRad)
         if match:
            # Ta med verifikationer som har kontering till ingående moms >0
            # Filtrera bort rader med kontering till moms = 0
            kontoNr = int(match.group(1))
            laggTillRad = True
            if kontoNr == 2640:
               belopp = int(match.group(3))
               if belopp != 0:
                  sparaVerif = True
               if belopp == 0:
                  laggTillRad = False

            # Skriv verifikation exklusive transdata men med tillagd transtext = "kontonamn"
            # Undantag: Utelämna momsrader med belopp 0
            if laggTillRad:
               verif = verif + \
                  '#TRANS ' + \
                  match.group(1) + \
                  ' ' + match.group(2) + \
                  ' ' + match.group(3) + \
                  ' ' + '"' + kontoNamnTab[kontoNr] + '"' + '\n'

            if kontoNr == 2640:
               belopp = int(match.group(3))
               if belopp != 0:
                  sparaVerif = True

         else:
            # Troligen slut på verifikation
            match = re.search("^}$", inRad)
            if match:
               verif = verif + '}' + '\n'  # Lägg till }-parentes
               if sparaVerif:
                  # Addera verifikationen till utRader
                  utRader += verif
                  antalVerifikationer +=1
               # Gå tillbaka till nivå 1.
               level = 1
            else:
               print('*** Filter(rad ' + int(radNr) + '): Förväntade "{" efter verifikationstitel "' +
                  verifTitel + '" men fann istället "' + inRad+ '".')
               level = 10
      elif level == 10:
         # Stanna här tills filen är slut
         None
    
   if level == 1:

      # Kopiera utRader till utfil och spara utfil.
      print('Antal utvalda verifikationer = '+str(antalVerifikationer) + '.')
      print('Skriver till "' + utFil + '".')
      sie_fil_reducerad = open(utFil, "w")
      sie_fil_reducerad.write(utRader)
   else:
      print('*** filtrera: Förväntade att level skulle vara 1 (normalt slut) men den var ' + str(level) + '.');


def test():

   numOfArguments = len(sys.argv)-1

   if numOfArguments==2:
      # Check that input file exists first
      if os.path.exists(sys.argv[1]):
         print('File ' + sys.argv[1] + ' exists.')
         ctypes.windll.user32.MessageBoxW(0, 'File ' + sys.argv[1] + ' exists.', 'xxx', 1)
         filtrera(sys.argv[1], sys.argv[2])
      else:
         print('*** ConvFromCP437: Expected name of existing file in command arg 1 but found "' + sys.argv[1] + '".')
         ctypes.windll.user32.MessageBoxW(0,
            '*** Filtrera: Expected name of existing file in command arg 1 but found "' + sys.argv[1] + '".',
            'xxx', 1)
   else: print('2 arguments were expected but '+str(numOfArguments)+ ' were found.')

# See PyCharm help at https://www.jetbrains.com/help/pycharm/

test()

# filtrera('2022-01-01_2022-12-31.txt','2022-01-01_2022-12-31-filtrerad.txt')
