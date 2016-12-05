#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/samtobam-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/samtobam-stderr-%j.txt
#SBATCH -J samtobam
#SBATCH --mem=16000
#SBATCH -p high
#SBATCH -t 24:00:00 
## Modified 15 November, 2016, JP


set -e
set -u

module load samtools

DIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/lanes_3-8
cd $DIR

for sample in `ls 017*Aligned.out.sam` 
do
	
	base=$(basename $sample .sam)
	echo $base

	echo `samtools view -bS -u $sample | samtools sort --output-fmt BAM  -o $DIR/$base.bam`
	
##	samtools view -bS -u  0001ARSC32191_S1_L005Aligned.out.sam  | samtools sort --output-fmt BAM  -o  0001ARSC32191_S1_L005_sorted.bam

done

#echo `samtools index *sorted.bam`