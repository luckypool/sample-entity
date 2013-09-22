package t::Test::mysqld;
use common::sense;

use parent qw/Class::Accessor::Fast/;

use Test::mysqld;
use JSON::XS qw/decode_json encode_json/;

__PACKAGE__->mk_accessors(qw/mysqld/);

my $mysqld;
BEGIN {
    if(my $json = $ENV{TEST_MYSQLD}){
        my $obj = decode_json $json;
        $mysqld = bless $obj, 'Test::mysqld';
    }
    else {
        say 'Starting Test::mysqld...';
        $mysqld = Test::mysqld->new(
            my_cnf => {
                'skip-networking' => '',
            }
        ) or die $Test::mysqld::errstr;
        $ENV{TEST_MYSQLD} = encode_json +{%$mysqld};
        say 'Load Test::mysqld: '. $ENV{TEST_MYSQLD};
    }
}

sub new {
    my $class = shift;
    return $class->SUPER::new({
        mysqld => $mysqld,
    });
}

1;
__END__
