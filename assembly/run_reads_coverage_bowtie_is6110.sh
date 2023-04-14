#!/bin/sh

#SBATCH --job-name=bowtie
#SBATCH --output=bowtie_logs/bowtie.%j.out
#SBATCH --error=bowtie_logs/bowtie.%j.err
#SBATCH --time=20:00:00
#SBATCH -p horence,quake
#SBATCH --mem=20Gb

# srr id is the only argument
srr="$1"

# paths
ref="/oak/stanford/groups/horence/jordi/dive_paper/annotations/is6110"
fq1="/oak/stanford/groups/horence/jordi/cryptic/fastq/${srr}_pass_1.fastq.gz"
fq2="/oak/stanford/groups/horence/jordi/cryptic/fastq/${srr}_pass_2.fastq.gz"
sam="/oak/stanford/groups/horence/jordi/cryptic/is6110/${srr}_bowtie_is6110.sam"
log="/oak/stanford/groups/horence/jordi/cryptic/is6110/${srr}_bowtie_is6110.log"
cov="/oak/stanford/groups/horence/jordi/cryptic/is6110/is6110_coverage.txt"

# bowtie command
bowtie2 --local -x "$ref" -1 "$fq1" -2 "$fq2" -S "$sam" 2> "$log"

# clean sam
grep '[[:blank:]][0-9]\+M[[:blank:]]' "$sam" | sponge "$sam"

# add coverage to shared file
cat "$sam" | awk -v s=0 -v sam="$sam" '{s+=length($10)}END{print sam,s/1361}' >> "$cov" 

