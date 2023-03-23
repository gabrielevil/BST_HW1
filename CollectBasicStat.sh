#!/bin/sh
#Calculate (and print to the screen) the number of sequences in your reference genome
echo "number of sequences: " 
grep -c "^>" ~/HW1/refs/mm10dna.fa.gz

#Calculate (and print to the screen) the number of reads in each sample.
echo "number of reads in each sample: "
grep -c "^@.*$" ~/HW1/inputs/*.fastq.gz

#Calculate the number of protein-coding genes in your genome. (gtf)
echo "number of protein-coding genes: " 
gunzip -c ~/HW1/refs/*.gtf.gz | grep -w "gene" | grep -w "protein_coding" | wc -l
