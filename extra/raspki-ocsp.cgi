#!/usr/bin/perl
use MIME::Base64;
use URI::Escape;
use CGI;
use IPC::Open3;

# based on nph-ocsp.cgi downloaded from http://itfeedback.com/pages/pki in 2009
# now only available on
# https://web.archive.org/web/20090211180857/http://itfeedback.com/pages/pki
# and some ideas from mod_gnutls oscp bash cgi wrapper:
# https://mod.gnutls.org/changeset/c0c4106737c1d6d7e545864f154a6a1acd40827c/mod_gnutls

my $error, $decoded;

if ($ENV{REQUEST_METHOD} eq "POST") {
	if ($ENV{CONTENT_TYPE} eq "application/ocsp-request") {
#An OCSP request using the POST method is constructed as follows
#The Content-Type header has the value "application/ocsp-request"
#while the body of the message is the binary value of the DER
#encoding of the OCSPRequest.
		$decoded = "";
	} else {
		$error = "415 Unsupported media type";
	}
} elsif ($ENV{REQUEST_METHOD} eq "GET") {
	if ($ENV{CONTENT_TYPE} eq "application/ocsp-request") {
#GET {url}/{url-encoding of base-64 encoding of the
#DER encoding of the OCSPRequest}
#$escaped = uri_escape(substr($ENV{SCRIPT_NAME},1));
		$decoded = decode_base64(substr($ENV{SCRIPT_NAME},1));
	} else {
		$error = "415 Unsupported media type";
	}
} else { $error = "405 Method not allowed";}

if ($error eq "") {
	local(*HIS_IN, *HIS_OUT, *HIS_ERR);
	$childpid = open3(*HIS_IN, *HIS_OUT, *HIS_ERR, $ENV{OPENSSL}, "ocsp", "-CAfile", $ENV{CA_CERT}, "-index", $ENV{OCSP_INDEX}, "-CA", $ENV{CA_CERT}, "-rsigner", $ENV{OCSP_CERT}, "-rkey", $ENV{OCSP_KEY}, "-nmin", "3", "-reqin", "/proc/self/fd/0", "-respout", "/proc/self/fd/1");
	if ($decoded eq "") {
		while (<>) {print HIS_IN $_;}
	} else {
		print HIS_IN $decoded;
	}
	close(HIS_IN);
	waitpid($childpid, 0);
	$err = $?;
	sysread(HIS_OUT, $resp, 4096);
	@errlines = <HIS_ERR>;
	close HIS_OUT;
	close HIS_ERR;
	if ($err) {
	    $error = "500 Internal OpenSSL OCSP Error";
	} else {
		use bytes;
		my $content_length = length($resp);

		print "Status: 200 OK\r\n";
		print "Content-Length: $content_length\r\n";
		print "Connection: close\r\n";
		print "Content-Type: application/ocsp-response\r\n\r\n";
		print $resp;
		exit 0;
	}
}
if ($error ne "") {
	print "Status: ".$error."\r\n";
	#print "Content-type: text/plain\n\n";
	#print "string".$ENV{REQUEST_STRING}."\n";
	#for (keys %ENV) { print "$_ => $ENV{$_}\r\n";  }
	#print @errlines;
	print "Content-Type: text/html\r\n\r\n";
	print <<end_marker;
<html>
 <head><title>$error</title></head>
 <body>
  <p>This server is an OCSP responder, not a web server.
  </p>
</html>
end_marker
	exit 1;
}
