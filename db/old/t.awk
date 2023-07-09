BEGIN { FS="\t"; OFS=","
	table = "XFER_STATUS" 
	while ("dbdef " table | getline)
		field[$1] = $2
}
NR == 1 {
	for (i=1; i<=NF; i++) {
		col[i] = $i
		if (field[$i] ~ /char/)
			quote[i] = 1
		else if (field[$i] ~ /date/)
			quote[i] = 2
		else
			quote[i] = 0
	}
}
NR != 1 {
	print "insert into " table 
	printf("(")
	for (i=1; i<=NF; i++)
		printf("%s%s", col[i], (i == NF) ? ")\n" : ",")
	printf("values\n(")
	for (i=1; i<=NF; i++) {
		if ($i == "NULL")
			printf("%s%s", $i, (i == NF) ? ")\n" : ",")
		else if (quote[i] == 1)
			printf("'%s'%s", $i, (i == NF) ? ")\n" : ",")
		else if (quote[i] == 2) {
#			gsub(/ ..:..[AP]M/, "", $i)
			printf("'%s'%s", $i, (i == NF) ? ")\n" : ",")
		}
		else
			printf("%s%s", $i, (i == NF) ? ")\n" : ",")
	}
	print "/"
}
