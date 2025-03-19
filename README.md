# Advanced VLSI - Project 1

## Project Prompt:
The objective of this course project is to design and implement low-pass FIR filter. Using Matlab to construct a 100-
tap low-pass filter with the transition region of 0.2pi~0.23pi rad/sample and stopband attenuation of at least 80dB
(you may increase the number of filter taps if necessary).

For the FIR filter architecture, consider (i)
pipelining, (2) reduced-complexity parallel processing (L=2 and L=3), and (3) combined pipelining and L=3 parallel
processing.

## Process:
1. First, Matlab Filter Designer was used to generate 102 coefficients for a 102 tap filter (102 taps is chosen since it is divisible by 2 and 3, which will make parallelizing simpler). 

![102 Tap FIR Filter Frequency Response](./Docs/Filter_Frequency_Response.png)

As seen in the image above, the filter's transistion region is between .2 pi and .23 pi, and the stop band attenuation is greater than 80 dB.

2. Next, a python script (`./Python/coef-h-to-signed-int.py`) was used to save these coefficients as 32 bit binary signed integers for use in verilog. The script also added assignment statements for ease of use in hdl files. These 32 bit binary signed integer coefficients can be found in (`./Python/coefficients.txt`). The base 10 version of these coefficients are hard coded into the python conversion script.

```python
coefficients = [
    -515860,    -2018687,    -5362055,   -11603411,   -21565046,   -35686216,
     -53391945,   -73016489,   -91589053,  -105383425,  -110503938,  -104071341,
     -85106985,   -55386511,   -19394114,    16263560,    44412288,    59059851,
      57255182,    40094432,    12808605,   -16548769,   -39239822,   -48499961,
     -41634426,   -21072786,     6284126,    31124103,    44802172,    42279435,
      24077016,    -3663544,   -31021587,   -47672121,   -46588404,   -26900426,
       5290124,    38504411,    59634059,    58627446,    32633810,   -11961939,
     -60449778,   -93673757,   -93794353,   -50239678,    36110148,   151932119,
     274204040,   376007135,   433764903,   433764903,   376007135,   274204040,
     151932119,    36110148,   -50239678,   -93794353,   -93673757,   -60449778,
     -11961939,    32633810,    58627446,    59634059,    38504411,     5290124,
     -26900426,   -46588404,   -47672121,   -31021587,    -3663544,    24077016,
      42279435,    44802172,    31124103,     6284126,   -21072786,   -41634426,
     -48499961,   -39239822,   -16548769,    12808605,    40094432,    57255182,
      59059851,    44412288,    16263560,   -19394114,   -55386511,   -85106985,
    -104071341,  -110503938,  -105383425,   -91589053,   -73016489,   -53391945,
     -35686216,   -21565046,   -11603411,    -5362055,    -2018687,     -515860
]
```

3. Next, several python scripts were utilized to generate discretized input signal data for use in filter test benches. These scripts can all be found within the `./Python/` directory. Among the several signals generated, notably, a two-tone sinusoid (components at 100MHz and 500MHz) was generated. This signal nicely demonstrates the filtering capabilities of the filters implemented in this project. The 100MHz component of this signal should be firmly in the pass band, and the 500MHz signal should be firmly in the stop band. When generating these discretized input signals, a sample rate of 2GHz was used. The operating speed of all filters in this project will be held at 2GHz.  

4. Now that the filter coefficients and test signals have been generated, we can begin implementing and benchmarking various filter architectures. Each filter is implemented using System Verilog, simulated with iverilog and examined using GTKWave. Once determined to be working via behavioral simulation, Cadence Genus is used to synthesize each filter and generate timing, area, and power reports for benchmarking purposes. The synthesis tool (Genus) is configured to use standard cells from a typical 45nm process.

## Results and Analysis
### Pipelined Only Low Pass FIR Filter:

This 102 tap FIR filter was implemented in direct form with added pipeline registers following each adder. Each cycle, the input sample is multiplied by every single coefficient, and the partial sum of all prior samples with prior coefficients is stored in a register.

![Pipelined FIR Filter Architecture](./Docs/Pipelined-FIR-Filter-Architecture.png)

The critical path of this pipelined filter is one multiplier and one adder.

To verify the behavior of the filter, a test bench inputs a two tone sine wave (100MHz + 500MHz tones) and the resulting filtered output is plotted.

![Pipelined Filter - Two Tone Response](./Docs/PipelinedFilter-two_tone_response.png)

#### Area Report 
When synthesized using Cadence Genus and 45nm standard cells, the area of this design is ~.39mm^2 or about 625 microns by 625 microns if square. Further information can be found in `./PipelinedFilter/Cadence_Genus/PipelineFilter_Area.rpt`

It's worth noting that Genus performs extensive optimization via various techniques including buffer insertion which can add cells and therefore area to the design. Genus settings were kept consistent throughout benchmarking to ensure fair comparison across designs.

#### Power Report
Instance: /filter
Power Unit: W
PDB Frames: /stim#0/frame#0
  -------------------------------------------------------------------------
    Category         Leakage     Internal    Switching        Total    Row%
  -------------------------------------------------------------------------
      memory     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
    register     3.95634e-03  1.18613e+00  8.95537e-02  1.27964e+00  25.67%
       latch     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
       logic     3.02380e-02  2.37488e+00  1.29936e+00  3.70448e+00  74.33%
        bbox     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
       clock     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
         pad     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
          pm     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
  -------------------------------------------------------------------------
    Subtotal     3.41944e-02  3.56101e+00  1.38891e+00  4.98411e+00 100.00%
  Percentage           0.69%       71.45%       27.87%      100.00% 100.00%
  -------------------------------------------------------------------------

The entire design consumes 5 watts, with 75% of this consumption coming from logic.

#### Timing Report
The design is a bit to slow to keep up with the 2GHz operating frequency chosen at the beginning of the project. The timing report shows -552 ps of slack in the circuit.

The path that doesn't meet timing requirements is from the input through several buffers, to several multipliers, adders, and eventually to the stage register where the partial sum is stored. All of these extra cells are inserted by genus to make the design synthesizable and genus goes through many iterations to optimize how it uses standard cells to achieve an implementation. Regardless, the clock speed would need to be lowered in order to effectively utilize this design.


### 2-Parallel Low Pass FIR Filter:

This 102 tap filter was implemented using the 2-parallel + FFA0 architecture from [[2]](https://www.researchgate.net/publication/26532566_Frequency_Spectrum_Based_Low-Area_Low-Power_Parallel_FIR_Filter_Design).

![2-parallel FIR Filter using FFA0](./Docs/2-Parallel-FIR-Filter-Architecture.png)

The critical path for this architecture is (102/3) multipliers and adders (found in each of the three MAC lines).

Once again, to verify the behavior of the filter, the two tone sinusoid was processed by the filter and the resulting output can be seen below.

![2-Parallel FIR Filter - Two Tone Response](./Docs/2-ParallelFilter-two_tone_response.png)

As seen above, the filter rejects the high frequency component (mostly captured by x_in), and passes the lower frequency component (seen in x_in1).

#### Area Report
This design is much larger than the pipelined version of the filter. The total area is ~1.08 mm^2. More information can be found in `./ParallelFilter_L=2/Cadence_Genus/2ParallelFilter_Area.rpt`

#### Power Report
Instance: /filter
Power Unit: W
PDB Frames: /stim#0/frame#0
  -------------------------------------------------------------------------
    Category         Leakage     Internal    Switching        Total    Row%
  -------------------------------------------------------------------------
      memory     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
    register     2.42200e-03  4.52471e-01  2.17971e-02  4.76690e-01   3.60%
       latch     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
       logic     1.04939e-01  7.84042e+00  4.81742e+00  1.27628e+01  96.40%
        bbox     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
       clock     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
         pad     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
          pm     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
  -------------------------------------------------------------------------
    Subtotal     1.07361e-01  8.29289e+00  4.83922e+00  1.32395e+01 100.00%
  Percentage           0.81%       62.64%       36.55%      100.00% 100.00%
  -------------------------------------------------------------------------

Unsurprisingly, the design also consumes more power at ~13 Watts. Nearly all of this power consumption comes from logic at over 96% of consumption.


#### Timing Report
The timing report once again shows negative slack. This design us about 1ns too slow on the critical path as compared to 550ps with the pipelined design. This time, the critical path is from the even_samples register all the way to the y_out1 output. It is very important to note that the slack and power consumption are in reality about on par with the pipelined design since adding parallelism enables us to decrease the clock speed without affecting the throughput of the circuit. Since this design has 2x parallelism, we could safely halve the operating frequency and achieve the same performance as the pipelined design. All of this is only true of course if the signal you are sampling has a nyquist frequency that is less than or equal to the newly halved clock frequency - if your goal is to support real-time filtering. The circuit instead store samples in a buffer and process them at any rate that suits the filter implementation.

### 3 Parallel Low Pass FIR Filter
The 3-Parallel implementation of this low pass filter was realized using the 3-Parallel using FFA0 design in [[2]](https://www.researchgate.net/publication/26532566_Frequency_Spectrum_Based_Low-Area_Low-Power_Parallel_FIR_Filter_Design)

![3-Parallel FIR Filter using FFA0](./Docs/3-Parallel-FIR-Filter-Architecture.png)

The image below shows the 3-parallel filter's behavior when processing our two tone sinusoid:

![3-Parallel FIR Filter - Two Tone Response]()


#### Area Report

#### Power Report

#### Timing Report


### 3 Parallel and Pipelined Low Pass FIR Filter
In order to utilize the benefits of both parallelism and pipelining, I implemented the architecture found on page 73 of the course textbook [1].

![3-Parallel FIR Filter Architecture with Fine-Grain Pipelining](./Docs/3-Parallel-Pipelined-FIR-Filter-Architecture.png)

In this implementation, pipeline registers are added between the multipliers of each branch of the filter. This decreases the critical path to the adders that accumulate the results from the multipliers.

The filter behaves as expected when given the two tone sinusoid as input (see below).

![3-Parallel FIR Filter with Fine Grain Pipelining - Two Tone Response](./Docs/3-Parallel-Pipelined-FIR-Filter-two_tone_response.png)

The filter rejects higher frequency components (distributed across the three input branches), and passes lower frequency components.

#### Area Report

#### Power Report

#### Timing Report
