#!/bin/bash -l
#SBATCH --array=1-337%50
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/191216-index-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/191216-index-stderr-%A-%a.txt
#SBATCH -J index
#SBATCH -p high
#SBATCH -t 24:00:00 

module load samtools

cd ~/niehs/Data/mergedalignments	
cd $DIR

f=$(find $DIR -name "*.rehead.bam" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
#name=$(echo $f | cut -d "/" -f 7 | cut -d "." -f 1)

echo "Processing sample $f"

samtools index $f