package Sample::Types;
use common::sense;

use Email::Valid;
use Exporter qw/import/;
use Data::Util qw/
    is_integer
    is_string
    is_array_ref
    is_instance
/;
use Params::Validate qw/
    SCALAR
    ARRAYREF
    OBJECT
    validate_pos
/;
use Time::Stamp
    parselocal => { -as => 'parsestamp' },
    localstamp => { format => 'easy'    };
use URI;

my $constants;
BEGIN {
    my $primitives = {
        TYPE_INTEGER => {
            type      => SCALAR,
            callbacks => {
                'is integer' => sub { is_integer(shift); },
            },
        },
        TYPE_STRING => {
            type      => SCALAR,
            callbacks => {
                'is string' => sub { is_string(shift); },
            },
        },
        TYPE_EMAIL => {
            type      => SCALAR,
            callbacks => {
                'is email' => sub {
                    my $target = shift;
                    return unless is_string($target);
                    my $is_valid_email = Email::Valid->address($target);
                    return unless $is_valid_email;
                    return 1;
                },
            },
        },
        TYPE_TIMESTAMP => {
            type      => SCALAR,
            callbacks => {
                'is timestamp' => sub {
                    my $target = shift;
                    return unless is_string($target);
                    my $time  = eval { parsestamp($target) };
                    return unless $time;
                    my $is_valid = localstamp($time) eq $target;
                    return unless $is_valid;
                    return 1;
                },
            },
            default => localstamp(),
        },
        TYPE_URL => {
            type      => SCALAR,
            callbacks => {
                'is url' => sub {
                    my $target = shift;
                    return unless is_string($target);
                    my $uri = eval { URI->new($target) };
                    return if $@;
                    return unless $uri;
                    return unless $uri->scheme =~ qr/(http|https)/;
                    return 1;
                },
            },
        },
        TYPE_DEVELOPER => {
            type      => OBJECT,
            callbacks => {
                'is developer' => sub {
                    my $target = shift;
                    return unless is_instance($target, 'Sample::Entity::Developer');
                    return 1;
                },
            },
        },
        TYPE_MACHINE => {
            type      => OBJECT,
            callbacks => {
                'is machine' => sub {
                    my $target = shift;
                    return unless is_instance($target, 'Sample::Entity::Machine');
                    return 1;
                },
            },
        },
    };

    my $primitive_array_callback = sub {
        my $primitive_type = shift;
        return +{
            'is primitive array' => sub {
                my $target = shift;
                return unless is_array_ref($target);
                foreach my $element ( @$target ){
                    my @params = ($element);
                    eval { validate_pos(@params, $primitive_type) };
                    return if $@;
                }
                return 1;
            },
        };
    };

    my $primitive_array_types = {
        TYPE_DEVELOPERS => {
            type      => ARRAYREF,
            callbacks => $primitive_array_callback->($primitives->{TYPE_DEVELOPER}),
            optional  => 1,
        },
        TYPE_MACHINES => {
            type      => ARRAYREF,
            callbacks => $primitive_array_callback->($primitives->{TYPE_MACHINE}),
            optional  => 1,
        },
    };

    $constants = {
        %$primitives,
        %$primitive_array_types,
    };
}

use constant $constants;
our @EXPORT_OK = keys %$constants;

1;
__END__
