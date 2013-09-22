use t::Test;

use Time::Stamp 
    parselocal => { -as => 'parsestamp' },
    localstamp => { format => 'easy'    };

use Sample::Entity::Machine;

my $class;
BEGIN {
    ::use_ok $class='Sample::Entity::Developer';
}

{
    package Data::Faker::Custom;
    use parent qw/Data::Faker/;
    __PACKAGE__->register_plugin(
        timestamp => sub { Data::Faker::DateTime::timestr('%F %T') },
        os        => [qw/windows osx ios android/],
    );
}

my $faker = Data::Faker::Custom->new;

sub __create_machine {
    my $owner = shift;
    my $created_at = $faker->timestamp;
    my $updated_at = $faker->timestamp;
    while( parsestamp($created_at) >= parsestamp($updated_at) ) {
        $updated_at = $faker->timestamp;
    }
    my $params = {
        id         => int rand 1_000_000_000,
        owner      => $owner,
        os         => $faker->os,
        created_at => $created_at,
        updated_at => $updated_at,
    };
    return Sample::Entity::Machine->new($params);
}

subtest 'basic' => sub {
    my $created_at = $faker->timestamp;
    my $updated_at = $faker->timestamp;
    while( parsestamp($created_at) >= parsestamp($updated_at) ) {
        $updated_at = $faker->timestamp;
    }
    my $name = $faker->name;
    my $machines = [ map {
        __create_machine($name)
    } (1..3) ];
    my $params = {
        id         => int rand 1_000_000_000,
        name       => $name,
        email      => $faker->email,
        company    => $faker->company,
        machines   => $machines,
        created_at => $created_at,
        updated_at => $updated_at,
    };
    my $entity = ::new_ok $class => [$params];

    my $expected = {
        %$params,
        machines => [ map { $_->to_plain_object } @$machines ],
    };
    ::cmp_deeply $entity->to_plain_object, $expected, 'to_plain_object ok';
};

::done_testing();

