# dt.awk -- reads two column input where first column is parent second
# column is child; it then prints out a dependency tree 
BEGIN {OFS=","}
/=/ { equiv[$3] = $1 }
!/=/{ 
	prnt = $1
	chld = $2
	for (e in equiv) {
		if (e == prnt)
			prnt = equiv[e]
		else if (e == chld)
			chld = equiv[e]
	}
	par[prnt]++
	ischd[chld] = 1
	child[prnt,par[prnt]] = chld 
}
END {
	for (q in par) {
		level = 0
		if (ischd[q] != 1) 
			pt(q)
	}
}

function pt (p,    i) {
	level++
	print level - 1, "", p
	if (p in par) 
		for (i = 1; i <= par[p]; i++)
			pt(child[p,i])
	level--
}	
