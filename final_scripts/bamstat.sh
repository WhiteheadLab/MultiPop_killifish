#!/bin/bash -l
#SBATCH --array=1-317%25
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/191017_bamstats-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/191017-bamstats-stderr-%A-%a.txt
#SBATCH -J bamstats
#SBATCH -p high
#SBATCH -t 24:00:00 

module load bamtools

DIR=~/niehs/Data/aligned
OUT=~/niehs/Data/bamstats

cd $DIR

#set sample 
f=$(find $DIR -name "*.bam" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
name=$(echo $f | cut -d "/" -f 7 | cut -d "." -f 1)
echo "Processing sample ${name}"

outfile=${name}_stat.txt

bamtools stats -in $f > $OUT/$outfile