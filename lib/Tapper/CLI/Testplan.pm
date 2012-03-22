package Tapper::CLI::Testplan;

use 5.010;
use warnings;
use strict;

use Tapper::Testplan::Reporter;

=head1 NAME

Tapper::CLI::Testplan - Tapper - testplan related commands for the tapper CLI

=head1 SYNOPSIS

This module is part of the Tapper::CLI framework. It is supposed to be
used together with App::Rad. All following functions expect their
arguments as $c->options->{$arg}.

    use App::Rad;
    use Tapper::CLI::Testplan;
    Tapper::CLI::Testplan::setup($c);
    App::Rad->run();

=head1 FUNCTIONS

=head2 testplansend

Send testplan reports to Taskjuggler. If optional names are given only tasks
that match at least one such name are reported.

@optparam name  - full subtask path (bot dot and slash are allowed as separatot)
@optparam quiet - stay silent when testplan was sent
@optparam help  - print out help message and die

=cut

sub testplansend
{
        my ($c) = @_;
        $c->getopt( 'name|n=s@','quiet|q', 'help|?' );

        if ( $c->options->{help} ) {
                say STDERR "Usage: $0 testplan-send [ --name=path ]*  [ --quiet ]";
                say STDERR "\n  Optional arguments:";
                say STDERR "\t--name\t\tPath name to request only this task to be reported. Slash(/) or dot(.) are allowed as seperators. Can be given multiple times.";
                say STDERR "\t--quiet\tStay silent when testplan was sent";
                say STDERR "\t--help\t\tPrint this help message and exit";
                exit -1;
        }


        my @names;
        if ($c->options->{name}) {
                @names = map {  tr|.|/|; {path => $_} } @{$c->options->{name}}; ## no critic
        }

        my $reporter = Tapper::Testplan::Reporter->new();
        $reporter->run(@names);
        return "Sending testplan finished" unless $c->options->{quiet};
        return;
}



=head2 setup

Initialize the testplan functions for tapper CLI

=cut

sub setup
{
        my ($c) = @_;
        $c->register('testplan-send', \&testplansend, 'Send testplan reports');
        return;
}

=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>

=head1 BUGS


=head1 COPYRIGHT & LICENSE

Copyright 2008-2011 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd


=cut

1; # End of Tapper::CLI
