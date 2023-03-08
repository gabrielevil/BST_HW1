#!/bin/sh
#Download the reference genome in FASTA format
wget "https://ftp.ensembl.org/pub/release-109/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.toplevel.fa.gz"
mv Mus_musculus.GRCm39.dna.toplevel.fa.gz HW1/refs
#Download the reference transcriptome in FASTA format
wget "https://ftp.ensembl.org/pub/release-109/fasta/mus_musculus/cdna/Mus_musculus.GRCm39.cdna.all.fa.gz"
mv Mus_musculus.GRCm39.cdna.all.fa.gz HW1/refs
#Download GTF/GFF3 file
wget "https://ftp.ensembl.org/pub/release-109/gtf/mus_musculus/Mus_musculus.GRCm39.109.gtf.gz"
mv Mus_musculus.GRCm39.109.gtf.gz HW1/refs
#Download raw FASTQ files
fasterq-dump --split-files SRR8985047
fasterq-dump --split-files SRR8985048
fasterq-dump --split-files SRR8985049
fasterq-dump --split-files SRR8985050
mv SRR* HW1/inputs
