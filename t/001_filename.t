# -*- cperl -*-

# t/001_filename.t - check module loading and test filename extraction
# these are UNIX filenames
# We must handle them even if we are not running on a UNIX system! 
# can't just grab $ENV{PATH} and expect that its a UNIX filename!


use strict;
use blib;
use Test::More;
use Test::CGI::Untaint;

my @extractable;
push @extractable,"bar";
#simple and short: see that '/var' is extracted from '/var'
push @extractable, "/var";
#case counts! this is a UNIX name!
push @extractable,"/Opt";
#more complex.Throw in a leading double slash.
push @extractable, "//this/is/a/very/deeply/nested/name/indeed/why/would/you/do/such/a/thing/superfragilisticexpialodocius/antidisestablishmentiarianism";
#blanks in unix names are a PITA but legal. Bad idea but since used by e.g. win32 they find their way into samba-exported filesystems
push @extractable,"/home/My Documents/";
push @extractable,"/home/my-documents";
push @extractable,"foo_bar";
#unusal but legal
push @extractable,"[14,22]";	# the old PPN naming of directories on DEC
push @extractable,"1+2";	#this is not 3 but it is 3 characters long
push @extractable,"+2";
#push @extractable,"foo\!";
push @extractable,"#foo"; # tricky; at the command line this has to be quoted to work but # is the standard emacs working file prefix
#push @extractable,"foo\$";	# $ only at end of the name.
#push @extractable,"foo\%"; #only at end of name
push @extractable,"^foo";
#illegal names testing. Bad people put shell escapes and so on into filenames.
my @invalid; #= qw/!foo |foo  &foo foo& foo; ;foo (foo foo(bar)  )baz </proc >/boot {meta }meta {meta}  %pooh ful%    $x x? ?x @host joe@  *baby baby* fragment; ;fragged/;
push @invalid, "foo\!baz";
push @invalid,"x\$y";
push @invalid, "\ffoo";	#control characters including CR and LF but space is legitimate
plan tests => @extractable + @invalid;
#see that each of these is extracted
my $case;
foreach $case (@extractable) {
  is_extractable($case,$case,"Filenames") or diag("cannot extract $case\n");
}

#see that extraction fails for each
foreach $case (@invalid) {
  unextractable($case,"Filenames") or diag("unexpectedly extracted $case\n");
}









