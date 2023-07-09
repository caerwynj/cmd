BEGIN {FS=","}
/^0/ { tbl=$2 "," $3}
/^1/ {
	col = $2 "," $3
	print tbl, col
}
/^2/ {print col, $2 "," $3}
