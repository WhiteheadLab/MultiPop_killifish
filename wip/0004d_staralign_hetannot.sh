#!/bin/bash -l
#SBATCH --array=1-174%20
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH --mem=40000
#SBATCH -t 48:00:00
#SBATCH -p high
#SBATCH -o /home/jajpark/niehs/slurm-log/180120-staraln-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/180120-staraln-stderr-%A-%a.txt
#SBATCH -J 18022-staralign
# modified 22 Jan 2018

set -e 
set -u 

module load perlnew
module load star

gendir=/home/jajpark/niehs/results/180111_staraln
dir=/home/jajpark/niehs/Data/trimmed_data/mergedfq
outdir=/home/jajpark/niehs/results/180111_staraln/alignments

cd $dir

f=$(find $dir -name "*_R1_merged.fq.gz" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
base=$(basename $f "_R1_merged.fq.gz")
echo $base
	
STAR --genomeDir ${gendir}/star_index \
--sjdbGTFfile ~/niehs/refseq/heteroclitus_refseq_GBE_2017-05-12.gff \
--sjdbGTFtagExonParentTranscript Parent \
--sjdbGTFtagExonParentGene ID \
--readFilesCommand zcat \
--readFilesIn ${dir}/${base}_R1_merged.fq.gz ${dir}/${base}_R2_merged.fq.gz \
--outFileNamePrefix ${outdir}/${base}_ \
--quantMode TranscriptomeSAM \
--runThreadN 1 \
--outSAMtype BAM Unsorted
	
done



