# Load necessary libraries
library(ape)
library(phangorn)

getwd()

# Read in the tree file
tree <- read.tree("/Users/oakley/Documents/GitHub/opsin1timetree/tree_knot/All_uniref_hits_ALN.fa.treefile")

# Root the tree using midpoint rooting
tree <- midpoint(tree)

# Define calibration points using the `makeChronosCalib` function
calibrations <- makeChronosCalib(
  phy = tree, 
  node = c(
    getMRCA(tree, c("XLR_Gloeobacter", "Xlr__Leptolyngbya__UniRef90_A0A6H2NHV9")),
    getMRCA(tree, c("Xer__Fischerella__UniRef90_A0A2N6KA72", "Xer__Calothrix__UniRef90_A0A930XBC0")),
    getMRCA(tree, c("Cyr__Pseudanabaenaceae__UniRef90_A0A928V9X3", "CyR_Calothrix")),
    getMRCA(tree, c("Cyhr__Pseudanabaena__UniRef90_A0A926ZYX4", "Cyhr__Leptolyngbya__UniRef90_A0A0P4V0S4"))
  ),
  age.min = c(179, 1600, -1, -1),
  age.max = c(2639, 1888, 1900, 1900)
)
root_max_age = 4510

# Add a root calibration if needed
root_calibration <- makeChronosCalib(
  phy = tree,
  node = getMRCA(tree, tree$tip.label),  # Assuming this is the root node
  age.min = 0,  # Assuming no minimum constraint
  age.max = root_max_age
)

# Combine with other calibrations
calibrations <- rbind(calibrations, root_calibration)


# Run the chronos function with the specified calibrations
chrono_tree <- chronos(
  phy = tree, 
  lambda = 1,  # Adjust lambda as needed
  calibration = calibrations,
  model = "correlated"  # Specify the evolutionary model
)

# Plot the resulting timetree
plot(chrono_tree)

# Save the resulting timetree to a file
write.tree(chrono_tree, file = "timetree_result.tree")

# Optional: Save the plot as a PDF
pdf("timetree_plot.pdf")
plot(chrono_tree)
dev.off()






