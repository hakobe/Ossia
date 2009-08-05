use strict;
use warnings;

use Ossia::Smart;

get '/' => sub {
    my ($req, $res) = @_;
    $res->content('Hello, Ossia!');
};

get '/reuselist' => sub {
    my ($req, $res) = @_;
};

get '/reuse/:id' => sub {
    my ($req, $res) = @_;
    $res->content(sprintf('Hello, Ossia! Reuse: %d', $req->param('id')));
};

Ossia::Smart->run;
