use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Regexp::Common::IRC',
    license             => 'perl',
    dist_author         => 'Chris Prather <cpan@prather.org>',
    dist_version_from   => 'lib/Regexp/Common/IRC.pm',
    requires => {
        'Test::More' => 0,
	'Regexp::Common' => 0,
    },
    add_to_cleanup      => [ 'Regexp-Common-IRC-*' ],
);

$builder->create_build_script();
