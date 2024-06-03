this folder contains all necessary scripts for assessing embryo exposure effects and phenotype endpoints 

This folder also contains all of the files used to process the RNA-seq data

Raw reads were checked for quality using FastQC, trimmed with trimmomatic, and mapped and quantified using Salmon. Reads were mapped to the Fundulus heteroclitus reference transcriptome. Gene-level counts were estimated from transcript-level estimates using tximport. Quality-trimmed RNA-seq reads were then aligned to a F. heteroclitus reference genome (Fundulus_heteroclitus-3.0.2, RefSeq assembly accession: GCF_000826765.1)

We removed duplicate reads using Picard tools v2.7.1 and used Freebayes v1.3.1 to call variants, excluding regions with low (<750) and high (>300,000) reads. We filtered variants with vcftools v0.1.16 to only include bi-allelic SNPs with minor allele frequency of >0.006 and quality scores > 30.

