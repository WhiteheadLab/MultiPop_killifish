#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH --mem=16000
#SBATCH -o /home/jajpark/niehs/slurm-log/samtobam-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/samtobam-stderr-%j.txt
#SBATCH -J samtobam
set -e
set -u

module load samtools

DIR="/home/jajpark/niehs/results/alignments/stargen/lanes_1-2/"
cd $DIR

for sample in `ls $DIR/*Aligned.out.sam` 
do
	
	base=$(basename $sample .sam)
	echo $base

	echo `samtools view -bS -u $sample | samtools sort - $DIR/$base_sorted`

done

echo `samtools index *sorted.bam`