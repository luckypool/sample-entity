package Sample::Model::Base;
use common::sense;

use parent qw/Class::Accessor::Fast/;

use Carp qw/croak/;
use Params::Validate qw//;
use UNIVERSAL::require;
use DBIx::Skinny;

__PACKAGE__->mk_accessors(qw/master slave table/);

sub new {
    my ($class, $args) = @_;
    croak 'table is undefined'   unless defined $args->{table};
    croak 'handler is undefined' unless defined $args->{handler};
    my $handler = $args->{handler};
    $handler->require or croak "cannot use $handler";
    my $params = {
        table  => $args->{table},
        master => $handler->new(role=>'m',model=>$class)->handler,
        slave  => $handler->new(role=>'s',model=>$class)->handler,
    };
    return $class->SUPER::new($params);
}

sub validate_primary_key   { croak 'override me!' }
sub validate_create_params { croak 'override me!' }
sub validate_update_params { croak 'override me!' }

sub create {
    my $self = shift;
    my $params = $self->validate_create_params(@_);
    return $self->master->create($self->table, $params)->get_columns;
}

sub replace {
    my $self = shift;
    my $params = $self->validate_create_params(@_);
    return $self->master->replace($self->table, $params)->get_columns;
}

sub select_by_primary_key {
    my $self = shift;
    my $params = $self->validate_primary_key(@_);
    my $row = $self->slave->search($self->table, $params)->first;
    return unless $row;
    return $row->get_columns;
}

sub update {
    my $self = shift;
    my $params = $self->validate_update_params(@_);
    return $self->master->update(
        $self->table,
        $params,
        { id => $params->{id} },
    );
}

sub delete_by_primary_key {
    my $self = shift;
    my $params = $self->validate_primary_key(@_);
    return $self->master->delete($self->table, $params);
}

1;
