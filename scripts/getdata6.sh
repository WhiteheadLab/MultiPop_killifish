#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/wget5-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/wget5-stderr-%j.txt
#SBATCH -J wget5
set -e
set -u

###get data###

cd ~/niehs/Data/

wget -r -nH -nc -np -R index.html* \
"http://slims.bioinformatics.ucdavis.edu/Data/653ys7d7f/" 




