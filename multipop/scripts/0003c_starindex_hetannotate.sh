#!/bin/bash -l
#SBATCH --mem=40000
#SBATCH --cpus-per-task=24
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/starindex_hetannot-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/starindex_hetannot-stdin-%j.txt
#SBATCH -J starindex-hetannot
# modified Wed November 16, 2016

module load perlnew
module load star

cd /home/jajpark/niehs/align/star-index-hetannot/
STAR  --runMode genomeGenerate --genomeDir /home/jajpark/niehs/align/star-index-hetannot/ --genomeFastaFiles GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fna --sjdbGTFfile GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.gff --sjdbGTFtagExonParentTranscript Parent
echo "genome indexed"
