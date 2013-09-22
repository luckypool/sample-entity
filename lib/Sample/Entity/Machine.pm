package Sample::Entity::Machine;
use common::sense;
use parent qw/Class::Accessor::Fast/;

use Sample::Types qw/
    TYPE_INTEGER
    TYPE_STRING
    TYPE_EMAIL
    TYPE_TIMESTAMP
/;

use constant ACCESSORS => [qw/
    id
    owner
    os
    created_at
    updated_at
/];

__PACKAGE__->mk_accessors(@{ACCESSORS()});

sub new {
    my $class = shift;
    my %args  = Params::Validate::validate(@_, {
        id         => TYPE_INTEGER,
        owner      => TYPE_STRING,
        os         => TYPE_STRING,
        updated_at => TYPE_TIMESTAMP,
        created_at => TYPE_TIMESTAMP,
    });
    return $class->SUPER::new({%args});
}

sub to_plain_object {
    my $self = shift;
    return +{
        map { $_ => $self->$_ } @{ACCESSORS()}
    };
}

sub to_db_object {
    shift->to_plain_object;
}

1;
__END__
