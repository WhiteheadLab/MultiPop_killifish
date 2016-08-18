#!/bin/bash -l
#SBATCH --mem=40000
#SBATCH --cpus-per-task=24
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/starindex-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/starindex-stderr-%j.txt
#SBATCH -J starindex
# modified Wed Aug 16 2016

module load perlnew
module load star

cd /home/jajpark/niehs/align/stargen-index/
STAR  --runMode genomeGenerate --genomeDir /home/jajpark/niehs/align/stargen-index/ --genomeFastaFiles GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fna
echo "genome indexed"

cd /home/jajpark/niehs/align/startran-index/
STAR  --runMode genomeGenerate --genomeDir /home/jajpark/niehs/align/startran-index/ --genomeFastaFiles killifish20130322asm.fa
echo "transcriptome indexed"

