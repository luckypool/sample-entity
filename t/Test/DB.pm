package t::Test::DB;
use common::sense;

use t::Test::mysqld;
use Carp qw/croak/;
use UNIVERSAL::require;
use Data::Util qw/
    install_subroutine
    uninstall_subroutine
/;
use DBIx::Skinny;

sub import {
    my $class = shift;
    my @handlers = @_;
    foreach my $handler (@handlers) {
        $handler->require or croak "cannot use $handler";
        my @namespace = (split /::/, $handler);
        my $db_name = lc pop @namespace;
        # replace to $handler->get_handler with t::Test::mysqld
        uninstall_subroutine($handler, 'get_handler');
        install_subroutine($handler,
            get_handler => sub {
                my ($self, $user, $model) = @_;
                return __initialize_db($db_name, $model);
            },
        );
    }
}

sub __initialize_db {
    my ($db_name, $model) = @_;
    my $db = eval {
        $model->connect_info({
            dsn => t::Test::mysqld->new->mysqld->dsn.';mysql_multi_statements=1',
            connect_options => {
                mysql_enable_utf8 => 1,
            }
        });
        $model->dbh;
    };
    die $@ if $@;
    # $db->debug(1);
    $db->do(__get_db_schema(lc $db_name));
    return $db;
}

sub __get_db_schema {
    my $db_name = shift;
    my $db_schema_file = "./db-schema/$db_name.sql";
    open my $fh, '<', $db_schema_file
        or croak "failed to open file: $!";
    my $schema = do { local $/; <$fh> };
    return $schema =~ s/\n//rg;
}

1;
__END__
