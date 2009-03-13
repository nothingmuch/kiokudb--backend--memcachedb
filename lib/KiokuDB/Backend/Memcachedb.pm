package KiokuDB::Backend::Memcachedb;
use Moose;

use Data::Stream::Bulk::Util qw(bulk);

use Cache::Memcached;
use namespace::clean -except => 'meta';

use Carp;

our $VERSION = "0.01";

with qw(
    KiokuDB::Backend
    KiokuDB::Backend::Serialize::Delegate
    KiokuDB::Backend::Role::Concurrency::POSIX
);

has create => (
    isa => "Bool",
    is  => "ro",
    default => 0,
);

sub BUILD {
    my $self = shift;
}

has db => (
    isa => "Cache::Memcached",
    is  => "ro",
    handles => [qw(document)],
);

sub new_from_dsn_params {
    my ( $self, %args ) = @_;

    my $servers = delete $args{ servers };
    my @servers = split /,/, $servers;
    my $db      = Cache::Memcached->new( { 'servers' => \@servers } );
    $self->new( %args, db => $db );
}

sub insert {
    my ( $self, @entries ) = @_;
    my $db = $self->db;
    foreach my $entry ( @entries ) {
        $db->set( $entry->id, $self->serialize( $entry ) );
    }
}

sub get {
    my ( $self, @ids ) = @_;

    my $db = $self->db;

    my @objs = map { $self->deserialize( $db->get( $_ ) ) } @ids;
    @objs;
}

sub exists {
    my ( $self, @ids ) = @_;
    my $check = $self->db->get_multi( @ids );
    map { exists $check->{ $_ } ? 1 : 0 } @ids;
}

sub delete {
    my ($self, @ids_or_entries) = @_;
    my @ids = map { ref($_) ? $_->id : $_ } @ids_or_entries;
    $self->db->delete($_) foreach (@ids);
}

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__

=pod

=head1 NAME

KiokuDB::Backend::Memcachedb - Memcachedb backend for L<KiokuDB>

=head1 SYNOPSIS

    KiokuDB->connect( 
        "memcachedb:servers=127.0.0.1:112200,127.0.0.1:112222" 
    );

=head1 DESCRIPTION

This backend provides L<KiokuDB> support for Memcachedb using
L<Cache::Memcached>

=head1 ATTRIBUTES

=over 4

=item db

An L<Cache::Memcachedb> instance.

Required.

=back

=head1 VERSION CONTROL

L<http://github.com/franckcuny/kiokudb-backend-memcachedb>

=head1 AUTHOR

Nils Grunwald E<lt>nils.grunwald@rtgi.frE<gt>
Franck Cuny E<lt>franck.cuny@rtgi.frE<gt>

=head1 COPYRIGHT

    Copyright (c) 2009, nils grunwald, franck cuny, RTGI. All
    rights reserved This program is free software; you can redistribute
    it and/or modify it under the same terms as Perl itself.

=cut
