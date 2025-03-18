`timescale 1ns / 1ps

module filter_tb;

  logic clk;
  logic rst;
  logic signed [31:0] x_in;
  logic signed [63:0] y_out;

  parameter CLK_PERIOD = 0.5; // 2GHz Clock
  parameter NUM_SAMPLES = 1000;

  filter uut(
    .clk(clk),
    .rst(rst),
    .x_in(x_in),
    .y_out(y_out)
  );


  // Start the clock
  initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk;
  end

  integer file, status;
  integer sample_count;

  logic signed [31:0] sample_data;

  initial begin
    $dumpfile("filter_tb.vcd");
    $dumpvars(0, filter_tb);

    rst = 1;
    x_in = 0;
    sample_count = 0;

    // Open the raw signal data
    file = $fopen("../Python/InputSignals/cosine_wave_100MHz_500MHz.bin", "rb");
    if (file == 0) begin
        $display("Error: Unable to open file!");
        $finish;
    end

    #20 rst = 0;

    // Read and feed samples to the pipeline
    while (sample_count < NUM_SAMPLES) begin
      status = $fread(sample_data, file);
      if (status == 0) begin
        $display("Error: End of file reached or read error!");
        $finish;
      end

      x_in = sample_data;
      sample_count = sample_count + 1;
      #CLK_PERIOD;
    end

    $fclose(file);
    #100 $finish;
  end

endmodule







