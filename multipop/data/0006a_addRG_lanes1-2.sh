#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH --mem=16000
#SBATCH -o /home/jajpark/niehs/slurm-log/addrg-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/addrg-stderr-%j.txt
#SBATCH -J addrg
## Modified 28 November, 2016, JP

module load picardtools

DIR="/home/jajpark/niehs/results/alignments/star_heteroclitus_annot_161116/lanes_1-2"
cd $DIR

for file in `ls $DIR/*L005*Aligned.out.bam`
do
	#Relabel lane numbers from L005,L006 to L007, L008
	newfile1="$(echo ${FILE} | sed -e 's/L005/L007/')" 
	
	#Define @RG fields
	sample=`echo $file | cut -c 5-13`
	lane=`echo $newfile1 | cut -f 3 -d "_"`
	rgid=${sample}_${lane}
	
	java -jar $PICARD/picard.jar AddOrReplaceReadGroups \
		I=$file \
		O=$file \
		RGID=$rgid \
		RGLB=$lane \
		RGPL=illumina \
		RGPU=x \
		RGSM=$sample \
		
done


for file in `ls $DIR/*L006*Aligned.out.bam`
do
	#Relabel lane numbers from L005,L006 to L007, L008
	newfile2="$(echo ${FILE} | sed -e 's/L006/L008/')" 
	
	#Define @RG fields
	sample=`echo $file | cut -c 5-13`
	lane=`echo $newfile2 | cut -f 3 -d "_"`
	rgid=${sample}_${lane}
	
	java -jar $PICARD/picard.jar AddOrReplaceReadGroups \
		I=$file \
		O=$file \
		RGID=$rgid \
		RGLB=$lane \
		RGPL=illumina \
		RGPU=x \
		RGSM=$sample \
		
done

