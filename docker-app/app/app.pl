#!/usr/bin/env perl

use strict;
use warnings;

use App::Base;

use HTTP::Server::PSGI;

my $server = HTTP::Server::PSGI->new(
    host => "0.0.0.0",
    port => 3000,
    timeout => 120,
);

$server->run(\&App::Base::app);