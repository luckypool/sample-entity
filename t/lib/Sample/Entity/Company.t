use t::Test;

use Time::Stamp 
    parselocal => { -as => 'parsestamp' },
    localstamp => { format => 'easy'    };

use Sample::Entity::Machine;
use Sample::Entity::Developer;

my $class;
BEGIN {
    ::use_ok $class='Sample::Entity::Company';
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

sub __create_developer {
    my $company = shift;
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
        company    => $company,
        machines   => $machines,
        created_at => $created_at,
        updated_at => $updated_at,
    };
    return Sample::Entity::Developer->new($params);
}

subtest 'create ok' => sub {
    my $created_at = $faker->timestamp;
    my $updated_at = $faker->timestamp;
    while( parsestamp($created_at) >= parsestamp($updated_at) ) {
        $updated_at = $faker->timestamp;
    }
    my $company = $faker->company;
    my $developers = [ map {
        __create_developer($company)
    } (1..3) ];
    my $params = {
        id         => int rand 1_000_000_000,
        name       => $company,
        url        => 'http://'.$faker->domain_name.'/',
        developers => $developers,
        created_at => $created_at,
        updated_at => $updated_at,
    };
    my $entity = ::new_ok $class => [$params];

    my $expected = {
        %$params,
        developers => [ map { $_->to_plain_object } @$developers ],
    };
    ::cmp_deeply $entity->to_plain_object, $expected, 'to_plain_object ok';
};

::done_testing();

