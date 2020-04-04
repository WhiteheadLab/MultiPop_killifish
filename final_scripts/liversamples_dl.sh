#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/20-01-15-dl-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/20-01-15-dl-stderr-%j.txt
#SBATCH -J dl
#SBATCH --mem=6000
#SBATCH -p high
#SBATCH -t 24:00:00 

cd /home/jajpark/niehs/Data/rawdata/liversamples

wget -r --user=X202SC19113065-Z01_01_14_20_OnMX --password=rv2Z6CFu ftp://128.120.88.251/

