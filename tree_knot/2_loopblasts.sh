#!/bin/bash
#SBATCH --job-name=process_opsin_fastas
#SBATCH --output=output_%A_%a.out
#SBATCH --error=error_%A_%a.err
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --array=0-5

# Load the bash profile to ensure conda is available
source ~/.bashrc

# Activate the conda environment
conda activate bioinf

# Define the array of codes
codes=("cyr" "cyhr" "xer" "pr" "xlr" "br")
code=${codes[$SLURM_ARRAY_TASK_ID]}
prefix=$(echo "$code" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')

# Execute the commands
diamond blastp -d /home/emily.lau/manuscripts/brittlestar/uniref_databases/uniref50 -q "${code}.fasta" -o "${code}_ref50_blast" -f 6 -k 50
awk '{print $2}' "${code}_ref50_blast" | sort | uniq > "${code}_ref50.txt"
seqkit grep -nrf "${code}_ref50.txt" /home/oakley/projects/uniref_dbs/uniref50.fasta > "${code}_50.fa"
python modify_fa.py -i "${code}_50.fa" -o "${code}_50b.fa" -p "$prefix"

