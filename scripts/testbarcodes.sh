#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/testbarcodes-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/testbarcodes-stderr-%j.txt
#SBATCH -J testbarcodes
set -e
set -u

cd ~/niehs/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/

## Look for the top 20 most prevalent barcode sequences in the Undetermined sample

zcat Undetermined_S0_L005_R1_001.fastq.gz | grep '^@J00113' | cut -d : -f 10 | sort | uniq -c | sort -nr | head -20 > ~/niehs/slurm-log/testbarcode1.txt 
zcat Undetermined_S0_L005_R2_001.fastq.gz | grep '^@J00113' | cut -d : -f 10 | sort | uniq -c | sort -nr | head -20 > ~/niehs/slurm-log/testbarcode2.txt

echo "Done" 
