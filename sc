#!/home/xcs0998/bin/rc

PROJECTDIR=()
args = $*
* = `` (/) {echo -n `{/bin/pwd}}
shift $RSHIFT
for (i in (pw data devteam SrcCntrl $*)) {
	PROJECTDIR = $PROJECTDIR^'/'$i
}
switch ($args(1)) {
	case install
		* = $args
		shift
		for (i)
			/pw/data/devteam/devl2test $i
	case *
		sccs $args
}
