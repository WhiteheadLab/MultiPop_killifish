#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/191209-mw-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/191209-mw-stderr-%j.txt
#SBATCH -J makwin
#SBATCH -p high
#SBATCH -t 24:00:00 

module load bedtools

DIR=~/niehs/refseq
GEN=~/niehs/refseq/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.gff.gz

cd $DIR

bedtools makewindows -g $GEN -w 500000 > fhet.500kb.bed 