#!/bin/bash -l
#SBATCH --cpus-per-task=24
#SBATCH --mem=16000
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/trimfastqc-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/trimfastqc-stderr-%j.txt
#SBATCH -J fastqc
# last modifed 2016 august 16
set -e
set -u

module load fastqc

cd /home/jajpark/niehs/Data/nebtrim
FastqcDir="/home/jajpark/niehs/results/nebtrim-fastqc/"

echo `fastqc *.fq.gz --noextract -o $FastqcDir`
