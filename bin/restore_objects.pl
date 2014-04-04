#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

die "s3cmd is not installed." if system ("which s3cmd > /dev/null 2>&1");
die "aws is not installed."   if system ("which aws > /dev/null 2>&1");

my $bucket          = "";
my $bucket_path     = "";
my $restore_request = "Days=7";

GetOptions("bucket=s"          => \$bucket,
           "bucket_path=s"     => \$bucket_path,
           "restore_request=s" => \$restore_request,
) or die "\nErorr : cannot get options.\n";

my $s3_path = "s3://${bucket}/${bucket_path}";

for my $row (`s3cmd ls --recursive "${s3_path}"`) {
    if ($row =~ m|$s3_path/(.*)|) {
        my $restore_file = $1;
        `aws s3api --bucket "${bucket}" --key "${bucket_path}/${restore_file}" --restore-request ${restore_request}`;
        print "Request restore object : ${s3_path}/${restore_file}\n";
        sleep 1;
    }
}

1;
