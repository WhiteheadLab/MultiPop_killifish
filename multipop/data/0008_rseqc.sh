#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH --mem=16000
#SBATCH -o /home/jajpark/niehs/slurm-log/008-metrics-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/008-metrics-stderr-%j.txt
#SBATCH -J metrics
#SBATCH  -p high 
#SBATCH  -t 24:00:00 
## Modified 14 December 2016, JP

module load java
module load picardtools

DIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/withRG
cd $DIR



java -jar $PICARD/picard.jar CollectRnaSeqMetrics \
      I=input.bam \
      O=output.RNA_Metrics \
      REF_FLAT=rGCF_000826765.1_Fundulus_heteroclitus-3.0.2_feature_table.txt.gz \
      STRAND=SECOND_READ_TRANSCRIPTION_STRAND \
      RIBOSOMAL_INTERVALS=ribosomal.interval_list
      
      GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.gbff.gz