#!/bin/bash -l
#SBATCH --cpus-per-task=24
#SBATCH --mem=16000
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/trim-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/trim-stderr-%j.txt
#SBATCH -J trim
# last modifed 2016 sep 13
set -e
set -u


DIR="/home/jajpark/niehs/Data/lanes_3-8/ReDLData"
outdir="/home/jajpark/niehs/Data/nebtrim_lanes_3-8/"


cd $DIR

for filename in *_R1_*.fastq.gz
do
     # first, make the base by removing fastq.gz
     base=$(basename $filename .fastq.gz)
     echo $base

     # now, construct the R2 filename by replacing R1 with R2
     baseR2=${base/_R1_/_R2_}
     echo $baseR2
     
     # finally, run Trimmomatic
     java -jar /home/jajpark/bin/trimmomatic-0.36.jar PE ${base}.fastq.gz ${baseR2}.fastq.gz \
        $outdir/${base}.qc.fq.gz $outdir/s1_se \
        $outdir/${baseR2}.qc.fq.gz $outdir/s2_se \
        ILLUMINACLIP:/home/jajpark/programs/Trimmomatic-0.36/adapters/NEBnextAdapt.fa:2:40:15 \
        LEADING:2 TRAILING:2 \
        SLIDINGWINDOW:4:2 \
        MINLEN:25
done

echo `gzip -9c $outdir/s1_se $outdir/s2_se >> $outdir/orphans.fq.gz`
rm -f $outdir/s1_se $outdir/s2_se




 ##############################

# java -jar /home/jajpark/bin/trimmomatic-0.36.jar PE 0001ARSC32191_S76_L005_R1_001.fastq.gz 0001ARSC32191_S76_L005_R2_001.fastq.gz	\
# 	0001ARSC32191_S76_L005_R1_001_pe.fastq 0001ARSC32191_S76_L005_R1_001_orphan.fastq \
# 	0001ARSC32191_S76_L005_R2_001_pe.fastq 0001ARSC32191_S76_L005_R2_001_orphan.fastq \
# 	ILLUMINACLIP:/home/jajpark/programs/Trimmomatic-0.36/adapters/TruSeq3-PE.fa:2:40:15 \
# 	LEADING:2 TRAILING:2 \
#   	SLIDINGWINDOW:4:2 \
#   	MINLEN:50
# 	
