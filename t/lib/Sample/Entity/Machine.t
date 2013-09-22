use t::Test;

use Time::Stamp 
    parselocal => { -as => 'parsestamp' },
    localstamp => { format => 'easy'    };

my $class;
BEGIN {
    ::use_ok $class='Sample::Entity::Machine';
}

{
    package Data::Faker::Custom;
    use parent qw/Data::Faker/;
    __PACKAGE__->register_plugin(
        timestamp => sub { Data::Faker::DateTime::timestr('%F %T') },
        os        => [qw/windows osx ios android/],
    );
}

subtest 'basic' => sub {
    my $faker = Data::Faker::Custom->new;
    my $created_at = $faker->timestamp;
    my $updated_at = $faker->timestamp;
    while( parsestamp($created_at) >= parsestamp($updated_at) ) {
        $updated_at = $faker->timestamp;
    }
    my $params = {
        id         => 1,
        owner      => $faker->name,
        os         => $faker->os,
        created_at => $created_at,
        updated_at => $updated_at,
    };
    my $entity = ::new_ok $class => [$params];
};

::done_testing();

