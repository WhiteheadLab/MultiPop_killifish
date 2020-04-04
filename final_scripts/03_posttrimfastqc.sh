#!/bin/bash -l
#SBATCH --cpus-per-task=24
#SBATCH --mem=16000
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/posttrimfastqc_lanes3-8-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/posttrimfastqc_lanes3-8-stderr-%j.txt
#SBATCH -J fastqc
# last modifed 2016 august 16
set -e
set -u

module load fastqc

cd /home/jajpark/niehs/Data/nebtrim_lanes_3-8/
FastqcDir="/home/jajpark/niehs/results/nebtrim-fastqc/lanes_3-8/"

echo `fastqc *.fq.gz --noextract -o $FastqcDir`
