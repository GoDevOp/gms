package GMS::Atheme::Client;

use TryCatch;
use RPC::Atheme::Error;

=head1 NAME

GMS::Atheme::Client

=cut

=head1 DESCRIPTION

This class handles any GMS functionality that needs to be done
through Atheme.

=cut

=head1 METHODS

=head2 new

Constructor.
Accepts a RPC::Atheme::Session object and stores it.

=cut

sub new {
    my ($class, $session) = @_;

    $self->{_session} = $session;

    bless $self, $class;
}

=head2 cloak

Uses Atheme to cloak a user.
It takes 2 arguments, the account name of the
user we want to cloak, and the cloak to set.

=cut

sub cloak {
    my ( $self, $accountname, $cloak ) = @_;
    my $session = $self->{_session};

    try {
        return $session->command($session->service, 'cloak', $accountname, $cloak);
    }
    catch (RPC::Atheme::Error $e) {
        die $e;
    }
}

=head2 take_over

Takes 3 arguments, a channel name, the account name
of a group contact, and the person who requested the change
( for logging )
It uses Atheme to transfer the channel to the contact.

=cut

sub take_over {
    my ($self, $channel, $gc_name, $requestor) = @_;
    my $session = $self->{_session};

    try {
        return $session->command($session->service, 'transfer', $channel, $gc_name, $requestor);
    }
    catch (RPC::Atheme::Error $e) {
        die $e;
    }
}

=head2 drop

Similar to take_over, but drops the channel instead of transferring it.

=cut

sub drop {
    my ($self, $channel, $requestor) = @_;
    my $session = $self->{_session};

    try {
        return $session->command($session->service, 'drop', $channel, $requestor);
    }
    catch (RPC::Atheme::Error $e) {
        die $e;
    }
}

=head2 metadata

Returns an account's metadata

=cut

sub metadata {
    my ($self, $uid, $metadata) = @_;
    my $session = $self->{_session};

    try {
        my $data = $session->command($session->service, 'metadata', $uid, $metadata);

        return $data;
    }
    catch (RPC::Atheme::Error $e) {
        die $e if ( $e->code != RPC::Atheme::Error::nosuchkey() );
    }
}

=head2 mark

Returns an account's mark, if there is one

=cut

sub mark {
    my ($self, $uid) = @_;

    try {
        my $mark = $self->metadata ($uid, 'private:mark:reason');
        my $setter = $self->metadata ($uid, 'private:mark:setter');
        my $time = $self->metadata ($uid, 'private:mark:timestamp');

        return [$mark, $setter, $time];
    }
    catch (RPC::Atheme::Error $e) {
        die $e;
    }
}

=head2 chanexists

Returns if a channel is registered

=cut

sub chanexists {
    my ($self, $channel) = @_;
    my $session = $self->{_session};

    try {
        return $session->command ($session->service, 'chanexists', $channel) == 1;
    }
    catch (RPC::Atheme::Error $e) {
        die 'wtf' .$e;
    }
}

1;