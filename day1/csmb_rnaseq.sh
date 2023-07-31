#!/bin/bash -l

cd $HOME/csmb_rnaSeq/1_rawData
samples=$(ls *| cut -f 1 -d "_")


for i in $samples
do
	cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -o $HOME/csmb_rnaSeq/3_cutadapt/${i}.trimmed.fastq.gz ${i}_*.fastq.gz 
	fastqc $HOME/csmb_rnaSeq/3_cutadapt/${i}.trimmed.fastq.gz -t 16 -o $HOME/csmb_rnaSeq/4_fastqc/
	kallisto quant -i $HOME/csmb_rnaSeq/2_reference/hg38_Index -o $HOME/csmb_rnaSeq/5_kallisto_quant/${i} -l 100 -s 2 --single $HOME/csmb_rnaSeq/3_cutadapt/${i}.trimmed.fastq.gz
done



