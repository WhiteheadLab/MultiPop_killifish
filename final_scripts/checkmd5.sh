#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/190128-checkmd-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/190128-checkmd-stderr-%j.txt
#SBATCH -J checkmd
#SBATCH --mem=16000
#SBATCH -p high
#SBATCH -t 24:00:00 

cd ~/niehs/Data/128.120.88.242/C202SC18122707/raw_data

for i in `find . -type d`; do 
	cd $i 
	md5sum -c MD5.txt >> ../results.txt
	cd ~/niehs/Data/128.120.88.242/C202SC18122707/raw_data	
	
done