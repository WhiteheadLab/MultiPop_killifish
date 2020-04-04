#!/bin/bash -l
#SBATCH --array=1-160%100
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/200306-fastqcf-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/200306-fastqcf-stderr-%A-%a.txt
#SBATCH -J fastqcf
#SBATCH --mem=16000
#SBATCH -p high
#SBATCH -t 24:00:00 

set -e
set -u

module load fastqc

start_time=`date +%s`

DIR=~/niehs/Data/rawdata/liversamples
OUT=~/niehs/results/liver_fastqc

cd $DIR

f=$(find . -name "*.fq.gz"  | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)

fastqc $f --noextract -o $OUT

end_time=`date +%s`

echo -e "\nParameters used: fastqc file --noextract -o $OUT" 
echo -e "\n execution time was `expr $end_time - $start_time` s." 
echo -e "\n Done" 

