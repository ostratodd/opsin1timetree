import pandas as pd

# Load your data
df = pd.read_csv("your_spreadsheet.csv")

# Define colors for each unique Site (dark, color-blind friendly palette)
site_colors = {
    "Bocas": "648FFF",   # Blue
    "Leigh": "785EF0",  # Purple
    "Colleague": "DC267F",  # Magenta
    "Lizard": "FE6100",  # Orange
    "SoCal": "FFB000"   # Yellow
}

# Start building the LaTeX document with smaller margins, no indentation, and smaller text
latex_output = r"""
\documentclass{article}
\usepackage[margin=0.5in]{geometry}  % Set custom margin size
\usepackage{xcolor}
\setlength{\parindent}{0pt}  % Disable paragraph indentation
\begin{document}
\small  % Set text to smaller size
"""

# Define each color for the unique sites in the Site column
for site in df['Site'].unique():
    if site in site_colors:
        color_code = site_colors[site]
        color_name = site.replace(" ", "_")  # Ensure color names are LaTeX-compatible
        latex_output += f"\\definecolor{{{color_name}}}{{HTML}}{{{color_code}}}\n"

# Build one continuous line with numbered Superfamily followed by Taxon entries
line_entries = []
for i, (superfamily, group) in enumerate(df.groupby("Superfamily"), 1):
    previous_taxon_first_word = None
    taxa_entries = []
    for _, row in group.iterrows():
        taxon = row['Taxon']
        site_color = row['Site'].replace(" ", "_")
        current_taxon_first_word = taxon.split()[0]
        if previous_taxon_first_word and previous_taxon_first_word == current_taxon_first_word:
            taxon = taxon.replace(current_taxon_first_word, current_taxon_first_word[0] + ".", 1)
        previous_taxon_first_word = current_taxon_first_word
        taxa_entries.append(f"\\textcolor{{{site_color}}}{{\\textit{{{taxon}}}}}")
    superfamily_entry = f"{i}. \\textbf{{{superfamily}}}: " + ", ".join(taxa_entries)
    line_entries.append(superfamily_entry)

# Join all entries into a single line of text
latex_output += " ".join(line_entries)

# End the LaTeX document
latex_output += r"""
\end{document}
"""

# Save the LaTeX output to a .tex file
with open("output.tex", "w") as file:
    file.write(latex_output)

