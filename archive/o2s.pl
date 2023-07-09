#!/usr/local/bin/perl
eval 'exec /usr/local/bin/perl -S $0 ${1+"$@"}'
    if $running_under_some_shell;
			# this emulates #! processing on NIH machines.
			# (remove #! line above if indigestible)

eval '$'.$1.'$2;' while $ARGV[0] =~ /^([A-Za-z_0-9]+=)(.*)/ && shift;
			# process any FOO=bar switches

# o2s.awk convert an oracle dumpschema file to sybase

$[ = 1;			# set array base to 1
$, = ' ';		# set output field separator
$\ = "\n";		# set output record separator

$FS = ',';

while (<>) {
    chop;	# strip record separator
    @Fld = split(/[,\n]/, $_, 9999);
    if (/2,typ/) {
	$typ = $Fld[3];
    }
    if (/2,len/) {
	$len = $Fld[3];
    }
    if (/2,prc/) {
	$prc = $Fld[3];
    }
    if (/2,(scl|def|nul|pos)/) {
	print $_;
    }
    if (/1,col/) {
	if ($typ eq 'CHAR') {
	    $typ = 'char';
	}
	elsif ($typ eq 'DATE') {
	    $typ = 'datetime';
	    $len = 8;
	}
	elsif ($typ eq 'LONG RAW') {
	    $typ = 'image';
	    $len = 16;
	}
	elsif ($typ eq 'VARCHAR2') {
	    $typ = 'varchar';
	}
	elsif ($typ eq 'RAW') {
	    $typ = $binary;
	}
	elsif ($typ eq 'NUMBER') {
	    if ($prc == 1) {
		$typ = 'bit';
		$len = 1;
		$prc = '';
	    }
	    elsif ($prc == 3) {
		$typ = 'tinyint';
		$len = 1;
	    }
	    elsif ($prc == 6) {
		$typ = 'smallint';
		$len = 2;
	    }
	    elsif ($prc == 10) {
		$typ = 'int';
		$len = 4;
	    }
	    elsif ($prc == 18) {
		$typ = 'numeric';
		$len = 9;
	    }
	    else {
		$typ = 'numeric';
	    }
	}
	else {
	   # print 'unkown type';
	}
	print '2,typ,' . $typ . ',0';
	print '2,len,' . $len . ',0';
	print '2,prc,' . $prc . ',0';
	print lc $_;
    }
    if (/^0/) {
	print $_;
    }
}
