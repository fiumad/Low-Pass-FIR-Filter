`timescale 1ns / 1ps

module filter(
  input logic clk,
  input logic rst,
  input logic signed [31:0] x_in,
  input logic signed [31:0] x_in1,
  input logic signed [31:0] x_in2,
  output logic signed [63:0] y_out,
  output logic signed [63:0] y_out1,
  output logic signed [63:0] y_out2
);

parameter NUM_TAPS = 102;

// Coefficients
logic signed [31:0] coeffs [102:0];

always_comb begin 
  coeffs[0] = 32'b11111111111110000010000011101100;
  coeffs[1] = 32'b11111111111000010011001010000001;
  coeffs[2] = 32'b11111111101011100010111001111001;
  coeffs[3] = 32'b11111111010011101111001000101101;
  coeffs[4] = 32'b11111110101101101111000110001010;
  coeffs[5] = 32'b11111101110111110111100010111000;
  coeffs[6] = 32'b11111100110100010100110110110111;
  coeffs[7] = 32'b11111011101001011101101101010111;
  coeffs[8] = 32'b11111010100010100111011001000011;
  coeffs[9] = 32'b11111001101101111111100111111111;
  coeffs[10] = 32'b11111001011010011101011111111110;
  coeffs[11] = 32'b11111001110010111111111101010011;
  coeffs[12] = 32'b11111010111011010101111011010111;
  coeffs[13] = 32'b11111100101100101101111001110001;
  coeffs[14] = 32'b11111110110110000001000110111110;
  coeffs[15] = 32'b00000000111110000010100110001000;
  coeffs[16] = 32'b00000010101001011010110110000000;
  coeffs[17] = 32'b00000011100001010010111010001011;
  coeffs[18] = 32'b00000011011010011010010100001110;
  coeffs[19] = 32'b00000010011000111100101011100000;
  coeffs[20] = 32'b00000000110000110111000110011101;
  coeffs[21] = 32'b11111111000000110111110001011111;
  coeffs[22] = 32'b11111101101010010011111101110010;
  coeffs[23] = 32'b11111101000110111111001100000111;
  coeffs[24] = 32'b11111101100001001011010110000110;
  coeffs[25] = 32'b11111110101111100111010001101110;
  coeffs[26] = 32'b00000000010111111110001101011110;
  coeffs[27] = 32'b00000001110110101110101010000111;
  coeffs[28] = 32'b00000010101010111010000001111100;
  coeffs[29] = 32'b00000010100001010010001000001011;
  coeffs[30] = 32'b00000001011011110110001011011000;
  coeffs[31] = 32'b11111111110010000001100101001000;
  coeffs[32] = 32'b11111110001001101010010111101101;
  coeffs[33] = 32'b11111101001010001001010011000111;
  coeffs[34] = 32'b11111101001110010001111000001100;
  coeffs[35] = 32'b11111110011001011000100000110110;
  coeffs[36] = 32'b00000000010100001011100010001100;
  coeffs[37] = 32'b00000010010010111000011111011011;
  coeffs[38] = 32'b00000011100011011111000110001011;
  coeffs[39] = 32'b00000011011111101001010101110110;
  coeffs[40] = 32'b00000001111100011111001111010010;
  coeffs[41] = 32'b11111111010010010111100110101101;
  coeffs[42] = 32'b11111100011001011001110000001110;
  coeffs[43] = 32'b11111010011010101010011011100011;
  coeffs[44] = 32'b11111010011010001100111111001111;
  coeffs[45] = 32'b11111101000000010110011101000010;
  coeffs[46] = 32'b00000010001001101111111101000100;
  coeffs[47] = 32'b00001001000011100100110011010111;
  coeffs[48] = 32'b00010000010110000000010110001000;
  coeffs[49] = 32'b00010110011010010110100111011111;
  coeffs[50] = 32'b00011001110110101011101000100111;
  coeffs[51] = 32'b00011001110110101011101000100111;
  coeffs[52] = 32'b00010110011010010110100111011111;
  coeffs[53] = 32'b00010000010110000000010110001000;
  coeffs[54] = 32'b00001001000011100100110011010111;
  coeffs[55] = 32'b00000010001001101111111101000100;
  coeffs[56] = 32'b11111101000000010110011101000010;
  coeffs[57] = 32'b11111010011010001100111111001111;
  coeffs[58] = 32'b11111010011010101010011011100011;
  coeffs[59] = 32'b11111100011001011001110000001110;
  coeffs[60] = 32'b11111111010010010111100110101101;
  coeffs[61] = 32'b00000001111100011111001111010010;
  coeffs[62] = 32'b00000011011111101001010101110110;
  coeffs[63] = 32'b00000011100011011111000110001011;
  coeffs[64] = 32'b00000010010010111000011111011011;
  coeffs[65] = 32'b00000000010100001011100010001100;
  coeffs[66] = 32'b11111110011001011000100000110110;
  coeffs[67] = 32'b11111101001110010001111000001100;
  coeffs[68] = 32'b11111101001010001001010011000111;
  coeffs[69] = 32'b11111110001001101010010111101101;
  coeffs[70] = 32'b11111111110010000001100101001000;
  coeffs[71] = 32'b00000001011011110110001011011000;
  coeffs[72] = 32'b00000010100001010010001000001011;
  coeffs[73] = 32'b00000010101010111010000001111100;
  coeffs[74] = 32'b00000001110110101110101010000111;
  coeffs[75] = 32'b00000000010111111110001101011110;
  coeffs[76] = 32'b11111110101111100111010001101110;
  coeffs[77] = 32'b11111101100001001011010110000110;
  coeffs[78] = 32'b11111101000110111111001100000111;
  coeffs[79] = 32'b11111101101010010011111101110010;
  coeffs[80] = 32'b11111111000000110111110001011111;
  coeffs[81] = 32'b00000000110000110111000110011101;
  coeffs[82] = 32'b00000010011000111100101011100000;
  coeffs[83] = 32'b00000011011010011010010100001110;
  coeffs[84] = 32'b00000011100001010010111010001011;
  coeffs[85] = 32'b00000010101001011010110110000000;
  coeffs[86] = 32'b00000000111110000010100110001000;
  coeffs[87] = 32'b11111110110110000001000110111110;
  coeffs[88] = 32'b11111100101100101101111001110001;
  coeffs[89] = 32'b11111010111011010101111011010111;
  coeffs[90] = 32'b11111001110010111111111101010011;
  coeffs[91] = 32'b11111001011010011101011111111110;
  coeffs[92] = 32'b11111001101101111111100111111111;
  coeffs[93] = 32'b11111010100010100111011001000011;
  coeffs[94] = 32'b11111011101001011101101101010111;
  coeffs[95] = 32'b11111100110100010100110110110111;
  coeffs[96] = 32'b11111101110111110111100010111000;
  coeffs[97] = 32'b11111110101101101111000110001010;
  coeffs[98] = 32'b11111111010011101111001000101101;
  coeffs[99] = 32'b11111111101011100010111001111001;
  coeffs[100] = 32'b11111111111000010011001010000001;
  coeffs[101] = 32'b11111111111110000010000011101100;
end


// Combined fine-grain pipelining and parallel processing for 3-tap FIR filter

// Instantiate registers that lie between multiplications in each branch of
// the filter

// Pipelines for computing y(3k)
logic signed [63:0] y_3k_x_3k2_pipeline [NUM_TAPS-1:0];
logic signed [63:0] y_3k_x_3k1_pipeline [NUM_TAPS-1:0];
logic signed [63:0] y_3k_x_3k_pipeline [NUM_TAPS-1:0];

//Pipelines for computing y(3k + 1)
logic signed [63:0] y_3k1_x_3k2_pipeline [NUM_TAPS-1:0];
logic signed [63:0] y_3k1_x_3k1_pipeline [NUM_TAPS-1:0];
logic signed [63:0] y_3k1_x_3k_pipeline [NUM_TAPS-1:0];

//Pipelines for computing y(3k + 2)
logic signed [63:0] y_3k2_x_3k2_pipeline [NUM_TAPS-1:0];
logic signed [63:0] y_3k2_x_3k1_pipeline [NUM_TAPS-1:0];
logic signed [63:0] y_3k2_x_3k_pipeline [NUM_TAPS-1:0];

// Instantiate delay units for input samples
logic signed [31:0] x3k1_delayed;
logic signed [31:0] x3k2_delayed;

always_ff @(posedge clk or posedge rst) begin 
  if (rst) begin 
    x3k1_delayed <= 0;
    x3k2_delayed <= 0;
  end else begin
    x3k1_delayed <= x_in1;
    x3k2_delayed <= x_in2;
  end
end

// Compute y(3k)
always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    for (int i = NUM_TAPS-1; i >= 0; i=i-1) begin
      y_3k_x_3k_pipeline[i] <= 0;
      y_3k_x_3k1_pipeline[i] <= 0;
      y_3k_x_3k2_pipeline[i] <= 0;
    end
  end else begin
    for (int i = 1; i < NUM_TAPS-1; i=i+1) begin
      // Shift and multiply by new coefficient
      y_3k_x_3k_pipeline[i] <=  y_3k_x_3k_pipeline[i-1] * coeffs[i-1];
      y_3k_x_3k1_pipeline[i] <= y_3k_x_3k1_pipeline[i-1] * coeffs[i-1];
      y_3k_x_3k2_pipeline[i] <= y_3k_x_3k2_pipeline[i-1] * coeffs[i-1];
    end
    y_3k_x_3k_pipeline[0] <= x_in * coeffs[0];
    y_3k_x_3k1_pipeline[0] <= x3k1_delayed * coeffs[0];
    y_3k_x_3k2_pipeline[0] <= x3k2_delayed * coeffs[0];

  end
end

// Compute y(3k + 1)
always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    for (int i = NUM_TAPS-1; i >= 0; i=i-1) begin
      y_3k1_x_3k_pipeline[i] <= 0;
      y_3k1_x_3k1_pipeline[i] <= 0;
      y_3k1_x_3k2_pipeline[i] <= 0;
    end
  end else begin
    for (int i = 1; i < NUM_TAPS-1; i=i+1) begin
      // Shift and multiply by new coefficient
      y_3k1_x_3k_pipeline[i] <= y_3k1_x_3k_pipeline[i-1] * coeffs[i-1];
      y_3k1_x_3k1_pipeline[i] <= y_3k1_x_3k1_pipeline[i-1] * coeffs[i-1];
      y_3k1_x_3k2_pipeline[i] <= y_3k1_x_3k2_pipeline[i-1] * coeffs[i-1];
    end
    y_3k1_x_3k_pipeline[0] <= x_in * coeffs[0];
    y_3k1_x_3k1_pipeline[0] <= x_in1 * coeffs[0];
    y_3k1_x_3k2_pipeline[0] <= x3k2_delayed * coeffs[0];
  end
end

// Compute y(3k + 2)
always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    for (int i = NUM_TAPS-1; i >= 0; i=i-1) begin
      y_3k2_x_3k_pipeline[i] <= 0;
      y_3k2_x_3k1_pipeline[i] <= 0;
      y_3k2_x_3k2_pipeline[i] <= 0;
    end
  end else begin
    for (int i = 1; i < NUM_TAPS-1; i=i+1) begin
      // Shift and multiply by new coefficient
      y_3k2_x_3k_pipeline[i] <= y_3k2_x_3k_pipeline[i-1] * coeffs[i-1];
      y_3k2_x_3k1_pipeline[i] <= y_3k2_x_3k1_pipeline[i-1] * coeffs[i-1];
      y_3k2_x_3k2_pipeline[i] <= y_3k2_x_3k2_pipeline[i-1] * coeffs[i-1];
    end
    y_3k2_x_3k_pipeline[0] <= x_in * coeffs[0];
    y_3k2_x_3k1_pipeline[0] <= x_in1 * coeffs[0];
    y_3k2_x_3k2_pipeline[0] <= x_in2 * coeffs[0];
  end
end

// Accumulate the values from the multiplication pipelines
always_comb begin
  y_out = y_3k_x_3k2_pipeline[NUM_TAPS-1] + y_3k_x_3k1_pipeline[NUM_TAPS-1] + y_3k_x_3k_pipeline[NUM_TAPS-1];
  y_out1 = y_3k1_x_3k2_pipeline[NUM_TAPS-1] + y_3k1_x_3k1_pipeline[NUM_TAPS-1] + y_3k1_x_3k_pipeline[NUM_TAPS-1];
  y_out2 = y_3k2_x_3k2_pipeline[NUM_TAPS-1] + y_3k2_x_3k1_pipeline[NUM_TAPS-1] + y_3k2_x_3k_pipeline[NUM_TAPS-1];
end


endmodule
