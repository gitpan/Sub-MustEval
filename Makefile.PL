use ExtUtils::MakeMaker;

WriteMakefile
(

    NAME            => 'Sub::MustEval',
    VERSION         => '0.01',
    ABSTRACT_FROM   => './lib/Sub/MustEval.pm',
    PREREQ_PM =>
    {
        strict              => 0,
        Carp                => 0,
        Symbol              => 0,
        version             => 0,
        Attribute::Handlers => 0.78
    },

);
