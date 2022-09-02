## Experimental Design:
* 5 populations of Fundulus grandis were collected across the Gulf of Mexico, RNA-seq data for: 
   * ARS: Aquatic Research Station, aquacultured pop in LA
   * GT: Grand Terre, recently oiled pop in LA
   * VB: Vince Bayou, industrial pollution pop from Houston Ship Channel
   * GB: Gang's Bayou, clean ref pop near Houston Ship Channel
  
* Adult fish were cultured in lab conditions for 1-2 generations before experiment
* Parent treatment: Adult fish were exposed to WAF or clean/control water for ~60 days before spawning
* Embryo exposure dosage: Embryos were exposed to WAF 00%, 10%, 32%, or 56% for 21 days
* Embryo developmental stage: Embryos were sampled for RNA-seq at stages 19, 28, 35, or hatch
     * Leftover embryos that were unhatched at the end of 21 days were collected as non-hatched (NH)
* Up to 5 replicates were sequenced for each treatment
* File naming convention: 
     * [SampleNumber, 4 digits] ARS [ParentTreatment, 1 letter] [Embryo exposure %, 2 digits] [Developmental Stage, 2 digits] [ReplicateNumber 1-5] 
     * Sample Number: unique number assigned to each embryo sequenced
     * ARS: population of F. grandis
     * Parent Treatment: Exposed (E) or Control (C)
     * Embryo exposure: 0, 10, 32, or 56%
     * Developmental Stage: 19, 28, 35, or HA
     * Replicate Number: Single digit, 1-5
* Samples 75, 145, 146, and 163 should be excluded from analysis due to barcoding error (see "Identifying samples that didn't get sequenced in the first lane trial")


##  General Pipeline:

* [Quality control with FastQC]
* [Trim short reads with Trimmomatic]
* [Map and quantify reads with Salmon]
* [Differential expression analysis in R]


### Quality control with FastQC
FastQC is a raw read quality assessment command line tool.
I used the following parameters to QC reads before and after trimming:

	fastqc file --noextract -o ToDir		
		

### Trim short reads with trimmomatic
Reads were trimmed lightly using Trimmomatic command line tool and NEBNext adaptor .fa file. 

[0002_trimmomaticNEB.sh] link to the script

The .fa files are located at: 

	~/programs/Trimmomatic-0.36/adapters
	
### Merge trimmed reads

Notes: looks like I copied the trimmed reads into intermediate mergedfq directories before merging and dumping into `OUTDIR=~/niehs/Data/trimmed_data/mergedfq`

### Map and quantify reads with Salmon

Reference transcriptome: 

* Lisa Cohen concatenated two [reference transcriptomes by Don Gilbert]
(http://arthropods.eugenes.org/EvidentialGene/killifish/genes/kfish2rae5/) that contain alternate gene model information. I used that concatenation, found here:

		~/niehs/refseq/kfish2rae5g.mrna.combined
		
* Trimmed and merged data located: 

		~/niehs/Data/trimmed_data/mergedfq/

Reads were ultimately mapped to Don Gilbert's reference transcriptome, fmd mode. 

### Differential Expression Analysis in R

Gene-level counts from transcript abundances were estimated using `tximport` in R. 

[link to Rmd script]


