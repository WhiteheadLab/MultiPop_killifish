#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/fastqcf-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/fastqcf-stderr-%j.txt
#SBATCH -J fastqcf
set -e
set -u

module load fastqc

start_time=`date +%s`

DIR=~/niehs

## Keep track of errors and outputs in a log.
logDir=$DIR/logs #Create log folder if it doesn't exist
if [ ! -d $logDir ]; then echo `mkdir -p $logDir`; fi
# Removes specific extension:
logPath=$DIR/logs/$(basename fastqcf.sh).log
##
echo `touch $logPath` #Create file to fill with log data
echo "Started on `date`" 2>&1 | tee $logPath
######


## Set source/destination folders.
SeqDir6="$DIR/Data/Data/ybpei8bxrj/Unaligned/Project_AWJP_L3_AWJJP001/*.fastq.gz"
ToDir6=$DIR/results/fastqcresults/ybpei8bxrj/
##

echo `mkdir -p $ToDir6`

for f in `ls $SeqDir6`; do
  echo $f 2>&1 | tee -a $logPath
  DoQC=`fastqc $f --noextract -o $ToDir6`
done >&2 | tee -a $logPath #Only errors. using 2>&1 creates a file too large.

end_time=`date +%s`

echo -e "\nParameters used: fastqc file --noextract -o ToDir" 2>&1 | tee -a $logPath
echo -e "\n execution time was `expr $end_time - $start_time` s."  2>&1 | tee -a $logPath
echo -e "\n Done `date`"  2>&1 | tee -a $logPath
##Done