use strict;
use warnings;

use Test::More;
use Scope::Guard;

BEGIN {
    #plan skip_all => 'Please set KIOKU_COUCHDB_URI to a CouchDB instance URI' unless $ENV{KIOKU_COUCHDB_URI};
    plan 'no_plan';
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
