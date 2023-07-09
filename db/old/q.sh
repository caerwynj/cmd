#!/bin/sh

case $# in
1) q=$1; shift;; 
*) echo "usage ..."; exit 1 ;;
esac

ln=`line`
echo "$ln"
qawk=`echo "$ln" | awk -f q.awk query="$q" `
awk "$qawk" $*
