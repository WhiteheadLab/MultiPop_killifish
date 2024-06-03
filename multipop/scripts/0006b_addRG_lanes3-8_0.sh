#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH --mem=16000
#SBATCH -o /home/jajpark/niehs/slurm-log/addrg2-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/addrg2-stderr-%j.txt
#SBATCH -J addrg2
## Modified 28 November, 2016, JP

module load picardtools

DIR="/home/jajpark/niehs/results/alignments/star_heteroclitus_annot_161116/lanes_3-8"
mergdir="/home/jajpark/niehs/results/alignments/star_heteroclitus_annot_161116/merge"
cd $DIR

for file in `ls *Aligned.out.bam`
do
	base=$(basename $file .bam)
	
	#Define @RG fields
	echo `sample=`echo $file | cut -c 5-13``
	echo `lane=`echo $file | cut -f 3 -d "_"``
	echo `rgid=${sample}_${lane}`
	echo `outfile="$($(mergdir)/${base})"`

	
	# java -jar $PICARD/picard.jar AddOrReplaceReadGroups \
# 		I=$file \
# 		O=$file.rg \
# 		RGID=$rgid \
# 		RGLB=$lane \
# 		RGPL=illumina \
# 		RGPU=x \
# 		RGSM=$sample \
		
done
