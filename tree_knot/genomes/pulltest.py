import os
from ftplib import FTP

# Function to download a file from FTP server
def download_ftp_file(ftp_host, ftp_dir, ftp_file, output_dir):
    ftp = FTP(ftp_host)
    ftp.login()
    ftp.cwd(ftp_dir)
    
    local_filename = os.path.join(output_dir, ftp_file)
    
    with open(local_filename, 'wb') as f:
        ftp.retrbinary('RETR ' + ftp_file, f.write)
    
    ftp.quit()

# NCBI FTP server details
ftp_host = "ftp.ncbi.nlm.nih.gov"
# Replace 'GCF_000317435.1_ASM31743v1' with the correct folder path for your assembly
ftp_dir = "/genomes/all/GCF/000/317/435/GCF_000317435.1_ASM31743v1/"
ftp_file = "GCF_000317435.1_ASM31743v1_protein.faa.gz"

# Directory to save the downloaded file
output_dir = "./proteomes"

# Ensure the output directory exists
os.makedirs(output_dir, exist_ok=True)

# Download the predicted proteome
download_ftp_file(ftp_host, ftp_dir, ftp_file, output_dir)

print(f"Downloaded {ftp_file} to {output_dir}")

