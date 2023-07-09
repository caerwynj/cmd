BEGIN {FS=","
  ncols = 0}
/1,col,.*,2$/ {
  col[ncols++] = $3
}
/^0,tbl,.*,2$/ && (ncols > 0) {
  print "select '" $3 "', "
  for (i = 0; i < ncols; i++) {
    printf("%s%s",  col[i], (i == (ncols - 1) ? "\n" : ","))
  }
  print "from " $3 "\n/\n"
  ncols = 0
}
/^0,tbl,.*,(1|3|0)$/ {
  ncols = 0
}

