def calcDiff(p_eval, b_eval):

	if p_eval.startswith('#') and b_eval.startswith('#'):	# Båda matt
		pNum = int(p_eval.replace('#',''))
		bNum = int(b_eval.replace('#',''))
		diff = abs(pNum - bNum)
		if diff <= 1: return 0
		elif diff == 2: return 50
		else: return 100
	elif p_eval.startswith('#') or b_eval.startswith('#'): 	# Exakt en matt
		return 300
	else: # Ingen matt
		return abs(int(b_eval) - int(p_eval))

def ass(a,b,facit):
	diff = calcDiff(a,b)
	if diff !=  facit: print('failed',a,b,diff,facit)

ass('40', '30',10)
ass('30', '40',10)
ass('40','120', 80)
ass('#-2', '120', 300)
ass('120', '#-2', 300)
ass('#2', '#5', 100)
ass('#2', '#4', 50)
ass('#2', '#3', 0)
ass('#2', '#2', 0)
