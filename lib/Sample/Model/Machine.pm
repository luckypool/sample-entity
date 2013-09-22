package Sample::Model::Machine;
use common::sense;

use parent qw/Sample::Model::Base/;

use Params::Validate qw//;
use Sample::Types qw/
    TYPE_INTEGER
    TYPE_MACHINE
/;

sub validate_primary_key {
    my $self = shift;
    return Params::Validate::validate_pos(@_, {
        id => TYPE_INTEGER,
    });
}

sub validate_create_params {
    my $self = shift;
    my $entity = Params::Validate::validate_pos(@_, TYPE_MACHINE);
    return $entity->to_db_object;
}

sub validate_update_params {
    my $self = shift;
    my $entity = Params::Validate::validate_pos(@_, TYPE_MACHINE);
    return $entity->to_db_object;
}

1;
__END__
