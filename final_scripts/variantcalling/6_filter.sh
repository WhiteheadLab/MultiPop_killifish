#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/200224-filt-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/200224-filt-stderr-%A-%a.txt
#SBATCH -J filter
#SBATCH -p high
#SBATCH -t 24:00:00 

DIR=~/niehs/Data/variantcalling
OUT=~/niehs/Data/filtered_vcfs

module load bio3

cd $DIR

vcffilter -f "QUAL > 30" fgrandis.all.vcf  > $OUT/filtered.fgrandis.all.vcf

