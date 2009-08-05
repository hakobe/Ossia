package Ossia::Dispatcher;

use Any::Moose;
use Ossia::Action;
use List::MoreUtils qw(first_value);

has actions => (
    is => 'ro',
    default => sub { [] },
);

no Any::Moose;

sub dispatch {
    my $self = shift;
    my $req  = shift;

    my ($action) = first_value { $_->match($req) } @{ $self->actions };

    $action;
}

sub register_action {
    my ($self, $method, $matcher, $handler) = @_;

    my $action = Ossia::Action->new(
        method  => $method,
        matcher => $matcher,
        handler => $handler, 
    );

    push @{ $self->actions }, $action;
}

1;

