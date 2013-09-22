requires 'Carp';
requires 'Class::Accessor::Fast';
requires 'Data::Dumper';
requires 'Data::Util';
requires 'Email::Valid';
requires 'Exporter';
requires 'Params::Validate';
requires 'Time::Stamp';
requires 'URI';
requires 'common::sense';
requires 'DBIx::Skinny';
requires 'DBIx::Skinny::Schema';
requires 'DateTime';
requires 'DateTime::Format::Strptime';
requires 'DateTime::Format::MySQL';
requires 'JSON::XS';

on test => sub {
    requires 'Data::Faker';
    requires 'Test::Deep';
    requires 'Test::Exception';
    requires 'Test::Flatten';
    requires 'Test::Harness';
    requires 'Test::Mock::Guard';
    requires 'Test::Name::FromLine';
    requires 'Test::Simple';
    requires 'Test::mysqld';
    requires 'Test::Fixture::DBIxSkinny';
    requires 'Test::Pretty';
    requires 'Harriet';
};

