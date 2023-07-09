BEGIN {	
	print "		0123456789abcdef0123456789abcdef0123456789abcdef"
}
{
	mth = $2
	day = $3

#	pos = (int(day / 2) + 1) + (((mth - 1) % 3) * 16)
	pos = $6 % 48
	est = $4
	act = $5
	if ($6 < 48) 
		q = 1
	else if ($6 < 96)
		q = 2
	else if ($6 < 144)
		q = 3
	else if ($6 < 192)
		q = 4
	est = est - act
	while (est > 0) {
		proj = $1 "	q" q "	"
		for (i = 0; i < 48; i++) {
			if (i < pos) {
				proj = proj "."
			} else if (est-- > 0) {
				proj = proj "X"
			} else {
				proj = proj "."
			}
		}
		print proj
		q++
		if ( q == 5) {
			q = 1
		}
		pos = 0
	}
}
