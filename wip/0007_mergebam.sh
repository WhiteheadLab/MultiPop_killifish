#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH --mem=16000
#SBATCH -o /home/jajpark/niehs/slurm-log/merge-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/merge-stderr-%j.txt
#SBATCH -J merge
#SBATCH  -p high 
#SBATCH  -t 24:00:00 
## Modified 5 December, 2016, JP

module load samtools

DIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/withRG
OUTDIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/merge
cd $DIR


for file in `ls *.bam`
do
	name=`echo $file | cut -f 1 -d "_"`	
	echo $name
done > names.txt

cat names.txt | uniq > uniqnames.txt

for f in `cat uniqnames.txt`
do 
	ls -1 $f*.bam > list
	cat list
	out="${OUTDIR}/$f.bam"
	echo $out
	
	samtools merge -f -b list $out
done
	

