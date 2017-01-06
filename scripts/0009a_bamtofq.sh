#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/bamtofq-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/bamtofq-stderr-%j.txt
#SBATCH -J bamtofq
#SBATCH --mem=16000
#SBATCH -p high
#SBATCH -t 24:00:00 
## Modified 15 December, 2016, JP

set -e
set -u

module load samtools
module load bedtools

DIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/merge
OUTDIR=~/niehs/results/countsalmon/mergetofq
cd $DIR

for sample in `ls *.bam` 
do
	base=$(basename $sample .bam)
	echo $base
	
	qsort=${base}.qsort.bam
	
	samtools sort -o $qsort -n $sample
	bedtools bamtofastq -i $qsort\
						-fq ${OUTDIR}/${base}.end1.fq \
						-fq2 ${OUTDIR}/${base}.end2.fq
	
done