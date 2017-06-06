package Analizo::Batch::Runner::Parallel;
use strict;
use warnings;
use ZMQ::FFI qw(ZMQ_PUSH ZMQ_PULL ZMQ_REQ ZMQ_REP);
use YAML;

use base qw( Analizo::Batch::Runner );

sub new {
  my ($class, $parallelism) = @_;
  $parallelism ||= 2;
  $class->SUPER::new(parallelism => $parallelism);
}

sub parallelism {
  my ($self) = @_;
  return $self->{parallelism};
}

sub actually_run {
  my ($self, $batch, $output) = @_;
  $self->start_workers();
  $self->coordinate_workers($batch, $output);
  $self->wait_for_workers();
}

sub _socket_spec {
  my ($name, $ppid) = @_;
  return "ipc:///tmp/.analizo-$name-$ppid";
}

sub start_workers {
  my ($self) = @_;

  $self->{workers} = [];
  my $number_of_workers = $self->parallelism();
  my $parent_pid = $$;

  create_workers($self, $parent_pid, $number_of_workers);

  create_distributor($self, $parent_pid, $number_of_workers);
}

sub create_workers {
  my ($self, $parent_pid, $number_of_workers) = @_;
  for my $i (1..$number_of_workers) {
    my $worker_pid = create_process($self, '[analizo worker]');
    if(!$worker_pid) {
      worker($parent_pid);
      exit();
    }
  }
}

sub create_distributor {
  my ($self, $parent_pid, $number_of_workers) = @_;
  my $distributor_pid = create_process($self, '[analizo queue]');
  if(!$distributor_pid) {
    distributor($parent_pid, $number_of_workers);
    exit();
  }
}

sub create_process {
  my ($self, $message) = @_;

  my $pid = fork();
  if ($pid) {
    # on parent
    push(@{$self->{workers}}, $pid);
  } else {
    # on child
    $0 = $message;
  }
  return $pid;
}

sub wait_for_workers {
  my ($self) = @_;
  for my $pid (@{$self->{workers}}) {
    waitpid($pid, 0);
  }
}

sub coordinate_workers {
  my ($self, $batch, $output) = @_;

  my $context = ZMQ::FFI->new();

  my $queue = $context->socket(ZMQ_PUSH);
  $queue->bind(_socket_spec('queue', $$));

  my $results = $context->socket(ZMQ_PULL);
  $results->bind(_socket_spec('results', $$));

  my $results_expected = enqueue_jobs($batch, $queue);
  
  collect_results($results_expected, $output, $results, $self);
}

sub enqueue_jobs {
  my ($batch, $queue) = @_;
  my $results_expected = 0;
  while (my $job = $batch->next()) {
    $queue->send(Dump($job));
    $results_expected++;
  }
  $queue->send(Dump({}));

  return $results_expected;
}

sub collect_results {
  my ($results_expected, $output, $results, $self) = @_;
  my $results_received = 0;

  while ($results_received < $results_expected) {
    my $msg = $results->recv();
    my $job = Load($msg);
    $output->push($job);
    $results_received++;
    $self->report_progress($job, $results_received, $results_expected);
  }
}

sub distributor {
  my ($parent_pid, $number_of_workers) = @_;
  my $context = ZMQ::FFI->new();

  my $queue = $context->socket(ZMQ_PULL);
  $queue->connect(_socket_spec('queue', $parent_pid));

  my $job_source = $context->socket(ZMQ_REP);
  $job_source->bind(_socket_spec('job_source', $parent_pid));

  my @queue = load_jobs($queue);

  finish_workers($number_of_workers, $job_source, @queue);
 
}

sub finish_workers {
  my ($number_of_workers, $job_source, @queue) = @_;
  my $job;
  my $workers_finished = 0;
  while ($workers_finished < $number_of_workers) {
    $job_source->recv();
    if(scalar(@queue) > 0) {
      $job = shift(@queue);
      $job_source->send(Dump($job));
    } else {
      $job_source->send(Dump({}));
      $workers_finished++;
    }
  }
}

sub load_jobs {
  my ($queue) = @_;
  my @queue;
  my $job;
  while(1) {
    my $msg = $queue->recv();
    $job = Load($msg);
    last if !exists($job->{id});
    push(@queue, $job);
  }
  return @queue;
}

sub process_jobs { 
  my ($source, $results) = @_; 
  my $last_job = undef;
  my $is_job_valid = undef;

  do{

    $source->send('');
    my $msg = $source->recv();
    my $job = Load($msg);

    $is_job_valid = exists($job->{id});

    if($is_job_valid){
      $last_job = $job;
      $job->parallel_prepare();
      $job->execute();
      $results->send(Dump($job));
    }

  } while($is_job_valid);

  if ($last_job) {
    $last_job->parallel_cleanup();
  }
}

sub worker {
  my ($parent_pid) = @_;
  my $context = ZMQ::FFI->new();

  my $source = $context->socket(ZMQ_REQ);
  $source->connect(_socket_spec('job_source', $parent_pid));

  my $results = $context->socket(ZMQ_PUSH);
  $results->connect(_socket_spec('results', $parent_pid));

  process_jobs($source, $results);
}

1;
