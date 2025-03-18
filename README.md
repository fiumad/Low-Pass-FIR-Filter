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

~ Insert Filter Plots ~

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




