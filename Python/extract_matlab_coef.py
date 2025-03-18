import numpy as np

# Input and output file names
input_filename = "../Matlab/low_pass_coefficients_v3.fcf"
output_filename = "low_pass_coefficients_v3.v"

# Read the filter coefficients from the file
coefficients = []
with open(input_filename, "r") as file:
    for line in file:
        line = line.strip()
        if line and not line.startswith("%"):
            coefficients.append(float(line))

coefficients = np.array(coefficients)

# Compute scale factor based on maximum absolute value
max_abs = np.max(np.abs(coefficients))
scale_factor = (2**31 - 1) / max_abs  # 2147483647 / max_abs

# Scale coefficients as floats
scaled_floats = coefficients * scale_factor

# Round to nearest integer
rounded_floats = np.round(scaled_floats)

# Clip to 32-bit signed integer range to prevent overflow
clipped_floats = np.clip(rounded_floats, -2147483648, 2147483647)

# Cast to 32-bit signed integers
scaled_coefficients = clipped_floats.astype(np.int32)

# Write the Verilog file
with open(output_filename, "w") as file:
    file.write("module filter_coefficients\n")
    file.write("    reg signed [31:0] coeffs [0:{}] = '{{\n".format(len(scaled_coefficients) - 1))
    
    for i, coeff in enumerate(scaled_coefficients):
        binary_coeff = format(np.uint32(coeff), "032b")
        file.write(f"        32'b{binary_coeff}{',' if i < len(scaled_coefficients) - 1 else ''}\n")
    
    file.write("    };\nendmodule\n")

print(f"Verilog file '{output_filename}' generated successfully.")

