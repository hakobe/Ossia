package Ossia::Action;

use Any::Moose;

has method   => ( is => 'ro' );
has matcher  => ( is => 'ro' );
has handler  => ( is => 'ro' );

no Any::Moose;

sub match {
    my ($self, $req) = @_;
    $self->matcher->($req);
}

sub handle {
    my ($self, $req, $res) = @_;
    $self->handler->($req, $res);
}


1;
