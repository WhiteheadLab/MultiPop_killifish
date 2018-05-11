#!/bin/bash -l
#SBATCH --array=1-174%40
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/arrayfeatc-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/arrayfeatc-stderr-%A-%a.txt
#SBATCH -J array_featcount
#SBATCH --mem=16000
#SBATCH --cpus-per-task=6
#SBATCH -p med
#SBATCH -t 24:00:00 
## Modified 24 February, 2017, JP

set -e
set -u

module load subread

DIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/merge
OUTDIR=~/niehs/results/featurecounts
REFSEQ=~/niehs/refseq/170224_fhet_genomic_4.gff

f=$(find $DIR -name "*.bam" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
base=$(basename $f .bam)
count=${base}_featcount.txt

featureCounts -s 2 -p -t exon -g GeneID -a $REFSEQ -o ${OUTDIR}/$count $f