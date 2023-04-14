import os, sys
from biodive import bio

fqfile = sys.argv[1]
outdir = sys.argv[2]

sourcefile = "/home/users/jabante/sbatching/cryptic/annot_source_code.py"
exec(compile(open(sourcefile).read(), sourcefile, 'exec'))
print(annot_fasta)

config = bio.Config(outdir=outdir, kmer_size=25, min_smp_sz=20, max_smp_sz=75, lmer_size=7, jsthrsh=0.15, no_new_min_p=0.75, q_thresh=0.1, annot_fasta=annot_fasta)

bio.biodive_single_sample_analysis(fqfile,config)
