#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/bamindex-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/bamindex-stderr-%j.txt
#SBATCH -J bai
#SBATCH --mem=16000
#SBATCH -p high
#SBATCH -t 24:00:00 
## Modified 15 November, 2016, JP


set -e
set -u

module load samtools

DIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/merge
cd $DIR

for sample in `ls *.bam` 
do

	samtools sort -o $sample $sample 
	samtools index -b $sample
	
done

