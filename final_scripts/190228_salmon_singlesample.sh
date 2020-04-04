#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/190409-salmcountfmd2-stout-%J.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/190409-salmcountfmd2-stderr-%J.txt
#SBATCH -J salmcount_kfish_fmd2
#SBATCH --mem=16000
#SBATCH -p high
#SBATCH -t 24:00:00 
## Modified 9 April 2019, JP

module load bio

cd /home/jajpark/niehs/Data/trimmed_data/all_pops

salmon quant -i ~/niehs/refseq/kfish_salm_index_fmd -l ISR \
         -1  VBE_00_19_5_USPD16092636-D704-AK1681_HW2K3CCXY_L5_1.qc.fq.gz VBE_00_19_5_USPD16092636-D704-AK1681_HW2K3CCXY_L6_1.qc.fq.gz VBE_00_19_5_USPD16092636-D704-AK1681_HW2K3CCXY_L7_1.qc.fq.gz VBE_00_19_5_USPD16092636-D704-AK1681_HW2K3CCXY_L8_1.qc.fq.gz\
         -2  VBE_00_19_5_USPD16092636-D704-AK1681_HW2K3CCXY_L5_2.qc.fq.gz VBE_00_19_5_USPD16092636-D704-AK1681_HW2K3CCXY_L6_2.qc.fq.gz VBE_00_19_5_USPD16092636-D704-AK1681_HW2K3CCXY_L7_2.qc.fq.gz VBE_00_19_5_USPD16092636-D704-AK1681_HW2K3CCXY_L8_2.qc.fq.gz \
         -p 8 -o ~/niehs/results/190925_kfishind_fmd_salmcounts/VBE_00_19_5_USPD16092636-D704-AK1681_HW2K3CCXY_quant