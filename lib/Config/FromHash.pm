package Config::FromHash;

use strict;
use warnings;
use 5.010;

use File::Basename();
use File::Slurp();
use Hash::Merge();

our $VERSION = '0.01';

sub new {
    my($class, %args) = @_;

    $args{'data'} ||= {};
    $args{'sep'}  ||= qr!/!;

    if(exists $args{'filenames'} && ref $args{'filenames'} ne 'ARRAY')  {
        die "'filenames' must be an array-ref. If specifying only one file, you can use 'filename' instead.";
    }

    if(exists $args{'filename'} && exists $args{'filenames'}) {
        unshift @{ $args{'filenames'} } => $args{'filename'};
        delete $args{'filename'};
    }
    elsif(exists $args{'filename'}) {
        $args{'filenames'} = [ $args{'filename'} ];
        delete $args{'filename'};
    }

    if(exists $args{'environment'} && ref $args{'environment'} ne 'ARRAY') {
        $args{'environment'} = [ $args{'environment'} ];
        if(!defined $args{'environment'}->[-1]) {
            push @{ $args{'environment'} } => undef;
        }
    }
    else {
        $args{'environment'} = [ undef ];
    }

    my $self = bless \%args => $class;

    Hash::Merge::set_set_behavior('RIGHT_PRECEDENT');
    my $data = $args{'data'};

    foreach my $environment (@{ $args{'environment'} }) {
        FILE:
        foreach my $config_file (@{ $args{'filenames'} }) {
            my($filename, $directory, $extension) = File::Basename::fileparse($config_file, qr{\.[^.]+$});
            my $new_filename = $directory . $filename . (defined $environment ? ".$environment" : '') . $extension;
            
            next FILE if !-e $new_filename;
            
            $data = Hash::Merge::merge($data, $self->_parse($config_file));

        }
    }

}

sub get {
    my $self = shift;
    my $path = shift;

    if(!defined $path) {
        warn "No path defined - nothing to return";
        return;
    }

    my @parts = split $self->{'sep'} => $path;
    my $hash = $self->{'data'};

    foreach my $part (@parts) {
        if(ref $val eq 'HASH') {
            $hash = $hash->{ $part };
        }
        else {
            die "Can't resolve path '$path' beyond '$part'";
        }
    }
    return $hash;
}

sub _parse {
    my $self = shift;
    my $file = shift;

    my $contents = File::Slurp::read_file($file, binmode => ':encoding(UTF-8');
    my($parsed, $error) = $self->_eval($contents);

    die "Can't parse <$file>: $error" if $error;
    die "<$file> doesn't contain hash" if ref $parsed ne 'HASH';

    return $parsed;

}

sub _eval {
    my $self = shift;
    my $contents = shift;

    return (eval shift, $@);
}


1;
__END__

# ABSTRACT: Read config files with hashes

=encoding utf-8

=head1 Config::FromHash

Config::FromHash - Read config files containing hashes

=head1 SYNOPSIS

  use Config::FromHash;

=head1 DESCRIPTION

Config::FromHash is yet another config file handler. This one reads config files that contain a Perl hash.

=head1 AUTHOR

Erik Carlsson E<lt>csson@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2014- Erik Carlsson

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
