#!/bin/sh
#Calculate (and print to the screen) the number of sequences in your reference genome
echo "number of sequences: " 
grep -c "^>" ~/HW1/refs/Mus_musculus.GRCm39.dna.toplevel.fa.gz4

#Calculate (and print to the screen) the number of reads in each sample.
echo "number of reads in each sample: "
grep -c "^@.*$" ~/HW1/inputs/SRR8985047.fastq.gz
grep -c "^@.*$" ~/HW1/inputs/SRR8985048.fastq.gz
grep -c "^@.*$" ~/HW1/inputs/SRR8985049.fastq.gz
grep -c "^@.*$" ~/HW1/inputs/SRR8985050.fastq.gz

#Calculate the number of protein-coding genes in your genome. (gtf)
echo "number of protein-coding genes: " 
gunzip -c ~/HW1/refs/*.gtf.gz | grep -w "gene" | grep -w "protein_coding" | wc -l