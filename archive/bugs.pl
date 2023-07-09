#! /usr/bin/perl -w
#
# Query the "Bug Priority List" web page and return the table of
# bugs in plain text.  
#
# Usage: bugs.pl user passwordfile
# where the first line of passwordfile contains the NT password for user.
#
# Notes:
#
# This web page requires authentication.  Use lynx and truss (Solaris) to
# see what we need to do.
#
# truss -t write -v write -wall lynx -auth=joelb:mypass -source
#         -dump "http://delta.kenan.com/priority/cgi-bin/prioritization.cgi"
#
# This shows the request is like:
#
# GET /priority/cgi-bin/prioritization.cgi HTTP/1.0\r\n
# Host:delta.kenan.com\r\n
# Authorization: Basic am9lbGI6bXlwYXNz
# \r\n
# \r\n
#
# The Authorization string is user:pass base64 encoded, e.g.
#   [joelb@dhcp-110-249 joelb]$ echo -n joelb:mypass | mimencode
#   am9lbGI6bXlwYXNz
# See RFC2068 for details.
#
# The problem with this is that the lynx command line contains the
# password, so anyone can see it using ps.  So, use LWP to send a
# direct request.  The only tricky part is that we need to add a
# header to the request like:
#
#   Authorization: Basic am9lbGI6bXlwYXNz
#
# where the string after Basic is user:password encoded in base64.
#

use LWP::UserAgent;
use MIME::Base64;
use strict;

my $user = shift || die print_usage();
my $pw_file = shift || die print_usage();

open(PW_FILE, $pw_file) || die "$pw_file: $!";
my $pw = <PW_FILE>;
chomp($pw);
close(PW_FILE);

my $url = "http://delta.kenan.com/priority/cgi-bin/prioritization.cgi";
my $text = "";
my @lines;

my $ua = new LWP::UserAgent;
my $request = new HTTP::Request('GET', $url);
my $auth_string = "Basic " . encode_base64($user . ":" . $pw);
$request->push_header("Authorization", $auth_string);

my $response = $ua->request($request);
$text = $response->{_content};

$text =~ s|(</tr>)|$1\n|gi;
$text =~ s|<[^>]*>||g;
$text =~ s|Additional Information on Defect \$id||g;

@lines = split("\n", $text);
@lines = grep /\d CAMqa.*\d+$/, @lines;
print join("\n", @lines), "\n";

sub print_usage
{
    print "Usage: $0 user passwordfile\n"
}

