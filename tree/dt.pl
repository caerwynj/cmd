#!/usr/local/bin/perl
eval 'exec /usr/local/bin/perl -S $0 ${1+"$@"}'
    if $running_under_some_shell;
			# this emulates #! processing on NIH machines.
			# (remove #! line above if indigestible)

eval '$'.$1.'$2;' while $ARGV[0] =~ /^([A-Za-z_0-9]+=)(.*)/ && shift;
			# process any FOO=bar switches

$, = ' ';		# set output field separator
$\ = "\n";		# set output record separator

while (<>) {
    ($Fld1,$Fld2) = split(' ', $_, 9999);

    $par{$Fld1}++;
    $ischd{$Fld2} = 1;
    $child{$Fld1, $par{$Fld1}} = $Fld2;
}

foreach $q (sort keys %par) {
    $level = 0;
    if ($ischd{$q} != 1) {
	&pt($q);
    }
}

sub pt {
    local($p, $i) = @_;
    $level++;
    &pspace($level);
    print $p;
    if (defined $par{$p}) {
	for ($i = 1; $i <= $par{$p}; $i++) {
	    &pt($child{$p, $i});
	}
    }
    $level--;
}

sub pspace {
    local($n, $j) = @_;
    $sp = $n * 8;
    for ($j = 0; $j < $sp; $j++) {
	printf ((' '));
    }
}
