#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/180123-salmindexfmd-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/180123-salmindexfmd-stderr-%j.txt
#SBATCH -J salmfmd
#SBATCH --mem=2600
#SBATCH -p med
#SBATCH -t 24:00:00 
## Modified 23 January, 2018, JP

set -e
set -u

module load bio

DIR=~/niehs/refseq/
cd $DIR

##first build salmon index
reft=GCF_000826765.1_Fundulus_heteroclitus-3.0.2_rna_from_genomic.fna.gz

salmon index -t $reft -i refseq_salm_index_fmd --type fmd --threads 8
