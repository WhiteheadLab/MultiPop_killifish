#!/bin/bash -l
#SBATCH --array=1-160%50
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/200307-trim-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/200307-trim-stderr-%A-%a.txt
#SBATCH -J trim
#SBATCH -p high
#SBATCH --mem=16000
#SBATCH -t 24:00:00 

# last modifed 2019 Jan 29

set -e
set -u

module load bio3 

start_time=`date +%s`

DIR=~/niehs/Data/rawdata/liversamples
OutDir=~/niehs/Data/trimmed_data/liversamples


cd $DIR

#ln -s $SeqDir/*/*.fq.gz . 

f=$(find . -name "*_1.fq.gz" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)

# first, make the base by removing fastq.gz
base=$(basename $f fq.gz)
echo $base

# now, construct the R2 filename by replacing R1 with R2
baseR2=${base//_1./_2.}
echo $baseR2
     
# finally, run Trimmomatic
trimmomatic PE ${base}fq.gz ${baseR2}fq.gz \
	$OutDir/${base}qc.fq.gz $OutDir/${base}s1_se \
    $OutDir/${baseR2}qc.fq.gz $OutDir/${baseR2}s2_se \
    ILLUMINACLIP:TruSeq3-PE-2.fa:2:40:15 \
    LEADING:2 TRAILING:2 \
    SLIDINGWINDOW:4:2 \
    MINLEN:25

end_time=`date +%s`

echo `gzip -9c $OutDir/${base}s1_se $OutDir/${baseR2}s2_se >> $OutDir/${base}orphans.fq.gz`
rm -f $OutDir/${base}s1_se $OutDir/${baseR2}s2_se

echo -e "\n execution time was `expr $end_time - $start_time` s." 
echo -e "\n Done" 


 	
 	
 	
 
