package B::Shared;

use 5.008_001;
#use strict;
#use warnings;

our $VERSION = '0.01';

use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

1;
__END__

=head1 NAME

B::Shared - Debugging utility for the shared string table

=head1 VERSION

This document describes B::Shared version 0.01.

=head1 SYNOPSIS

	use B::Shared;

	B::Shared::dump();

	B::Shared::dump('shared.out');

=head1 DESCRIPTION

B::Shared provides

=head1 DEPENDENCIES

Perl 5.8.1 or later, and a C compiler.

=head1 BUGS

No bugs have been reported.

Please report any bugs or feature requests to the author.

=head1 SEE ALSO

F<sv.c>.

F<hv.c>.

=head1 AUTHOR

Goro Fuji (gfx) E<lt>gfuji(at)cpan.orgE<gt>.

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009, Goro Fuji (gfx). Some rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
