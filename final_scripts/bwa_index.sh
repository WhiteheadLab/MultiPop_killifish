#!/bin/bash -l
#SBATCH --mem=40000
#SBATCH -t 24:00:00
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/191217-bwaindex-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/191217-bwaindex-stderr-%j.txt
#SBATCH -J bwa_index
# modified Oct 10, 2019

module load bwa/0.7.9a 

cd ~/niehs/refseq

genome=GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fna.gz

bwa index -p fhet $genome