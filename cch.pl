#!/usr/bin/perl

# Contrast formula via Ilmari Karonen

use v5.10;
use Getopt::Std;

$Getopt::Std::STANDARD_HELP_VERSION = 1;
getopts('b', \my %opts) || die 
	"Try 'cch --help' for help\n";
my $bg_only = 1 if $opts{b};

sub HELP_MESSAGE{
	say	"Usage: cch [OPTION] [FILE]\n" .
		"\nOption:\n" .
		"\t-b\tomits foreground text\n\n" .
		"Examples:\n" .
		"\tcch ~/.Xresources | less -r\n" .
		"\techo #333 #444 #555 | cch\n";
}

sub VERSION_MESSAGE {
	say	"Color Code Highlighter v0.2";
} 

sub prep {
	my $code = shift;
	$code =~ s/#//;
	return $code if length($code) == 6;
	my @rgb = split(//, $code);
	for my $i (@rgb) { $i x= 2; }
	return join(//, @rgb);
}

sub contrast {
	my $rgb = shift;
	my ($r, $g, $b) = @{$rgb};
	my $gamma = 2.2;
	my $l = 0.2126 * ($r/255) ** $gamma;
	$l += 0.7152 * ($g/255) ** $gamma;
	$l += 0.0722 * ($b/255) ** $gamma;
	return "220" if $l < (0.5 ** $gamma);
	return "50";
}

sub colorize {
	my $code = shift;
	my @bg = map $_, unpack 'C*', pack 'H*', prep($code);
	my $fg = contrast(\@bg);
	my $spaces = " " x length($code);
	my $str = "\x1b[48;2;${bg[0]};${bg[1]};${bg[2]}m"
	. "\x1b[1;38;2;${fg};${fg};${fg}m";
	$bg_only ? return $str . "${spaces}\x1b[0m"
		 : return $str . "${code}\x1b[0m";
}

sub main {
	my $fh;
	my $file = shift @ARGV;
	$file ? open($fh, "<", $file) 
		|| die "Can't read from $file: $!\n"
		: open($fh, "-");

	if (-t $fh) {
		say "Use 'q' to exit";
		print "Enter code(s): ";
	}

	while (my $row = <$fh>) {
		last if -t $fh && $row eq "q\n";
		chomp $row;
		$row =~ s/((\#[[:xdigit:]]{6})
			 |(\#[[:xdigit:]]{3}))
			 (?![[:alnum:]])
			 /colorize($1)
			 /xeg;
		say $row;
		print "Enter code(s): " if -t $fh;
	}
}

main();
