package Log::Plugin::Syslog;
use strict;
use warnings;
our $VERSION = '0.01';

use Sys::Syslog;
use Sys::Syslog qw/ :macros setlogsock /;

my %_ident;
my %_facility;
my %_option;

sub import {
    my ($class, %args) = @_;
    my $package = caller;

    $_facility{$package} = exists $args{facility} ? $args{facility} : 'local0';
    $_option{$package}   = exists $args{option}   ? $args{option}   : 'cons,pid';
    $_ident{$package}    = exists $args{ident}    ? $args{ident}    : undef;

    {
        no strict 'refs'; ## no critic
        for my $method (qw( debug info notice warning error crit alert emerg log) ) {
            *{"$package\::$method"}   = \&$method;
        }
    }
}


sub debug {
    my ($self, $message) = @_;
    $self->log(LOG_DEBUG, $message);
}

sub info {
    my ($self, $message) = @_;
    $self->log(LOG_INFO, $message);
}

sub notice {
    my ($self, $message) = @_;
    $self->log(LOG_NOTICE, $message);
}

sub warning {
    my ($self, $message) = @_;
    $self->log(LOG_WARNING, $message);
}

sub error {
    my ($self, $message) = @_;
    $self->log(LOG_ERR, $message);
}

sub crit {
    my ($self, $message) = @_;
    $self->log(LOG_CRIT, $message);
}

sub alert {
    my ($self, $message) = @_;
    $self->log(LOG_ALERT, $message);
}

sub emerg {
    my ($self, $message) = @_;
    $self->log(LOG_EMERG, $message);
}

sub log {
    my ($self, $priority, $message) = @_;
    my $class = ref $self ? ref $self : $self;

    my $ident = $_ident{$class};
    $ident ||= $class;

    openlog($ident, $_option{$class}, $_facility{$class});
    syslog($priority, $message);
    closelog;
}

1;
__END__

=head1 NAME

Log::Plugin::Syslog -

=head1 SYNOPSIS

  package Your::Module;
  use Log::Plugin::Syslog (facility => 'local6', ident 'hoge', option => 'pid');

  sub method {
      my $self = shift;
      $self->debug('debug');
      $self->info('info');
      $self->notice('notice');
      $self->warning('warning');
      $self->error('error');
      $self->crit('critical');
      $self->alert('alert');
      $self->emerg('emergency');
  }

=head1 DESCRIPTION

Log::Plugin::Syslog is

=head1 AUTHOR

SUZUKI Masashi / masasuzu E<lt>m15.suzuki.masahi@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
