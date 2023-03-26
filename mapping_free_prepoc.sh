#!/bin/sh
##Reference transcriptome preparation
#Check if index files exist/create reference transcriptome index if it doesn't
salmon index -t ~/HW1/refs/mm10cdna.fa -i ~/HW1/refs/mm10cdna

##Data QC
#FASTQC analysis on each FASTQC file
fastqc -t 6 ~/HW1/inputs/SRR8985047_1.fastq.gz ~/HW1/inputs/SRR8985047_2.fastq.gz -o ~/HW1/outputs
fastqc -t 6 ~/HW1/inputs/SRR8985048_1.fastq.gz ~/HW1/inputs/SRR8985048_2.fastq.gz -o ~/HW1/outputs
fastqc -t 6 ~/HW1/inputs/SRR8985049_1.fastq.gz ~/HW1/inputs/SRR8985049_2.fastq.gz -o ~/HW1/outputs
fastqc -t 6 ~/HW1/inputs/SRR8985050_1.fastq.gz ~/HW1/inputs/SRR8985050_2.fastq.gz -o ~/HW1/outputs

#Generate MULTIQC report
multiqc ~/HW1/outputs -o ~/HW1/outputs  

#Standard FASQC trimming
trim_galore -j 6 --paired --length 20 -o ~/HW1/trimmed_files/ ~/HW1/inputs/SRR8985047_1.fastq.gz ~/HW1/inputs/SRR8985047_2.fastq.gz
trim_galore -j 6 --paired --length 20 -o ~/HW1/trimmed_files/ ~/HW1/inputs/SRR8985048_1.fastq.gz ~/HW1/inputs/SRR8985048_2.fastq.gz
trim_galore -j 6 --paired --length 20 -o ~/HW1/trimmed_files/ ~/HW1/inputs/SRR8985049_1.fastq.gz ~/HW1/inputs/SRR8985049_2.fastq.gz
trim_galore -j 6 --paired --length 20 -o ~/HW1/trimmed_files/ ~/HW1/inputs/SRR8985050_1.fastq.gz ~/HW1/inputs/SRR8985050_2.fastq.gz

#Rerun FASTQC on cleaned fastq files
fastqc -t 6 -o ~/HW1/outputs/trimmed ~/HW1/trimmed_files/SRR8985047_1_val_1.fq.gz ~/HW1/trimmed_files/SRR8985047_2_val_2.fq.gz
fastqc -t 6 -o ~/HW1/outputs/trimmed ~/HW1/trimmed_files/SRR8985048_1_val_1.fq.gz ~/HW1/trimmed_files/SRR8985048_2_val_2.fq.gz
fastqc -t 6 -o ~/HW1/outputs/trimmed ~/HW1/trimmed_files/SRR8985049_1_val_1.fq.gz ~/HW1/trimmed_files/SRR8985049_2_val_2.fq.gz
fastqc -t 6 -o ~/HW1/outputs/trimmed ~/HW1/trimmed_files/SRR8985050_1_val_1.fq.gz ~/HW1/trimmed_files/SRR8985050_2_val_2.fq.gz


##Quantification
#Quantify each sample
for i in ~/HW1/trimmed_files/*_1_val_1.fq.gz 
do
    R1=${i}
    R2="~/HW1/trimmed_files/"$(basename ${i} _1_val_1.fq.gz)"_2_val_2.fq.gz"
    QUANT="~/HW1/outputs/trimmed/"$(basename ${i} _1_val_1.fq.gz)"_transcripts_quant"
    salmon quant -i ~/HW1/refs/mm10cdna -l IU -1 ${R1} -2 ${R2} --validateMappings -o ${QUANT}
done