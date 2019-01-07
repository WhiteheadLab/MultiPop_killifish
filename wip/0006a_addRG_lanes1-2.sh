#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH --mem=16000
#SBATCH -o /home/jajpark/niehs/slurm-log/addrga-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/addrga-stderr-%j.txt
#SBATCH -J addrga
#SBATCH  -p high 
#SBATCH  -t 24:00:00 
## Modified 29 November, 2016, JP

module load java
module load picardtools

DIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/lanes_1-2
mergdir=~/niehs/results/alignments/star_heteroclitus_annot_161116/withRG
cd $DIR


for file in `ls *L005*Aligned.out.bam`
do
	#Relabel lane numbers from L005,L006 to L007, L008
	newfile1="$(echo ${file} | sed -e 's/L005/L007/')" 
	
	#Define @RG fields
	name=`echo $file | cut -c 5-13`
	echo $name
	lane=`echo $newfile1 | cut -f 3 -d "_"`
	echo $lane
	rgid="${name}_$lane"
	echo $rgid
	out="${mergdir}/$newfile1"
	echo $out
	
	java -jar $PICARD/picard.jar AddOrReplaceReadGroups \
		I=$file \
		O=$out \
		RGID=$rgid \
		RGLB=$lane \
		RGPL=illumina \
		RGPU=x \
		RGSM=$name \
		
done


for file in `ls *L006*Aligned.out.bam`
do
	#Relabel lane numbers from L005,L006 to L007, L008
	newfile2="$(echo ${file} | sed -e 's/L006/L008/')" 
	
	#Define @RG fields
	name=`echo $file | cut -c 5-13`
	echo $name
	lane=`echo $newfile2 | cut -f 3 -d "_"`
	echo $lane
	rgid="${name}_$lane"
	echo $rgid
	out="${mergdir}/$newfile2"
	echo $out
	
	java -jar $PICARD/picard.jar AddOrReplaceReadGroups \
		I=$file \
		O=$out \
		RGID=$rgid \
		RGLB=$lane \
		RGPL=illumina \
		RGPU=x \
		RGSM=$name \
		
done

