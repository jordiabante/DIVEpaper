#!/bin/sh

#SBATCH --job-name=bowtie
#SBATCH --output=bowtie_logs/bowtie.%j.out
#SBATCH --error=bowtie_logs/bowtie.%j.err
#SBATCH --time=1:00:00
#SBATCH -p horence,quake
#SBATCH --mem=10Gb

# srr id is the only argument
fa="$1"

# paths
ref="/oak/stanford/groups/horence/jordi/dive_paper/annotations/is6110"
sam="${fa%.fa}_bowtie_is6110.sam"
log="${fa%.fa}_bowtie_is6110.log"

# bowtie command
bowtie2 -f --local -x "$ref" -U "$fa" -S "$sam" 2> "$log"

