# Matchning av SSFID mot lämpliga bilder

Idag kan man visa en person, i member.schack.se, i olika kontexter.  
member.schack.se har en funktion, getPlayerPhoto(SSFID) som returnerar ett PhotoID.  
Denna funktion behöver bytas ut pga byte från BB1 till BB2.  
Istället för att skärmskrapa BB1/BB2 använder man en tabell, SSFID_Photo.json  

Information som kan skärmskrapas från https://member.schack.se/ShowTournamentServlet?id=16916:  

```
postshowindtournamentresultform('16916','546353') Lo Ljungros
postshowindtournamentresultform('16916','516448') Victor Lilliehöök
```

(Denna fil borde kunna tillhandahållas av Peter Halvarsson)  
16916.txt
```
546353 Lo Ljungros
516448 Victor Lilliehöök
```

När man klickar på en person, visas bl a en bild på honom. Denna bild hämtas mha getPlayerPhoto.  

## IN: bilder.json (från turnering 16916)

* "2025-10-18 Trojanska Hästen JGP II  Täby Stockholm_**T16916**_I10753":  
* * "Pristagare Klass **A**":  
* * * "Vy-Trojh_JGP_03.**Lo_Ljungros**_Klass_A_2025-10-18.jpg":[475,537,3047147,1813,2048,"**B9HGb42E_6**"]  

## IN: deltagarlista (för turnering 16916)

Varje turnering har en egen deltagarlista.  
Bör kunna hämtas med t ex https://member.schack.se/ShowTournamentServlet?id=16916&typ=deltagarlista  
Om inte detta går, måste man skärmskrapa fram denna information.  

```
516448 Victor Lilliehöök
546353 Lo Ljungros
```

## UT: SSFID_Photo.txt

Varje turnering har en egen sådan fil.
```
546353 B9HGb42E_6
```

## Tillvägagångssätt

* loopa genom deltagarlistan
* * loopa genom bilderna
* * * Om deltagarnamnet finns med i bildnamnet skrivs SSFID och bildens ID ut i SSFID_Photo.

Alla turneringsfiler sammanställs till en enda json-fil.  
För varje SSFID väljs största (senaste) PhotoID.  
Alternativt kan slumpning ske, t ex bland de tre senaste.  
Bedömd storlek: 10.000 * 20 = 200.000 tecken  

## Eventuellt hinder

bilder.json anger bara ID för den första turneringen. Delturneringarna benämns A-F, men man vet bara ID för A.  
Bör funderas igenom. Kanske så här:  
Pristagare Klass B => Pristagare Klass 16917 B  

Alternativ I: 
```
Matchningen sker mellan alla deltagare i A, B, C, D, E och F.  
Vilket tar längre tid och kan leda till missmatcher.  
Dock måste man fortfarande veta ID för turneringarna.  
```

Alternativ II:
```
"2025-10-18 Trojanska Hästen JGP II Klass A Täby Stockholm_T16916_I10753":
	{"Vy-Trojh_JGP_01.Pratyush_Tripathi_Klass_A_2025-10-18.jpg":[475,534,3270855,1821,2048,"B9HGcFP0XC"],
	"Vy-Trojh_JGP_02.CM_Melvin_Ral_Lustig_Klass_A_2025-10-18.jpg":[475,585,2380261,1663,2048,"B9HGba4Wxl"],
	"Vy-Trojh_JGP_03.Lo_Ljungros_Klass_A_2025-10-18.jpg":[475,537,3047147,1813,2048,"B9HGb42E_6"],
	"Vy-Trojh_JGP_11.Nathalie_Biström_bästa_tjej_Klass_A_2025-10-18.jpg":[475,458,3005188,2048,1976,"B9HGackIWl"]},
"2025-10-18 Trojanska Hästen JGP II Klass B Täby Stockholm_T16917_I10753":
	"Vy-Trojh_JGP_01.Pratyush_Tripathi_Klass_B_2025-10-18.jpg":[475,534,3270855,1821,2048,"B9HGcFP0XC"],
	"Vy-Trojh_JGP_02.CM_Melvin_Ral_Lustig_Klass_B_2025-10-18.jpg":[475,585,2380261,1663,2048,"B9HGba4Wxl"],
```