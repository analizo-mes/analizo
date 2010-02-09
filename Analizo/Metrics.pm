package Analizo::Metrics;
use strict;
use base qw(Class::Accessor::Fast);
use List::Compare;
use Graph;
use YAML;

__PACKAGE__->mk_accessors(qw(model report_global_metrics_only));

my %DESCRIPTIONS = (
  acc       => "Afferent Connections per Class (to calculate Coupling Factor - COF)",
  accm      => "Average Cyclomatic Complexity per Method",
  amloc     => "Average Method LOC ",
  anpm      => "Average Number of Parameters per Method",
  cbo       => "Coupling Between Objects",
  dit       => "Depth of Inheritance Tree",
  lcom4     => "Lack of Cohesion of Methods ",
  mmloc     => "Max Method LOC",
  noc       => "Number of Children",
  nom       => "Number of Methods",
  npm       => "Number of Public Methods",
  npv       => "Number of Public Variables",
  rfc       => "Response For a Class",
  tloc      => "Total Lines of Code"
);

sub new {
  my ($package, %args) = @_;
  return bless { model => $args{model} }, $package;
}

sub total_abstract_classes {
  my $self = shift;
  my @total_of_abstract_classes = $self->model->abstract_classes;
  return @total_of_abstract_classes ? scalar(@total_of_abstract_classes) : 0;
}

sub acc {
  my ($self, $module) = @_;

  my @seen_modules = ();
  for my $caller_member (keys(%{$self->model->calls})){
    my $caller_module = $self->model->members->{$caller_member};
    for my $called_member (keys(%{$self->model->calls->{$caller_member}})) {
      my $called_module = $self->model->members->{$called_member};
      if($caller_module ne $called_module && $called_module eq $module){
        if(! grep { $_ eq $caller_module } @seen_modules){
          push @seen_modules, $caller_module;
        }
      }
    }
  }
  return scalar @seen_modules + $self->_recursive_noc($module);
}

sub accm {
  my ($self, $module) = @_;

  my @functions = $self->model->functions($module);
  my $total_of_conditional_paths = 0;
  my $number_of_functions = 0;

  for my $function(@functions) {
    $total_of_conditional_paths += $self->model->{conditional_paths}->{$function};
    $number_of_functions++;
  }

  return ($number_of_functions > 0) ? ($total_of_conditional_paths / $number_of_functions) : 0;
}

sub amloc {
  my ($self, $loc, $count) = @_;
  return ($count > 0) ? ($loc / $count) : 0;
}

sub anpm {
  my ($self, $module) = @_;

  my @functions = $self->model->functions($module);
  my $total_of_parameters = 0;
  my $number_of_functions = 0;

  for my $function (@functions) {
    $total_of_parameters += $self->model->{parameters}->{$function};
    $number_of_functions++;
  }

  return ($number_of_functions > 0) ? ($total_of_parameters / $number_of_functions) : 0;
}

sub cbo {
  my ($self, $module) = @_;
  my %seen = ();
  for my $caller_function ($self->model->functions($module)) {
    for my $called_function (keys(%{$self->model->calls->{$caller_function}})) {
      my $called_module = $self->model->members->{$called_function};
      next if $called_module && ($called_module eq $module);
      $seen{$called_module}++ if $called_module;
    }
  }
  return (scalar keys(%seen));
}

sub dit {
  my ($self, $module) = @_;
  my @parents = $self->model->inheritance($module);
  if (@parents) {
    my @parent_dits = map { $self->dit($_) } @parents;
    my @sorted = reverse(sort(@parent_dits));
    return 1 + $sorted[0];
  } else {
    return 0;
  }
}

sub lcom4 {
  my ($self, $module) = @_;
  my $graph = new Graph;
  my @functions = $self->model->functions($module);
  my @variables = $self->model->variables($module);
  for my $function (@functions) {
    $graph->add_vertex($function);
    for my $used (keys(%{$self->model->calls->{$function}})) {
      # only include in the graph functions and variables that are inside the module.
      if ((grep { $_ eq $used } @functions) || (grep { $_ eq $used } @variables)) {
        $graph->add_edge($function, $used);
      }
    }
  }
  my @components = $graph->weakly_connected_components;
  return scalar @components;
}

sub noc {
  my ($self, $module) = @_;

  my $number_of_children = 0;

  for my $module_name ($self->model->module_names) {
    if (grep {$_ eq $module} $self->model->inheritance($module_name)) {
      $number_of_children++;
    }
  }
  return $number_of_children;
}

sub nom {
  my ($self, $module) = @_;
  my @list = $self->model->functions($module);
  return scalar(@list);
}

sub npm {
  my ($self, $module) = @_;

  my @functions = $self->model->functions($module);
  my $npm = 0;
  for my $function (@functions) {
    $npm += 1 if $self->_is_public($function);
  }
  return $npm;
}

sub npv {
  my ($self, $module) = @_;

  my @variables = $self->model->variables($module);
  my $npv = 0;
  for my $variable (@variables) {
    $npv += 1 if $self->_is_public($variable);
  }
  return $npv;
}

sub rfc {
  my ($self, $module) = @_;

  my @functions = $self->model->functions($module);

  my $rfc = scalar @functions;
  for my $function (@functions){
    $rfc += scalar keys(%{$self->model->calls->{$function}});
  }

  return $rfc;
}

sub tloc {
  my ($self, $module) = @_;

  my @functions = $self->model->functions($module);
  my $tloc = 0;
  my $max = 0;

  for my $function (@functions) {
    my $lines = $self->model->{lines}->{$function} || 0;
    $tloc += $lines;
    $max = $lines if $lines > $max;
  }

  return ($tloc, $max);
}

sub _recursive_noc {
  my ($self, $module) = @_;

  my $number_of_children = 0;

  for my $module_name ($self->model->module_names){
    if (grep {$_ eq $module} $self->model->inheritance($module_name)) {
      $number_of_children += $self->_recursive_noc($module_name) + 1;
    }
  }

  return $number_of_children;
}

sub _is_public {
  my ($self, $member) = @_;
  return $self->model->{protection}->{$member} && $self->model->{protection}->{$member} eq "public";
}

sub _report_module {
  my ($self, $module) = @_;

  my $acc                  = $self->acc($module);
  my $accm                 = $self->accm($module);
  my $anpm                 = $self->anpm($module);
  my $cbo                  = $self->cbo($module);
  my $dit                  = $self->dit($module);
  my $lcom4                = $self->lcom4($module);
  my $noc                  = $self->noc($module);
  my $nom                  = $self->nom($module);
  my $npm                  = $self->npm($module);
  my $npv                  = $self->npv($module);
  my $rfc                  = $self->rfc($module);
  my ($tloc, $mmloc)      = $self->tloc($module);
  my $amloc                = $self->amloc($tloc, $nom);

  my %data = (
    _module              => $module,
    acc                  => $acc,
    accm                 => $accm,
    amloc                => $amloc,
    anpm                 => $anpm,
    cbo                  => $cbo,
    dit                  => $dit,
    lcom4                => $lcom4,
    mmloc                => $mmloc,
    noc                  => $noc,
    nom                  => $nom,
    npm                  => $npm,
    npv                  => $npv,
    rfc                  => $rfc,
    tloc                 => $tloc
  );

  return %data;
}

sub report {
  my $self = shift;
  my $details = '';
  my %totals = (
    anpm      => 0,
    accm      => 0,
    cbo       => 0,
    classes   => 0,
    cof       => 0,
    lcom4     => 0,
    nom       => 0,
    npm       => 0,
    npv       => 0,
    tloc      => 0
  );

  my @module_names = $self->model->module_names;
  if (scalar(@module_names) == 0) {
    return '';
  }

  for my $module (@module_names) {
    my %data = $self->_report_module($module);

    unless ($self->report_global_metrics_only()) {
      $details .= Dump(\%data);
    }

    $totals{'anpm'}    += $data{anpm};
    $totals{'accm'}    += $data{accm};
    $totals{'cbo'}     += $data{cbo};
    $totals{'lcom4'}   += $data{lcom4};
    $totals{'classes'} += 1;
    $totals{'nom'}     += $data{nom};
    $totals{'npm'}     += $data{npm};
    $totals{'tloc'}    += $data{tloc};
    $totals{'cof'}     += $data{acc};
    $totals{'npv'}     += $data{npv};
  }

  my %summary = (
    sum_classes          => $totals{'classes'},
    sum_nom              => $totals{'nom'},
    sum_npm              => $totals{'npm'},
    sum_npv              => $totals{'npv'},
    sum_tloc             => $totals{'tloc'},
    sum_abstract_classes => $self->total_abstract_classes
  );
  if ($totals{classes} > 0) {
    $summary{average_anpm}   = ($totals{'anpm'}) / $totals{'classes'};
    $summary{average_accm}    = ($totals{'accm'}) / $totals{'classes'};
    $summary{average_cbo}    = ($totals{'cbo'}) / $totals{'classes'};
    $summary{average_lcom4}  = ($totals{'lcom4'}) / $totals{'classes'};
  }
  else {
    $summary{average_anpm}   = 0;
    $summary{average_cbo}    = 0;
    $summary{average_lcom4}  = 0;
    $summary{average_accm}   = 0;
  }

  if ($totals{classes} > 1) {
    $summary{cof} = ($totals{'cof'}) / ($totals{'classes'} * ($totals{'classes'} - 1))
  }
  else {
    $summary{cof} = $totals{'cof'};
  }

  return Dump(\%summary) . $details;
}

sub list_of_metrics {
  my $self = shift;
  my %report = $self->_report_module('dummy-module');
  my @names = grep { $_ !~ /^_/ } keys(%report);
  my %list = ();
  for my $name (@names) {
    $list{$name} = $DESCRIPTIONS{$name};
  }
  return %list;
}

1;

