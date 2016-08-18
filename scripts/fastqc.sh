#!/bin/bash -l
#SBATCH --cpus-per-task=24
#SBATCH --mem=16000
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/trimmomatic-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/trimmomatic-stderr-%j.txt
#SBATCH -J trim
# last modifed 2016 july 26
set -e
set -u

module load fastqc

cd /home/jajpark/niehs/Data/trim
FastqcDir="/home/jajpark/niehs/results/fastqcresults/"

echo `fastqc *.fq.gz --noextract -o $FastqcDir`
