package Sample::DB::Handler::Practice;
use common::sense;

use parent qw/Sample::DB::Handler::Base/;

use Sample::DB::Config qw/DB_PRACTICE/;
use Sample::DB::Schema::Practice;

sub get_handler {
    my ($self, $user, $model) = @_;
    my $db_hander = eval {
        $model->connect_info({
            dsn => DB_PRACTICE,
            username => $user,
            connect_options => {
                mysql_enable_utf8 => 1,
            }
        });
        $model->dbh;
    };
    die $@ if $@;
    return $db_hander;
}

1;
__END__
