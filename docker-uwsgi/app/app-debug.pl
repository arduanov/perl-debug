#!/usr/bin/env perl
use strict;
use warnings;

use Plack::Middleware::Camelcadedb (
    remote_host => ($ENV{PERL5_DEBUG_HOST}) . ":" . ($ENV{PERL5_DEBUG_PORT}),
);
use Plack::Builder;
use App::Base;

builder {
    enable "Camelcadedb";
    \&App::Base::app;
};