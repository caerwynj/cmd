BEGIN {
	lastmnth = 7
	lastday = 19
	lastpos = ((lastmnth - 1) * 16) + int(lastday/2) + 1
	dist = 0.4
}

{
	p = $1
	est = $5
	act = $6
	own=$2
	
	if (lastp[own] == 0) {
		lastp[own] = lastpos
		lastm[own] = lastmnth
		lastd[own] = lastday
	}
	nest = int(((est) / 10) / dist)
	nact = int(((act) / 10) / dist)
	print $1, lastm[own], lastd[own], int((nest *10)/8), int((nact*10)/8)
	lastp[own] += nest
	lastp[own] %= 192
	lastm[own] = int((lastp[own] / 16)) + 1
	lastd[own] = int((lastp[own] % 16)) * 2 + 1
}

