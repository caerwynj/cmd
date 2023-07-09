BEGIN {FS=","}
/obj/ {print "drop default " $3 "\n/"}
