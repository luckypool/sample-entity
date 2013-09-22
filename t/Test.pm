package t::Test;

use parent qw(Exporter);

use common::sense;
use Test::More;
use Test::Deep;
use Test::Exception;

use Data::Dumper;

our @EXPORT = (
    @Test::More::EXPORT,
    @Test::Deep::EXPORT,
    @Test::Exception::EXPORT,
);

sub import {
    common::sense->import;
    __PACKAGE__->export_to_level(1, @_);
}

1;
__END__
