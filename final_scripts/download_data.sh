#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/wget3-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/wget3-stderr-%j.txt
#SBATCH -J wget_data
#SBATCH --mem=16000
#SBATCH -p high
#SBATCH -t 24:00:00 

set -e
set -u

cd ~/niehs/Data/

wget -r --user=P202SC18122707-01_20190124_yKaRAK --password=03OadE ftp://128.120.88.242/

echo -e "\n Done"




