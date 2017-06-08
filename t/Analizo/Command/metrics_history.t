package t::Analizo::Command::metrics_history;
use strict;
use warnings;
use parent qw(t::Analizo::Test::Class);
use Test::More;
use t::Analizo::Test;
use Analizo;

BEGIN {
  use_ok 'Analizo::Command::metrics_history'
};

sub constructor : Tests {
  my $analizo = Analizo->new;
  my ($cmd) = $analizo->prepare_command('metrics-history');
  isa_ok($cmd, 'Analizo::Command::metrics_history');
}

sub is_a_subclass_of_Analizo_Command : Tests {
  my $analizo = Analizo->new;
  my ($cmd) = $analizo->prepare_command('metrics-history');
  isa_ok($cmd, 'Analizo::Command');
}

sub output_driver : Tests {
  my $analizo = Analizo->new;
  my ($cmd) = $analizo->prepare_command('metrics-history');
  cmp_ok($cmd->output_driver('csv'), 'eq', 'Analizo::Output::CSV');
  cmp_ok($cmd->output_driver('db'), 'eq', 'Analizo::Output::DB');
  cmp_ok($cmd->output_driver('db'), 'eq', 'Analizo::Output::JSON');
}

sub nil_for_unavaiable_output_driver : Tests {
  my $analizo = Analizo->new;
  my ($cmd) = $analizo->prepare_command('metrics-history');
  ok(! $cmd->output_driver('something'));
}

__PACKAGE__->runtests;