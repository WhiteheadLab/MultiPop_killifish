#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH --mem=16000
#SBATCH -o /home/jajpark/niehs/slurm-log/merge-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/merge-stderr-%j.txt
#SBATCH -J merge
#SBATCH  -p high 
#SBATCH  -t 24:00:00 
## Modified 29 November, 2016, JP

module load samtools

DIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/withRG
OUTDIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/merge
cd $DIR

for file in `ls 0001*.bam | head -1`
do
	num=`echo $file | cut -c 1-4`
	echo $num
	ls -1 $num* > list
	cat list
	
	outn=`echo $file | cut -f 1 -d "_"`
	out="${OUTDIR}/$outn.bam"
	echo $out

	samtools merge -f -b list $out
	
done
	
	