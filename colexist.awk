BEGIN {FS=","; OFS=","
  ok=0
  cnt=1
}
/^0,tbl,.*,2$/ {tbl=$3; ok=1}
/^1,col,.*,2$/ && (ok == 1) {print "," cnt++, tbl, $3}
/^0,tbl,.*,(1|0|3)$/ {ok=0}
