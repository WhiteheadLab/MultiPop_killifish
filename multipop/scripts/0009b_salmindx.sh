#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/salmindex-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/salmindex-stderr-%j.txt
#SBATCH -J salmindx
#SBATCH --mem=16000
#SBATCH -p high
#SBATCH -t 24:00:00 
## Modified 15 December, 2016, JP

set -e
set -u

module load salmon

DIR=~/niehs/refseq/
cd $DIR

##first build salmon index
reft=GCF_000826765.1_Fundulus_heteroclitus-3.0.2_rna.fna.gz

salmon index -t $reft -i transcripts_salm_index --type quasi -k 31
