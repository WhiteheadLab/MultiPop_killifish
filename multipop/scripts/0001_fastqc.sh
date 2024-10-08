#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/fastqctest-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/fastqctest-stderr-%j.txt
#SBATCH -J fastqctest
set -e
set -u

module load fastqc

start_time=`date +%s`

DIR="/home/jajpark/niehs"

## Keep track of errors and outputs in a log.
logDir=$DIR/logs #Create log folder if it doesn't exist
if [ ! -d $logDir ]; then echo `mkdir -p $logDir`; fi
# Removes specific extension:
logPath=$DIR/logs/$(basename $BASH_SOURCE .sh).log
##
echo `touch $logPath` #Create file to fill with log data
echo "Started on `date`" 2>&1 | tee $logPath
######


## Set source/destination folders.
SeqDir1="$DIR/Data/Data/653ys7d7f/Unaligned/Project_AWJP_L5_AWJJP002/*.fastq.gz"
ToDir1=$DIR/results/fastqcresults/653ys7d7f/

SeqDir2="$DIR/Data/Data/bxod0sf9u/Unaligned/Project_AWJP_L6_AWJJP002/*.fastq.gz"
ToDir2=$DIR/results/fastqcresults/bxod0sf9u/

SeqDir3="$DIR/Data/Data/cbt64b3g2h/Unaligned/Project_AWJP_L1_AWJJP001/*.fastq.gz"
ToDir3=$DIR/results/fastqcresults/cbt64b3g2h/

SeqDir4="$DIR/Data/Data/nvyu3ierdv/Unaligned/Project_AWJP_L4_AWJJP002/*.fastq.gz"
ToDir4=$DIR/results/fastqcresults/nvyu3ierdv/

SeqDir5="$DIR/Data/Data/pucb29hv6/Unaligned/Project_AWJP_L2_AWJJP001/*.fastq.gz"
ToDir5=$DIR/results/fastqcresults/pucb29hv6/

SeqDir6="$DIR/Data/Data/ybpei8bxrj/Unaligned/Project_AWJP_L3_AWJJP001/*.fastq.gz"
ToDir6=$DIR/results/fastqcresults/ybpei8bxrj/
##

echo `mkdir -p $ToDir`

for f in `ls $SeqDir`; do
  echo $f 2>&1 | tee -a $logPath
  DoQC=`fastqc $f --noextract -o $ToDir`
done >&2 | tee -a $logPath #Only errors. using 2>&1 creates a file too large.

end_time=`date +%s`

echo -e "\nParameters used: fastqc file --noextract -o ToDir" 2>&1 | tee -a $logPath
echo -e "\n execution time was `expr $end_time - $start_time` s."  2>&1 | tee -a $logPath
echo -e "\n Done `date`"  2>&1 | tee -a $logPath
##Done

