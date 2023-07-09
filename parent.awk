{ 
	par[$1]++
	ischd[$2] = 1
	child[$1,par[$1]] = $2
}
END {
	for (q in par) {
		level = 0
		if (ischd[q] != 1) 
			print q
	}
}
