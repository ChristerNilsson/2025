# from PyPDF2 import PdfReader
# import json
#
# data = []
# path ="tfs_1991_01.pdf"
# reader = PdfReader(path)
# for page in reader.pages:
# 	t = page.extract_text()
# 	print(t)
	# z=99
	# data.append(page.extract_text())
# data.append({"file": path, "text": text})

# with open("pdf_index.json", "w", encoding="utf8") as f:
# 	json.dump(data, f)




import fitz
doc = fitz.open("tfs_1991_01.pdf")
print(doc[0].get_text().strip()[:200])
