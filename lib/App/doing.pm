use strict;
use warnings;
package App::doing;
use	File::Copy;
use DateTime;

# ABSTRACT: Keep track of what you were doing in a folder!

=head2 add

Adds a new entry to the CURRENTLY_DOING file

=cut

sub add {
	my ($c,$message,$options) = @_;
	if (defined($message)){
		_new_entry('.doing.log',$message);
	}
	else {
		_new_entry('.doing.log');
		system('vim','.doing.log');
	}
	return;
}

sub _new_entry {
	my ($file,$message) = @_;
	use DateTime;
	my $dt = DateTime->now;
	if(defined($message)){
		$message =~ s/^(?!\t)/\t/gm;
		_push_file($file,"$dt\n$message\n");
	}
	else {
		_push_file($file,"$dt\n");
	}
}

sub _push_file {
	my ($file,$message,$options) = @_;
	copy($file,"$file.old") if -f $file;
	open my $out, '>', $file;
	print $out "$message\n";

	if (-f "$file.old"){
		open my $in,  '<', "$file.old";
		while(<$in>){
			print $out $_;
		}
		close $in;
		unlink ("$file.old");
	}

	close $out;
}

1;
