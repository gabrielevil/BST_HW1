# Read the sample information into R
sampleinfo <- read.delim("sampleInfo.txt")
View(sampleinfo)
sampleinfo
rownames(sampleinfo) <- sampleinfo$run

# Identifying the files
dirs <- list.files("salmon/")
quant_files <- list.files("salmon/",pattern="quant.sf",recursive = TRUE,full.names = TRUE)
names(quant_files) <- dirs
quant_files

#Inspecting the salmon output
library(readr)
quants <- read_tsv(quant_files[1])
head(quants)

#Demonstrating TMP calculation
rpk <- quants$NumReads / quants$EffectiveLength
scale_factor <- sum(rpk) / 1e6
tpm <- rpk / scale_factor

#Defining the transcript mapping
gtf_file <- "mm10.gtf"
file.exists(gtf_file)

#Creating a transcript database
library(GenomicFeatures)
txdb <- makeTxDbFromGFF(gtf_file)
keytypes(txdb)
columns(txdb)
k <- keys(txdb, keytype="TXNAME")
tx_map <- select(txdb, keys = k, columns="GENEID", keytype = "TXNAME")
head(tx_map)

#Creating gene level salmon counts
library(tximport)
tx2gene <- tx_map
txi <- tximport(quant_files,type="salmon",tx2gene = tx2gene,ignoreTxVersion = TRUE)
names(txi)
head(txi$counts)
all(rownames(sampleinfo) == colnames(txi$counts))

# Write the output of head(txi$counts) to a text file
write.table(txi$counts, file = "salmon_counts.txt", sep = "\t")


