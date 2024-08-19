import argparse
from Bio import SeqIO

def fasta_to_phylobayes(fasta_file, phylobayes_file):
    # Read sequences from the FASTA file
    sequences = list(SeqIO.parse(fasta_file, "fasta"))
    
    # Get the number of taxa and the length of the sequences
    num_taxa = len(sequences)
    num_sites = len(sequences[0].seq)
    
    # Write the PhyloBayes format output
    with open(phylobayes_file, 'w') as output:
        # Write header
        output.write(f"{num_taxa} {num_sites}\n")
        
        # Write each taxon and its sequence
        for record in sequences:
            taxon_name = record.id
            sequence = str(record.seq)
            output.write(f"{taxon_name} {sequence}\n")

if __name__ == "__main__":
    # Set up argument parsing
    parser = argparse.ArgumentParser(description="Convert a FASTA file to PhyloBayes format.")
    parser.add_argument("input_fasta", help="Path to the input FASTA file")
    parser.add_argument("output_phylobayes", help="Path to the output PhyloBayes formatted file")
    
    # Parse arguments
    args = parser.parse_args()
    
    # Call the conversion function with the provided arguments
    fasta_to_phylobayes(args.input_fasta, args.output_phylobayes)

