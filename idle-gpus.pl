#! /usr/bin/env perl
#
# Specify idle GPUs
# This version does not use standard XML parsers 
#  such as XML::Simple because some hosts do not have the libraries.
#
# Written by kenji.imamura@nict.go.jp
#

use strict;
use Getopt::Long;
use FileHandle;

my($num_gpus) = 0;

#
# Usage
#

sub usage () {
    print STDERR "Specify idle GPUs.\n";
    print STDERR "Usage: $0 [options]\n";
    print STDERR " -n,--num=INT   the number of GPUs to use
                (default:0 -> list all idle GPUs)\n";
    print STDERR " -h,--help      print this message\n";
    exit 0;
}

#
# Execute the "nvidia-smi" command and get the result.
#

sub exec_nvidia_command () {
    my($ret) = system("which nvidia-smi > /dev/null 2>&1");
    if ($ret > 0) {
	print STDERR "nvidia-smi is not installed.\n";
	exit $ret;
    }
    open(IN, "nvidia-smi -q -x |") 
	or die "nvidia-smi command exec error: $!";
    my(@lines) = <IN>;
    close(IN);
    return(join('', @lines));
}

#
# Parse the result of nvidia-smi 
#  and extract GPUs that any process is running.
#

sub parse_xml ($$) {
    my($xml, $tagname) = @_;
    if ($xml =~ /<$tagname(\s[^>]+?>|>)/m) {
	my($prefix, $tag, $rest) = ($`, $&, $');
	if ($rest =~ /<\/$tagname>/m) {
	    my($body, $suffix) = ($`, $');
	    return($tag, $body, $prefix, $suffix);
	}
	else {
	    print STDERR "Invalid XML: $tag\n";
	    exit 1;
	}
    }
    else {
	return(undef, undef, $xml, "");
    }
}

sub extract_idle_gpus ($) {
    my($xml) = @_;
    my(@idle_gpus) = ();
    my($gpu_id) = 0;
    while (1) {
	my($gpu_tag, $gpu_body, $prefix, $suffix)
	    = &parse_xml($xml, "gpu");
	if (not defined($gpu_tag)) { last; }
	my($proc_tag, $proc_body)
	    = &parse_xml($gpu_body, "processes");
	if (not defined($proc_tag)) {
	    print STDERR "<processes> is not found.\n";
	    exit 1;
	}

	if ($proc_body !~ /<process_info>/m) {
	    push @idle_gpus, $gpu_id;
	}
	$xml = $suffix;
	$gpu_id ++;
    }
    return(@idle_gpus);
}

############################################################
#
# Main
#

my($help) = 0;
my($machines) = undef;
my($result);
$result = GetOptions("num=i"  => \$num_gpus,
		     "help"   => \$help);

if (! $result) { usage; exit 1; }
elsif ($help)  { usage; exit 0; }

my($xml) = &exec_nvidia_command;
my(@gpu_ids) = &extract_idle_gpus($xml);

if ($num_gpus > 0) {
    if (scalar(@gpu_ids) < $num_gpus) {
	print STDERR 
	    "The number of idle GPUs is less than the number you require.\n";
	exit 1;
    }
    elsif (scalar(@gpu_ids) > $num_gpus) {
	@gpu_ids = @gpu_ids[0..$num_gpus-1];
    }
}
print join(",", @gpu_ids), "\n";

