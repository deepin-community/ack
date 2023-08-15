#!perl

use strict;
use warnings;

use Test::More tests => 10;
use lib 't';
use Util;

my @expected_norecurse = line_split( <<'END' );
t/swamp/groceries/fruit:1:apple
t/swamp/groceries/junk:1:apple fritters
END

my @expected_recurse = line_split( <<'END' );
t/swamp/groceries/another_subdir/fruit:1:apple
t/swamp/groceries/another_subdir/junk:1:apple fritters
t/swamp/groceries/dir.d/fruit:1:apple
t/swamp/groceries/dir.d/junk:1:apple fritters
t/swamp/groceries/fruit:1:apple
t/swamp/groceries/junk:1:apple fritters
t/swamp/groceries/subdir/fruit:1:apple
t/swamp/groceries/subdir/junk:1:apple fritters
END

if ( is_windows() ) {
    s{/}{\\}g for ( @expected_norecurse, @expected_recurse );
}

my @args;
my @lines;

prep_environment();

# We sort to ensure deterministic results.
@args  = qw( -n --sort-files apple t/swamp/groceries );
@lines = run_ack(@args);
lists_match( \@lines, \@expected_norecurse, '-n should disable recursion' );

@args  = qw( --no-recurse --sort-files apple t/swamp/groceries );
@lines = run_ack(@args);
lists_match( \@lines, \@expected_norecurse, '--no-recurse should disable recursion' );

# Make sure that re-enabling recursion works.
@args  = qw( -n -r --sort-files apple t/swamp/groceries );
@lines = run_ack(@args);
lists_match( \@lines, \@expected_recurse, '-r after -n should re-enable recursion' );

@args  = qw( --no-recurse -R --sort-files apple t/swamp/groceries );
@lines = run_ack(@args);
lists_match( \@lines, \@expected_recurse, '-R after --no-recurse should re-enable recursion' );

@args  = qw( --no-recurse --recurse --sort-files apple t/swamp/groceries );
@lines = run_ack(@args);
lists_match( \@lines, \@expected_recurse, '--recurse after --no-recurse should re-enable recursion' );

done_testing();

exit 0;
