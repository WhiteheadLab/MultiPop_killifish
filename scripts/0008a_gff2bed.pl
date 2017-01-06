#!/usr/bin/perl -w

use strict;
use Bio::Tools::GFF;
use feature qw(say switch);

my $gffio = Bio::Tools::GFF->new(-fh => \*STDIN, -gff_version => 2);
my $feature;

while ($feature = $gffio->next_feature()) {
    # print $gffio->gff_string($feature)."\n";

    # cf. <http://www.sanger.ac.uk/Software/formats/GFF/GFF_Spec.shtml>
    my $seq_id = $feature->seq_id();   
    my $start = $feature->start() - 1;
    my $end = $feature->end();
    my $strand = $feature->strand();
    my @sites = $feature->get_tag_values('Site');

    # translate strand
    given ( $strand ) {
        when ($_ == 1)  { $strand = "+"; }
        when ($_ == -1) { $strand = "-"; }
    }

    # output
    print "$seq_id\t$start\t$end\t$sites[0]\t0.0\t$strand\n";
}
$gffio->close();