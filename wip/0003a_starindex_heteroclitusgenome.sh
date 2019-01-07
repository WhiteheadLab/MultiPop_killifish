#!/bin/bash -l
#SBATCH --mem=40000
#SBATCH -t 24:00:00
#SBATCH --cpus-per-task=24
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/180118-starindex-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/180118-starindex-stderr-%j.txt
#SBATCH -J starindex
# modified Mon Sep 26, 2016	

module load perlnew
module load star


DIR="/home/jajpark/niehs/results/180111_staraln/star_index"

cd $DIR
STAR  --runMode genomeGenerate \
--genomeDir $DIR \
--genomeFastaFiles ../GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fna
	 
echo "genome indexed"

