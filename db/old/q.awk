BEGIN {	FS="\t"
}
NR == 1 { 
#	print query
 	for (i=1; i<=NF; i++)  {
#		print $i, i
		attr[$i] = i
	}
	for (j in attr)
		gsub("\\$" j, "$" attr[j], query)
	print query 
}
