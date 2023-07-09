BEGIN { FS="~"; OFS="~"}
NR==1 { gsub("~", ","); print}
NR == 2 {
	for (i=1; i<=NF; i++) {
#		printf("%s%s", $i, (i == NF) ? "\n" : ",")
		if ($i ~ /char|CHAR/)
			quote[i] = 1
		else if ($i ~ /date|DATE/)
			quote[i] = 2
		else
			quote[i] = 0
	}
}
NR >2 {
	for (i=1; i<=NF; i++) {
		if ($i == "")
			printf("NULL%s", (i == NF) ? "\n" : ",")
		else if (quote[i] == 1){
			gsub("'", "''", $i)
			printf("'%s'%s", $i, (i == NF) ? "\n" : ",")
		}else if (quote[i] == 2) {
#			gsub(/ ..:..[AP]M/, "", $i)
			printf("'%s'%s", $i, (i == NF) ? "\n" : ",")
		}
		else
			printf("%s%s", $i, (i == NF) ? "\n" : ",")
	}
}
