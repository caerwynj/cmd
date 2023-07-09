#!/bin/perl

my ($dir) = @ARGV;

$dir =~ s|//+|/|;
my @elems = split '/', $dir;
readns();

sub readns {
	open NS, "$ENV{HOME}/.namespace" or die "can't open .namespace";
	my %ns;
	while (<NS>) {
		my ($from, $to) = split ' ', $_;
		$ns{$from} = $to;
	}

	foreach (keys %ns) {
		print "from: $_ to: $ns{$_}\n";
	}
}