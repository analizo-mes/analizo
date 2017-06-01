package Analizo::Output::JSON;
use JSON;

use base qw( Analizo::Output );

sub push {
  my ($self, $job) = @_;
    $self->{jobs} ||= [];
    push @{$self->{jobs}}, $job;
}

sub report {
  my ($self, @output) = @_;
  return to_json((\@output), {utf8 => 1, pretty => 1, space_before => 0});
}

# This method encode the received data used in metrics-batch in json,
# same as write_data in csv, but the json doesn`t need to write the details of
# which folder it`s analysing at the folder directory.

sub write_data {
  my ($self, $fh) = @_;
  my @fields = ();
  my %json = ();
  for my $job (@{$self->{jobs}}) {
    my ($summary, $details) = $job->metrics->data();
    $json{$job->id} = $summary;

		# Print on specific file
		my $file_detail = $job->id. "-details.json";
		my $json_details = to_json({$job->id => $details}, {utf8 => 1, pretty => 1, space_before => 0});
		open my $fc, '>'.$file_detail  || die "Cannot open ".$job->id."-details.json\n".$!;
		print $fc $json_details;
		close ($fc);
	}
	my $line = to_json(\%json, {utf8 => 1, pretty => 1, space_before => 0});
	print {$fh} $line;
}

1;
