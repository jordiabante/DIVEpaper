#!/usr/bin/env bash

set -x 

# installs: conda install -c bioconda seqkit,hmmer,infernal
# env: conda activate prot_hmlgy

# input
fa="$1"
fadir="$(dirname $fa)"
fabase="$(basename $fa)"
fapref="${fabase%.*}"

# define output files
aapath="${fadir}/${fapref}.aa"
hmmerpref="${fadir}/${fapref}_hmmer_pfam35"

# translate the sequences in FASTA
seqkit translate -F --clean -f 6 "$fa" > "$aapath"

# run homology analysis
Pfam="/oak/stanford/groups/horence/zheludev/preprint_060722/pipeline/Pfam"
hmmsearch --notextw -o "${hmmerpref}.stdout" --tblout "${hmmerpref}.tblout" --cpu 10 "${Pfam}/Pfam-A.hmm" "$aapath"
