package Sample::DB::Schema::Practice;
use common::sense;

use DateTime;
use DateTime::Format::Strptime;
use DateTime::Format::MySQL;
use DBIx::Skinny::Schema;

sub pre_insert_hook {
    my ($class, $args) = @_;
    $args->{created_at} = DateTime->now( time_zone => 'Asia/Tokyo' );
}

sub pre_update_hook {
    my ($class, $args) = @_;
    $args->{updated_at} = DateTime->now( time_zone => 'Asia/Tokyo' );
}

install_inflate_rule '^.+_at$' => callback {
    inflate {
        my $value = shift;
        my $dt = DateTime::Format::Strptime->new(
            pattern => '%Y-%m-%d %H:%M:%S',
            time_zone => container('timezone'),
        )->parse_datetime($value);
        return DateTime->from_object( object => $dt );
    };
    deflate {
        my $value = shift;
        return DateTime::Format::MySQL->format_datetime($value);
    };
};

install_table machine => schema {
    pk 'id';
    columns qw/id owner os created_at updated_at/;
    trigger pre_insert => \&pre_insert_hook;
    trigger pre_update => \&pre_update_hook;
};

install_table developer => schema {
    pk 'id';
    columns qw/id name company email created_at updated_at/;
    trigger pre_insert => \&pre_insert_hook;
    trigger pre_update => \&pre_update_hook;
};

install_table company => schema {
    pk 'id';
    columns qw/id name url created_at updated_at/;
    trigger pre_insert => \&pre_insert_hook;
    trigger pre_update => \&pre_update_hook;
};

install_utf8_columns qw/owner name/;

1;
__END__
