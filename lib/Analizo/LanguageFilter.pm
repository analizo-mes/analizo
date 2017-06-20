package Analizo::LanguageFilter;

use strict;
use warnings;
use Carp;

use base qw(Analizo::FilenameFilter);

our $DEFAULT_FILTER = 'all';

our $FILTERS = {
  c         => 'c|h',
  cpp       => 'cpp|cxx|cc|h|hh|hpp',
  java      => 'java',
};
$FILTERS->{$DEFAULT_FILTER} = join('|', values(%$FILTERS));

sub new {
  my ($package, $filter_type) = @_;
  $filter_type ||= $DEFAULT_FILTER;
  my $regex = _generate_regex($filter_type);
  my $self = {
    regex => _standardize_regex($regex),
  };
  return bless $self, $package;
}

sub _generate_regex {
  my ($filter_type) = @_;
  my $regex = $FILTERS->{$filter_type};

  if (!defined($regex)) {
    croak "E: Unknown language filter $filter_type";
  }
  return $regex;
}

sub _standardize_regex {
  my ($regex) = @_;
  return '\.(' . $regex . '|' . uc($regex) . ')$';
}

sub list {
  my ($self) = @_;
  sort keys %$FILTERS;
}

1;
