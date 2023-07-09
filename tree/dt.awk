# dt.awk -- reads two column input where first column is parent second
# column is child; it then prints out a dependency tree 
BEGIN {OFS=","}
{ 
	par[$1]++
	ischd[$2] = 1
	child[$1,par[$1]] = $2
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
#	pspace(level)
	print level - 1, "", p
	if (p in par) 
		for (i = 1; i <= par[p]; i++)
			pt(child[p,i])
	level--
}	

function pspace (n,   j) {
	sp = n * 8
	for (j = 0; j < sp; j++)
		printf(" ")
}
