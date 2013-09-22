package Sample::Entity::Developer;
use common::sense;
use parent qw/Class::Accessor::Fast/;

use Sample::Types qw/
    TYPE_INTEGER
    TYPE_STRING
    TYPE_EMAIL
    TYPE_MACHINES
    TYPE_TIMESTAMP
/;

use constant ACCESSORS => [qw/
    id
    name
    company
    email
    machines
    created_at
    updated_at
/];

__PACKAGE__->mk_accessors(@{ACCESSORS()});

sub new {
    my $class = shift;
    my %args  = Params::Validate::validate(@_, {
        id         => TYPE_INTEGER,
        name       => TYPE_STRING,
        company    => TYPE_STRING,
        email      => TYPE_EMAIL,
        machines   => TYPE_MACHINES,
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
            my $value = $key eq 'machines'
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
        map { $_ => $self->$_ } grep { $_ ne 'machines' } @{ACCESSORS()}
    };
}

1;
__END__
