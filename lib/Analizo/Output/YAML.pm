package Analizo::Output::YAML;
use YAML;

use base qw( Analizo::Output );

sub push {
}

sub report {
  my ($self, @output) = @_;
  return Dump(@output);
}

sub write_data {
}

1;
