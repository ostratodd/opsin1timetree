#!/bin/bash
#SBATCH --job-name=mafft_iqtree_all  # Job name
#SBATCH --output=mafft_iqtree_%j.out  # Standard output log
#SBATCH --error=mafft_iqtree_%j.err   # Standard error log
#SBATCH --time=10:00:00  # Time limit hrs:min:sec
#SBATCH --nodes=1  # Run all processes on a single node
#SBATCH --ntasks=1  # Number of processes
#SBATCH --cpus-per-task=8  # Number of CPU cores per task

# Activate the conda environment
source ~/.bashrc
conda activate bioinf

# Concatenate the FASTA files
cat cyr.fasta cyhr.fasta br.fasta xer.fasta pr.fasta xlr.fasta *50b.fa *90b.fa > All_uniref_hits.fa

# Perform multiple sequence alignment with MAFFT
mafft All_uniref_hits.fa > All_uniref_hits_ALN.fa

# Run IQ-TREE with automatic thread detection

#**** running LG model for faster exploratory analyses. Not based on full model test run
iqtree -s All_uniref_hits_ALN.fa -nt 8 -m LG+I+R7 -redo

