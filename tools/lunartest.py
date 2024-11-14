import numpy as np
import matplotlib.pyplot as plt

# Parameters
num_days = 29
num_pixels = 10
bar_height = 500

# Generate figure
fig, ax = plt.subplots(figsize=(15, 5))

for day in range(1, num_days + 1):
    # Calculate illumination ratio
    illumination_ratio = (1 + np.cos(2 * np.pi / num_days * (day - 1))) / 2
    yellow_pixels = round(illumination_ratio * num_pixels)
    
    # Calculate visibility ratio (simplified to be proportional to day for this example)
    visibility_ratio = min(1, max(0, (12 - (day * 50 % 1440) / 60) / 12))
    
    # Draw the bar
    for pixel in range(num_pixels):
        if pixel < yellow_pixels:
            color = (1.0, 1.0, 0.0, visibility_ratio)  # Yellow with transparency based on visibility
        else:
            color = 'black'
        
        ax.add_patch(plt.Rectangle((day, pixel * (bar_height / num_pixels)), 1, bar_height / num_pixels, color=color))

# Display figure
plt.xlim(1, num_days + 1)
plt.ylim(0, bar_height)
plt.axis('off')
plt.show()

