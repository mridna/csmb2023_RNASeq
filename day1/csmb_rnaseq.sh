#!/bin/bash -l

#changing directory
cd $HOME/csmb_rnaSeq/1_rawData

#downloading all 6 datasets
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR347/002/SRR3471622/SRR3471622.fastq.gz -o SRR3471622_GSM2141237_AF11_NI2_Homo_sapiens_RNA-Seq.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR347/003/SRR3471623/SRR3471623.fastq.gz -o SRR3471623_GSM2141238_AF11_S2_Homo_sapiens_RNA-Seq.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR347/006/SRR3471626/SRR3471626.fastq.gz -o SRR3471626_GSM2141241_AF17_S2_Homo_sapiens_RNA-Seq.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR347/009/SRR3471629/SRR3471629.fastq.gz -o SRR3471629_GSM2141244_AF19_S2_Homo_sapiens_RNA-Seq.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR347/008/SRR3471628/SRR3471628.fastq.gz -o SRR3471628_GSM2141243_AF19_NI2_Homo_sapiens_RNA-Seq.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR347/005/SRR3471625/SRR3471625.fastq.gz -o SRR3471625_GSM2141240_AF17_NI2_Homo_sapiens_RNA-Seq.fastq.g


#storing the 6 datasets that we want to analyse
samples=$(ls *| cut -f 1 -d "_")

#activating conda environment
conda activate csmb_rnaSeq

#using a for loop to perform the analyses for all 6 samples; this means: for every sample stored in the previous line execute the commands between do and done

for i in $samples
do
	#adapter trimming
	cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -o $HOME/csmb_rnaSeq/3_cutadapt/${i}.trimmed.fastq.gz ${i}_*.fastq.gz

	#quality control
	fastqc $HOME/csmb_rnaSeq/3_cutadapt/${i}.trimmed.fastq.gz -t 16 -o $HOME/csmb_rnaSeq/4_fastqc/

	#quantifying reads
	kallisto quant -i $HOME/csmb_rnaSeq/2_reference/hg38_Index -o $HOME/csmb_rnaSeq/5_kallisto_quant/${i} -l 100 -s 2 --single $HOME/csmb_rnaSeq/3_cutadapt/${i}.trimmed.fastq.gz
done

#exiting conda environ
conda deactivate
