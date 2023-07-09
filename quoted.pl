#!/usr/local/bin/perl
eval 'exec /usr/local/bin/perl -S $0 ${1+"$@"}'
    if $running_under_some_shell;
			# this emulates #! processing on NIH machines.
			# (remove #! line above if indigestible)

eval '$'.$1.'$2;' while $ARGV[0] =~ /^([A-Za-z_0-9]+=)(.*)/ && shift;
			# process any FOO=bar switches

# quoted.awk read a schema file and extract the quoted field
# A quoted field is enclosed in double-quote chars "..."
# A quted field may conatin commas but not newlines
# A quoted field may contain double-quote characters", represented by "".
# A quoted field may be empty
$[ = 1;			# set array base to 1

$FS = ',';

while (<>) {
    chop;	# strip record separator
    @Fld = split(/[,\n]/, $_, 9999);
    if ($Fld[1] == 0) {
	delete $opened{$file} && close($file);
	$file = $Fld[3];
    }
    if ($Fld[1] == 1) {
	# this line contains a quoted field
	$line = $_;
	if ($line =~ /".*"/ &&

	  ($RLENGTH = length($&), $RSTART = length($`)+1)) {
	    $line = substr($line, $RSTART + 1, $RLENGTH - 2);# removed quotes
	    $line =~ s/""/\"/g;
	    $s = "\\f", $line =~ s/$s/\n/g;
	    &Pick('>', $file) &&
		(printf $fh '%s', $line);
	}
    }
}

sub Pick {
    local($mode,$name,$pipe) = @_;
    $fh = $name;
    open($name,$mode.$name.$pipe) unless $opened{$name}++;
}
