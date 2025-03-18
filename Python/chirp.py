import numpy as np
import struct

fs = 2_000_000_000  # Sampling frequency: 2 GHz
frequencies = [int(f) for f in np.logspace(np.log10(1_000_000), np.log10(500_000_000), num=50)]  # Logarithmic spacing
duration = 1e-3
num_points = 200

output_filename = "chirp.bin"

t = np.arange(num_points * len(frequencies)) / fs

for frequency in frequencies:
    wave = np.cos(2 * np.pi * frequency * t)
    
    # Normalize to the range of 32-bit signed integer
    max_int32 = 2**31 - 1
    scaled_wave = (wave / np.max(np.abs(wave))) * max_int32
    int_wave = scaled_wave.astype(np.int32)

    with open(output_filename, "ab") as f:
        f.write(struct.pack(f">{len(int_wave)}i", *int_wave))

