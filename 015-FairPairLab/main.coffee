import { FairPair } from './fairpair.js' 
import { Player } from './player.js' 
	
range = _.range
echo = console.log

elos = [1698,1558,1549,1679,1653,1673, 1699,1560,1552,1683,1658,1679,1511,1714,1588,1410].sort().reverse()
players = (new Player i,elos[i] for i in range elos.length)

fairpair = new FairPair players,6

for p in fairpair.players
	echo p.opp,p.col,p.balans()

echo "" 

for i in range players.length
	line = fairpair.matrix[i]
	echo i%10 + '   ' + line.join('   ') + '  ' + players[i].elo

echo 'summa', fairpair.summa
echo 'rounds',fairpair.rounds