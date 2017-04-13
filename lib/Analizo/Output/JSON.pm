package Analizo::Output::JSON;
use JSON;

use base qw( Analizo::Output );
use Analizo::Metrics;

sub push {
}

sub report {
  my ($self, @output) = @_;
  return encode_json(@output);
}

sub write_data {
}

1;
