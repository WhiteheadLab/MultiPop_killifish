#!/bin/bash -l
#SBATCH --array=1-83%50
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/200106-merge-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/200106-merge-stderr-%A-%a.txt
#SBATCH -J merge
#SBATCH -p high
#SBATCH -t 24:00:00 

module load bamtools 

inbam=~/niehs/Data/dedup	
outdir=~/niehs/Data/mergedalignments

cd $inbam

#set sample 
f=$(find $inbam -name "*_L1*.bam" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
name=$(echo $f | cut -d "/" -f 7 | cut -d "_" -f 1-4)
echo "Processing sample ${name}"

find $inbam -name "*$name*bam" >$name.list

bamtools merge -list $name.list -out $outdir/$name.bam
