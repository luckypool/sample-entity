use t::Test;
use t::Test::DB qw/Sample::DB::Handler::Practice/;

my $class;
BEGIN {
    ::use_ok($class='Sample::Model::Machine');
}

my $model = ::new_ok $class => [{
    handler => 'Sample::DB::Handler::Practice',
    table   => 'machine',
}];

::done_testing;
