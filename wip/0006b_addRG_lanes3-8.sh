#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH --mem=16000
#SBATCH -o /home/jajpark/niehs/slurm-log/addrgb-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/addrgb-stderr-%j.txt
#SBATCH -J addrgb
#SBATCH  -p high 
#SBATCH  -t 24:00:00 
## Modified 29 November, 2016, JP

module load java
module load picardtools

DIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/lanes_3-8
mergdir=~/niehs/results/alignments/star_heteroclitus_annot_161116/withRG
cd $DIR

for file in `ls *L004*Aligned.out.bam`
do
	# base=$(basename $file .bam)
# 	echo $base
	
	#Define @RG fields
	name=`echo $file | cut -c 5-13`
	echo $name
	lane=`echo $file | cut -f 3 -d "_"`
	echo $lane
	rgid="${name}_$lane"
	echo $rgid
	outfile="${mergdir}/$file"
	echo $outfile

	
	java -jar $PICARD/picard.jar AddOrReplaceReadGroups \
		I=$file \
		O=$outfile \
		RGID=$rgid \
		RGLB=$lane \
		RGPL=illumina \
		RGPU=x \
		RGSM=$name \
		
done
