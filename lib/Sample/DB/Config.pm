package Sample::DB::Config;
use common::sense;

use Exporter qw/import/;

my %constants;
BEGIN {
    %constants = (
        DB_PRACTICE => 'DBI:mysql:practice',
    );
}

use constant \%constants;
our @EXPORT_OK = keys %constants;

1;
__END__
