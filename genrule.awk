# genrule - read rule schema file and generate sql statement
# to check that no field in table violates the rule

BEGIN {FS=","}

/2,val/ {
  line = $0
  if (match(line, /".*"/)) {
    line = substr(line, RSTART + 1, RLENGTH - 2) # removed quotes
    gsub(/""/, "\"", line)
    gsub("\f", "\n", line)
    gsub(/@/, "", line)
    gsub(/create .* as /, "", line)
  }
}
/2,col/ {col = $3}
/0,tbl/ {
  print "select '" $3 " " col "', count(*) from " $3 " where not "
  print "( " line " )"
  print "/"
}
