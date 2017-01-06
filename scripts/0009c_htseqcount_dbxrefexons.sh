#!/bin/bash -l
#SBATCH --array=1-174%40
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/arrayhtseq-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/arrayhtseq-stderr-%A-%a.txt
#SBATCH -J array_htseqcount
#SBATCH --mem=16000
#SBATCH --cpus-per-task=6
#SBATCH -p med
#SBATCH -t 24:00:00 
## Modified 21 December, 2016, JP

set -e
set -u

module load python
module load HTSeq

DIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/merge
### OUTDIR1=~/niehs/results/htseqcount/genes
OUTDIR2=~/niehs/results/htseqcount/exons_by_dbxref
cd $DIR

gff=~/niehs/refseq/170104_fhet_genomic.gff 
f=$(find $DIR -name "*.bam" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
base=$(basename $f .bam)
count=${base}_htseq.count

echo $f
echo $base
echo $count

### htseq-count --format=bam -i Dbxref -t gene $f $gff > ${OUTDIR1}/$count
htseq-count --format=bam -i Dbxref -t exon $f $gff > ${OUTDIR2}/$count

