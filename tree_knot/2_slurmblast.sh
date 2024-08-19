#!/bin/bash
#SBATCH --job-name=process_opsin_fastas
#SBATCH --output=output_%A_%a.out
#SBATCH --error=error_%A_%a.err
#SBATCH --time=04:00:00  # Increased time limit to account for additional tasks
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --array=0-13  # Double the job array size to handle both UniRef50 and UniRef90

# Load the bash profile to ensure conda is available
source ~/.bashrc

# Activate the conda environment containing biopython, mafft, and iqtree
conda activate bioinf

# Define the array of codes
codes=("cyr" "cyhr" "xer" "pr" "xlr" "br" "euk")
code_index=$(($SLURM_ARRAY_TASK_ID % 7))  # Get the index for the 7 codes
db_index=$(($SLURM_ARRAY_TASK_ID / 7))    # Determine whether to use UniRef50 or UniRef90
code=${codes[$code_index]}
prefix=$(echo "$code" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')

# Select the database based on the job array ID
if [ $db_index -eq 0 ]; then
    db="uniref50"
    output_suffix="_ref50"
else
    db="uniref90"
    output_suffix="_ref90"
fi

##Just do uniref90 because 50 already done
#db="uniref90"
#output_suffix="_ref90"


# Execute the commands
diamond blastp -d /home/emily.lau/manuscripts/brittlestar/uniref_databases/$db -q "${code}.fasta" -o "${code}${output_suffix}_blast" -f 6 -k 50
awk '{print $2}' "${code}${output_suffix}_blast" | sort | uniq > "${code}${output_suffix}.txt"
seqkit grep -nrf "${code}${output_suffix}.txt" /home/oakley/projects/uniref_dbs/$db.fasta > "${code}_${db}.fa"
python modify_fa.py -i "${code}_${db}.fa" -o "${code}_${db}b.fa" -p "$prefix"

