#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/191126-merge2-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/191126-merge2-stderr-%j.txt
#SBATCH -J merge2
#SBATCH -p high
#SBATCH -t 24:00:00 

module load bamtools 

inbam=~/niehs/Data/dedup	
outdir=~/niehs/Data/mergedalignments

cd $inbam

f=$(find $inbam -name "GTC_00_35_4*dedup.bam")
name=$(echo $f | cut -d "/" -f 7 | cut -d "_" -f 1-4)
echo "Processing sample ${name}"

find $inbam -name "*$name*bam" >$name.list

bamtools merge -list $name.list -out $outdir/$name.bam
