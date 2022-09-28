this folder contains all of the scripts used to process the RNA-seq data in the "data" folder

Embryos (n = 5) were collected for transcriptomic analyses from 3 replicate containers and flash frozen in liquid nitrogen at pre-hatch/onset of eye and pectoral fin movement (~10-14 dpf)

RNA-Seq libraries were prepared using NEBNext Directional RNA Library Prep Kit for Illumina (Cat # E7420L) and libraries were sequenced on an Illumina HiSeq 4000 as paired end 150-bp reads at the UC Davis Core Genomics Facility.


Raw reads were checked for quality using FastQC, trimmed with trimmomatic, and mapped and quantified using Salmon. Reads were mapped to the Fundulus heteroclitus reference transcriptome. Gene-level counts were estimated from transcript-level estimates using tximport. Quality-trimmed RNA-seq reads were then aligned to a F. heteroclitus reference genome (Fundulus_heteroclitus-3.0.2, RefSeq assembly accession: GCF_000826765.1)

We removed duplicate reads using Picard tools v2.7.1 and used Freebayes v1.3.1 to call variants, excluding regions with low (<750) and high (>300,000) reads. We filtered variants with vcftools v0.1.16  to only include bi-allelic SNPs with minor allele frequency of >0.006 and quality scores > 30. 

Variants were estimated from 40 embryos from LA-REF, 39 embryos from LA-DWH, 39 embryos from TX-REF, and 37 embryos from TX-SF. We estimated genome-wide pairwise Fst values between each population using Weir and Cockerham’s calculations and vcftools v0.1.16 and averaging Fst values across all variant sites.
