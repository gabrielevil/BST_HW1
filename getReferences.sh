#!/bin/sh
#Download the reference genome in FASTA format
wget "https://ftp.ensembl.org/pub/release-109/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.toplevel.fa.gz"

#Download the reference transcriptome in FASTA format
wget "https://ftp.ensembl.org/pub/release-109/fasta/mus_musculus/cdna/Mus_musculus.GRCm39.cdna.all.fa.gz"

#Download GTF/GFF3 file
wget "https://ftp.ensembl.org/pub/release-109/gtf/mus_musculus/Mus_musculus.GRCm39.109.gtf.gz"

#Download raw FASTQ files
prefetch SRR8985047 SRR8985048 SRR8985049 SRR8985050

fastq-dump --gzip SRR8985047 SRR8985048 SRR8985049 SRR8985050
#Move to correct directories
mv SRR* ~/HW1/inputs
mv Mus* ~/HW1/refs
mv fasterq* ~/HW1/refs
