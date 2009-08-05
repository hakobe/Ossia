package Ossia::Request;

use Any::Moose;

extends qw(HTTP::Engine::Request);

sub path {
    my $self = shift;

    my $path = $self->uri->rel->path;
    $path =~ s!^\.\./[^/]+!!;                    # fix ../foo/path => /path
    $path =~ s/^\.+//;                           # fix ./path => /path
    $path = '/' . $path unless $path =~ m!^/!; # path should be / first

    $path;
}

1;
