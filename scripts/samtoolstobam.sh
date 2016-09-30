#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH --mem=16000
#SBATCH -o /home/jajpark/niehs/slurm-log/samtoolsbam-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/samtoolsbam-stderr-%j.txt
#SBATCH -J samtoolsbam
set -e
set -u

module load samtools

DIR="/home/jajpark/niehs/results/alignments/stargen"
cd $DIR

for sample in `ls $DIR/*Aligned.out.sam` 
do
	
	base=$(basename $sample "Aligned.out.sam")
	echo $base

	echo `samtools view -bS $sample | samtools sort -o $DIR/$base.sorted -O bam`

done

echo `samtools index *sorted.bam`