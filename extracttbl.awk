BEGIN {dr=0; cr=0}
/drop table/ {
	dr=1
	table=$3 ".tbl"
	gsub(/\(/, "", table) 
}
/(CREATE|create) (TABLE|table)/{
	cr=1
	if (dr == 0) {
		table=$3 ".tbl"
		gsub(/\(/, "", table)
	}
}
dr == 1 || cr == 1 {print > table}
/^\// && cr == 1 {dr=0; cr=0; close(table)}
