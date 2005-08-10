# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-FTPSSL.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';
use strict;
use Test::More;

plan tests => 4;

BEGIN { use_ok('Net::FTPSSL') }


diag( "\nNet::FTPSSL was loaded properly. " );

my $more_test = ask_yesno("Do you want to make a deeper test");

SKIP: {
	skip "Deeper test skipped for some reason...", 3 unless $more_test;

	my( $address, $server, $port, $user, $pass, $mode ); 

	$address = ask("Server address ( host[:port] )");

	$mode = ask("\tConnection mode (I)mplicit or (E)xplicit. Default 'E'");

	$user = ask("\tUser (default 'anonymous')");

	$pass = ask("\tPassword (default 'user\@localhost')");

	( $server, $port ) = split( /:/, $address );
	$port = 21 unless $port;
	$mode = EXP_CRYPT unless $mode =~ /(I|E)/;
	$user = 'anonymous' unless $user;
	$pass = 'user@localhost' unless $pass;

  my $ftp =
    Net::FTPSSL->new( $server, port => $port, encryption => $mode )
    or die "Can't open $server:$port";

  isa_ok( $ftp, 'Net::FTPSSL', 'Net::FTP object creation' );

  ok( $ftp->login( $user, $pass ), 'Login' );

  ok( scalar $ftp->list() != 0, 'list() command (PASV() command worked too!)' );

  $ftp->quit();
}

sub ask {
  my $question = shift;
  diag("\n$question ? ");

  my $answer = <STDIN>;
  chomp $answer;
  return $answer;
}

sub ask_yesno {

  my $question = shift;
  diag("\n$question ? [y/N]");

  my $answer = <STDIN>;
  chomp $answer;
  return $answer =~ /^y(es)*$/i ? 1 : 0;
}

# vim:ft=perl:
