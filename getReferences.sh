#!/bin/sh
#Download the reference genome in FASTA format
wget -O mm10dna.fa.gz "https://ftp.ensembl.org/pub/release-99/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.toplevel.fa.gz"

#Download the reference transcriptome in FASTA format
wget -O mm10cdna.fa.gz "https://ftp.ensembl.org/pub/release-99/fasta/mus_musculus/cdna/Mus_musculus.GRCm38.cdna.all.fa.gz"

#Download GTF/GFF3 file
wget -O mm10.gtf.gz "https://ftp.ensembl.org/pub/release-99/gtf/mus_musculus/Mus_musculus.GRCm38.99.gtf.gz"

#Download raw FASTQ files
prefetch SRR8985047 SRR8985048 SRR8985049 SRR8985050

fastq-dump --gzip --split-3 SRR8985047 SRR8985048 SRR8985049 SRR8985050
#Move to correct directories
mv SRR* ~/HW1/inputs
mv mm10* ~/HW1/refs
#mv fasterq* ~/HW1/refs
