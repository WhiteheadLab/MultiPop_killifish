#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH --cpus-per-task=24
#SBATCH --mem=30000
#SBATCH -o /home/jajpark/niehs/slurm-log/salmonindex-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/salmonindex-stderr-%j.txt
#SBATCH -J salmonindex
# 23 Aug 2016

set -e
set -u

module load salmon

cd /home/jajpark/niehs/refseq/

salmon index -t GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fna -i salmon_index_fhgenome