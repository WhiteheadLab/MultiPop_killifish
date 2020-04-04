#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/191216-index-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/191216-index-stderr-%j.txt
#SBATCH -J index
#SBATCH -p high
#SBATCH -t 24:00:00 

module load samtools


DIR=~/niehs/Data/mergedalignments	
cd $DIR

# f=$(find $DIR -name "*.bam" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
# #name=$(echo $f | cut -d "/" -f 7 | cut -d "." -f 1)
# 
# echo "Processing sample $f"

samtools index VBC_10_35_1.bam
samtools index 0037ARSC00282_dedup.bam 
samtools index GTC_00_35_4.bam
samtools index GTC_32_35_1.bam
samtools index GTE_56_19_3.bam