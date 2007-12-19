use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WWW::Reddit',
    AUTHOR              => 'Andrew Moore <amoore@cpan.org>',
    VERSION_FROM        => 'lib/WWW/Reddit.pm',
    ABSTRACT_FROM       => 'lib/WWW/Reddit.pm',
    PL_FILES            => {},
    PREREQ_PM => {
                  'Test::More'        => 0,
                  'Object::InsideOut' => 0,
                  'WWW::Mechanize'    => 0,
              },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WWW-Reddit-*' },
);
