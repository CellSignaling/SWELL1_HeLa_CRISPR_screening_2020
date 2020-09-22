#!usr/bin/env python

# open Toronto library file from http://tko.ccbr.utoronto.ca/ as f
# create output file, "TKOv1.fa" as o
# create output file, "sgRNA_identifiers.txt" as u
# create output file, "tko_coordinates_out.txt" as c

tko_in = "data/original_data/TKOv1-supp-85k-library-85180_sequences"
tko_fa_out = "data/derived_data/TKOv1_supp.fa"
tko_sgrna_out = "data/derived_data/sgRNA_identifiers_supp.txt"
tko_coordinates_out = "data/derived_data/coordinates_sgrna_supp.txt"

with open(tko_in) as f, open(tko_fa_out, "w") as o, open(tko_sgrna_out, "w") as u, open(tko_coordinates_out, "w") as c:
    # For each line in TKO file
    for line in f:
        # Split by tab and store sequence of sgRNA
        sgRNA = line.split("\t")[0]
        # Split by tab and store second column
        gene_info = line.split("\t")[1]
        # Extract gene name from second column
        gene_name = gene_info.split("_")[1]
        # Write in FASTA format >Gene_sequencesgRNA \n SequencesgRNA \n
        o.write(">" + gene_name + "_" + sgRNA + "\n")
        o.write(sgRNA + "\n")
        # Write identifiers of sgRNA for future use
        u.write(gene_name + "_" + sgRNA + "\n")
        # Write coordinates of sgRNA for future use
        sgrna_cord = gene_info.split("_")[0]
        c.write(gene_name + "_" + sgrna_cord + "\n")
        