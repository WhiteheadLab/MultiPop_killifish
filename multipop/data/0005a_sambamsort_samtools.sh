#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH --mem=16000
#SBATCH -o /home/jajpark/niehs/slurm-log/samtobam-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/samtobam-stderr-%j.txt
#SBATCH -J samtobam
## Modified 15 November, 2016, JP

set -e
set -u

module load samtools

DIR="/home/jajpark/niehs/results/alignments/stargen/lanes_1-2/"
cd $DIR

for sample in `ls $DIR/*Aligned.out.sam` 
do
	
	base=$(basename $sample .sam)
	echo $base

	echo `samtools view -bS -u $sample | samtools sort --output-fmt BAM  -o $DIR/$base_sorted.bam`
	
##	samtools view -bS -u  0001ARSC32191_S1_L005Aligned.out.sam  | samtools sort --output-fmt BAM  -o  0001ARSC32191_S1_L005_sorted.bam

done

echo `samtools index *sorted.bam`