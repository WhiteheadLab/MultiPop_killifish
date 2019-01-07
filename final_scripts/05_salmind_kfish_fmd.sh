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
reft=kfish2rae5g.mrna.combined

salmon index -t $reft -i kfish_salm_index_fmd --type fmd --threads 8
