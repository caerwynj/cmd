#!/usr/bin/perl -w

use strict;

use lib ("$ENV{HOME}/pm");

my $isSybase = 1;
my $type = "t";

while ($_ = $ARGV[0], /^-/) {
    shift;
    last if /^--$/;
    if (/^-s/)  {$isSybase = 1}
    if (/^-o/)  {$isSybase = 0}
    if (/^-t/)  {$type = "t"}
    if (/^-c/)  {$type = "c"}
    if (/^-d/)  {$type = "d"}
    if (/^-r/)  {$type = "r"}
    if (/^-k/)  {$type = "k"}
    if (/^-h/)  {
	print "Usage: dumpschema.pl [-o|-s] [-t|-d|-c|-r|-k] files ...\n";
	print "  -o oracle; -s sybase\n";
	print "  -t table; -d default; -c constraint; -r rule; -k key\n";
	print "  -s and -t are the defaults if no flags given\n";
	exit;
    }
}

if    ($type eq "t") {dumptbl(@ARGV);}
elsif ($type eq "c") {dumpconstraint(@ARGV);}
elsif ($type eq "d") {dumpdefault(@ARGV);}
elsif ($type eq "k") {dumpkeys(@ARGV);}
elsif ($type eq "r") {dumprules(@ARGV); }
exit;    


sub dumprules {
    if ($isSybase) {
	require ReadSybRule;
	import ReadSybRule;
    } else {
	require ReadOraRule;
	import ReadOraRule;
    }

    my $rule;
    while ($rule = shift) {
	my $rules = read_rules($rule);
	
	foreach my $name (sort keys %$rules) {
	    my ($value, $table_rows) = @{$rules->{$name}};
	    $value =~ s/\"/\"\"/gm;
	    $value =~ s/\n/\f/gm;
	    foreach my $trow (@$table_rows) {
		my ($table, $row) = split(/\./, $trow);
        	print "0,tbl,", $table, ",0\n";
        	print "1,rul,", $name, ",0\n";
        	print "2,val,\"", $value, "\",0\n";
        	print "2,col,", $row, ",0\n";
	    }
	}
    }
}

sub dumpkeys {
    if ($isSybase) {
	require ReadSybKey;
	import ReadSybKey;
    } else {
	require ReadOraKey;
	import ReadOraKey;
    }


    my $key;
    while ($key = shift) {
	my $keys = read_keys($key);
	
	my ($table, $name, $cols, $unique, $clustered, $with);
	foreach $table (keys %$keys) {
	    print "0,tbl,", $table, ",0\n";
	    my $index;
	    foreach $index (@{ $keys->{$table} }) {
        	($name, $cols, $unique, $clustered, $with) = @$index;
        	print "1,key,", $name, ",0\n";
        	print "2,unq,", $unique, ",0\n";
        	print "2,clu,", $clustered, ",0\n";
		
        	foreach my $c (@$cols) {
        	    $c =~ s/[ \n\t]//gm;
        	    print "2,col,", $c, ",0\n";
        	}
	    }
	}
    }
}

sub dumpdefault {
    if ($isSybase) {
	require ReadSybDefault;
	import ReadSybDefault;
    } else {
	require ReadOraDefault;
	import ReadOraDefault;
    }


    my $default;
    while ($default = shift) {
	my $defaults = read_defaults($default);
	
	foreach my $name (sort keys %$defaults) {
	    my ($value, $table_rows) = @{$defaults->{$name}};
	    foreach my $trow (@$table_rows) {
		my ($table, $row) = split(/\./, $trow);
		print "0,tbl,", $table, ",0\n";
		print "1,col,", $row, ",0\n";
		print "2,defn,", $name, ",0\n";
		print "2,def,", $value, ",0\n";
	    }
	}
    }
}

sub dumpconstraint {

    if ($isSybase) {
	require ReadSybConst;
	import ReadSybConst;
    } else {
	require ReadOraConst;
	import ReadOraConst;
    }

    my $file;
    while ($file = shift) {
	my $const_def = read_consts($file);
	
	my ($table1);
	foreach $table1 (keys %$const_def) {
	    my $const;
	    print "0,tbl,", $table1, ",0\n";
	    foreach $const (@{ $const_def->{$table1}{'FK'} }) {
		my ($name, $cols1, $table2, $cols2) = @$const;
		print "1,cns,", $name, ",0\n";
		foreach my $c (@$cols1) {
		    print "2,col,", $c, ",0\n";
		}
		print "2,dtbl,", $table2, ",0\n";
		foreach my $c (@$cols2) {
		    print "2,dcol,", $c, ",0\n";
		}
		
	    }
	    
	    foreach $const (@{ $const_def->{$table1}{'CHECK'} }) {
		my ($name, $check) = @$const;
		print "1,6,", $name, ",0\n";
		$check =~ s/\n/\f/gm;
		print "2,7,\"", $check, "\",0\n";
	    }
	}
    }
}

sub dumptbl {
    my %sizes = ();

    if ($isSybase) {
	require ReadSybTable;
	import ReadSybTable;
	require ReadSybDefault;
	import ReadSybDefault;
	%sizes = ("int"       => 4,
		  "tinyint"   => 1,
		  "smallint"  => 2, 
		  "datetime"  => 8,
		  "bit"       => 1,
		  "smalldatetime" => 4,
		  );

    } else {
	require ReadOraTable;
	import ReadOraTable;
	require ReadOraDefault;
	import ReadOraDefault;
	%sizes = ("DATE" => 7,
		  "FLOAT" => 0);
    }

    my %numeric_size = ("1" => "2",
			"2" => "2",
			"3" => "3",
			"4" => "3",
			"5" => "4",
			"6" => "4",
			"7" => "4",
			"8" => "5",
			"9" => "5",
			"10" => "6",
			"11" => "6",
			"12" => "6",
			"13" => "7",
			"14" => "7",
			"15" => "8",
			"16" => "8",
			"17" => "9",
			"18" => "9");

    while (my $table = shift) {
	my $dir = `dirname $table`;
	chomp $dir;
	my $tbl = `basename $table`;
	my $prec;
	$tbl =~ s/\.table//;
	my $result = read_tables($table);
	foreach my $table_name (keys %$result) {
	    print "0,tbl,$table_name,0\n";
	    foreach my $line (@{ $result->{$table_name}{"columns"} }) {
		my ($col_name, $data_type, $data_size, $data_scale, $null, $pos) = 
		    @$line;

		#my $default = get_default($dir, $table_name, $col_name);

		if ($null eq "NOT NULL") {
		    $null = "N";
		} else {
		    $null = "Y";
		}
		$data_size = $sizes{$data_type} if 
		    exists $sizes{$data_type};

		# only the numeric type has scale and precision 
		if ($data_type eq "numeric" || $data_type eq "NUMBER") {
		    $prec = $data_size;
		    if ($isSybase) {
			$data_size = $numeric_size{$prec} if
			    exists $numeric_size{$prec};
		    } else {
			$data_size = 22;
		    }
		} else {
		    $data_scale = "";
		    $prec = "";
		}
		print "1,col,$col_name,0\n";
		print "2,nul,$null,0\n";
		#print "2,def,$default,0\n";
		print "2,typ,$data_type,0\n";
		print "2,len,$data_size,0\n";
		print "2,prc,$prec,0\n";
		print "2,scl,$data_scale,0\n";
		print "2,pos,$pos,0\n";
	    }
	}
    } 
}


# Return for table.column as a string or '' if there is none
# In: dir      - the table direcrory
#     table    - the table name
#     column   - the column name
# Out: default - the default on table.column as a string or '' if no default
sub get_default {
    my ($dir, $table, $column) = @_;
    my $default = '';

    my $file = "$dir/../defaults/$column".'.default';
    return $default unless -f $file;

    my $defaults = read_defaults($file);

    foreach my $name (sort keys %$defaults) {
	my ($value, $table_rows) = @{$defaults->{$name}};
	foreach my $trow (@$table_rows) {
	    my ($t, $c) = split(/\./, $trow);
	    if ($table eq $t and $column eq $c) {
		$default = $value;
	    }
	}
    }
    
    return $default;
}
