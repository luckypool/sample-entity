use t::Test;

use Params::Validate qw//;
use Data::Dumper;

use Sample::Types qw/TYPE_TIMESTAMP/;

sub __dump {
    my $dump;
    {
        local $Data::Dumper::Terse  = 1; # don't output names where feasible
        local $Data::Dumper::Indent = 0; # turn off all pretty print
        $dump = Data::Dumper::Dumper @_;
    }
    return $dump;
}

subtest 'success' => sub {
    my @valid_patterns = (
        { timestamp => '2012-10-10 08:19:29' },
        { timestamp => '2012-02-29 23:59:59' }, # leap day
    );
    foreach my $pattern (@valid_patterns) {
        my @valid_params = ($pattern);
        my $test_sub = sub {
            Params::Validate::validate(@valid_params, {
                timestamp => TYPE_TIMESTAMP,
            });
        };
        ::lives_ok sub { $test_sub->(); }, 'Valid pattern: ' . __dump(@valid_params);
    }
};

subtest 'failure' => sub {
    my @invalid_patterns = (
        1,
        'hoge',
        [ 'hobe', 'fuga' ],
        { foo => 'bar' },
        { timestamp => '2012-10-10 08:19:29 aaa' },
        { timestamp => '2013-02-29 23:59:59' },
        { timestamp => '2012-10-10T08:19:29' },
    );
    foreach my $pattern (@invalid_patterns) {
        my @invalid_params = ($pattern);
        my $test_sub = sub {
            Params::Validate::validate(@invalid_params, {
                timestamp => TYPE_TIMESTAMP,
            });
        };
        ::dies_ok sub { $test_sub->(); }, 'Invalid pattern: ' . __dump(@invalid_params);
    }
};

done_testing;
