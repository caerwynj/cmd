#!/usr/local/bin/perl
# Adds, drops, and appends columns in the specified file.

die "Usage: $0 <filename> <delim> <defaults> <trunc date fields> <drop fields> <append fields>\n"
  unless @ARGV == 6;

($filename, $del, $defaults, $date, $drop, $append) = @ARGV;
$tempfile = "$filename.$$";

%def_vals = $defaults ? (split /\t/, $defaults) : ();
@def_list = sort { $a <=> $b } keys %def_vals;
@date_vals = $date ? (split /\t/, $date) : ();
@drop_vals = $drop ? sort { $b <=> $a } (split /\t/, $drop) : ();
#@drop_vals = $drop ? sort { $a <=> $b } (split /\t/, $drop) : ();
@append_vals = $append ? (split /\t/, $append) : ();

open (DATAFILE, "<$filename") or die "read: $!";
open (OUTFILE, ">$tempfile") or die "write: $!";

if (@drop_vals || @date_vals || @def_list) {
#    %dropped_field = ();
#    foreach $i (@drop_vals) {
#	$dropped_field{$i} = 1;
#    }
    while (<DATAFILE>) {
	chomp;
	@fields = split /[$del]/o, $_, -1;
#	foreach $f (@fields) {print $f, "|";} print "\n";
	
	foreach $i (@def_list) {
	    $fields[$i-1] = $def_vals{$i} if $fields[$i-1] eq "";
	}
	
	foreach $i (@date_vals) {
	    $fields[$i-1] =~ s/:\d\d\d//i;
	}
	
	foreach $i (@drop_vals) {
#	    print "$i\n";
	    if ($i == 1) {
		shift @fields;
	    } elsif ($i == $#fields + 1) {
		pop @fields;
	    } else {
		splice (@fields, $i-1, 1);
#	    @fields = (@fields[0 .. $i - 2], @fields[$i .. $#fields]);
	    }
	}

	print OUTFILE join("$del", @fields);
#, @append_vals)), "\n";

#	for($i=0; $i <= $#fields; $i++){
#	    next if (exists $dropped_field{$i+1});
#	    print OUTFILE $fields[$i];
#	    print OUTFILE "$del" unless ($i == $#fields);
#	}
	print OUTFILE "$append\n";
    }
}
else {
    while(<DATAFILE>) {
	chomp;
	print OUTFILE "$_$append\n";
    }
}    
close DATAFILE or die "close: $!";
close OUTFILE or die "close: $!";
rename $tempfile, $filename or die "mv: $!";
