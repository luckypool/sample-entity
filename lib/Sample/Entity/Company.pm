package Sample::Entity::Company;
use common::sense;
use parent qw/Class::Accessor::Fast/;

use Sample::Types qw/
    TYPE_INTEGER
    TYPE_STRING
    TYPE_URL
    TYPE_DEVELOPERS
    TYPE_TIMESTAMP
/;

use constant ACCESSORS => [qw/
    id
    name
    url
    developers
    created_at
    updated_at
/];

__PACKAGE__->mk_accessors(@{ACCESSORS()});

sub new {
    my $class = shift;
    my %args  = Params::Validate::validate(@_, {
        id         => TYPE_INTEGER,
        name       => TYPE_STRING,
        url        => TYPE_URL,
        developers => TYPE_DEVELOPERS,
        updated_at => TYPE_TIMESTAMP,
        created_at => TYPE_TIMESTAMP,
    });
    return $class->SUPER::new({%args});
}

sub to_plain_object {
    my $self = shift;
    return +{
        map {
            my $key = $_;
            my $value = $key =~ qr/developers/
                      ? [ map { $_->to_plain_object } @{$self->$key} ]
                      : $self->$key;
            ($key => $value);
        }
        @{ACCESSORS()}
    };
}

sub to_db_object {
    my $self = shift;
    return +{
        map { $_ => $self->$_ } grep { $_ ne 'developers' } @{ACCESSORS()}
    };
}

1;
__END__
