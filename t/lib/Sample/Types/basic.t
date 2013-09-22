use t::Test;

my $class;
my @exports;
BEGIN {
    @exports = qw/
        TYPE_INTEGER
        TYPE_STRING
        TYPE_EMAIL
        TYPE_TIMESTAMP
        TYPE_URL
        TYPE_DEVELOPERS
        TYPE_MACHINES
    /;
    use_ok $class='Sample::Types', @exports;
}

can_ok $class, @exports;
can_ok __PACKAGE__, @exports;

done_testing;
