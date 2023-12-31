#! /usr/bin/perl
$RCS_ID = '$Id: P,v 1.1.1.1 2000/09/08 15:52:42 caerwyn Exp $' ;
$0 =~ s-.*/-- ;
$HelpInfo = <<EOH ;

	    RDB operator: $0

Usage:  $0  [options]  list

Options:
    -edit    Edit option. Used by etbl.
    -help    Print this help info.
    -v	     Inverse option. Selects all columns except those named.

Selects columns by name (and order) and outputs an rdbtable with these columns.
Can effectively select, order, add, delete, or duplicate columns.

The value 'list' is normally a list of column names.  If 'list' contains a
triplicate of the form '-c NAME NEW' then column name 'NAME' will be changed
to 'NEW'.  If 'list' contains a triplicate of the form '-a  NAME  DEFN' then
a new (null) column is added, at that point in the list of column names,
with name 'NAME' and definition 'DEFN'.

The definition is described under the 'ptbl' operator.

This RDB operator reads an rdbtable from STDIN and writes an rdbtable to STDOUT.
Options may be abbreviated.

$RCS_ID
EOH
while ( ($_ = $ARGV[0]) =~ /^-/ ) {				# Get args
    if( /^-a.*/ || /^-c.*/ ){ last ; }
    if( /^-e.*/ ){ $EDT++ ; shift ; next ; }
    if( /^-h.*/ ){ print $HelpInfo ; exit 1 ; }
    if( /^-v.*/ ){ $INV++ ; shift ; next ; }
    if( /^-(\d.*)/ ){ $CBC = $1 ; shift ; next ; }
    die "\nBad arg: $_\n", "For help type \"$0 -help\".\n" ; 
}
while(<STDIN>){					# get header info, 1 lines
    if( /^\.\.>>>/ ){ print ; next ; }
    if( /^\s*#/ ){ print ; next ; }		# comment
    $lln++ ;
    chop ;
    if( $lln == 1 ){
	@H = split( /,/, $_ ) ; # column names
	$nrf = @H ; 
	last ; } }		 # nr of fields for data reads
if( $CBC ){					# columns by count option
    # chk @ARGV empty ... die error ...
    @cbc = split( /([a-z])/, $CBC ) ;
    unshift( @cbc, 'n' ) ;
    @tmp = @H ;
    while(@cbc){
	$opr = shift( @cbc ) ;
	$cnt = shift( @cbc ) ;
	while( @tmp && $cnt-- ){
	    if( $opr eq 'n' ){
		push( @ARGV, shift(@tmp) ) ; }
	    else{
		shift(@tmp) ; }
	}
    }
}
while( $arg = shift ){				# process column names
    if( $arg =~ /^-a/ ){	# add new column
	if( $INV ){
	    push( @add, shift ) ;
	    push( @add, shift ) ; }
	else{
	    push( @H, shift ) ;
	    push( @F, shift ) ;
	    push( @nh, $#H ) ;
	    push( @nd, '-' ) ; }
	next ; }
    if( $arg =~ /^-c/ ){	# change column name
	$arg = shift ;
	$new = shift ; }	# ( No 'next' here ... )
    for( $ok=$f=0 ; $f <= $#H ; $f++ ){
	if( $arg eq $H[$f] ){	# select existing column
	    $ok++ ;
	    if( ! $INV ){
		push( @nh, $f );
		push( @nd, $f );
		if( $new ){
		    splice( @H, $f, 1, $new ) ;
		    $new = "" ; } }
	    else{
		push( @xh, $f );
		push( @x, $f ); }
	    last ; }
    }
    die "$0: Bad column name: $arg\n" if ! $ok ;
}
if( $INV ){					# inverse option
    loop: for( $f=0 ; $f <= $#H ; $f++ ){
	for $i (@x){
	    if( $i eq $f ){ next loop ; } }
	push( @nh, $f );
	push( @nd, $f ); }
    while (@add){
	push( @H, shift(@add) ) ;
	push( @F, shift(@add) ) ;
	push( @nh, $#H ) ;
	push( @nd, '-' ) ; }
}
@n = @nh ;					# print the new header
@D = @H ; &printem ;
@n = @nd ;

while(<STDIN>){					# read the data 
    if( /^\.\.>>>/ ){ print ; next ; }
    chop ;
    @D = split( /,/, $_, $nrf );
    &printem ;
}
sub printem {					# print a row from @D
    $c = 0 ;
    for $x (@n) {
	print "," if $c++ > 0 ;
	next if $x eq '-' ;
	print $D[$x] ; }
    print "\n" if @n ;
}
