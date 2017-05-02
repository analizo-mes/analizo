package t::Analizo::Output::YAML;
use strict;
use warnings;
use parent qw(t::Analizo::Test::Class);
use Test::More;
use t::Analizo::Test;

use Analizo::Output::YAML;

sub constructor : Tests {
  isa_ok(new Analizo::Output::YAML, 'Analizo::Output');
  isa_ok(new Analizo::Output::YAML, 'Analizo::Output::YAML');
}

__PACKAGE__->runtests;

1;
