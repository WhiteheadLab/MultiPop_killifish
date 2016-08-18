#!/bin/bash 
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/getnewdata-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/getnewdata-stderr-%j.txt
#SBATCH -J getnewdata
set -e
set -u

###get data###

cd /home/jajpark/niehs/

wget -r -nH -nc -np -R index.html* "http://slims.bioinformatics.ucdavis.edu/Data/wtv2m3vq5z/UnalignedL5L6/Project_AWJP_L5_AWJJP001/"
wget -r -nH -nc -np -R index.html* "http://slims.bioinformatics.ucdavis.edu/Data/3b4t6qxtd5/UnalignedL5L6/Project_AWJP_L6_AWJJP002/"




