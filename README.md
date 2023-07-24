# DIVEpaper
Code used to analyze output of DIVE in Abante et al 2023.

- dive/: contains the code used to perform DIVE analysis. The python script dive_call.py is called in the submission script, which takes as input the full path of the FASTQ file and that of the output directory.
- assembly/: contains the code used to perform seed based assembly using SSAKE. The script ssake_paired.sh contains the source code to perform this step, taking as input the base directory (which needs to include a fastq/ folder), the SRR of the sample, and a text file containing the seeds to be used. This script is called within the SLURM submission script run_ssake_putmge.sh.
- homology/: contains the code used to perform homology analysis using HMMER. The script prot_hmlgy.sh takes a FASTA file as input and used the function hmmsearch to generate the protein homology results. This script is called within the SLURM submission script run_hmmer_put_mge.sh.

In our paper, we selected DIVE anchors with unidirectional variability (up or down), and used these as seeds during the assembly step.
