#!/bin/bash -l
#SBATCH --array=1-174%50
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/array-compr-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/array-compr-stderr-%A-%a.txt
#SBATCH -J array_comprfq
#SBATCH --mem=16000
#SBATCH --cpus-per-task=6
#SBATCH -p med
#SBATCH -t 24:00:00 
## Modified 2017-01-09, JP

DIR=~/niehs/Data/trimmed_data/mergedfq
cd $DIR
f=$(find $DIR -name "*.fq" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
echo $f
gzip $f