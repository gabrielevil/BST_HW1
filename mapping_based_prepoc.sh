#!/bin/sh

##Reference genome preparation
gungz ~/HW1/refs/mm10dna.fa.gz
hisat2-build ~/HW1/refs/mm10dna.fa ~/HW1/refs/mm10dna.fa

##Data QC
#FASTQC analysis on each FASTQC file

fastqc -t 6 ~/HW1/inputs/SRR8985047_1.fastq.gz ~/HW1/inputs/SRR8985047_2.fastq.gz -o ~/HW1/outputs
fastqc -t 6 ~/HW1/inputs/SRR8985048_1.fastq.gz ~/HW1/inputs/SRR8985048_2.fastq.gz -o ~/HW1/outputs
fastqc -t 6 ~/HW1/inputs/SRR8985049_1.fastq.gz ~/HW1/inputs/SRR8985049_2.fastq.gz -o ~/HW1/outputs
fastqc -t 6 ~/HW1/inputs/SRR8985050_1.fastq.gz ~/HW1/inputs/SRR8985050_2.fastq.gz -o ~/HW1/outputs


# #Generate MultiQC report
multiqc ~/HW1/outputs -o ~/HW1/outputs  

# #Standard FASTQC trimming

trim_galore -j 6 --paired --length 20 -o ~/HW1/trimmed_files/ ~/HW1/inputs/SRR8985047_1.fastq.gz ~/HW1/inputs/SRR8985047_2.fastq.gz
trim_galore -j 6 --paired --length 20 -o ~/HW1/trimmed_files/ ~/HW1/inputs/SRR8985048_1.fastq.gz ~/HW1/inputs/SRR8985048_2.fastq.gz
trim_galore -j 6 --paired --length 20 -o ~/HW1/trimmed_files/ ~/HW1/inputs/SRR8985049_1.fastq.gz ~/HW1/inputs/SRR8985049_2.fastq.gz
trim_galore -j 6 --paired --length 20 -o ~/HW1/trimmed_files/ ~/HW1/inputs/SRR8985050_1.fastq.gz ~/HW1/inputs/SRR8985050_2.fastq.gz


#Rerun FASTQC on cleaned fastq files

fastqc -t 6 -o ~/HW1/outputs/trimmed ~/HW1/trimmed_files/SRR8985047_1_val_1.fq.gz ~/HW1/trimmed_files/SRR8985047_2_val_2.fq.gz
fastqc -t 6 -o ~/HW1/outputs/trimmed ~/HW1/trimmed_files/SRR8985048_1_val_1.fq.gz ~/HW1/trimmed_files/SRR8985048_2_val_2.fq.gz
fastqc -t 6 -o ~/HW1/outputs/trimmed ~/HW1/trimmed_files/SRR8985049_1_val_1.fq.gz ~/HW1/trimmed_files/SRR8985049_2_val_2.fq.gz
fastqc -t 6 -o ~/HW1/outputs/trimmed ~/HW1/trimmed_files/SRR8985050_1_val_1.fq.gz ~/HW1/trimmed_files/SRR8985050_2_val_2.fq.gz

#Create multiQC plots for raw and processed data
multiqc ~/HW1/outputs -o ~/HW1/outputs

##Mapping, QC and quantification

ref="~/HW1/refs/mm10dna.fa"
for i in ~/HW1/trimmed_files/*_1_val_1.fq.gz
do
    R1=${i}
    R2="~/HW1/trimmed_files/"$(basename ${i} _1_val_1.fq.gz)"_2_val_2.fq.gz"
    SAM="~/HW1/outputs/trimmed/"$(basename ${i} _1_val_1.fq.gz)".sam"
    BAM="~/HW1/outputs/trimmed/"$(basename ${i} _1_val_1.fq.gz)".bam"
    BAM_S="~/HW1/outputs/trimmed/"$(basename ${i} _1_val_1.fq.gz)"_sorted.bam"
    BAM_Fil="~/HW1/outputs/trimmed/"$(basename ${i} _1_val_1.fq.gz)"_filtered.bam"
    BAM_F="~/HW1/outputs/trimmed/"$(basename ${i} _1_val_1.fq.gz)"_fixmate.bam"
    BAM_P="~/HW1/outputs/trimmed/"$(basename ${i} _1_val_1.fq.gz)"_positionsort.bam"
    BAM_M="~/HW1/outputs/trimmed/"$(basename ${i} _1_val_1.fq.gz)"_markdup.bam"
    hisat2 -p 6 --dta -x ${ref} -1 ${R1} -2 ${R2} -S ${SAM}
    samtools view -@ 6 -bS ${SAM} -o ${BAM}
    samtools view -@ 6 -F 260 -bS ${BAM} > ${BAM_Fil}
    samtools sort -n -o ${BAM_S} ${BAM_Fil}
    samtools fixmate -m ${BAM_S} ${BAM_F}
    samtools sort -o ${BAM_P} ${BAM_F}
    samtools markdup -r ${BAM_P} ${BAM_M}
    samtools index ${BAM_M}
    rm ${BAM} ${SAM} ${BAM_Fil} ${BAM_S} ${BAM_F} ${BAM_P}
done 

for i in ~/HW1/outputs/trimmed/*_markdup.bam
do
    GTF="~/HW1/outputs/stringtie/"$(basename ${i} _markdup.bam)".gtf"
    BAM_M=${i}
    stringtie -p 6 -G ~/HW1/refs/mm10.gtf -o ${GTF} ${BAM_M}
done

#Create correlation diagram and PCA plot for the data (in results folder)

multiBamSummary bins --outFileName ~/HW1/results/mapped.npz --binSize 1000 -p 6 --outRawCounts ~/HW1/results/raw_counts.tsv -b ~/HW1/outputs/trimmed/*_markdup.bam

plotCorrelation -in ~/HW1/results/mapped.npz -c pearson -p heatmap -o ~/HW1/results/mapped_data_heatmap.pdf

plotCorrelation -in ~/HW1/results/mapped.npz -c pearson -p scatterplot -o ~/HW1/results/mapped_data_scatter.pdf

# --removeOutliers

plotPCA -in ~/HW1/results/mapped.npz -o ~/HW1/results/mapped_data_pca.pdf
