#!/bin/bash
# jjpark @ whitehead lab
# how to pull samples from the unidentified sample fastq.gz file from illumina
# Modified: 2016 july  18

#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/demultiplex-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/demultiplex-stderr-%j.txt
#SBATCH -J demultiplex
set -e
set -u

module load fastx

start_time=`date +%s`

DIR="/home/jajpark/niehs"

# Name of the file to demultiplex
SeqFile1='Undetermined_S0_L005_R1_001.fastq.gz'
SeqFile2='Undetermined_S0_L005_R2_001.fastq.gz'
barcodeFile='missingbarcodes.txt'

## Set source/destination folders.
seqPath1=$DIR/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/$SeqFile1
seqPath2=$DIR/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/$SeqFile2
barcodePath=$DIR/scripts/$barcodeFile

# Output parameters
toDir1=$DIR/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/0006ARSE32351_S81_L005_R1_001
toDir2=$DIR/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/0006ARSE32351_S81_L005_R2_001
outExt=.fastq

# Create new dir
echo `mkdir -p $toDir1` 2>&1
echo `mkdir -p $toDir2` 2>&1
 

#Set the parameters for fastx splitter
## I chose 3 mismatches and 1 partial match based on trial and error, getting the optimum 
# sorted reads to a barcode vs unmatched reads. Tested with a head/tail subset of the full sequencing fike. See my notes. 
splitCommand1="fastx_barcode_splitter.pl --bcfile $barcodePath --bol --prefix $toDir1 --suffix $outExt"
splitCommand2="fastx_barcode_splitter.pl --bcfile $barcodePath --bol --prefix $toDir2 --suffix $outExt"

## Read the file to stdoutput *don't decompress*
## Run barcode splitter
## Save info to file
echo `zcat $seqPath1 | $splitCommand1 2>&1 
# Compress everything inside the folder
echo `gzip $toDir1/*` 2>&1 

echo `zcat $seqPath2 | $splitCommand2 2>&1 
# Compress everything inside the folder
echo `gzip $toDir2/*` 2>&1 

# Set Input/Output parameters.
# Input = r1 and r2 fastq.gz
# Output = Newsamplename.fastq.gz
# 
# 0006ARSE32351_S81_L005_R1_001.fastq.gz
# 0006ARSE32351_S81_L005_R2_001.fastq.gz
# 
# 0094ARSC00354_S168_L006_R1_001.fastq.gz
# 0094ARSC00354_S168_L006_R2_001.fastq.gz
# 
# 
# Search for barcode match
# barcode= AGCGATAG+GTCAGTAC
# 
# zcat lane1_Undetermined_L001_R1_001.fastq.gz | head -1 | grep 'AGCGATAG+GTCAGTAC' | cut -d : -f 10 | sort | uniq -c | sort -nr | head -20
# 
# 
