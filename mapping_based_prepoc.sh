#!/bin/sh

##Reference genome preparation
gunzip ~/HW1/refs/mm10dna.fa.gz
hisat2-build ~/HW1/refsmm10dna.fa ~/HW1/refsmm10dna.fa

##Data QC
#FASTQC analysis on each FASTQC file
fastqc ~/HW1/inputs/*.fastq.gz -o ~/HW1/outputs

#Generate MultiQC report
multiqc ~/HW1/outputs

#Standard FASQC trimming
for i in ~/HW1/inputs/*_1.fastq.gz;
do
  R1=${i};
  R2="~/HW1/inputs/"$(basename ${i} _1.fastq.gz)"_2.fastq.gz";
  trim_galore -j 6 --paired ~/HW1/inputs/${R1} ~/HW1/inputs/${R2} --length 20 --output_dir ~/HW1/trimmed_files/
done

#Rerun FASTQC on cleaned fastq files
fastqc ~/HW1/trimmed_files/*.fastq.gz -o ~/HW1/outputs

#Create multiQC plots for raw and processed data
multiqc ~/HW1/outputs


##Mapping, QC and quantification

ref="~/HW1/refs/mm10dna.fa"
gtf="~/HW1/refs/mm10.gtf"
threads=6

for i in ~/HW1/inputs/*_1.fastq.gz;
do
  R1=${i};
  R2="~/HW1/inputs/"$(basename ${i} _1.fastq.gz)"_2.fastq.gz";
  BAM="~/HW1/outputs/"$(basename ${i} _1.fastq.gz)".bam";
  OUT1="~/HW1/outputs/"$(basename ${i} _1.fastq.gz)"_1_val_1.fq.gz"
  OUT2="~/HW1/outputs/"$(basename ${i} _1.fastq.gz)"_2_val_2.fq.gz"
  SAMPLE=$(basename ${i} _1.fastq.gz)

  hisat2 -p ${threads} --dta -x ${ref} -1 ${OUT1} -2 ${OUT2} -S ~/HW1/tmp/${SAMPLE}.sam 2>~/HW1/alignloc/${SAMPLE}.alnstats
  samtools view -bS -@ 6 ~/HW1/tmp/${SAMPLE}.sam | samtools sort -@ 6 -o ${BAM}
  samtools index ${BAM}
  samtools flagstat ${BAM}
  rm ~/HW1/tmp/${SAMPLE}.sam

  stringtie -p 6 -G ${gtf} -o ~/HW1/outputs/${SAMPLE}.gtf -l ${SAMPLE} ${BAM}
done

ls -l ~/HW1/outputs/*.gtf > ~/HW1/outputs/mergelist.txt 
stringtie --merge -p 6 -G ${gtf} -o ~/HW1/results/stringtie_merged.gtf ~/HW1/outputs/mergelist.txt 

for i in ~/HW1/inputs/*_1.fastq.gz;
do
  ID=$(basename $i _1.fastq.gz)

  stringtie -e -B -p ${threads} -G ~/HW1/results/stringtie_merged.gtf -o outputs/${ID}/${ID}.gtf ~/HW1/outputs/${ID}.bam
done
#Create correlation diagram and PCA plot for the data (in results folder)

