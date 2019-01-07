#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH --mem=16000
#SBATCH -o /home/jajpark/niehs/slurm-log/extn-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/extn-stderr-%j.txt
#SBATCH -J extn
#SBATCH  -p high 
#SBATCH  -t 24:00:00 
## Modified 1 December, 2016, JP

DIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/merge
cd $DIR

for f in `ls *.out`
do

	echo $f
	mv $f ${f}.bam
	
done