package t::Analizo::Output::JSON;
use strict;
use warnings;
use parent qw(t::Analizo::Test::Class);
use Test::More;
use t::Analizo::Test;

use Analizo::Output::JSON;

sub constructor : Tests {
  isa_ok(new Analizo::Output::JSON, 'Analizo::Output');
  isa_ok(new Analizo::Output::JSON, 'Analizo::Output::JSON');
}

__PACKAGE__->runtests;

1;
