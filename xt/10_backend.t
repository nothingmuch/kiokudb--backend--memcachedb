use strict;
use warnings;

use Test::More;
use Scope::Guard;

BEGIN {
    use IO::Socket::INET;
    my $addr = shift || "127.0.0.1:21201";
    my $msock = IO::Socket::INET->new(
        PeerAddr => $addr,
        Timeout  => 3
    );
    if ( $msock ) {
        plan 'no_plan';
    } else {
        plan skip_all => "No memcachedb instance running\n";
        exit 0;
    }
}

use ok 'KiokuDB';
use ok 'KiokuDB::Backend::Memcachedb';

use KiokuDB::Test;

my $db = Cache::Memcached->new( { 'servers' => [ '127.0.0.1:21201' ] } );

run_all_fixtures(
    KiokuDB->new(
        backend => KiokuDB::Backend::Memcachedb->new( db => $db, ),
    )
);
