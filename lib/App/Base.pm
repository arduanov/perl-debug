package App::Base;

use strict;
use warnings;

sub app {
    my ($env) = @_;

    my $content = "current time: " . localtime();

    return [
        '200',
        [ 'Content-Type' => 'text/plain' ],
        [ $content ],
    ];
};

1;