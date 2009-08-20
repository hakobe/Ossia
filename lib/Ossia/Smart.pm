package Ossia::Smart;
use Any::Moose;

extends qw(Ossia);

use Exporter::Lite;
our @EXPORT = qw(get post static);

use List::MoreUtils qw(zip);
use HTTP::Engine;
use HTTP::Engine::Middleware;

no Any::Moose;

my $instance;
sub instance { 
    return $instance if ref $_[0];
    my $class = shift;

    $instance = $instance || $class->new;
}

sub register_smart_action {
    my ($self, $method, $path, $handler) = @_;

    my @capture_keys = ();
    my $pattern = "$path";
    $pattern =~ s{:([^:]+)}{
        push @capture_keys, $1;
        "([^/]+)";
    }ge;
    $pattern = qr/^$pattern$/xms;
    my $matcher = sub {
        my $req = shift;
        my @captures = $req->path =~ $pattern;;
        return unless @captures;

        my %params = zip @capture_keys, @captures;
        $req->param($_ => $params{$_}) for keys %params;
        1;
    };

    $self->dispatcher->register_action( $method, $matcher, $handler);
}

sub get {
    my ($path, $handler) = @_;
    my $self = __PACKAGE__->instance;
    $self->register_smart_action( 'GET', $path, $handler);
}

sub post {
    my ($path, $handler) = @_;
    my $self = __PACKAGE__->instance;
    $self->register_smart_action( 'POST', $path, $handler);
}

my $mw = HTTP::Engine::Middleware->new;
sub static {
	my ($path, $base) = @_;
    return unless $path;
    $path =~ s{^/+}{}xms;
    $mw->install('HTTP::Engine::Middleware::Static' => {
        regexp => qr{^ / $path / .+ }xms,
        docroot => $base || 'static',
    });
}

sub run {
    my ($class, %opts) = @_;

    my $self = $class->instance;
    HTTP::Engine->new(
        interface => {
            module => 'ServerSimple',
            args   => {
                host => 'localhost',
                port =>  3000,
            },
            request_handler => $mw->handler(sub {
                $self->handler->(@_);
            }),
            %opts
        },
    )->run;
}


1;
