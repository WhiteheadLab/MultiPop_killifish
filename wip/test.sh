#!/bin/bash -l 
#SBATCH -D /home/jajpark/niehs/scripts
#SBATCH -o /home/jajpark/niehs/slurm-log/test-stdout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/test-stderr-%j.txt
#SBATCH -J test
set -e
set -u

bob=( 1 1 1 2 2 2 3 3 3 )
sue=( 1 2 3 1 2 3 1 2 3 )

block=${bob[$SLURM_ARRAY_TASK_ID]}
min=${sue[$SLURM_ARRAY_TASK_ID]}

echo "$block is $min" 
