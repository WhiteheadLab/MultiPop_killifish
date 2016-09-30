#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts
#SBATCH -o /home/jajpark/niehs/slurm-log/wget1-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/wget1-stderr-%j.txt
#SBATCH -J wget1 
set -e
set -u

###get data###

cd ~/niehs/Data/lanes_3-8/ReDLData

wget -r -nH -nc -np -R index.html* \
"http://slims.bioinformatics.ucdavis.edu/Data/cbt64b3g2h/" 




