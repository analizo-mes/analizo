package Analizo::Output::JSON;
use JSON;

use base qw( Analizo::Output );
use Analizo::Metrics;

sub push {
	my ($self, $job) = @_;
  	$self->{jobs} ||= [];
  	push @{$self->{jobs}}, $job;
}

sub report {
  my ($self, @output) = @_;
  return encode_json(\@output);
}

# This method encode the received data used in metrics-batch in json,
# same as write_data in csv, but the json doesn`t need  to write the details of 
# which folder it`s analysing at the folder directory.

sub write_data {
  my ($self, $fh, $id) = @_;
  my @fields = ();
  my @metadata_fields;
  my $file_name;

  for my $job (@{$self->{jobs}}) {
    my ($summary, $details) = $job->metrics->data();
    my $metadata = $job->metadata;
    my $json_context = to_json($summary, {utf8 => 1, pretty => 1, space_before => 0});

    my $line = join($file_name,$json_context). "\n";
	print $fh $line;
  }

}

1;
