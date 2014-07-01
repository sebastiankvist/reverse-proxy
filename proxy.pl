#!/usr/bin/perl -w
 
###########################################################
# Created by: Sebastian Kvist
#
# Desc.: Reverse proxy for GET-requests against specified
# host. See array "allowedHosts".
###########################################################
 
use strict;
use CGI;
use LWP::Simple;
use LWP::UserAgent;
use URI::Escape;
 
my $browser = LWP::UserAgent->new();
my $q = CGI->new();
my $queryString = $ENV{'QUERY_STRING'};;
my $url = '';
my $host = '';
my @allowedHosts = ('thissiteitrust.com', 'anothersiteitrust.com');
my $hostIsOK = 0;
 
(my $key, my $val) = split(/url=/, $queryString);
$url = uri_unescape($val);
 
if ($url eq '') {
$url = "http://hopefullyincludedinallowedhosts.com";
}
 
my $startIdx = index($url, "//") + 2;
$host = substr($url, $startIdx);
 
my $endIdx = index($host, "/");
if ($endIdx > 0) {
$host = substr($host, 0, $endIdx);
}
 
foreach my $allowedHost (@allowedHosts) {
if ($host eq $allowedHost) {
$hostIsOK = 1;
}
}
 
if ($hostIsOK) {
my $response = $browser->get($url);
print $q->header(-type=>$response->content_type, -status=>$response->status_line);
print $response->content;
} else {
print $q->header(-type=>'text/plain', -status=>'502 Bad Gateway');
print "This proxy does not allow you to access that location (" . $host . ").";
}
