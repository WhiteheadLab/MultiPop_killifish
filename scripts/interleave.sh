#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/intleave-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/intleave-stderr-%j.txt
#SBATCH --cpus-per-task=24
#SBATCH --mem=16000
#SBATCH -J intleave
# last modifed 2016 aug 2
# adapted from T.Brown pipeline

set -e
set -u

module load khmer

cp /home/jajpark/niehs/Data/trim/* /home/jajpark/niehs/Data/intleave/

DIR="/home/jajpark/niehs/Data/intleave"

cd $DIR

for filename in *_R1_*.qc.fq.gz
do
     # first, make the base by removing .extract.fastq.gz
     base=$(basename $filename .qc.fq.gz)
     echo $base

     # now, construct the R2 filename by replacing R1 with R2
     baseR2=${base/_R1_/_R2_}
     echo $baseR2

     # construct the output filename
     output=${base/_R1_/}.pe.qc.fq.gz

     (interleave-reads.py ${base}.qc.fq.gz ${baseR2}.qc.fq.gz | \
         gzip > $output) && rm ${base}.qc.fq.gz ${baseR2}.qc.fq.gz
done

echo `chmod u-w *.pe.qc.fq.gz orphans.fq.gz`
