use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Regexp::Common::IRC',
    AUTHOR              => 'Chris Prather <cpan@prather.org>',
    VERSION_FROM        => 'lib/Regexp/Common/IRC.pm',
    ABSTRACT_FROM       => 'lib/Regexp/Common/IRC.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
	'Regexp::Common' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Regexp-Common-IRC-*' },
);
