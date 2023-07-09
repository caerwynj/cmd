BEGIN {FS=","}
/^0,tbl/ {print $3}
