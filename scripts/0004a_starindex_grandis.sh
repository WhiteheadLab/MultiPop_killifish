#!/bin/bash -l
#SBATCH --mem=40000
#SBATCH --cpus-per-task=24
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/starindex-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/starindex-stderr-%j.txt
#SBATCH -J starindex
# modified Mon Sep 26, 2016	

module load perlnew
module load star

cd /home/jajpark/niehs/align/star-index-grandis/
STAR  --runMode genomeGenerate --genomeDir /home/jajpark/niehs/align/star-index-grandis/ --genomeFastaFiles grandis_2015-04-21.fasta
echo "genome indexed"

