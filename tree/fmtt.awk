BEGIN {FS=","; p = 0}
{	
	level[p] = $1
	treecnt[$1]++
	stack[p++] = $0
}

$1 == 0	{
#	print "debug: noels " p
	for (i = p - 1; i >= 0; i--) {
		pline(level[i])
		print stack[i]
#		print "debug: " i, level[i], treecnt[level[i]]
		treecnt[level[i]]--
	}
	for (i in level)
		treecnt[level[i]] = 0
	p = 0
}

function pline(m) {
	line = ""
#	print "debug pline: " m
	for (l = 1; l <= m; l++) {
#		print "debug pline l: " l
		if (l == m)
			line = line "   |__"
		else if (treecnt[l] > 0 && l != m)
			line = line "   |"
		else 
			line = line "    "
	}
	printf("%s", line)
}
