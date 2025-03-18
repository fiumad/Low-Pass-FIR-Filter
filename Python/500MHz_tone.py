import numpy as np
import struct

# Define parameters
fs = 2_000_000_000  # Sampling frequency: 2 GHz
tone1 = 100_000_000  # First tone: 100 MHz
tone2 = 500_000_000  # Second tone: 500 MHz
duration = 1e-3  # Duration of the signal (1 ms)
num_samples = int(fs * duration)  # Total number of samples

# Generate time vector
t = np.arange(num_samples) / fs

# Generate cosine wave with two tones
wave = np.cos(2 * np.pi * tone2 * t)

# Normalize to the range of 32-bit signed integer
max_int32 = 2**31 - 1
scaled_wave = (wave / np.max(np.abs(wave))) * max_int32

# Convert to 32-bit signed integers
int_wave = scaled_wave.astype(np.int32)

# Save to binary file
output_filename = "cosine_wave_500MHz.bin"
with open(output_filename, "wb") as f:
    f.write(struct.pack(f">{len(int_wave)}i", *int_wave)) # Big-endian

print(f"Generated {num_samples} samples and saved to {output_filename}")
