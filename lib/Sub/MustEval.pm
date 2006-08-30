########################################################################
# check for eval on stack at runtime.
########################################################################

########################################################################
# housekeeping
########################################################################

package Sub::MustEval;

use strict;

use Carp;
use Symbol;

use version;

our $VERSION = qv( '0.0.1' );

use Attribute::Handlers;

########################################################################
# package variables
########################################################################

# max stack depth possible in Perl. this is the upper limit for
# caller $x to check for an "(eval" on the stack.

########################################################################
# public sub's
########################################################################

########################################################################
# wrap the attributed sub so that it checks the current stack for an
# eval or dies.
#
# undef &$ref avoids redefinied sub warnings by wiping out the original
# before installing the wrapper. with Symbol this allows warnings to
# be left on throughout the code.

sub UNIVERSAL::MustEval :ATTR(CODE)
{
  my ( undef, $install, $wrapped ) = @_;

  my $name  = join '::', *{$install}{PACKAGE}, *{$install}{NAME}; 

  *{ $install }
  = sub
  {
    my $i = -1;

    while( my @caller = caller ++$i )
    {
      goto &$wrapped
      if $caller[3] =~ m{ ^ \( eval \b }x;
    }

    confess qq{Fatal: '$name' called outside of any eval};
  };
}

# keep require happy

1

__END__

=head1 NAME

Sub::MustEval - Force execution in an eval, prevents 
subroutines from throwing uncaught exceptions.

=head1 VERSION

This document describes Sub::MustEval version 0.0.1

=head1 SYNOPSIS

    use Sub::MustEval;

    # this dies at runtime if it is not in an block eval.

    sub foo :MustEval
    {
       ...
    }


    # a bare call to foo() in the main code will fail with 
    # a stack trace.

    foo();

    # this works, however, since foo can find that
    # bletch was called from within an eval.

    eval { bletch() };

    sub bletch { bar() }

    sub bar { foo() }

    # nested eval's work also since the code checks for
    # an eval anywhere on the stack.

    eval { bletch() };

    sub bletch { bar() }

    sub bar { foo() }


=head1 DESCRIPTION

Subroutines that are marked with the MustEval attribute 
immediately throw an exception if they're called anywhere 
that an exception would not be caught by an C<eval>.

Note that this inludes anything that dies for any reason
even if the death is not intended as an OO 'exception'.
This can be helpful for long-lived processes that need to
ensure survival. It can also be handy for subs that call
modules which use Fatal: all of the fatalities can be
guaranteed to be gracefully handled.

=head1 INTERFACE

Use the module adn add the C<:MustEval> attribute to a 
subroutine:

    use Sub::MustEval;

    sub foo :MustEval { ...}


=head1 DIAGNOSTICS

=over 4

=item C<< Fatal: '$orig' called outside of any eval >>

An C<:MustEval> subroutine was called from a context 
where exceptions would not be caught bu any surrounding 
C<eval>. This uses confess() to 

=back

=head1 CONFIGURATION AND ENVIRONMENT

Sub::MustEval requires no configuration files or environment
variables.


=head1 DEPENDENCIES

  strict

  Carp

  Symbol

  version

  Attribute::Handlers 


=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-sub-MustEval@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHORS

Steven Lembark <lembark@wrkhors.com>
Damian Conway


=head1 LICENCE AND COPYRIGHT

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES. 
