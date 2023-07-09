BEGIN {FS=","}
{print "select count(*) \""$1"\" from "$1";"}

