package OneLinerLib;

use Exporter;
use utf8;

@ISA = qw(Exporter);
@EXPORT = qw(p);

sub p {
    print @_;
}
1;
__END__
