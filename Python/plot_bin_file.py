import numpy as np
import matplotlib.pyplot as plt
import struct

# Define parameters
fs = 2_000_000_000  # Sampling frequency: 2 GHz
input_filename = "./InputSignals/chirp.bin"

# Read binary file
with open(input_filename, "rb") as f:
    data = f.read()
    num_samples = len(data) // 4  # 4 bytes per 32-bit integer
    samples = struct.unpack(f"{num_samples}i", data)

# Convert to NumPy array
samples = np.array(samples, dtype=np.int32)

# Generate time axis
t = np.arange(num_samples) / fs

# Plot the waveform
plt.figure(figsize=(10, 4))
plt.plot(t[:500], samples[:500], label="Cosine Wave")  # Plot first 500 samples
plt.xlabel("Time (s)")
plt.ylabel("Amplitude")
plt.title("Cosine Wave")
plt.legend()
plt.grid()
plt.show()
