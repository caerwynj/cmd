BEGIN {FS=","}
/tbl/ {print "drop table " $3"\n/"}
