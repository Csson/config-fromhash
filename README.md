# Config::FromHash

Config::FromHash - Read config files containing hashes

# SYNOPSIS
    # in config file
    {
        thing => 'something',
        things => \['lots', 'of', 'things'\],
        deep => {
            ocean => 'submarine',
        },
    }

    # in module
    use Config::FromHash;

    my $config = Config::FromHash->new(filename => 'theconfig.conf', data => { thing => 'default' });

    # prints 'submarine'
    print $config->get('deep/ocean');

# DESCRIPTION

Config::FromHash is yet another config file handler. This one reads config files that contain a Perl hash.

# AUTHOR

Erik Carlsson <csson@cpan.org>

# COPYRIGHT

Copyright 2014- Erik Carlsson

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
