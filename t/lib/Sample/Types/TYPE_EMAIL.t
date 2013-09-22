use t::Test;

use Params::Validate qw//;
use Data::Dumper;
use Data::Faker qw/Internet/;

use Sample::Types qw/TYPE_EMAIL/;

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
    my $faker = Data::Faker->new;
    my @valid_patterns = (
        { email => $faker->email },
    );
    foreach my $pattern (@valid_patterns) {
        my @valid_params = ($pattern);
        my $test_sub = sub {
            Params::Validate::validate(@valid_params, {
                email => TYPE_EMAIL,
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
        { email => 'foo.bar.@docomo.ne.jp' },
    );
    foreach my $pattern (@invalid_patterns) {
        my @invalid_params = ($pattern);
        my $test_sub = sub {
            Params::Validate::validate(@invalid_params, {
                email => TYPE_EMAIL,
            });
        };
        ::dies_ok sub { $test_sub->(); }, 'Invalid pattern: ' . __dump(@invalid_params);
    }
};

done_testing;
