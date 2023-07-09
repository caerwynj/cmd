/new_abp_/ {
  sub(/EXPORT /, "") 
  sub(/;$/, "")
  sub(/\(.*\)/, "")
  match($0, /[a-zA-Z0-9_]+ *$/)
  funcname = substr($0, RSTART, RLENGTH)
  sub(/new_abp_/, "", funcname)
  print "0,api," funcname
}
! /^$/ { 
  orig = $0
  sub(/EXPORT /, "") 
  sub(/;[ 	]*$/, "")
  match($0, /\(.*\)/)
  args = substr($0, RSTART + 1, RLENGTH - 2)
  sub(/\(.*\)/, "")

  match($0, /[a-zA-Z0-9_]+ *$/)
  funcname = substr($0, RSTART, RLENGTH)
  sub(/[a-zA-Z0-9_]+ *$/, "")
  rettype = $0
  print "1,fnc," funcname
  print "2,ret," rettype

  if (args !~ /^ *void *$/) {
    split(args, ary, ",");
    j=1
    for (i in ary) {
      match(ary[i], /[a-zA-Z0-9_]+ *$/)
      argname = substr(ary[i], RSTART, RLENGTH)
      sub(/[a-zA-Z0-9_]+ *$/, "", ary[i])
      sub(/^ */, "", ary[i])
      argtype = ary[i]
      print "2,arg," argname
      print "3,pos," i
      print "3,typ," argtype
      j++
    }
  }
#  print "orig: " orig
}
