package Analizo::Output::YAML;
use YAML;

use base qw( Analizo::Output );

sub push {
  my ($self, $job) = @_;
    $self->{jobs} ||= [];
    push @{$self->{jobs}}, $job;
}

sub report {
  my ($self, @output) = @_;
  return Dump(@output);
}

sub write_data {
  my ($self, $fh) = @_;
  my @fields = ();
  my $yml = {};
  for my $job (@{$self->{jobs}}) {
    my ($summary, $details) = $job->metrics->data();
    $yml->{$job->id} = $summary;

		# Print on specific file
		my $file_detail = $job->id. "-details.yml";
		my $yml_details = Dump({$job->id => $details});
		open my $fc, '>'.$file_detail  || die "Cannot open ".$job->id."-details.yml\n".$!;
		print $fc $yml_details;
		close ($fc);
	}
	my $line = Dump($yml) ;
	print {$fh} $line;
}

1;
