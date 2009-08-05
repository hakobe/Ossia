package Ossia;

use Any::Moose;
our $VERSION = '0.01';


use UNIVERSAL::require;
use HTTP::Engine;
use Ossia::Dispatcher;
use Ossia::Request;

has dispatcher => (
    is => 'ro',
    default => sub { Ossia::Dispatcher->new  },
);

no Any::Moose;

sub handler {
    my $self = shift;
    sub {
        $self->handle_request(@_);
    };
}

sub handle_request {
    my $self = shift;
    my $req = shift;

    my $action = $self->dispatcher->dispatch($req);
    my $res = $self->process($action, $req);

    $res;
}

sub process {
    my ($self, $action, $req, @opts) = @_;

    my $res = HTTP::Engine::Response->new(status => 200);
    $res->header("Content-Type" => "text/html");

    if (!$action) {
        $res->code(404);
        $res->content("Not Found");
        return $res;
    }

    eval {
        $action->handle($req, $res, @opts);
    };
    if ($@) {
        $res->code(500);
        $res->header("Content-Type" => "text/plain");
        $res->content($@);
    }

    $res;
}



1;

__END__

=encoding utf8

=head1 NAME

Ossia -

=head1 SYNOPSIS

  use Ossia;

=head1 DESCRIPTION

Ossia is

=head1 AUTHOR

Yohei Fushii E<lt>hakobe@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
