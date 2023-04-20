#!/bin/bash

output_file="salmon.txt"
input_file="~/HW1/refs/mm10.gtf"

# Open output file for writing and write header line
echo -e "transcript_id\tgene_id" > "$output_file"

# Read input file line by line
while read -r line; do
    # Skip lines starting with #
    if [[ ${line:0:1} != "#" ]]; then
        # Get ID column and extract gene_id and transcript_id
        id_column=$(echo "$line" | cut -f 9)
        gene_id=$(echo "$id_column" | cut -d ";" -f 1 | sed 's/gene_id=//; s/"//g; s/ //g')
        tr_id=$(echo "$id_column" | cut -d ";" -f 2 | sed 's/transcript_id=//; s/"//g; s/ //g')

        # If both gene_id and transcript_id are present, write them to output file
        if [[ $gene_id == *"gene_id"* && $tr_id == *"transcript_id"* ]]; then
            echo -e "$tr_id\t$gene_id" >> "$output_file"
        fi
    fi
done < "~/HW1/refs/mm10.gtf"
