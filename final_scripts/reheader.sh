#!/bin/bash -l
#SBATCH --array=1-164%50
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/191211-reheader-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/191211-reheader-stderr-%A-%a.txt
#SBATCH -J reheader
#SBATCH -p high
#SBATCH -t 24:00:00 

module load samtools 

DIR=~/niehs/Data/mergedalignments
cd $DIR

f=$(find $DIR -name "*.bai" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
name=$(echo $f | cut -d "/" -f 7 | cut -d "." -f 1 | cut -d "_" -f 1-4 )

echo "Processing sample ${name}"

samtools view -H $name.bam | sed -e "s/ID:/ID:${name}./" | samtools reheader -P - ${name}.bam > ${name}.rehead.bam