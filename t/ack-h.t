#!perl

use strict;
use warnings;

use Test::More tests => 12;

use lib 't';
use Util;

prep_environment();

NO_SWITCHES_ONE_FILE: {
    my @expected = line_split( <<'HERE' );
use strict;
HERE

    my @files = qw( t/swamp/options.pl );
    my @args = qw( strict );
    my @results = run_ack( @args, @files );

    lists_match( \@results, \@expected, 'Looking for strict in one file' );
}


NO_SWITCHES_MULTIPLE_FILES: {
    my $target_file = reslash( 't/swamp/options.pl' );
    my @expected = line_split( <<"HERE" );
$target_file:2:use strict;
HERE

    my @files = qw( t/swamp/options.pl t/swamp/pipe-stress-freaks.F );
    my @args = qw( strict );
    my @results = run_ack( @args, @files );

    lists_match( \@results, \@expected, 'Looking for strict in multiple files' );
}


WITH_SWITCHES_ONE_FILE: {
    my $target_file = reslash( 't/swamp/options.pl' );
    for my $opt ( qw( -H --with-filename ) ) {
        my @expected = line_split( <<"HERE" );
$target_file:2:use strict;
HERE

        my @files = qw( t/swamp/options.pl );
        my @args = ( $opt, qw( strict ) );
        my @results = run_ack( @args, @files );

        lists_match( \@results, \@expected, "Looking for strict in one file with $opt" );
    }
}


WITH_SWITCHES_MULTIPLE_FILES: {
    for my $opt ( qw( -h --no-filename ) ) {
        my @expected = line_split( <<'HERE' );
use strict;
HERE

        my @files = qw( t/swamp/options.pl t/swamp/crystallography-weenies.f );
        my @args = ( $opt, qw( strict ) );
        my @results = run_ack( @args, @files );

        lists_match( \@results, \@expected, "Looking for strict in multiple files with $opt" );
    }
}

done_testing();

exit 0;
