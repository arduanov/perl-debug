#!/usr/bin/env perl

use strict;
use warnings;

use Plack::Builder;
use App::Base;

builder {
    \&App::Base::app;
};