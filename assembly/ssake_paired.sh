#!/usr/bin/env bash

set -x 

# SRR
proj_dir="$1"                   # main directory containing fastq/ folder
srr="$2"                        # SRR for fastq's assuming they are in fastq/
seeds="$(readlink -f $3)"       # specify full path
# nrounds="$4"                  # number of rounds

# go to project directory
cd "$proj_dir"

echo "creating input files to SSAKE..."

#########################################################################################################################################################
# THIS PART PERFORMS READ QUALITY TRIMMING (SSAKE's recommendation)
#########################################################################################################################################################

# gunzip (next steps only work with unzip FASTQ)
gunzip fastq/"$srr"_pass_1.fastq.gz
gunzip fastq/"$srr"_pass_2.fastq.gz

# trim reads (-e 33 is for Illumina >1.8)
TQSfastq.py -f fastq/"$srr"_pass_1.fastq -c 15 -t 20 -e 33
TQSfastq.py -f fastq/"$srr"_pass_2.fastq -c 15 -t 20 -e 33

# compress again
gzip fastq/"$srr"_pass_1.fastq
gzip fastq/"$srr"_pass_2.fastq

# clean headers (need the last digit of the read name to be 1 or 2 indicating mate #)
sed -i 's/ .*$//' fastq/"$srr"_pass_1.fastq_T20C15E33.trim.fa
sed -i 's/ .*$//' fastq/"$srr"_pass_2.fastq_T20C15E33.trim.fa

# # make paired and unpaired files 
mkdir -p "ssake_ass/${srr}"
cd "ssake_ass/${srr}"
makePairedOutput2UNEQUALfiles.pl ../../fastq/"$srr"_pass_1.fastq_T20C15E33.trim.fa ../../fastq/"$srr"_pass_2.fastq_T20C15E33.trim.fa 400

    # Not sure about insert size: For Illumina systems DNA insert size range of 200–800 bp. It depends on the used Illumina system, the used reagents (kits) 
    #  and the mode (single/paired end). That's why you should first take a look in the operating instructions of your used device and kit.)

# rm intermediate files
rm ../../fastq/"$srr"_pass_1.fastq_T20C15E33.trim.fa ../../fastq/"$srr"_pass_2.fastq_T20C15E33.trim.fa

#########################################################################################################################################################
# GET ASSEMBLY SEEDS FROM ONLY UPSTREAM AND DOWNSTREAM ANCHORS
#########################################################################################################################################################

# copy seed file
cp  "$seeds" "${srr}_seeds_1.fa"

# run SSAKE
for i in {1..10}
do
    echo -ne "\n\n#############################################################################################################################\n\n"
    echo "Round ${i} of SSAKE..."

    j=$((i+1))

    # run SSAKE
    SSAKE -f paired.fa -g unpaired.fa -s "${srr}_seeds_${i}.fa" -p 1 -m 20 -o 1 -c 1 -w 5 -r 0.51 -i 0 -b "${srr}_ssake_${i}"

    # create seed file from contigs
    ln -s "${srr}_ssake_${i}_contigs.fa" "${srr}_seeds_${j}.fa"

done

# SSAKE
# -g  Fasta file containing unpaired sequence reads (optional)
# -w  Minimum depth of coverage allowed for contigs (e.g. -w 1 = process all reads [v3.7 behavior], required, recommended -w 5)
#     *The assembly will stop when 50+ contigs with coverage < -w have been seen.*
# -s  Fasta file containing sequences to use as seeds exclusively (specify only if different from read set, optional)
# 	-i Independent (de novo) assembly  i.e Targets used to recruit reads for de novo assembly, not guide/seed reference-based assemblies (-i 1 = yes (default), 0 = no, optional)
# 	-j Target sequence word size to hash (default -j 15)
# 	-u Apply read space restriction to seeds while -s option in use (-u 1 = yes, default = no, optional)
# -m  Minimum number of overlapping bases with the seed/contig during overhang consensus build up (default -m 20)
# -o  Minimum number of reads needed to call a base during an extension (default -o 2)
# -r  Minimum base ratio used to accept a overhang consensus base (default -r 0.7)
# -t  Trim up to -t base(s) on the contig end when all possibilities have been exhausted for an extension (default -t 0, optional)
# -c  Track base coverage and read position for each contig (default -c 0, optional)
# -y  Ignore read mapping to consensus (-y 1 = yes, default = no, optional)
# -h  Ignore read name/header *will use less RAM if set to -h 1* (-h 1 = yes, default = no, optional)
# -b  Base name for your output files (optional)
# -z  Minimum contig size to track base coverage and read position (default -z 100, optional)
# -q  Break tie when no consensus base at position, pick random base (-q 1 = yes, default = no, optional)
# -p  Paired-end reads used? (-p 1 = yes, default = no, optional)
# -v  Runs in verbose mode (-v 1 = yes, default = no, optional)
