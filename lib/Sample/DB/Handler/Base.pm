package Sample::DB::Handler::Base;
use common::sense;

use parent qw/Class::Accessor::Fast/;

use Carp qw/croak/;
use Params::Validate qw/SCALAR/;

__PACKAGE__->mk_accessors(qw/handler/);

use constant TYPE_DB_ROLE => {
    type => Params::Validate::SCALAR,
    regex => qr/^(m|s|master|slave)$/,
};

sub new {
    my $class = shift;
    my $params = Params::Validate::validate(@_, {
        role  => TYPE_DB_ROLE,
        model => SCALAR,
    });
    my $self = {
        handler => $class->get_handler_by_role($params->{role}, $params->{model}),
    };
    return bless $self, $class;
}

sub get_handler_by_role {
    my ($class, $role, $model) = @_;
    my $is_master = $role eq 'm' || $role eq 'master';
    return $class->get_handler('master_user', $model) if $is_master;
    return $class->get_handler('readonly_user', $model);
}

sub get_handler {
    croak 'override me!!';
}

1;
__END__
